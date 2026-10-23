// Surface a nested opencode server (spawned by opencode.nvim) in herdr.
//
// herdr derives a pane's agent from the foreground process, which is nvim, and
// herdr's own opencode integration deliberately ignores `opencode serve`
// (lifecycle belongs to its TUI plugin, which opencode.nvim never runs). So this
// reports state from the server under a custom source.
//
// - Label is "opencode-nvim", not "opencode": herdr has no manifest for it, so
//   these reports are the sole authority and no screen rule scraping nvim's
//   rendering can contradict them (same reasoning as herdr-claude-shim.sh).
// - Never sends agent_session_id: a bound agent_session makes the pane drop
//   every report, including the nested claude shim's.
// - Cannot release on exit: opencode.nvim SIGKILLs the server. The release lives
//   in neovim's sudo-opencode.lua (VimLeavePre). Keep SOURCE/AGENT in sync.
//
// This file is NOT managed by herdr.
import net from "node:net";

const SOURCE = "custom:opencode-nvim";
const AGENT = "opencode-nvim";

// Epoch microseconds, strictly increasing. Fits a JS number exactly; the nvim
// release uses the same unit so a restarted server always outranks it.
let lastSeq = 0;
function nextSeq() {
  lastSeq = Math.max(lastSeq + 1, Date.now() * 1000);
  return lastSeq;
}

let chain = Promise.resolve();
let lastState;

function send(method, params) {
  const request = {
    id: `${SOURCE}:${Date.now()}:${Math.floor(Math.random() * 1_000_000)}`,
    method,
    params: {
      pane_id: process.env.HERDR_PANE_ID,
      source: SOURCE,
      agent: AGENT,
      seq: nextSeq(),
      ...params,
    },
  };
  return new Promise((resolve) => {
    let timer;
    const client = net.createConnection(process.env.HERDR_SOCKET_PATH, () => {
      client.write(`${JSON.stringify(request)}\n`);
    });
    const finish = () => {
      clearTimeout(timer);
      client.destroy();
      resolve();
    };
    timer = setTimeout(finish, 500);
    timer.unref?.();
    client.on("data", finish);
    client.on("error", finish);
    client.on("end", finish);
    client.on("close", finish);
  });
}

function report(state) {
  if (state === lastState) return chain;
  lastState = state;
  chain = chain.then(() => send("pane.report_agent", { state }), () => {});
  return chain;
}

const STATE_BY_STATUS = new Map([
  ["idle", "idle"],
  ["busy", "working"],
  ["retry", "working"],
]);

// Events from subagent (child) sessions only matter when they block on the user.
const CHILD_STATES = new Map([
  ["permission.asked", "blocked"],
  ["question.asked", "blocked"],
  ["permission.replied", "working"],
  ["question.replied", "working"],
  ["question.rejected", "working"],
]);

export const HerdrNvimAgentState = async () => {
  if (
    process.env.HERDR_ENV !== "1" ||
    !process.env.HERDR_SOCKET_PATH ||
    !process.env.HERDR_PANE_ID ||
    !process.env.NVIM
  ) {
    return {};
  }

  const childSessions = new Set();
  // Establish the agent as soon as the server loads, not on the first prompt.
  await report("idle");

  return {
    "chat.message": async ({ sessionID }) => {
      if (!childSessions.has(sessionID)) await report("working");
    },
    event: async ({ event }) => {
      const props = event?.properties ?? {};
      if (props.info?.id && props.info.parentID) childSessions.add(props.info.id);
      if (props.sessionID && childSessions.has(props.sessionID)) {
        const state = CHILD_STATES.get(event.type);
        if (state) await report(state);
        return;
      }
      switch (event?.type) {
        case "session.status": {
          const state = STATE_BY_STATUS.get(props.status?.type);
          if (state) await report(state);
          break;
        }
        case "permission.replied":
        case "question.replied":
        case "question.rejected":
          await report("working");
          break;
        case "permission.asked":
        case "question.asked":
        case "session.error":
          await report("blocked");
          break;
        case "session.idle":
          await report("idle");
          break;
      }
    },
  };
};

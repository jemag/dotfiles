local azure_org = vim.env.AZURE_DEVOPS_ORG_URL -- e.g. https://dev.azure.com/<org>
local azure_token = vim.env.AZURE_DEVOPS_TOKEN
local has_azure = azure_org ~= nil and azure_org ~= "" and azure_token ~= nil and azure_token ~= ""

local providers = {
  github = {
    cache_ttl = 300, -- auth via `gh auth login`
  },
}

local pulls = {
  default_merge_method = "squash",
  -- Fetch PR refs over SSH (Azure `sshUrl` / GitHub ssh URL). The https
  -- transport uses Azure's `https://<org>@dev.azure.com/...` remoteUrl without
  -- the PAT, so git falls back to a credential helper / TTY prompt and fails.
  git_transport = "ssh",
  diff = {
    -- Use atlas's built-in viewer, not CodeDiff: review.nvim attaches to every
    -- CodeDiff session and overrides atlas's buffer keys (c, C, S, q, ]n, ...).
    open_cmd = "AtlasDiff",
    layout = "side-by-side"
  },
  github = {
    views = {
      { name = "My PRs", key = "1", layout = "plain", search = "is:open author:@me sort:updated-desc" },
      {
        name = "Review requested",
        key = "2",
        layout = "compact",
        search = "is:open review-requested:@me sort:updated-desc",
      },
      { name = "Repo", key = "3", layout = "grouped", current_repo = true, search = "is:open sort:updated-desc" },
    },
    bookmarks = {
      items = {
        ["Drafts"] = "is:pr is:draft author:@me",
        ["Recently merged"] = "is:pr is:merged author:@me sort:updated-desc",
      },
    },
  },
}

local issues = {
  github = {
    views = {
      { name = "Assigned", key = "1", layout = "plain", search = "is:open assignee:@me sort:updated-desc" },
      { name = "Repo", key = "2", layout = "compact", current_repo = true, search = "is:open sort:updated-desc" },
    },
  },
}

if has_azure then
  providers.azure = {
    base_url = azure_org,
    token = azure_token,
    cache_ttl = 300,
  }

  pulls.azure = {
    views = {
      { name = "Reviewing", key = "1", layout = "grouped", current_repo = true, scope = "assigned_to_me" },
      { name = "Created", key = "2", layout = "compact", current_repo = true, scope = "created_by_me" },
      { name = "All", key = "3", layout = "grouped", current_repo = true, scope = "all" },
    },
  }

  issues.azure = {
    views = {
      {
        name = "Assigned",
        key = "1",
        current_repo = true,
        search = [[
          SELECT [System.Id] FROM WorkItems
          WHERE [System.TeamProject] = @project AND [System.AssignedTo] = @Me
            AND [System.State] NOT IN ('Closed', 'Done', 'Removed')
          ORDER BY [System.ChangedDate] DESC
        ]],
      },
      {
        -- The WIQL endpoint is project-scoped (no team in the URL), so
        -- @CurrentIteration resolves against the AKS project's default team.
        name = "AKS iteration",
        key = "2",
        project = "AKS",
        search = [[
          SELECT [System.Id] FROM WorkItems
          WHERE [System.TeamProject] = @project
            AND [System.IterationPath] = @CurrentIteration
          ORDER BY [System.WorkItemType], [System.State], [System.ChangedDate] DESC
        ]],
      },
    },
  }
end

require("atlas").setup({
  ui = {
    picker = "snacks",
  },
  providers = providers,
  pulls = pulls,
  issues = issues,
})

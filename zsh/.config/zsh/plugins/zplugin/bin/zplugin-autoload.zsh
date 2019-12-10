# -*- mode: sh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# Copyright (c) 2019 Sebastian Gniazdowski and contributors

builtin source ${ZPLGM[BIN_DIR]}"/zplugin-side.zsh"

ZPLGM[EXTENDED_GLOB]=""

#
# Backend, low level functions
#

# FUNCTION: -zplg-unregister-plugin {{{
# Removes the plugin from ZPLG_REGISTERED_PLUGINS array and from the
# zsh_loaded_plugins array (managed according to the plugin standard)
-zplg-unregister-plugin() {
    -zplg-any-to-user-plugin "$1" "$2"
    local uspl2="${reply[-2]}${${reply[-2]:#(%|/)*}:+/}${reply[-1]}" \
        teleid="$3"

    # If not found, the index will be length+1
    ZPLG_REGISTERED_PLUGINS[${ZPLG_REGISTERED_PLUGINS[(i)$uspl2]}]=()
    # Support Zsh plugin standard
    zsh_loaded_plugins[${zsh_loaded_plugins[(i)$teleid]}]=()
    ZPLG_REGISTERED_STATES[$uspl2]="0"
} # }}}
# FUNCTION: -zplg-diff-functions-compute {{{
# Computes FUNCTIONS that holds new functions added by plugin.
# Uses data gathered earlier by -zplg-diff-functions().
#
# $1 - user/plugin
-zplg-diff-functions-compute() {
    local uspl2="$1"

    # Cannot run diff if *_BEFORE or *_AFTER variable is not set
    # Following is paranoid for *_BEFORE and *_AFTER being only spaces

    builtin setopt localoptions extendedglob nokshglob noksharrays
    [[ "${ZPLGM[FUNCTIONS_BEFORE__$uspl2]}" != *[$'! \t']* || "${ZPLGM[FUNCTIONS_AFTER__$uspl2]}" != *[$'! \t']* ]] && return 1

    typeset -A func
    local i

    # This includes new functions. Quoting is kept (i.e. no i=${(Q)i})
    for i in "${(z)ZPLGM[FUNCTIONS_AFTER__$uspl2]}"; do
        func[$i]=1
    done

    # Remove duplicated entries, i.e. existing before. Quoting is kept
    for i in "${(z)ZPLGM[FUNCTIONS_BEFORE__$uspl2]}"; do
        # if would do unset, then: func[opp+a\[]: invalid parameter name
        func[$i]=0
    done

    # Store the functions, associating them with plugin ($uspl2)
    ZPLGM[FUNCTIONS__$uspl2]=""
    for i in "${(onk)func[@]}"; do
        [[ "${func[$i]}" = "1" ]] && ZPLGM[FUNCTIONS__$uspl2]+="$i "
    done

    return 0
} # }}}
# FUNCTION: -zplg-diff-options-compute {{{
# Computes OPTIONS that holds options changed by plugin.
# Uses data gathered earlier by -zplg-diff-options().
#
# $1 - user/plugin
-zplg-diff-options-compute() {
    local uspl2="$1"

    # Cannot run diff if *_BEFORE or *_AFTER variable is not set
    # Following is paranoid for *_BEFORE and *_AFTER being only spaces
    builtin setopt localoptions extendedglob nokshglob noksharrays
    [[ "${ZPLGM[OPTIONS_BEFORE__$uspl2]}" != *[$'! \t']* || "${ZPLGM[OPTIONS_AFTER__$uspl2]}" != *[$'! \t']* ]] && return 1

    typeset -A opts_before opts_after opts
    opts_before=( "${(z)ZPLGM[OPTIONS_BEFORE__$uspl2]}" )
    opts_after=( "${(z)ZPLGM[OPTIONS_AFTER__$uspl2]}" )
    opts=( )

    # Iterate through first array (keys the same
    # on both of them though) and test for a change
    local key
    for key in "${(k)opts_before[@]}"; do
        if [[ "${opts_before[$key]}" != "${opts_after[$key]}" ]]; then
            opts[$key]="${opts_before[$key]}"
        fi
    done

    # Serialize for reporting
    local IFS=" "
    ZPLGM[OPTIONS__$uspl2]="${(kv)opts[@]}"
    return 0
} # }}}
# FUNCTION: -zplg-diff-env-compute {{{
# Computes ZPLG_PATH, ZPLG_FPATH that hold (f)path components
# added by plugin. Uses data gathered earlier by -zplg-diff-env().
#
# $1 - user/plugin
-zplg-diff-env-compute() {
    local uspl2="$1"
    typeset -a tmp

    # Cannot run diff if *_BEFORE or *_AFTER variable is not set
    # Following is paranoid for *_BEFORE and *_AFTER being only spaces
    builtin setopt localoptions extendedglob nokshglob noksharrays
    [[ "${ZPLGM[PATH_BEFORE__$uspl2]}" != *[$'! \t']* || "${ZPLGM[PATH_AFTER__$uspl2]}" != *[$'! \t']* ]] && return 1
    [[ "${ZPLGM[FPATH_BEFORE__$uspl2]}" != *[$'! \t']* || "${ZPLGM[FPATH_AFTER__$uspl2]}" != *[$'! \t']* ]] && return 1

    typeset -A path_state fpath_state
    local i

    #
    # PATH processing
    #

    # This includes new path elements
    for i in "${(z)ZPLGM[PATH_AFTER__$uspl2]}"; do
        path_state[${(Q)i}]=1
    done

    # Remove duplicated entries, i.e. existing before
    for i in "${(z)ZPLGM[PATH_BEFORE__$uspl2]}"; do
        unset "path_state[$i]"
    done

    # Store the path elements, associating them with plugin ($uspl2)
    ZPLGM[PATH__$uspl2]=""
    for i in "${(onk)path_state[@]}"; do
        ZPLGM[PATH__$uspl2]+="${(q)i} "
    done

    #
    # FPATH processing
    #

    # This includes new path elements
    for i in "${(z)ZPLGM[FPATH_AFTER__$uspl2]}"; do
        fpath_state[${(Q)i}]=1
    done

    # Remove duplicated entries, i.e. existing before
    for i in "${(z)ZPLGM[FPATH_BEFORE__$uspl2]}"; do
        unset "fpath_state[$i]"
    done

    # Store the path elements, associating them with plugin ($uspl2)
    ZPLGM[FPATH__$uspl2]=""
    for i in "${(onk)fpath_state[@]}"; do
        ZPLGM[FPATH__$uspl2]+="${(q)i} "
    done

    return 0
} # }}}
# FUNCTION: -zplg-diff-parameter-compute {{{
# Computes ZPLG_PARAMETERS_PRE, ZPLG_PARAMETERS_POST that hold
# parameters created or changed (their type) by plugin. Uses
# data gathered earlier by -zplg-diff-parameter().
#
# $1 - user/plugin
-zplg-diff-parameter-compute() {
    local uspl2="$1"
    typeset -a tmp

    # Cannot run diff if *_BEFORE or *_AFTER variable is not set
    # Following is paranoid for *_BEFORE and *_AFTER being only spaces
    builtin setopt localoptions extendedglob nokshglob noksharrays
    [[ "${ZPLGM[PARAMETERS_BEFORE__$uspl2]}" != *[$'! \t']* || "${ZPLGM[PARAMETERS_AFTER__$uspl2]}" != *[$'! \t']* ]] && return 1

    # Un-concatenated parameters from moment of diff start and of diff end
    typeset -A params_before params_after
    params_before=( "${(z)ZPLGM[PARAMETERS_BEFORE__$uspl2]}" )
    params_after=( "${(z)ZPLGM[PARAMETERS_AFTER__$uspl2]}" )

    # The parameters that changed, with save of what
    # parameter was when diff started or when diff ended
    typeset -A params_pre params_post
    params_pre=( )
    params_post=( )

    # Iterate through all existing keys, before or after diff,
    # i.e. after all variables that were somehow live across
    # the diffing process
    local key
    typeset -aU keys
    keys=( "${(k)params_after[@]}" );
    keys=( "${keys[@]}" "${(k)params_before[@]}" );
    for key in "${keys[@]}"; do
        key="${(Q)key}"
        [[ "${params_after[$key]}" = *local* ]] && continue
        if [[ "${params_after[$key]}" != "${params_before[$key]}" ]]; then
            # Empty for a new param, a type otherwise
            [[ -z "${params_before[$key]}" ]] && params_before[$key]="\"\""
            params_pre[$key]="${params_before[$key]}"

            # Current type, can also be empty, when plugin
            # unsets a parameter
            [[ -z "${params_after[$key]}" ]] && params_after[$key]="\"\""
            params_post[$key]="${params_after[$key]}"
        fi
    done

    # Serialize for reporting
    ZPLGM[PARAMETERS_PRE__$uspl2]="${(j: :)${(qkv)params_pre[@]}}"
    ZPLGM[PARAMETERS_POST__$uspl2]="${(j: :)${(qkv)params_post[@]}}"

    return 0
} # }}}
# FUNCTION: -zplg-any-to-uspl2 {{{
# Converts given plugin-spec to format that's used in keys for hash tables.
# So basically, creates string "user/plugin" (this format is called: uspl2).
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - (optional) plugin (only when $1 - i.e. user - given)
-zplg-any-to-uspl2() {
    -zplg-any-to-user-plugin "$1" "$2"
    [[ "${reply[-2]}" = "%" ]] && REPLY="${reply[-2]}${reply[-1]}" || REPLY="${reply[-2]}${${reply[-2]:#(%|/)*}:+/}${reply[-1]//---//}"
} # }}}
# FUNCTION: -zplg-save-set-extendedglob {{{
# Enables extendedglob-option first saving if it was already
# enabled, for restoration of this state later.
-zplg-save-set-extendedglob() {
    [[ -o "extendedglob" ]] && ZPLGM[EXTENDED_GLOB]="1" || ZPLGM[EXTENDED_GLOB]="0"
    builtin setopt extendedglob
} # }}}
# FUNCTION: -zplg-restore-extendedglob {{{
# Restores extendedglob-option from state saved earlier.
-zplg-restore-extendedglob() {
    [[ "${ZPLGM[EXTENDED_GLOB]}" = "0" ]] && builtin unsetopt extendedglob || builtin setopt extendedglob
} # }}}
# FUNCTION: -zplg-prepare-readlink {{{
# Prepares readlink command, used for establishing completion's owner.
#
# $REPLY = ":" or "readlink"
-zplg-prepare-readlink() {
    REPLY=":"
    if type readlink 2>/dev/null 1>&2; then
        REPLY="readlink"
    fi
} # }}}
# FUNCTION: -zplg-clear-report-for {{{
# Clears all report data for given user/plugin. This is
# done by resetting all related global ZPLG_* hashes.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - (optional) plugin (only when $1 - i.e. user - given)
-zplg-clear-report-for() {
    -zplg-any-to-uspl2 "$1" "$2"

    # Shadowing
    ZPLG_REPORTS[$REPLY]=""
    ZPLGM[BINDKEYS__$REPLY]=""
    ZPLGM[ZSTYLES__$REPLY]=""
    ZPLGM[ALIASES__$REPLY]=""
    ZPLGM[WIDGETS_SAVED__$REPLY]=""
    ZPLGM[WIDGETS_DELETE__$REPLY]=""

    # Function diffing
    ZPLGM[FUNCTIONS__$REPLY]=""
    ZPLGM[FUNCTIONS_BEFORE__$REPLY]=""
    ZPLGM[FUNCTIONS_AFTER__$REPLY]=""

    # Option diffing
    ZPLGM[OPTIONS__$REPLY]=""
    ZPLGM[OPTIONS_BEFORE__$REPLY]=""
    ZPLGM[OPTIONS_AFTER__$REPLY]=""

    # Environment diffing
    ZPLGM[PATH__$REPLY]=""
    ZPLGM[PATH_BEFORE__$REPLY]=""
    ZPLGM[PATH_AFTER__$REPLY]=""
    ZPLGM[FPATH__$REPLY]=""
    ZPLGM[FPATH_BEFORE__$REPLY]=""
    ZPLGM[FPATH_AFTER__$REPLY]=""

    # Parameter diffing
    ZPLGM[PARAMETERS_PRE__$REPLY]=""
    ZPLGM[PARAMETERS_POST__$REPLY]=""
    ZPLGM[PARAMETERS_BEFORE__$REPLY]=""
    ZPLGM[PARAMETERS_AFTER__$REPLY]=""
} # }}}
# FUNCTION: -zplg-exists-message {{{
# Checks if plugin is loaded. Testable. Also outputs error
# message if plugin is not loaded.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - (optional) plugin (only when $1 - i.e. user - given)
-zplg-exists-message() {
    -zplg-any-to-uspl2 "$1" "$2"
    if [[ -z "${ZPLG_REGISTERED_PLUGINS[(r)$REPLY]}" ]]; then
        -zplg-any-colorify-as-uspl2 "$1" "$2"
        print "${ZPLGM[col-error]}No such plugin${ZPLGM[col-rst]} $REPLY"
        return 1
    fi
    return 0
} # }}}
# FUNCTION: -zplg-at-eval {{{
-zplg-at-eval() {
    [[ "$1" = "%atclone" ]] && { eval "$2"; return $?; } || { eval "$1"; return $?; }
}
# }}}

#
# Format functions
#

# FUNCTION: -zplg-format-functions {{{
# Creates a one or two columns text with functions created
# by given plugin.
#
# $1 - user/plugin (i.e. uspl2 format of plugin-spec)
-zplg-format-functions() {
    local uspl2="$1"

    typeset -a func
    func=( "${(z)ZPLGM[FUNCTIONS__$uspl2]}" )

    # Get length of longest left-right string pair,
    # and length of longest left string
    integer longest=0 longest_left=0 cur_left_len=0 count=1
    local f
    for f in "${(on)func[@]}"; do
        [[ -z "${#f}" ]] && continue
        f="${(Q)f}"

        # Compute for elements in left column,
        # ones that will be paded with spaces
        if (( count ++ % 2 != 0 )); then
            [[ "${#f}" -gt "$longest_left" ]] && longest_left="${#f}"
            cur_left_len="${#f}"
        else
            cur_left_len+="${#f}"
            cur_left_len+=1 # For separating space
            [[ "$cur_left_len" -gt "$longest" ]] && longest="$cur_left_len"
        fi
    done

    # Output in one or two columns
    local answer=""
    count=1
    for f in "${(on)func[@]}"; do
        [[ -z "$f" ]] && continue
        f="${(Q)f}"

        if (( COLUMNS >= longest )); then
            if (( count ++ % 2 != 0 )); then
                answer+="${(r:longest_left+1:: :)f}"
            else
                answer+="$f"$'\n'
            fi
        else
            answer+="$f"$'\n'
        fi
    done
    REPLY="$answer"
    # == 0 is: next element would have newline (postfix addition in "count ++")
    (( COLUMNS >= longest && count % 2 == 0 )) && REPLY="$REPLY"$'\n'
} # }}}
# FUNCTION: -zplg-format-options {{{
# Creates one-column text about options that changed when
# plugin "$1" was loaded.
#
# $1 - user/plugin (i.e. uspl2 format of plugin-spec)
-zplg-format-options() {
    local uspl2="$1"

    REPLY=""

    # Paranoid, don't want bad key/value pair error
    integer empty=0
    -zplg-save-set-extendedglob
    [[ "${ZPLGM[OPTIONS__$uspl2]}" != *[$'! \t']* ]] && empty=1
    -zplg-restore-extendedglob
    (( empty )) && return 0

    typeset -A opts
    opts=( "${(z)ZPLGM[OPTIONS__$uspl2]}" )

    # Get length of longest option
    integer longest=0
    local k
    for k in "${(kon)opts[@]}"; do
        [[ "${#k}" -gt "$longest" ]] && longest="${#k}"
    done

    # Output in one column
    local txt
    for k in "${(kon)opts[@]}"; do
        [[ "${opts[$k]}" = "on" ]] && txt="was unset" || txt="was set"
        REPLY+="${(r:longest+1:: :)k}$txt"$'\n'
    done
} # }}}
# FUNCTION: -zplg-format-env {{{
# Creates one-column text about FPATH or PATH elements
# added when given plugin was loaded.
#
# $1 - user/plugin (i.e. uspl2 format of plugin-spec)
# $2 - if 1, then examine PATH, if 2, then examine FPATH
-zplg-format-env() {
    local uspl2="$1" which="$2"

    # Format PATH?
    if [[ "$which" = "1" ]]; then
        typeset -a elem
        elem=( "${(z@)ZPLGM[PATH__$uspl2]}" )
    elif [[ "$which" = "2" ]]; then
        typeset -a elem
        elem=( "${(z@)ZPLGM[FPATH__$uspl2]}" )
    fi

    # Enumerate elements added
    local answer="" e
    for e in "${elem[@]}"; do
        [[ -z "$e" ]] && continue
        e="${(Q)e}"
        answer+="$e"$'\n'
    done

    [[ -n "$answer" ]] && REPLY="$answer"
} # }}}
# FUNCTION: -zplg-format-parameter {{{
# Creates one column text that lists global parameters that
# changed when the given plugin was loaded.
#
# $1 - user/plugin (i.e. uspl2 format of plugin-spec)
-zplg-format-parameter() {
    local uspl2="$1" infoc="${ZPLGM[col-info]}" k

    builtin setopt localoptions extendedglob nokshglob noksharrays
    REPLY=""
    [[ "${ZPLGM[PARAMETERS_PRE__$uspl2]}" != *[$'! \t']* || "${ZPLGM[PARAMETERS_POST__$uspl2]}" != *[$'! \t']* ]] && return 0

    typeset -A elem_pre elem_post
    elem_pre=( "${(z)ZPLGM[PARAMETERS_PRE__$uspl2]}" )
    elem_post=( "${(z)ZPLGM[PARAMETERS_POST__$uspl2]}" )

    # Find longest key and longest value
    integer longest=0 vlongest1=0 vlongest2=0
    local v1 v2
    for k in "${(k)elem_post[@]}"; do
        k="${(Q)k}"
        [[ "${#k}" -gt "$longest" ]] && longest="${#k}"

        v1="${(Q)elem_pre[$k]}"
        v2="${(Q)elem_post[$k]}"
        [[ "${#v1}" -gt "$vlongest1" ]] && vlongest1="${#v1}"
        [[ "${#v2}" -gt "$vlongest2" ]] && vlongest2="${#v2}"
    done

    # Enumerate parameters that changed. A key
    # always exists in both of the arrays
    local answer="" k
    for k in "${(k)elem_post[@]}"; do
        v1="${(Q)elem_pre[$k]}"
        v2="${(Q)elem_post[$k]}"
        k="${(Q)k}"

        k="${(r:longest+1:: :)k}"
        v1="${(l:vlongest1+1:: :)v1}"
        v2="${(r:vlongest2+1:: :)v2}"
        answer+="$k ${infoc}[$v1 -> $v2]${ZPLGM[col-rst]}"$'\n'
    done

    [[ -n "$answer" ]] && REPLY="$answer"

    return 0
} # }}}

#
# Completion functions
#

# FUNCTION: -zplg-get-completion-owner {{{
# Returns "user---plugin" string (uspl1 format) of plugin that
# owns given completion.
#
# Both :A and readlink will be used, then readlink's output if
# results differ. Readlink might not be available.
#
# :A will read the link "twice" and give the final repository
# directory, possibly without username in the uspl format;
# readlink will read the link "once"
#
# $1 - absolute path to completion file (in COMPLETIONS_DIR)
# $2 - readlink command (":" or "readlink")
-zplg-get-completion-owner() {
    setopt localoptions extendedglob nokshglob noksharrays noshwordsplit
    local cpath="$1"
    local readlink_cmd="$2"
    local in_plugin_path tmp

    # Try to go not too deep into resolving the symlink,
    # to have the name as it is in .zplugin/plugins
    # :A goes deep, descends fully to origin directory
    # Readlink just reads what symlink points to
    in_plugin_path="${cpath:A}"
    tmp=$( "$readlink_cmd" "$cpath" )
    # This in effect works as: "if different, then readlink"
    [[ -n "$tmp" ]] && in_plugin_path="$tmp"

    if [[ "$in_plugin_path" != "$cpath" ]]; then
        # Get the user---plugin part of path
        while [[ "$in_plugin_path" != ${ZPLGM[PLUGINS_DIR]}/[^/]## && "$in_plugin_path" != "/" ]]; do
            in_plugin_path="${in_plugin_path:h}"
        done
        in_plugin_path="${in_plugin_path:t}"

        if [[ -z "$in_plugin_path" ]]; then
            in_plugin_path="${tmp:h}"
        fi
    else
        # readlink and :A have nothing
        in_plugin_path="[unknown]"
    fi

    REPLY="$in_plugin_path"
} # }}}
# FUNCTION: -zplg-get-completion-owner-uspl2col {{{
# For shortening of code - returns colorized plugin name
# that owns given completion.
#
# $1 - absolute path to completion file (in COMPLETIONS_DIR)
# $2 - readlink command (":" or "readlink")
-zplg-get-completion-owner-uspl2col() {
    # "cpath" "readline_cmd"
    -zplg-get-completion-owner "$1" "$2"
    -zplg-any-colorify-as-uspl2 "$REPLY"
} # }}}
# FUNCTION: -zplg-find-completions-of-plugin {{{
# Searches for completions owned by given plugin.
# Returns them in `reply' array.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-find-completions-of-plugin() {
    builtin setopt localoptions nullglob extendedglob nokshglob noksharrays
    -zplg-any-to-user-plugin "$1" "$2"
    local user="${reply[-2]}" plugin="${reply[-1]}" uspl
    [[ "$user" = "%" ]] && uspl="${user}${plugin}" || uspl="${reply[-2]}${reply[-2]:+---}${reply[-1]//\//---}"

    reply=( "${ZPLGM[PLUGINS_DIR]}/$uspl"/**/_[^_.]*~*(*.zwc|*.html|*.txt|*.png|*.jpg|*.jpeg|*.js|_zsh_highlight*|/zsdoc/*)(DN) )
} # }}}
# FUNCTION: -zplg-check-comp-consistency {{{
# Zplugin creates symlink for each installed completion.
# This function checks whether given completion (i.e.
# file like "_mkdir") is indeed a symlink. Backup file
# is a completion that is disabled - has the leading "_"
# removed.
#
# $1 - path to completion within plugin's directory
# $2 - path to backup file within plugin's directory
-zplg-check-comp-consistency() {
    local cfile="$1" bkpfile="$2"
    integer error="$3"

    # bkpfile must be a symlink
    if [[ -e "$bkpfile" && ! -L "$bkpfile" ]]; then
        print "${ZPLGM[col-error]}Warning: completion's backup file \`${bkpfile:t}' isn't a symlink${ZPLGM[col-rst]}"
        error=1
    fi

    # cfile must be a symlink
    if [[ -e "$cfile" && ! -L "$cfile" ]]; then
        print "${ZPLGM[col-error]}Warning: completion file \`${cfile:t}' isn't a symlink${ZPLGM[col-rst]}"
        error=1
    fi

    # Tell user that he can manually modify but should do it right
    (( error )) && print "${ZPLGM[col-error]}Manual edit of ${ZPLGM[COMPLETIONS_DIR]} occured?${ZPLGM[col-rst]}"
} # }}}
# FUNCTION: -zplg-check-which-completions-are-installed {{{
# For each argument that each should be a path to completion
# within a plugin's dir, it checks whether that completion
# is installed - returns 0 or 1 on corresponding positions
# in reply.
#
# $1, ... - path to completion within plugin's directory
-zplg-check-which-completions-are-installed() {
    local i cfile bkpfile
    reply=( )
    for i in "$@"; do
        cfile="${i:t}"
        bkpfile="${cfile#_}"

        if [[ -e "${ZPLGM[COMPLETIONS_DIR]}"/"$cfile" || -e "${ZPLGM[COMPLETIONS_DIR]}"/"$bkpfile" ]]; then
            reply+=( "1" )
        else
            reply+=( "0" )
        fi
    done
} # }}}
# FUNCTION: -zplg-check-which-completions-are-enabled {{{
# For each argument that each should be a path to completion
# within a plugin's dir, it checks whether that completion
# is disabled - returns 0 or 1 on corresponding positions
# in reply.
#
# Uninstalled completions will be reported as "0"
# - i.e. disabled
#
# $1, ... - path to completion within plugin's directory
-zplg-check-which-completions-are-enabled() {
    local i cfile
    reply=( )
    for i in "$@"; do
        cfile="${i:t}"

        if [[ -e "${ZPLGM[COMPLETIONS_DIR]}"/"$cfile" ]]; then
            reply+=( "1" )
        else
            reply+=( "0" )
        fi
    done
} # }}}
# FUNCTION: -zplg-uninstall-completions {{{
# Removes all completions of given plugin from Zshell (i.e. from FPATH).
# The FPATH is typically `~/.zplugin/completions/'.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-uninstall-completions() {
    builtin setopt localoptions nullglob extendedglob unset nokshglob noksharrays noshwordsplit

    typeset -a completions symlinked backup_comps
    local c cfile bkpfile
    integer action global_action=0

    -zplg-get-path "$1" "$2"
    [[ -e "$REPLY" ]] && {
        completions=( "$REPLY"/**/_[^_.]*~*(*.zwc|*.html|*.txt|*.png|*.jpg|*.jpeg|*.js|_zsh_highlight*|/zsdoc/*)(DN) )
    } || {
        print "No such completion $1${${1:#(%|/)*}:+${2:+/}}$2"
        return 1
    }

    symlinked=( "${ZPLGM[COMPLETIONS_DIR]}"/_[^_.]*~*.zwc )
    backup_comps=( "${ZPLGM[COMPLETIONS_DIR]}"/[^_.]*~*.zwc )

    # Delete completions if they are really there, either
    # as completions (_fname) or backups (fname)
    for c in "${completions[@]}"; do
        action=0
        cfile="${c:t}"
        bkpfile="${cfile#_}"

        # Remove symlink to completion
        if [[ -n "${symlinked[(r)*/$cfile]}" ]]; then
            command rm -f "${ZPLGM[COMPLETIONS_DIR]}/$cfile"
            action=1
        fi

        # Remove backup symlink (created by cdisable)
        if [[ -n "${backup_comps[(r)*/$bkpfile]}" ]]; then
            command rm -f "${ZPLGM[COMPLETIONS_DIR]}/$bkpfile"
            action=1
        fi

        if (( action )); then
            print "${ZPLGM[col-info]}Uninstalling completion \`$cfile'${ZPLGM[col-rst]}"
            # Make compinit notice the change
            -zplg-forget-completion "$cfile"
            (( global_action ++ ))
        else
            print "${ZPLGM[col-info]}Completion \`$cfile' not installed${ZPLGM[col-rst]}"
        fi
    done

    if (( global_action > 0 )); then
        print "${ZPLGM[col-info]}Uninstalled $global_action completions${ZPLGM[col-rst]}"
    fi

    (( ${+functions[-zplg-forget-completion]} )) || builtin source ${ZPLGM[BIN_DIR]}"/zplugin-install.zsh"
    -zplg-compinit >/dev/null
} # }}}

#
# User-exposed functions
#

# FUNCTION: -zplg-pager {{{
# BusyBox less lacks the -X and -i options, so it can use more
-zplg-pager() {
    setopt LOCAL_OPTIONS EQUALS
    if [[ ${${:-=less}:A:t} = 'busybox' ]]; then
        more
    else
        less -FRXi
    fi
}
# }}}

# FUNCTION: -zplg-self-update {{{
# Updates Zplugin code (does a git pull).
#
# User-action entry point.
-zplg-self-update() {
    setopt localoptions extendedglob nokshglob noksharrays noshwordsplit
    local nl=$'\n' escape=$'\x1b['
    local -a lines
    (   builtin cd -q "${ZPLGM[BIN_DIR]}" && \
        command git fetch --quiet && \
            lines=( ${(f)"$(command git log --color --date=short --pretty=format:'%Cgreen%cd %h %Creset%s %Cred%d%Creset || %b' ..FETCH_HEAD)"} )
        if (( ${#lines} > 0 )); then
            # Remove the (origin/master ...) segments, to expect only tags to appear
            lines=( "${(S)lines[@]//\(([,[:blank:]]#(origin|HEAD|master)[^a-zA-Z]##(HEAD|origin|master)[,[:blank:]]#)#\)/}" )
            # Remove " ||" if it ends the line (i.e. no additional text from the body)
            lines=( "${lines[@]/ \|\|[[:blank:]]#(#e)/}" )
            # If there's no ref-name, 2 consecutive spaces occur - fix this
            lines=( "${lines[@]/(#b)[[:space:]]#\|\|[[:space:]]#(*)(#e)/|| ${match[1]}}" )
            lines=( "${lines[@]/(#b)$escape([0-9]##)m[[:space:]]##${escape}m/$escape${match[1]}m${escape}m}" )
            # Replace what follows "|| ..." with the same thing but with no newlines,
            # and also only first 10 words (the (w)-flag enables word-indexing)
            lines=( "${lines[@]/(#b)[[:blank:]]#\|\|(*)(#e)/| ${${match[1]//$nl/ }[(w)1,(w)10]}}" )
            builtin print -rl -- "${lines[@]}" | -zplg-pager
        fi
        command git pull --no-stat;
    )
    builtin print -- "Compiling Zplugin (zcompile)..."
    command rm -f "${ZPLGM[BIN_DIR]}"/*.zwc(DN)
    zcompile "${ZPLGM[BIN_DIR]}"/zplugin.zsh
    zcompile "${ZPLGM[BIN_DIR]}"/zplugin-side.zsh
    zcompile "${ZPLGM[BIN_DIR]}"/zplugin-install.zsh
    zcompile "${ZPLGM[BIN_DIR]}"/zplugin-autoload.zsh
    zcompile "${ZPLGM[BIN_DIR]}"/git-process-output.zsh
} # }}}
# FUNCTION: -zplg-show-registered-plugins {{{
# Lists loaded plugins (subcommands list, lodaded).
#
# User-action entry point.
-zplg-show-registered-plugins() {
    typeset -a filtered
    local keyword="$1"

    -zplg-save-set-extendedglob
    keyword="${keyword## ##}"
    keyword="${keyword%% ##}"
    if [[ -n "$keyword" ]]; then
        print "Installed plugins matching ${ZPLGM[col-info]}$keyword${ZPLGM[col-rst]}:"
        filtered=( "${(M)ZPLG_REGISTERED_PLUGINS[@]:#*$keyword*}" )
    else
        filtered=( "${ZPLG_REGISTERED_PLUGINS[@]}" )
    fi
    -zplg-restore-extendedglob

    local i
    for i in "${filtered[@]}"; do
        [[ "$i" = "_local/zplugin" ]] && continue
        -zplg-any-colorify-as-uspl2 "$i"
        # Mark light loads
        [[ "${ZPLG_REGISTERED_STATES[$i]}" = "1" ]] && REPLY="$REPLY ${ZPLGM[col-info]}*${ZPLGM[col-rst]}"
        print -r -- "$REPLY"
    done
} # }}}
# FUNCTION: -zplg-unload {{{
# 0. Call the Zsh Plugin's Standard *_plugin_unload function
# 0. Call the code provided by the Zsh Plugin's Standard @zsh-plugin-run-at-update
# 1. Delete bindkeys (...)
# 2. Delete Zstyles
# 3. Restore options
# 4. Remove aliases
# 5. Restore Zle state
# 6. Unfunction functions (created by plugin)
# 7. Clean-up FPATH and PATH
# 8. Delete created variables
# 9. Forget the plugin
#
# User-action entry point.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-unload() {
    -zplg-any-to-user-plugin "$1" "$2"
    local uspl2="${reply[-2]}${${reply[-2]:#(%|/)*}:+/}${reply[-1]}" user="${reply[-2]}" plugin="${reply[-1]}" quiet="${${3:+1}:-0}"
    local k

    -zplg-any-colorify-as-uspl2 "$uspl2"
    (( quiet )) || print -r -- "${ZPLGM[col-bar]}---${ZPLGM[col-rst]} Unloading plugin: $REPLY ${ZPLGM[col-bar]}---${ZPLGM[col-rst]}"

    local __dir
    [[ "$user" = "%" ]] && __dir="$plugin" || __dir="${ZPLGM[PLUGINS_DIR]}/${user:+${user}---}${plugin//\//---}"

    # KSH_ARRAYS immunity
    integer correct=0
    [[ -o "KSH_ARRAYS" ]] && correct=1

    # Allow unload for debug user
    if [[ "$uspl2" != "_dtrace/_dtrace" ]]; then
        -zplg-exists-message "$1" "$2" || return 1
    fi

    -zplg-any-colorify-as-uspl2 "$1" "$2"
    local uspl2col="$REPLY"

    # Store report of the plugin in variable LASTREPORT
    typeset -g LASTREPORT
    LASTREPORT=`-zplg-show-report "$1" "$2"`

    #
    # Call the Zsh Plugin's Standard *_plugin_unload function
    #

    (( ${+functions[${plugin}_plugin_unload]} )) && ${plugin}_plugin_unload

    #
    # Call the code provided by the Zsh Plugin's Standard @zsh-plugin-run-at-update
    #

    local -a tmp
    local -A sice
    tmp=( "${(z@)ZPLG_SICE[$uspl2]}" )
    (( ${#tmp} > 1 && ${#tmp} % 2 == 0 )) && sice=( "${(Q)tmp[@]}" ) || sice=()

    if [[ -n ${sice[ps-on-unload]} ]]; then
        (( quiet )) || print -r "Running plugin's provided unload code: ${ZPLGM[col-info]}${sice[ps-on-unload][1,50]}${sice[ps-on-unload][51]:+…}${ZPLGM[col-rst]}"
        local __oldcd="$PWD"
        () { setopt localoptions noautopushd; builtin cd -q "$__dir"; }
        eval "${sice[ps-on-unload]}"
        () { setopt localoptions noautopushd; builtin cd -q "$__oldcd"; }
    fi

    #
    # 1. Delete done bindkeys
    #

    typeset -a string_widget
    string_widget=( "${(z)ZPLGM[BINDKEYS__$uspl2]}" )
    local sw
    for sw in "${(Oa)string_widget[@]}"; do
        [[ -z "$sw" ]] && continue
        # Remove one level of quoting to split using (z)
        sw="${(Q)sw}"
        typeset -a sw_arr
        sw_arr=( "${(z)sw}" )

        # Remove one level of quoting to pass to bindkey
        local sw_arr1="${(Q)sw_arr[1-correct]}" # Keys
        local sw_arr2="${(Q)sw_arr[2-correct]}" # Widget
        local sw_arr3="${(Q)sw_arr[3-correct]}" # Optional previous-bound widget
        local sw_arr4="${(Q)sw_arr[4-correct]}" # Optional -M or -A or -N
        local sw_arr5="${(Q)sw_arr[5-correct]}" # Optional map name
        local sw_arr6="${(Q)sw_arr[6-correct]}" # Optional -R (not with -A, -N)

        if [[ "$sw_arr4" = "-M" && "$sw_arr6" != "-R" ]]; then
            if [[ -n "$sw_arr3" ]]; then
                (( quiet )) || print -r "Restoring bindkey ${(q)sw_arr1} $sw_arr3 ${ZPLGM[col-info]}in map ${ZPLGM[col-rst]}$sw_arr5"
                bindkey -M "$sw_arr5" "$sw_arr1" "$sw_arr3"
            else
                (( quiet )) || print -r "Deleting bindkey ${(q)sw_arr1} $sw_arr2 ${ZPLGM[col-info]}in map ${ZPLGM[col-rst]}$sw_arr5"
                bindkey -M "$sw_arr5" -r "$sw_arr1"
            fi
        elif [[ "$sw_arr4" = "-M" && "$sw_arr6" = "-R" ]]; then
            if [[ -n "$sw_arr3" ]]; then
                (( quiet )) || print -r "Restoring ${ZPLGM[col-info]}range${ZPLGM[col-rst]} bindkey ${(q)sw_arr1} $sw_arr3 ${ZPLGM[col-info]}in map ${ZPLGM[col-rst]}$sw_arr5"
                bindkey -RM "$sw_arr5" "$sw_arr1" "$sw_arr3"
            else
                (( quiet )) || print -r "Deleting ${ZPLGM[col-info]}range${ZPLGM[col-rst]} bindkey ${(q)sw_arr1} $sw_arr2 ${ZPLGM[col-info]}in map ${ZPLGM[col-rst]}$sw_arr5"
                bindkey -M "$sw_arr5" -Rr "$sw_arr1"
            fi
        elif [[ "$sw_arr4" != "-M" && "$sw_arr6" = "-R" ]]; then
            if [[ -n "$sw_arr3" ]]; then
                (( quiet )) || print -r "Restoring ${ZPLGM[col-info]}range${ZPLGM[col-rst]} bindkey ${(q)sw_arr1} $sw_arr3"
                bindkey -R "$sw_arr1" "$sw_arr3"
            else
                (( quiet )) || print -r "Deleting ${ZPLGM[col-info]}range${ZPLGM[col-rst]} bindkey ${(q)sw_arr1} $sw_arr2"
                bindkey -Rr "$sw_arr1"
            fi
        elif [[ "$sw_arr4" = "-A" ]]; then
            (( quiet )) || print -r "Linking backup-\`main' keymap \`$sw_arr5' back to \`main'"
            bindkey -A "$sw_arr5" "main"
        elif [[ "$sw_arr4" = "-N" ]]; then
            (( quiet )) || print -r "Deleting keymap \`$sw_arr5'"
            bindkey -D "$sw_arr5"
        else
            if [[ -n "$sw_arr3" ]]; then
                (( quiet )) || print -r "Restoring bindkey ${(q)sw_arr1} $sw_arr3"
                bindkey "$sw_arr1" "$sw_arr3"
            else
                (( quiet )) || print -r "Deleting bindkey ${(q)sw_arr1} $sw_arr2"
                bindkey -r "$sw_arr1"
            fi
        fi
    done

    #
    # 2. Delete created Zstyles
    #

    typeset -a pattern_style
    pattern_style=( "${(z)ZPLGM[ZSTYLES__$uspl2]}" )
    local ps
    for ps in "${(Oa)pattern_style[@]}"; do
        [[ -z "$ps" ]] && continue
        # Remove one level of quoting to split using (z)
        ps="${(Q)ps}"
        typeset -a ps_arr
        ps_arr=( "${(z)ps}" )

        # Remove one level of quoting to pass to zstyle
        local ps_arr1="${(Q)ps_arr[1-correct]}"
        local ps_arr2="${(Q)ps_arr[2-correct]}"

        (( quiet )) || print "Deleting zstyle $ps_arr1 $ps_arr2"

        zstyle -d "$ps_arr1" "$ps_arr2"
    done

    #
    # 3. Restore changed options
    #

    # Paranoid, don't want bad key/value pair error
    -zplg-diff-options-compute "$uspl2"
    integer empty=0
    -zplg-save-set-extendedglob
    [[ "${ZPLGM[OPTIONS__$uspl2]}" != *[$'! \t']* ]] && empty=1
    -zplg-restore-extendedglob

    if (( empty != 1 )); then
        typeset -A opts
        opts=( "${(z)ZPLGM[OPTIONS__$uspl2]}" )
        for k in "${(kon)opts[@]}"; do
            # Internal options
            [[ "$k" = "physical" ]] && continue

            if [[ "${opts[$k]}" = "on" ]]; then
                (( quiet )) || print "Setting option $k"
                builtin setopt "$k"
            else
                (( quiet )) || print "Unsetting option $k"
                builtin unsetopt "$k"
            fi
        done
    fi

    #
    # 4. Delete aliases
    #

    typeset -a aname_avalue
    aname_avalue=( "${(z)ZPLGM[ALIASES__$uspl2]}" )
    local nv
    for nv in "${(Oa)aname_avalue[@]}"; do
        [[ -z "$nv" ]] && continue
        # Remove one level of quoting to split using (z)
        nv="${(Q)nv}"
        typeset -a nv_arr
        nv_arr=( "${(z)nv}" )

        # Remove one level of quoting to pass to unalias
        local nv_arr1="${(Q)nv_arr[1-correct]}"
        local nv_arr2="${(Q)nv_arr[2-correct]}"
        local nv_arr3="${(Q)nv_arr[3-correct]}"

        if [[ "$nv_arr3" = "-s" ]]; then
            if [[ -n "$nv_arr2" ]]; then
                (( quiet )) || print "Restoring ${ZPLGM[col-info]}suffix${ZPLGM[col-rst]} alias ${nv_arr1}=${nv_arr2}"
                alias "$nv_arr1" &> /dev/null && unalias -s -- "$nv_arr1"
                alias -s -- "${nv_arr1}=${nv_arr2}"
            else
                (( quiet )) || alias "$nv_arr1" &> /dev/null && {
                    print "Removing ${ZPLGM[col-info]}suffix${ZPLGM[col-rst]} alias ${nv_arr1}"
                    unalias -s -- "$nv_arr1"
                }
            fi
        elif [[ "$nv_arr3" = "-g" ]]; then
            if [[ -n "$nv_arr2" ]]; then
                (( quiet )) || print "Restoring ${ZPLGM[col-info]}global${ZPLGM[col-rst]} alias ${nv_arr1}=${nv_arr2}"
                alias "$nv_arr1" &> /dev/null && unalias -g -- "$nv_arr1"
                alias -g -- "${nv_arr1}=${nv_arr2}"
            else
                (( quiet )) || alias "$nv_arr1" &> /dev/null && {
                    print "Removing ${ZPLGM[col-info]}global${ZPLGM[col-rst]} alias ${nv_arr1}"
                    unalias -- "${(q)nv_arr1}"
                }
            fi
        else
            if [[ -n "$nv_arr2" ]]; then
                (( quiet )) || print "Restoring alias ${nv_arr1}=${nv_arr2}"
                alias "$nv_arr1" &> /dev/null && unalias -- "$nv_arr1"
                alias -- "${nv_arr1}=${nv_arr2}"
            else
                (( quiet )) || alias "$nv_arr1" &> /dev/null && {
                    print "Removing alias ${nv_arr1}"
                    unalias -- "$nv_arr1"
                }
            fi
        fi
    done

    #
    # 5. Restore Zle state
    #

    local -a keys
    keys=( "${(@on)ZPLGM[(I)TIME_<->_*]}" )
    integer keys_size=${#keys}
    () {
        setopt localoptions extendedglob noksharrays typesetsilent
        typeset -a restore_widgets skip_delete
        local wid
        restore_widgets=( "${(z)ZPLGM[WIDGETS_SAVED__$uspl2]}" )
        for wid in "${(Oa)restore_widgets[@]}"; do
            [[ -z "$wid" ]] && continue
            wid="${(Q)wid}"
            typeset -a orig_saved
            orig_saved=( "${(z)wid}" )

            local tpe="${orig_saved[1]}"
            local orig_saved1="${(Q)orig_saved[2]}" # Original widget
            local comp_wid="${(Q)orig_saved[3]}"
            local orig_saved2="${(Q)orig_saved[4]}" # Saved target function
            local orig_saved3="${(Q)orig_saved[5]}" # Saved previous $widget's contents

            local found_time_key="${keys[(r)TIME_<->_${uspl2//\//---}]}" to_process_plugin
            integer found_time_idx=0 idx=0
            to_process_plugin=""
            [[ "$found_time_key" = (#b)TIME_(<->)_* ]] && found_time_idx="${match[1]}"
            if (( found_time_idx )); then # Must be true
                for (( idx = found_time_idx + 1; idx <= keys_size; ++ idx )); do
                    found_time_key="${keys[(r)TIME_${idx}_*]}"
                    local oth_uspl2=""
                    [[ "$found_time_key" = (#b)TIME_${idx}_(*) ]] && oth_uspl2="${match[1]//---//}"
                    local -a entry_splitted
                    entry_splitted=( "${(z@)ZPLGM[WIDGETS_SAVED__$oth_uspl2]}" )
                    integer found_idx="${entry_splitted[(I)(-N|-C)\ $orig_saved1\\\ *]}"
                    if (( found_idx ))
                    then
                        # Skip multiple loads of the same plugin
                        # TODO: Fully handle multiple plugin loads
                        if [[ "$oth_uspl2" != "$uspl2" ]]; then
                            to_process_plugin="$oth_uspl2"
                            break # Only the first one is needed
                        fi
                    fi
                done
                if [[ -n "$to_process_plugin" ]]; then
                    if (( !found_idx )); then
                        (( quiet )) || print "Problem (1) during handling of widget \`$orig_saved1' (contents: $orig_saved2)"
                        continue
                    fi
                    (( quiet )) || print "Chaining widget \`$orig_saved1' to plugin $oth_uspl2"
                    local -a oth_orig_saved
                    oth_orig_saved=( "${(z)${(Q)entry_splitted[found_idx]}}" )
                    local oth_fun="${oth_orig_saved[4]}"
                    # oth_orig_saved[2]="${(q)orig_saved2}" # not do this, because
                                                    # we don't want to call other
                                                    # plugin's function at any moment
                    oth_orig_saved[5]="${(q)orig_saved3}" # chain up the widget
                    entry_splitted[found_idx]="${(q)${(j: :)oth_orig_saved}}"
                    ZPLGM[WIDGETS_SAVED__$oth_uspl2]="${(j: :)entry_splitted}"
                    integer idx="${functions[$orig_saved2][(i)(#b)([^\{[:space:]]#$orig_saved1[^\{[:space:]])#]}"
                    if (( idx <= ${#functions[$orig_saved2]} ))
                    then
                        local prefix_X="${match[1]}"
                        idx="${functions[$oth_fun][(i)(#b)([^\{[:space:]]#$orig_saved1[^\}[:space:]]#)]}"
                        if (( idx <= ${#functions[$oth_fun]} )); then
                            local oth_prefix_uspl2_X="${match[1]}"
                            if [[ "${widgets[$prefix_X]}" = builtin ]]; then
                                (( quiet )) || print "Builtin-restoring widget \`$oth_prefix_uspl2_X' ($oth_uspl2)"
                                zle -A ".${prefix_X#.}" "$oth_prefix_uspl2_X"
                            elif [[ "${widgets[$prefix_X]}" = completion:* ]]; then
                                (( quiet )) || print "Chain*-restoring widget \`$oth_prefix_uspl2_X' ($oth_uspl2)"
                                zle -C "$oth_prefix_uspl2_X" "${(@)${(@s.:.)${orig_saved3#user:}}[2,3]}"
                            else
                                (( quiet )) || print "Chain-restoring widget \`$oth_prefix_uspl2_X' ($oth_uspl2)"
                                zle -N "$oth_prefix_uspl2_X" "${widgets[$prefix_X]#user:}"
                            fi
                        fi

                        # The alternate method
                        #skip_delete+=( "${match[1]}" )
                        #functions[$oth_fun]="${functions[$oth_fun]//[^\{[:space:]]#$orig_saved1/${match[1]}}"
                    fi
                else
                    (( quiet )) || print "Restoring Zle widget $orig_saved1"
                    if [[ "$orig_saved3" = builtin ]]; then
                        zle -A ".$orig_saved1" "$orig_saved1"
                    elif [[ "$orig_saved3" = completion:* ]]; then
                        zle -C "$orig_saved1" "${(@)${(@s.:.)${orig_saved3#user:}}[2,3]}"
                    else
                        zle -N "$orig_saved1" "${orig_saved3#user:}"
                    fi
                fi
            else
                (( quiet )) || print "Problem (2) during handling of widget \`$orig_saved1' (contents: $orig_saved2)"
            fi
        done
    }

    typeset -a delete_widgets
    delete_widgets=( "${(z)ZPLGM[WIDGETS_DELETE__$uspl2]}" )
    local wid
    for wid in "${(Oa)delete_widgets[@]}"; do
        [[ -z "$wid" ]] && continue
        wid="${(Q)wid}"
        if [[ -n "${skip_delete[(r)$wid]}" ]]; then
            print "Would delete $wid"
            continue
        fi
        if [[ "${ZPLG_ZLE_HOOKS_LIST[$wid]}" = "1" ]]; then
            (( quiet )) || print "Removing Zle hook \`$wid'"
        else
            (( quiet )) || print "Removing Zle widget \`$wid'"
        fi
        zle -D "$wid"
    done

    #
    # 6. Unfunction
    #

    -zplg-diff-functions-compute "$uspl2"
    typeset -a func
    func=( "${(z)ZPLGM[FUNCTIONS__$uspl2]}" )
    local f
    for f in "${(on)func[@]}"; do
        [[ -z "$f" ]] && continue
        f="${(Q)f}"
        (( quiet )) || print "Deleting function $f"
        (( ${+functions[$f]} )) && unfunction -- "$f"
        (( ${+precmd_functions} )) && precmd_functions=( ${precmd_functions[@]:#$f} )
        (( ${+preexec_functions} )) && preexec_functions=( ${preexec_functions[@]:#$f} )
        (( ${+chpwd_functions} )) && chpwd_functions=( ${chpwd_functions[@]:#$f} )
        (( ${+periodic_functions} )) && periodic_functions=( ${periodic_functions[@]:#$f} )
        (( ${+zshaddhistory_functions} )) && zshaddhistory_functions=( ${zshaddhistory_functions[@]:#$f} )
        (( ${+zshexit_functions} )) && zshexit_functions=( ${zshexit_functions[@]:#$f} )
    done

    #
    # 7. Clean up FPATH and PATH
    #

    -zplg-diff-env-compute "$uspl2"

    # Have to iterate over $path elements and
    # skip those that were added by the plugin
    typeset -a new elem p
    elem=( "${(z)ZPLGM[PATH__$uspl2]}" )
    for p in "${path[@]}"; do
        [[ -z "${elem[(r)${(q)p}]}" ]] && { new+=( "$p" ); } || {
            (( quiet )) || print "Removing PATH element ${ZPLGM[col-info]}$p${ZPLGM[col-rst]}"
            [[ -d "$p" ]] || (( quiet )) || print "${ZPLGM[col-error]}Warning:${ZPLGM[col-rst]} it didn't exist on disk"
        }
    done
    path=( "${new[@]}" )

    # The same for $fpath
    elem=( "${(z)ZPLGM[FPATH__$uspl2]}" )
    new=( )
    for p in "${fpath[@]}"; do
        [[ -z "${elem[(r)${(q)p}]}" ]] && { new+=( "$p" ); } || {
            (( quiet )) || print "Removing FPATH element ${ZPLGM[col-info]}$p${ZPLGM[col-rst]}"
            [[ -d "$p" ]] || (( quiet )) || print "${ZPLGM[col-error]}Warning:${ZPLGM[col-rst]} it didn't exist on disk"
        }
    done
    fpath=( "${new[@]}" )

    #
    # 8. Delete created variables
    #

    -zplg-diff-parameter-compute "$uspl2"
    empty=0
    -zplg-save-set-extendedglob
    [[ "${ZPLGM[PARAMETERS_POST__$uspl2]}" != *[$'! \t']* ]] && empty=1
    -zplg-restore-extendedglob

    if (( empty != 1 )); then
        typeset -A elem_pre elem_post
        elem_pre=( "${(z)ZPLGM[PARAMETERS_PRE__$uspl2]}" )
        elem_post=( "${(z)ZPLGM[PARAMETERS_POST__$uspl2]}" )

        # Find variables created or modified
        local wl found
        local -a whitelist
        whitelist=( "${(@Q)${(z@)ZPLGM[ENV-WHITELIST]}}" )
        for k in "${(k)elem_post[@]}"; do
            k="${(Q)k}"
            local v1="${(Q)elem_pre[$k]}"
            local v2="${(Q)elem_post[$k]}"

            # "" means a variable was deleted, not created/changed
            if [[ "$v2" != "\"\"" ]]; then
                # Don't unset readonly variables
                [[ "$v1" = *-readonly* || "$v2" = *-readonly* ]] && continue

                # Don't unset arrays managed by add-zsh-hook,
                # also ignore a few special parameters
                # TODO: remember and remove hooks
                case "$k" in
                    (chpwd_functions|precmd_functions|preexec_functions|periodic_functions|zshaddhistory_functions|zshexit_functions|zsh_directory_name_functions)
                        continue
                    (path|PATH|fpath|FPATH)
                        continue;
                        ;;
                esac

                # Don't unset redefined variables, only newly defined
                # "" means variable didn't exist before plugin load
                # (didn't have a type)
                if [[ "$v1" = "\"\"" || ( "$k" = (RPROMPT|RPS1|RPS2|PROMPT|PS1) && "$v1" != "$v2" ) ]]; then
                    found=0
                    for wl in "${whitelist[@]}"; do
                        if [[ "$k" = ${~wl} ]]; then
                            found=1
                            break
                        fi
                    done
                    if (( !found )); then
                        (( quiet )) || print "Unsetting variable $k"
                        # Checked that 4.3.17 does support "--"
                        # There cannot be parameter starting with
                        # "-" but let's defensively use "--" here
                        unset -- "$k"
                    else
                        print "Skipping unset of variable $k (whitelist)"
                    fi
                fi
            fi
        done
    fi

    #
    # 9. Forget the plugin
    #

    if [[ "$uspl2" = "_dtrace/_dtrace" ]]; then
        -zplg-clear-debug-report
        (( quiet )) || print "dtrace report saved to \$LASTREPORT"
    else
        (( quiet )) || print "Unregistering plugin $uspl2col"
        -zplg-unregister-plugin "$user" "$plugin" "${sice[teleid]}"
        zsh_loaded_plugins[${zsh_loaded_plugins[(i)$user${${user:#(%|/)*}:+/}$plugin]}]=()  # Support Zsh plugin standard
        -zplg-clear-report-for "$user" "$plugin"
        (( quiet )) || print "Plugin's report saved to \$LASTREPORT"
    fi

} # }}}
# FUNCTION: -zplg-show-report {{{
# Displays report of the plugin given.
#
# User-action entry point.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user (+ plugin in $2), plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-show-report() {
    setopt localoptions extendedglob warncreateglobal typesetsilent noksharrays
    -zplg-any-to-user-plugin "$1" "$2"
    local user="${reply[-2]}" plugin="${reply[-1]}" uspl2="${reply[-2]}${${reply[-2]:#(%|/)*}:+/}${reply[-1]}"

    # Allow debug report
    if [[ "$user/$plugin" != "_dtrace/_dtrace" ]]; then
        -zplg-exists-message "$user" "$plugin" || return 1
    fi

    # Print title
    printf "${ZPLGM[col-title]}Report for${ZPLGM[col-rst]} %s%s plugin\n"\
            "${user:+${ZPLGM[col-uname]}$user${ZPLGM[col-rst]}}${${user:#(%|/)*}:+/}"\
            "${ZPLGM[col-pname]}$plugin${ZPLGM[col-rst]}"

    # Print "----------"
    local msg="Report for $user${${user:#(%|/)*}:+/}$plugin plugin"
    print -- "${ZPLGM[col-bar]}${(r:${#msg}::-:)tmp__}${ZPLGM[col-rst]}"

    local -A map
    map=(
        Error:  "${ZPLGM[col-error]}"
        Warning:  "${ZPLGM[col-error]}"
        Note:  "${ZPLGM[col-note]}"
    )
    # Print report gathered via shadowing
    () {
        setopt localoptions extendedglob
        print -rl -- "${(@)${(f@)ZPLG_REPORTS[$uspl2]}/(#b)(#s)([^[:space:]]##)([[:space:]]##)/${map[${match[1]}]:-${ZPLGM[col-keyword]}}${match[1]}${ZPLGM[col-rst]}${match[2]}}"
    }

    # Print report gathered via $functions-diffing
    REPLY=""
    -zplg-diff-functions-compute "$uspl2"
    -zplg-format-functions "$uspl2"
    [[ -n "$REPLY" ]] && print "${ZPLGM[col-p]}Functions created:${ZPLGM[col-rst]}"$'\n'"$REPLY"

    # Print report gathered via $options-diffing
    REPLY=""
    -zplg-diff-options-compute "$uspl2"
    -zplg-format-options "$uspl2"
    [[ -n "$REPLY" ]] && print "${ZPLGM[col-p]}Options changed:${ZPLGM[col-rst]}"$'\n'"$REPLY"

    # Print report gathered via environment diffing
    REPLY=""
    -zplg-diff-env-compute "$uspl2"
    -zplg-format-env "$uspl2" "1"
    [[ -n "$REPLY" ]] && print "${ZPLGM[col-p]}PATH elements added:${ZPLGM[col-rst]}"$'\n'"$REPLY"

    REPLY=""
    -zplg-format-env "$uspl2" "2"
    [[ -n "$REPLY" ]] && print "${ZPLGM[col-p]}FPATH elements added:${ZPLGM[col-rst]}"$'\n'"$REPLY"

    # Print report gathered via parameter diffing
    -zplg-diff-parameter-compute "$uspl2"
    -zplg-format-parameter "$uspl2"
    [[ -n "$REPLY" ]] && print "${ZPLGM[col-p]}Variables added or redefined:${ZPLGM[col-rst]}"$'\n'"$REPLY"

    # Print what completions plugin has
    -zplg-find-completions-of-plugin "$user" "$plugin"
    typeset -a completions
    completions=( "${reply[@]}" )

    if [[ "${#completions[@]}" -ge "1" ]]; then
        print "${ZPLGM[col-p]}Completions:${ZPLGM[col-rst]}"
        -zplg-check-which-completions-are-installed "${completions[@]}"
        typeset -a installed
        installed=( "${reply[@]}" )

        -zplg-check-which-completions-are-enabled "${completions[@]}"
        typeset -a enabled
        enabled=( "${reply[@]}" )

        integer count="${#completions[@]}" idx
        for (( idx=1; idx <= count; idx ++ )); do
            print -n "${completions[idx]:t}"
            if [[ "${installed[idx]}" != "1" ]]; then
                print -n " ${ZPLGM[col-uninst]}[not installed]${ZPLGM[col-rst]}"
            else
                if [[ "${enabled[idx]}" = "1" ]]; then
                    print -n " ${ZPLGM[col-info]}[enabled]${ZPLGM[col-rst]}"
                else
                    print -n " ${ZPLGM[col-error]}[disabled]${ZPLGM[col-rst]}"
                fi
            fi
            print
        done
        print
    fi
} # }}}
# FUNCTION: -zplg-show-all-reports {{{
# Displays reports of all loaded plugins.
#
# User-action entry point.
-zplg-show-all-reports() {
    local i
    for i in "${ZPLG_REGISTERED_PLUGINS[@]}"; do
        [[ "$i" = "_local/zplugin" ]] && continue
        -zplg-show-report "$i"
    done
} # }}}
# FUNCTION: -zplg-show-debug-report {{{
# Displays dtrace report (data recorded in interactive session).
#
# User-action entry point.
-zplg-show-debug-report() {
    -zplg-show-report "_dtrace/_dtrace"
} # }}}
# FUNCTION: -zplg-update-or-status {{{
# Updates (git pull) or does `git status' for given plugin.
#
# User-action entry point.
#
# $1 - "status" for status, other for update
# $2 - plugin spec (4 formats: user---plugin, user/plugin, user (+ plugin in $2), plugin)
# $3 - plugin (only when $1 - i.e. user - given)
-zplg-update-or-status() {
    setopt localoptions extendedglob nokshglob noksharrays \
            nullglob rmstarsilent warncreateglobal

    local -a arr

    -zplg-two-paths "$2${${2:#(%|/)*}:+${3:+/}}$3"
    if [[ -d "${reply[-4]}" || -d "${reply[-2]}" ]]; then
        -zplg-update-or-status-snippet "$1" "$2" "$3"
        return $?
    fi

    -zplg-any-to-user-plugin "$2" "$3"
    local user="${reply[-2]}" plugin="${reply[-1]}" st="$1" \
        local_dir filename is_snippet key \
        id_as="${reply[-2]}${${reply[-2]:#(%|/)*}:+/}${reply[-1]}"
    local -A ice

    -zplg-exists-physically-message "$user" "$plugin" || return 1

    if [[ "$st" = "status" ]]; then
        ( builtin cd -q "${ZPLGM[PLUGINS_DIR]}/${user:+${user}---}${plugin//\//---}"; command git status; )
        return 0
    fi

    (( ${#ZPLG_ICE[@]} > 0 )) && { ZPLG_SICE[$user/$plugin]=""; local nf="-nftid"; }

    -zplg-compute-ice "$user${${user:#(%|/)*}:+/}$plugin" "pack$nf" \
        ice local_dir filename is_snippet || return 1
    [[ "${ice[teleid]:-$id_as}" = (#b)([^/]##)/(*) ]] && { user="${match[1]}"; plugin="${match[2]}"; } || { user=""; plugin="${ice[teleid]:-$id_as}"; }

    # Check if repository has a remote set, if it is _local
    local repo="${ZPLGM[PLUGINS_DIR]}/${id_as//\//---}"
    if [[ -f "$repo/.git/config" ]]; then
        local -a config
        config=( ${(f)"$(<$repo/.git/config)"} )
        if [[ ${#${(M)config[@]:#\[remote[[:blank:]]*\]}} -eq 0 ]]; then
            [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && {
                -zplg-any-colorify-as-uspl2 "$id_as"
                [[ "$id_as" = _local/* ]] && print -r -- "Skipping local plugin $REPLY" || \
                    print -r -- "$REPLY doesn't have a remote set, will not fetch"
            }
            return 1
        fi
    fi

    command rm -f $local_dir/.zplugin_lstupd

    if (( 1 )); then
        if [[ -z "${ice[is_release]}" && "${ice[from]}" = (gh-r|github-rel) ]]; then
            ice[is_release]=true
        fi
        local do_update=0 skip_pull=0
        if [[ -n "${ice[is_release]}" ]] {
            (( ${+functions[-zplg-setup-plugin-dir]} )) || builtin source ${ZPLGM[BIN_DIR]}"/zplugin-install.zsh"
            -zplg-get-latest-gh-r-version "$user" "$plugin"
            if [[ "${ice[is_release]}" = */$REPLY/* ]] {
                [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && \
                    print -- "\rBinary release already up to date (version: $REPLY)"

                (( ${+ice[run-atpull]} )) && { do_update=1; skip_pull=1; }
            } else {
                do_update=1
            }

            if (( do_update )) {
                (( !skip_pull )) && [[ "${ICE_OPTS[opt_-r,--reset]}" = 1 ]] && {
                    [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && print "Removing the previous file(s) (-r/--reset given)..."
                    command rm -rf "${local_dir:-/tmp/xyzabc312}"/*(ND)
                }
                ZPLG_ICE=( "${(kv)ice[@]}" )
                # Run annexes' atpull hooks (the before atpull-ice ones)
                [[ ${+ice[atpull]} = 1 && ${ice[atpull]} = "!"* ]] && {
                    reply=( "${(@on)ZPLG_EXTS[(I)z-annex hook:\\\!atpull <->]}" )
                    for key in "${reply[@]}"; do
                        arr=( "${(Q)${(z@)ZPLG_EXTS[$key]}[@]}" )
                        "${arr[5]}" "plugin" "$user" "$plugin" "$id_as" "$local_dir" \!atpull
                    done
                }

                (( !skip_pull && ${+ZPLG_ICE[reset]} )) && (
                    [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && print -P "%F{220}reset: running ${ZPLG_ICE[reset]:-rm -rf ${local_dir:-/tmp/xyzabc312}/*}%f"
                    eval ${ZPLG_ICE[reset]:-command rm -rf "${local_dir:-/tmp/xyzabc312}"/*(ND)}
                )

                [[ ${ice[atpull]} = "!"* ]] && -zplg-countdown "atpull" && ( (( ${+ice[nocd]} == 0 )) && { builtin cd -q "$local_dir" && -zplg-at-eval "${ice[atpull]#\!}" "${ice[atclone]}"; ((1)); } || -zplg-at-eval "${ice[atpull]#\!}" "${ice[atclone]}"; )
                print -r -- "<mark>" >! "$local_dir/.zplugin_lstupd"

                if (( !skip_pull )) {
                    [[ "${ICE_OPTS[opt_-q,--quiet]}" = 1 ]] && {
                        -zplg-any-colorify-as-uspl2 "$id_as"
                        print "\nUpdating plugin $REPLY"
                    }
                    -zplg-setup-plugin-dir "$user" "$plugin" "$id_as" "-u"
                }
                ZPLG_ICE=()
            }
        } else {
            ( builtin cd -q "$local_dir" || return 1
              integer had_output=0
              local IFS=$'\n'
              command git fetch --quiet && \
                command git log --color --date=short --pretty=format:'%Cgreen%cd %h %Creset%s %Cred%d%Creset%n' ..FETCH_HEAD | \
                while read line; do
                  [[ -n "${line%%[[:space:]]##}" ]] && {
                      [[ $had_output -eq 0 ]] && {
                          had_output=1
                          [[ "${ICE_OPTS[opt_-q,--quiet]}" = 1 ]] && {
                              -zplg-any-colorify-as-uspl2 "$id_as"
                              print "\r\nUpdating plugin $REPLY"
                          }
                      }
                      print $line
                  }
                done | \
                command tee .zplugin_lstupd | \
                -zplg-pager &
                integer pager_pid=$!
                { sleep 20 && kill -9 $pager_pid 2>/dev/null 1>&2; } &!
                { wait $pager_pid; } > /dev/null 2>&1

              local -a log
              { log=( ${(@f)"$(<$local_dir/.zplugin_lstupd)"} ); } 2>/dev/null
              [[ ${#log} -gt 0 ]] && do_update=1 || \
                  {
                      (( ${+ice[run-atpull]} )) && {
                          do_update=1; skip_pull=1
                          print -r -- "<mark>" >! "$local_dir/.zplugin_lstupd"
                      }
                  }

              if (( do_update )) {
                  (( !skip_pull )) && [[ "${ICE_OPTS[opt_-r,--reset]}" = 1 ]] && {
                      [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && print "Resetting the repository (-r/--reset given)..."
                      command git reset --hard HEAD
                  }
                  ZPLG_ICE=( "${(kv)ice[@]}" )
                  # Run annexes' atpull hooks (the before atpull-ice ones)
                  [[ ${+ice[atpull]} = 1 && ${ice[atpull]} = "!"* ]] && {
                      reply=( "${(@on)ZPLG_EXTS[(I)z-annex hook:\\\!atpull <->]}" )
                      for key in "${reply[@]}"; do
                          arr=( "${(Q)${(z@)ZPLG_EXTS[$key]}[@]}" )
                          "${arr[5]}" "plugin" "$user" "$plugin" "$id_as" "$local_dir" \!atpull
                      done
                  }
                  (( ${+ZPLG_ICE[reset]} )) && (
                      [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && print -P "%F{220}reset: running ${ZPLG_ICE[reset]:-git reset --hard HEAD}%f"
                      eval "${ZPLG_ICE[reset]:-command git reset --hard HEAD}"
                  )
                  [[ ${ice[atpull]} = "!"* ]] && -zplg-countdown "atpull" && ( (( ${+ice[nocd]} == 0 )) && { builtin cd -q "$local_dir" && -zplg-at-eval "${ice[atpull]#\!}" "${ice[atclone]}"; ((1)); } || -zplg-at-eval "${ice[atpull]#\!}" "${ice[atclone]}"; )
                  ZPLG_ICE=()
                  (( !skip_pull )) && command git pull --no-stat
              }
            )
        }

        [[ -d "$local_dir/.git" ]] && \
            (  builtin cd -q "$local_dir" # || return 1 - don't return, maybe it's some hook's logic
               command git pull --recurse-submodules
            )

        local -a log
        { log=( ${(@f)"$(<$local_dir/.zplugin_lstupd)"} ); } 2>/dev/null

        command rm -f $local_dir/.zplugin_lstupd

        # Any new commits?
        [[ ${#log} -gt 0 ]] && {
            [[ ${+ice[make]} = 1 && ${ice[make]} = "!!"* ]] && -zplg-countdown make && { command make -C "$local_dir" ${(@s; ;)${ice[make]#\!\!}}; }

            if [[ -z "${ice[is_release]}" && -n "${ice[mv]}" ]]; then
                local from="${ice[mv]%%[[:space:]]#->*}" to="${ice[mv]##*->[[:space:]]#}"
                local -a afr
                ( builtin cd -q "$local_dir" || return 1
                  afr=( ${~from}(DN) )
                  [[ ${#afr} -gt 0 ]] && { command mv -vf "${afr[1]}" "$to"; command mv -vf "${afr[1]}".zwc "$to".zwc 2>/dev/null; }
                )
            fi

            if [[ -z "${ice[is_release]}" && -n "${ice[cp]}" ]]; then
                local from="${ice[cp]%%[[:space:]]#->*}" to="${ice[cp]##*->[[:space:]]#}"
                local -a afr
                ( builtin cd -q "$local_dir" || return 1
                  afr=( ${~from}(DN) )
                  [[ ${#afr} -gt 0 ]] && { command cp -vf "${afr[1]}" "$to"; command cp -vf "${afr[1]}".zwc "$to".zwc 2>/dev/null; }
                )
            fi

            ZPLG_ICE=( "${(kv)ice[@]}" )
            # Run annexes' atpull hooks (the before atpull-ice ones)
            [[ ${ice[atpull]} != "!"* ]] && {
                reply=( "${(@on)ZPLG_EXTS[(I)z-annex hook:\\\!atpull <->]}" )
                for key in "${reply[@]}"; do
                    arr=( "${(Q)${(z@)ZPLG_EXTS[$key]}[@]}" )
                    "${arr[5]}" "plugin" "$user" "$plugin" "$id_as" "$local_dir" \!atpull
                done
            }

            [[ ${+ice[make]} = 1 && ${ice[make]} = ("!"[^\!]*|"!") ]] && -zplg-countdown make && { command make -C "$local_dir" ${(@s; ;)${ice[make]#\!}}; }
            [[ -n ${ice[atpull]} && ${ice[atpull][1]} != "!" ]] && -zplg-countdown "atpull" && ( (( ${+ice[nocd]} == 0 )) && { builtin cd -q "$local_dir" && -zplg-at-eval "${ice[atpull]}" "${ice[atclone]}"; ((1)); } || -zplg-at-eval "${ice[atpull]}" "${ice[atclone]}"; )
            [[ ${+ice[make]} = 1 && ${ice[make]} != "!"* ]] && -zplg-countdown make && command make -C "$local_dir" ${(@s; ;)${ice[make]}}

            # Run annexes' atpull hooks (the after atpull-ice ones)
            reply=( "${(@on)ZPLG_EXTS[(I)z-annex hook:atpull <->]}" )
            for key in "${reply[@]}"; do
                arr=( "${(Q)${(z@)ZPLG_EXTS[$key]}[@]}" )
                "${arr[5]}" "plugin" "$user" "$plugin" "$id_as" "$local_dir" atpull
            done
            ZPLG_ICE=()
        }

        # Store ices to disk at update of plugin
        -zplg-store-ices "$local_dir/._zplugin" ice "" "" "" ""
    fi
    ZPLG_ICE=( "${(kv)ice[@]}" )
    # Run annexes' atpull hooks (the `always' after atpull-ice ones)
    reply=( ${(@on)ZPLG_EXTS[(I)z-annex hook:%atpull <->]} )
    for key in "${reply[@]}"; do
        arr=( "${(Q)${(z@)ZPLG_EXTS[$key]}[@]}" )
        "${arr[5]}" "plugin" "$user" "$plugin" "$id_as" "$local_dir" \%atpull
    done

    if [[ -n ${ZPLG_ICE[ps-on-update]} ]]; then
        (( quiet )) || print -r "Running plugin's provided update code: ${ZPLGM[col-info]}${ZPLG_ICE[ps-on-update][1,50]}${ZPLG_ICE[ps-on-update][51]:+…}${ZPLGM[col-rst]}"
        (
            builtin cd -q "$local_dir"
            eval "${ZPLG_ICE[ps-on-update]}"
        )
    fi
    ZPLG_ICE=()

    return 0
} # }}}
# FUNCTION: -zplg-update-or-status-snippet {{{
#
# Implements update or status operation for snippet given by URL.
#
# $1 - "status" or "update"
# $2 - snippet URL
-zplg-update-or-status-snippet() {
    local st="$1" URL="${2%/}" local_dir filename is_snippet
    (( ${#ZPLG_ICE[@]} > 0 )) && { ZPLG_SICE[$URL]=""; local nf="-nf"; }
    -zplg-compute-ice "$URL" "pack$nf" \
        ZPLG_ICE local_dir filename is_snippet || return 1

    if [[ "$st" = "status" ]]; then
        if (( ${+ZPLG_ICE[svn]} )); then
            print -r -- "${ZPLGM[col-info]}Status for ${${${local_dir:h}:t}##*--}/${local_dir:t}${ZPLGM[col-rst]}"
            ( builtin cd -q "$local_dir"; command svn status -vu )
            print
        else
            print -r -- "${ZPLGM[col-info]}Status for ${${local_dir:h}##*--}/$filename${ZPLGM[col-rst]}"
            ( builtin cd -q "$local_dir"; command ls -lth $filename )
            print
        fi
    else
        -zplg-load-snippet "${ZPLG_ICE[teleid]:-$URL}" "-i" "-f" "-u"
    fi

    ZPLG_ICE=()
}
# }}}
# FUNCTION: -zplg-update-or-status-all {{{
# Updates (git pull) or does `git status` for all existing plugins.
# This includes also plugins that are not loaded into Zsh (but exist
# on disk). Also updates (i.e. redownloads) snippets.
#
# User-action entry point.
-zplg-update-or-status-all() {
    builtin setopt localoptions nullglob nokshglob noksharrays typesetsilent

    local st="$1" id_as
    local repo snip pd user plugin

    local -A ZPLG_ICE
    ZPLG_ICE=()

    local -a snipps
    snipps=( ${ZPLGM[SNIPPETS_DIR]}/**/._zplugin(ND) )

    [[ "$st" != "status" && "${ICE_OPTS[opt_-q,--quiet]}" != 1 && -n "$snipps" ]] && \
        print "${ZPLGM[col-info]}Note:${ZPLGM[col-rst]} updating also unloaded snippets"

    for snip in "${ZPLGM[SNIPPETS_DIR]}"/**/._zplugin/mode(D); do
        [[ ! -f "${snip:h}/url" ]] && continue
        [[ -f "${snip:h}/id-as" ]] && \
            id_as="$(<${snip:h}/id-as)" ||
            id_as=""
        -zplg-update-or-status-snippet "$st" "${id_as:-$(<${snip:h}/url)}"
        ZPLG_ICE=()
    done
    [[ -n "$snipps" ]] && print

    ZPLG_ICE=()

    if [[ "$st" = "status" ]]; then
        [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && \
            print "${ZPLGM[col-info]}Note:${ZPLGM[col-rst]} status done also for unloaded plugins"
    else
        [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && \
            print "${ZPLGM[col-info]}Note:${ZPLGM[col-rst]} updating also unloaded plugins"
    fi

    for repo in "${ZPLGM[PLUGINS_DIR]}"/*; do
        pd="${repo:t}"

        # Two special cases
        [[ "$pd" = "custom" || "$pd" = "_local---zplugin" ]] && continue

        -zplg-any-colorify-as-uspl2 "$pd"

        # Check if repository has a remote set
        if [[ -f "$repo/.git/config" ]]; then
            local -a config
            config=( ${(f)"$(<$repo/.git/config)"} )
            if [[ ${#${(M)config[@]:#\[remote[[:blank:]]*\]}} -eq 0 ]]; then
                [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && \
                    [[ "$pd" = _local---* ]] && print -- "\nSkipping local plugin $REPLY" || \
                        print "\n$REPLY doesn't have a remote set, will not fetch"
                continue
            fi
        fi

        -zplg-any-to-user-plugin "$pd"
        local user="${reply[-2]}" plugin="${reply[-1]}"

        # Must be a git repository or a binary release
        if [[ ! -d "$repo/.git" && ! -f "$repo/._zplugin/is_release" ]]; then
            [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && \
                print "\n$REPLY not a git repository"
            continue
        fi

        if [[ "$st" = "status" ]]; then
            print "\nStatus for plugin $REPLY"
            ( builtin cd -q "$repo"; command git status )
        else
            [[ "${ICE_OPTS[opt_-q,--quiet]}" != 1 ]] && print "\nUpdating plugin $REPLY" || print -n .
            -zplg-update-or-status "update" "$user" "$plugin"
        fi
    done
} # }}}
# FUNCTION: -zplg-show-zstatus {{{
# Shows Zplugin status, i.e. number of loaded plugins,
# of available completions, etc.
#
# User-action entry point.
-zplg-show-zstatus() {
    builtin setopt localoptions nullglob extendedglob nokshglob noksharrays

    local infoc="${ZPLGM[col-info2]}"

    print "Zplugin's main directory: ${infoc}${ZPLGM[HOME_DIR]}${ZPLGM[col-rst]}"
    print "Zplugin's binary directory: ${infoc}${ZPLGM[BIN_DIR]}${ZPLGM[col-rst]}"
    print "Plugin directory: ${infoc}${ZPLGM[PLUGINS_DIR]}${ZPLGM[col-rst]}"
    print "Completions directory: ${infoc}${ZPLGM[COMPLETIONS_DIR]}${ZPLGM[col-rst]}"

    # Without _zlocal/zplugin
    print "Loaded plugins: ${infoc}$(( ${#ZPLG_REGISTERED_PLUGINS[@]} - 1 ))${ZPLGM[col-rst]}"

    # Count light-loaded plugins
    integer light=0
    local s
    for s in "${ZPLG_REGISTERED_STATES[@]}"; do
        [[ "$s" = 1 ]] && (( light ++ ))
    done
    # Without _zlocal/zplugin
    print "Light loaded: ${infoc}$(( light - 1 ))${ZPLGM[col-rst]}"

    # Downloaded plugins, without _zlocal/zplugin, custom
    typeset -a plugins
    plugins=( "${ZPLGM[PLUGINS_DIR]}"/*(DN) )
    print "Downloaded plugins: ${infoc}$(( ${#plugins} - 1 ))${ZPLGM[col-rst]}"

    # Number of enabled completions, with _zlocal/zplugin
    typeset -a completions
    completions=( "${ZPLGM[COMPLETIONS_DIR]}"/_[^_.]*~*.zwc(DN) )
    print "Enabled completions: ${infoc}${#completions[@]}${ZPLGM[col-rst]}"

    # Number of disabled completions, with _zlocal/zplugin
    completions=( "${ZPLGM[COMPLETIONS_DIR]}"/[^_.]*~*.zwc(DN) )
    print "Disabled completions: ${infoc}${#completions[@]}${ZPLGM[col-rst]}"

    # Number of completions existing in all plugins
    completions=( "${ZPLGM[PLUGINS_DIR]}"/*/**/_[^_.]*~*(*.zwc|*.html|*.txt|*.png|*.jpg|*.jpeg|*.js|_zsh_highlight*|/zsdoc/*)(DN) )
    print "Completions available overall: ${infoc}${#completions[@]}${ZPLGM[col-rst]}"

    # Enumerate snippets loaded
    print "Snippets loaded: ${infoc}${(j:, :onv)ZPLG_SNIPPETS[@]}${ZPLGM[col-rst]}"

    # Number of compiled plugins
    typeset -a matches m
    integer count=0
    matches=( ${ZPLGM[PLUGINS_DIR]}/*/*.zwc(DN) )

    local cur_plugin="" uspl1
    for m in "${matches[@]}"; do
        uspl1="${${m:h}:t}"

        if [[ "$cur_plugin" != "$uspl1" ]]; then
            (( count ++ ))
            cur_plugin="$uspl1"
        fi
    done

    print "Compiled plugins: ${infoc}$count${ZPLGM[col-rst]}"
} # }}}
# FUNCTION: -zplg-show-times {{{
# Shows loading times of all loaded plugins.
#
# User-action entry point.
-zplg-show-times() {
    setopt localoptions extendedglob nokshglob noksharrays
    local opt="$1 $2 $3" entry entry2 entry3 user plugin
    float -F 3 sum=0.0
    local -A sice
    local -a tmp

    [[ "$opt" = *-[a-z]#m[a-z]#* ]] && \
        { print "Plugin loading moments:"; ((1)); } || \
        print "Plugin loading times:"

    for entry in "${(@on)ZPLGM[(I)TIME_[0-9]##_*]}"; do
        entry2="${entry#TIME_[0-9]##_}"
        entry3="AT_$entry"
        if [[ "$entry2" = (http|https|ftp|ftps|scp|OMZ|PZT):* ]]; then
            REPLY="${ZPLGM[col-pname]}$entry2${ZPLGM[col-rst]}"

            tmp=( "${(z@)ZPLG_SICE[${entry2%/}]}" )
            (( ${#tmp} > 1 && ${#tmp} % 2 == 0 )) && sice=( "${(Q)tmp[@]}" ) || sice=()
        else
            user="${entry2%%---*}"
            plugin="${entry2#*---}"
            [[ "$user" = \% ]] && plugin="/${plugin//---/\/}"
            [[ "$user" = "$plugin" && "$user/$plugin" != "$entry2" ]] && user=""
            -zplg-any-colorify-as-uspl2 "$user" "$plugin"

            tmp=( "${(z@)ZPLG_SICE[$user/$plugin]}" )
            (( ${#tmp} > 1 && ${#tmp} % 2 == 0 )) && sice=( "${(Q)tmp[@]}" ) || sice=()
        fi

        local attime=$(( ZPLGM[$entry3] - ZPLGM[START_TIME] ))
        if [[ "$opt" = *-[a-z]#s[a-z]#* ]]; then
            local time="$ZPLGM[$entry] sec"
            attime="${(M)attime#*.???} sec"
        else
            local time="${(l:5:: :)$(( ZPLGM[$entry] * 1000 ))%%[,.]*} ms"
            attime="${(l:5:: :)$(( attime * 1000 ))%%[,.]*} ms"
        fi

        if [[ "$opt" = *-[a-z]#m[a-z]#* ]]; then
            time="$attime"
        fi

        if [[ ${sice[as]} == "command" ]]; then
            print "$time" - "$REPLY (command)"
        elif [[ -n ${sice[sbin]} ]]; then
            print "$time" - "$REPLY (sbin command)"
        elif [[ -n ${sice[fbin]} ]]; then
            print "$time" - "$REPLY (fbin command)"
        elif [[ ( ${sice[pick]} = /dev/null || ${sice[as]} = null ) && ${+sice[make]} = 1 ]]; then
            print "$time" - "$REPLY (/dev/null make plugin)"
        else
            print "$time" - "$REPLY"
        fi

        (( sum += ZPLGM[$entry] ))
    done
    print "Total: $sum sec"
}
# }}}
# FUNCTION: -zplg-list-bindkeys {{{
-zplg-list-bindkeys() {
    local uspl2 uspl2col sw first=1
    local -a string_widget

    # KSH_ARRAYS immunity
    integer correct=0
    [[ -o "KSH_ARRAYS" ]] && correct=1

    for uspl2 in "${(@ko)ZPLGM[(I)BINDKEYS__*]}"; do
        [[ -z "${ZPLGM[$uspl2]}" ]] && continue

        (( !first )) && print
        first=0

        uspl2="${uspl2#BINDKEYS__}"

        -zplg-any-colorify-as-uspl2 "$uspl2"
        uspl2col="$REPLY"
        print "$uspl2col"

        string_widget=( "${(z@)ZPLGM[BINDKEYS__$uspl2]}" )
        for sw in "${(Oa)string_widget[@]}"; do
            [[ -z "$sw" ]] && continue
            # Remove one level of quoting to split using (z)
            sw="${(Q)sw}"
            typeset -a sw_arr
            sw_arr=( "${(z@)sw}" )

            # Remove one level of quoting to pass to bindkey
            local sw_arr1="${(Q)sw_arr[1-correct]}" # Keys
            local sw_arr2="${(Q)sw_arr[2-correct]}" # Widget
            local sw_arr3="${(Q)sw_arr[3-correct]}" # Optional -M or -A or -N
            local sw_arr4="${(Q)sw_arr[4-correct]}" # Optional map name
            local sw_arr5="${(Q)sw_arr[5-correct]}" # Optional -R (not with -A, -N)

            if [[ "$sw_arr3" = "-M" && "$sw_arr5" != "-R" ]]; then
                print "bindkey $sw_arr1 $sw_arr2 ${ZPLGM[col-info]}for keymap $sw_arr4${ZPLGM[col-rst]}"
            elif [[ "$sw_arr3" = "-M" && "$sw_arr5" = "-R" ]]; then
                print "${ZPLGM[col-info]}range${ZPLGM[col-rst]} bindkey $sw_arr1 $sw_arr2 ${ZPLGM[col-info]}mapped to $sw_arr4${ZPLGM[col-rst]}"
            elif [[ "$sw_arr3" != "-M" && "$sw_arr5" = "-R" ]]; then
                print "${ZPLGM[col-info]}range${ZPLGM[col-rst]} bindkey $sw_arr1 $sw_arr2"
            elif [[ "$sw_arr3" = "-A" ]]; then
                print "Override of keymap \`main'"
            elif [[ "$sw_arr3" = "-N" ]]; then
                print "New keymap \`$sw_arr4'"
            else
                print "bindkey $sw_arr1 $sw_arr2"
            fi
        done
    done
}
# }}}

# FUNCTION: -zplg-compiled {{{
# Displays list of plugins that are compiled.
#
# User-action entry point.
-zplg-compiled() {
    builtin setopt localoptions nullglob

    typeset -a matches m
    matches=( ${ZPLGM[PLUGINS_DIR]}/*/*.zwc(DN) )

    if [[ "${#matches[@]}" -eq "0" ]]; then
        print "No compiled plugins"
        return 0
    fi

    local cur_plugin="" uspl1 file user plugin
    for m in "${matches[@]}"; do
        file="${m:t}"
        uspl1="${${m:h}:t}"
        -zplg-any-to-user-plugin "$uspl1"
        user="${reply[-2]}" plugin="${reply[-1]}"

        if [[ "$cur_plugin" != "$uspl1" ]]; then
            [[ -n "$cur_plugin" ]] && print # newline
            -zplg-any-colorify-as-uspl2 "$user" "$plugin"
            print -r -- "$REPLY:"
            cur_plugin="$uspl1"
        fi

        print "$file"
    done
} # }}}
# FUNCTION: -zplg-compile-uncompile-all {{{
# Compiles or uncompiles all existing (on disk) plugins.
#
# User-action entry point.
-zplg-compile-uncompile-all() {
    builtin setopt localoptions nullglob

    local compile="$1"

    typeset -a plugins
    plugins=( "${ZPLGM[PLUGINS_DIR]}"/*(DN) )

    local p user plugin
    for p in "${plugins[@]}"; do
        [[ "${p:t}" = "custom" || "${p:t}" = "_local---zplugin" ]] && continue

        -zplg-any-to-user-plugin "${p:t}"
        user="${reply[-2]}" plugin="${reply[-1]}"

        -zplg-any-colorify-as-uspl2 "$user" "$plugin"
        print -r -- "$REPLY:"

        if [[ "$compile" = "1" ]]; then
            -zplg-compile-plugin "$user" "$plugin"
        else
            -zplg-uncompile-plugin "$user" "$plugin" "1"
        fi
    done
} # }}}
# FUNCTION: -zplg-uncompile-plugin {{{
# Uncompiles given plugin.
#
# User-action entry point.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user (+ plugin in $2), plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-uncompile-plugin() {
    builtin setopt localoptions nullglob

    -zplg-any-to-user-plugin "$1" "$2"
    local user="${reply[-2]}" plugin="${reply[-1]}" silent="$3"

    # There are plugins having ".plugin.zsh"
    # in ${plugin} directory name, also some
    # have ".zsh" there
    [[ "$user" = "%" ]] && local pdir_path="$plugin" || local pdir_path="${ZPLGM[PLUGINS_DIR]}/${user:+${user}---}${plugin//\//---}"
    typeset -a matches m
    matches=( $pdir_path/*.zwc(DN) )

    if [[ "${#matches[@]}" -eq "0" ]]; then
        if [[ "$silent" = "1" ]]; then
            print "not compiled"
        else
            -zplg-any-colorify-as-uspl2 "$user" "$plugin"
            print -r -- "$REPLY not compiled"
        fi
        return 1
    fi

    for m in "${matches[@]}"; do
        print "Removing ${ZPLGM[col-info]}${m:t}${ZPLGM[col-rst]}"
        command rm -f "$m"
    done
} # }}}

# FUNCTION: -zplg-show-completions {{{
# Display installed (enabled and disabled), completions. Detect
# stray and improper ones.
#
# Completions live even when plugin isn't loaded - if they are
# installed and enabled.
#
# User-action entry point.
-zplg-show-completions() {
    builtin setopt localoptions nullglob extendedglob nokshglob noksharrays
    local count="${1:-3}"

    typeset -a completions
    completions=( "${ZPLGM[COMPLETIONS_DIR]}"/_[^_.]*~*.zwc "${ZPLGM[COMPLETIONS_DIR]}"/[^_.]*~*.zwc )

    local cpath c o s group

    # Prepare readlink command for establishing
    # completion's owner
    -zplg-prepare-readlink
    local rdlink="$REPLY"

    float flmax=${#completions} flcur=0
    typeset -F1 flper

    local -A owner_to_group
    local -a packs splitted

    integer disabled unknown stray
    for cpath in "${completions[@]}"; do
        c="${cpath:t}"
        [[ "${c#_}" = "${c}" ]] && disabled=1 || disabled=0
        c="${c#_}"

        # This will resolve completion's symlink to obtain
        # information about the repository it comes from, i.e.
        # about user and plugin, taken from directory name
        -zplg-get-completion-owner "$cpath" "$rdlink"
        [[ "$REPLY" = "[unknown]" ]] && unknown=1 || unknown=0
        o="$REPLY"

        # If we successfully read a symlink (unknown == 0), test if it isn't broken
        stray=0
        if (( unknown == 0 )); then
            [[ ! -f "$cpath" ]] && stray=1
        fi

        s=$(( 1*disabled + 2*unknown + 4*stray ))

        owner_to_group[${o}--$s]+="$c;"
        group="${owner_to_group[${o}--$s]%;}"
        splitted=( "${(s:;:)group}" )

        if [[ "${#splitted}" -ge "$count" ]]; then
            packs+=( "${(q)group//;/, } ${(q)o} ${(q)s}" )
            unset "owner_to_group[${o}--$s]"
        fi

        (( ++ flcur ))
        flper=$(( flcur / flmax * 100 ))
        print -u 2 -n -- "\r${flper}% "
    done

    for o in "${(k)owner_to_group[@]}"; do
        group="${owner_to_group[$o]%;}"
        s="${o##*--}"
        o="${o%--*}"
        packs+=( "${(q)group//;/, } ${(q)o} ${(q)s}" )
    done
    packs=( "${(on)packs[@]}" )

    print -u 2 # newline after percent

    # Find longest completion name
    integer longest=0
    local -a unpacked
    for c in "${packs[@]}"; do
        unpacked=( "${(Q@)${(z@)c}}" )
        [[ "${#unpacked[1]}" -gt "$longest" ]] && longest="${#unpacked[1]}"
    done

    for c in "${packs[@]}"; do
        unpacked=( "${(Q@)${(z@)c}}" ) # TODO: ${(Q)${(z@)c}[@]} ?

        -zplg-any-colorify-as-uspl2 "$unpacked[2]"
        print -n "${(r:longest+1:: :)unpacked[1]} $REPLY"

        (( unpacked[3] & 0x1 )) && print -n " ${ZPLGM[col-error]}[disabled]${ZPLGM[col-rst]}"
        (( unpacked[3] & 0x2 )) && print -n " ${ZPLGM[col-error]}[unknown file, clean with cclear]${ZPLGM[col-rst]}"
        (( unpacked[3] & 0x4 )) && print -n " ${ZPLGM[col-error]}[stray, clean with cclear]${ZPLGM[col-rst]}"
        print
    done
} # }}}
# FUNCTION: -zplg-clear-completions {{{
# Delete stray and improper completions.
#
# Completions live even when plugin isn't loaded - if they are
# installed and enabled.
#
# User-action entry point.
-zplg-clear-completions() {
    builtin setopt localoptions nullglob extendedglob nokshglob noksharrays

    typeset -a completions
    completions=( "${ZPLGM[COMPLETIONS_DIR]}"/_[^_.]*~*.zwc "${ZPLGM[COMPLETIONS_DIR]}"/[^_.]*~*.zwc )

    # Find longest completion name
    local cpath c
    integer longest=0
    for cpath in "${completions[@]}"; do
        c="${cpath:t}"
        c="${c#_}"
        [[ "${#c}" -gt "$longest" ]] && longest="${#c}"
    done

    -zplg-prepare-readlink
    local rdlink="$REPLY"

    integer disabled unknown stray
    for cpath in "${completions[@]}"; do
        c="${cpath:t}"
        [[ "${c#_}" = "${c}" ]] && disabled=1 || disabled=0
        c="${c#_}"

        # This will resolve completion's symlink to obtain
        # information about the repository it comes from, i.e.
        # about user and plugin, taken from directory name
        -zplg-get-completion-owner "$cpath" "$rdlink"
        [[ "$REPLY" = "[unknown]" ]] && unknown=1 || unknown=0
        -zplg-any-colorify-as-uspl2 "$REPLY"

        # If we successfully read a symlink (unknown == 0), test if it isn't broken
        stray=0
        if (( unknown == 0 )); then
            [[ ! -f "$cpath" ]] && stray=1
        fi

        if (( unknown == 1 || stray == 1 )); then
            print -n "Removing completion: ${(r:longest+1:: :)c} $REPLY"
            (( disabled )) && print -n " ${ZPLGM[col-error]}[disabled]${ZPLGM[col-rst]}"
            (( unknown )) && print -n " ${ZPLGM[col-error]}[unknown file]${ZPLGM[col-rst]}"
            (( stray )) && print -n " ${ZPLGM[col-error]}[stray]${ZPLGM[col-rst]}"
            print
            command rm -f "$cpath"
        fi
    done
} # }}}
# FUNCTION: -zplg-search-completions {{{
# While -zplg-show-completions() shows what completions are
# installed, this functions searches through all plugin dirs
# showing what's available in general (for installation).
#
# User-action entry point.
-zplg-search-completions() {
    builtin setopt localoptions nullglob extendedglob nokshglob noksharrays

    typeset -a plugin_paths
    plugin_paths=( "${ZPLGM[PLUGINS_DIR]}"/*(DN) )

    # Find longest plugin name. Things are ran twice here, first pass
    # is to get longest name of plugin which is having any completions
    integer longest=0
    typeset -a completions
    local pp
    for pp in "${plugin_paths[@]}"; do
        completions=( "$pp"/**/_[^_.]*~*(*.zwc|*.html|*.txt|*.png|*.jpg|*.jpeg|*.js|_zsh_highlight*|/zsdoc/*)(DN^/) )
        if [[ "${#completions[@]}" -gt 0 ]]; then
            local pd="${pp:t}"
            [[ "${#pd}" -gt "$longest" ]] && longest="${#pd}"
        fi
    done

    print "${ZPLGM[col-info]}[+]${ZPLGM[col-rst]} is installed, ${ZPLGM[col-p]}[-]${ZPLGM[col-rst]} uninstalled, ${ZPLGM[col-error]}[+-]${ZPLGM[col-rst]} partially installed"

    local c
    for pp in "${plugin_paths[@]}"; do
        completions=( "$pp"/**/_[^_.]*~*(*.zwc|*.html|*.txt|*.png|*.jpg|*.jpeg|*.js|_zsh_highlight*|/zsdoc/*)(DN^/) )

        if [[ "${#completions[@]}" -gt 0 ]]; then
            # Array of completions, e.g. ( _cp _xauth )
            completions=( "${completions[@]:t}" )

            # Detect if the completions are installed
            integer all_installed="${#completions[@]}"
            for c in "${completions[@]}"; do
                if [[ -e "${ZPLGM[COMPLETIONS_DIR]}/$c" || -e "${ZPLGM[COMPLETIONS_DIR]}/${c#_}" ]]; then
                    (( all_installed -- ))
                fi
            done

            if [[ "$all_installed" -eq "${#completions[@]}" ]]; then
                print -n "${ZPLGM[col-p]}[-]${ZPLGM[col-rst]} "
            elif [[ "$all_installed" -eq "0" ]]; then
                print -n "${ZPLGM[col-info]}[+]${ZPLGM[col-rst]} "
            else
                print -n "${ZPLGM[col-error]}[+-]${ZPLGM[col-rst]} "
            fi

            # Convert directory name to colorified $user/$plugin
            -zplg-any-colorify-as-uspl2 "${pp:t}"

            # Adjust for escape code (nasty, utilizes fact that
            # ${ZPLGM[col-rst]} is used twice, so as a $ZPLG_COL)
            integer adjust_ec=$(( ${#ZPLGM[col-rst]} * 2 + ${#ZPLGM[col-uname]} + ${#ZPLGM[col-pname]} ))

            print "${(r:longest+adjust_ec:: :)REPLY} ${(j:, :)completions}"
        fi
    done
} # }}}
# FUNCTION: -zplg-cenable {{{
# Disables given installed completion.
#
# User-action entry point.
#
# $1 - e.g. "_mkdir" or "mkdir"
-zplg-cenable() {
    local c="$1"
    c="${c#_}"

    local cfile="${ZPLGM[COMPLETIONS_DIR]}/_${c}"
    local bkpfile="${cfile:h}/$c"

    if [[ ! -e "$cfile" && ! -e "$bkpfile" ]]; then
        print "${ZPLGM[col-error]}No such completion \`$c'${ZPLGM[col-rst]}"
        return 1
    fi

    # Check if there is no backup file
    # This is treated as if the completion is already enabled
    if [[ ! -e "$bkpfile" ]]; then
        print "Completion ${ZPLGM[col-info]}$c${ZPLGM[col-rst]} already enabled"

        -zplg-check-comp-consistency "$cfile" "$bkpfile" 0
        return 1
    fi

    # Disabled, but completion file already exists?
    if [[ -e "$cfile" ]]; then
        print "${ZPLGM[col-error]}Warning: completion's file \`${cfile:t}' exists, will overwrite${ZPLGM[col-rst]}"
        print "${ZPLGM[col-error]}Completion is actually enabled and will re-enable it again${ZPLGM[col-rst]}"
        -zplg-check-comp-consistency "$cfile" "$bkpfile" 1
        command rm -f "$cfile"
    else
        -zplg-check-comp-consistency "$cfile" "$bkpfile" 0
    fi

    # Enable
    command mv "$bkpfile" "$cfile" # move completion's backup file created when disabling

    # Prepare readlink command for establishing completion's owner
    -zplg-prepare-readlink
    # Get completion's owning plugin
    -zplg-get-completion-owner-uspl2col "$cfile" "$REPLY"

    print "Enabled ${ZPLGM[col-info]}$c${ZPLGM[col-rst]} completion belonging to $REPLY"

    return 0
} # }}}
# FUNCTION: -zplg-cdisable {{{
# Enables given installed completion.
#
# User-action entry point.
#
# $1 - e.g. "_mkdir" or "mkdir"
-zplg-cdisable() {
    local c="$1"
    c="${c#_}"

    local cfile="${ZPLGM[COMPLETIONS_DIR]}/_${c}"
    local bkpfile="${cfile:h}/$c"

    if [[ ! -e "$cfile" && ! -e "$bkpfile" ]]; then
        print "${ZPLGM[col-error]}No such completion \`$c'${ZPLGM[col-rst]}"
        return 1
    fi

    # Check if it's already disabled
    # Not existing "$cfile" says that
    if [[ ! -e "$cfile" ]]; then
        print "Completion ${ZPLGM[col-info]}$c${ZPLGM[col-rst]} already disabled"

        -zplg-check-comp-consistency "$cfile" "$bkpfile" 0
        return 1
    fi

    # No disable, but bkpfile exists?
    if [[ -e "$bkpfile" ]]; then
        print "${ZPLGM[col-error]}Warning: completion's backup file \`${bkpfile:t}' already exists, will overwrite${ZPLGM[col-rst]}"
        -zplg-check-comp-consistency "$cfile" "$bkpfile" 1
        command rm -f "$bkpfile"
    else
        -zplg-check-comp-consistency "$cfile" "$bkpfile" 0
    fi

    # Disable
    command mv "$cfile" "$bkpfile"

    # Prepare readlink command for establishing completion's owner
    -zplg-prepare-readlink
    # Get completion's owning plugin
    -zplg-get-completion-owner-uspl2col "$bkpfile" "$REPLY"

    print "Disabled ${ZPLGM[col-info]}$c${ZPLGM[col-rst]} completion belonging to $REPLY"

    return 0
} # }}}

# FUNCTION: -zplg-cd {{{
# Jumps to plugin's directory (in Zplugin's home directory).
#
# User-action entry point.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-cd() {
    setopt localoptions extendedglob nokshglob noksharrays
    -zplg-get-path "$1" "$2" && {
        if [[ -e "$REPLY" ]]; then
            builtin cd "$REPLY"
        else
            print -r -- "No such plugin or snippet"
            return 1
        fi
        print
    } || {
        print -r -- "No such plugin or snippet"
        return 1
    }
} # }}}
# FUNCTION: -zplg-run-delete-hooks {{{
-zplg-run-delete-hooks() {
    if [[ -n ${ZPLG_ICE[atdelete]} ]]; then
        -zplg-countdown "atdelete" && ( (( ${+ZPLG_ICE[nocd]} == 0 )) && \
                { builtin cd -q "$5" && eval "${ZPLG_ICE[atdelete]}"; ((1)); } || \
                eval "${ZPLG_ICE[atdelete]}" )
    fi
    local -a arr
    reply=( "${(@on)ZPLG_EXTS[(I)z-annex hook:atdelete <->]}" )
    for key in "${reply[@]}"; do
        arr=( "${(Q)${(z@)ZPLG_EXTS[$key]}[@]}" )
        "${arr[5]}" "$1" "$2" $3 "$4" "$5" atdelete
    done
}
# }}}
# FUNCTION: -zplg-delete {{{
# Deletes plugin's or snippet's directory (in Zplugin's home directory).
#
# User-action entry point.
#
# $1 - snippet URL or plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-delete() {
    setopt localoptions extendedglob nokshglob noksharrays warncreateglobal

    # Parse options
    local -a opts
    opts=( --all --clean --yes -y -q --quiet )
    : ${@[@]//(#b)([ $'\t']##|(#s))(${(~j.|.)opts})([ $'\t']##|(#e))/${ICE_OPTS[${opt_map[${match[2]}]}]::=1}}
    set -- "${@[@]:#(${(~j.|.)opts})}"

    local the_id="$1${${1:#(%|/)*}:+${2:+/}}$2"

    # --all given?
    if (( ICE_OPTS[opt_--all] )); then
        -zplg-confirm "Prune all plugins in \`${ZPLGM[PLUGINS_DIR]}'"\
"and snippets in \`${ZPLGM[SNIPPETS_DIR]}'?" \
"command rm -rf ${${ZPLGM[PLUGINS_DIR]##[[:space:]]##}:-/tmp/abcEFG312}/*~*/_local---zplugin(ND) "\
"${${ZPLGM[SNIPPETS_DIR]##[[:space:]]##}:-/tmp/abcEFG312}/*~*/plugins(ND)"
        return $?
    fi

    # --clean given?
    if (( ICE_OPTS[opt_--clean] )); then
        -zplg-confirm "Prune ${ZPLGM[col-info]}CURRENTLY NOT LOADED${ZPLGM[col-rst]}"\
" plugins in ${ZPLGM[PLUGINS_DIR]}"\
" and snippets in ${ZPLGM[SNIPPETS_DIR]}?" \
"command rm -rf ${${ZPLGM[PLUGINS_DIR]##[[:space:]]##}:-/tmp/abcEFG312}/*~*/(${(j:|:)${ZPLG_REGISTERED_PLUGINS[@]//\//---}})(ND) "\
"${${ZPLGM[SNIPPETS_DIR]##[[:space:]]##}:-/tmp/abcEFG312}/*~*/(plugins|OMZ::lib|${(j:|:)${(@)${(@)${${ZPLG_SNIPPETS[@]% <*>}[@]:h}//\//--}}})(ND)"
        return $?
    fi

    local -A ZPLG_ICE
    local local_dir filename is_snippet

    -zplg-compute-ice "$the_id" "pack" \
        ZPLG_ICE local_dir filename is_snippet || return 1

    if [[ "$local_dir" != /* ]]
    then
        print "Obtained a risky, not-absolute path ($local_dir), aborting"
        return 1
    fi

    ZPLG_ICE[teleid]="${ZPLG_ICE[teleid]:-${ZPLG_ICE[id-as]}}"

    local -a files
    files=( "$local_dir"/*.(zsh|sh|bash|ksh)(DN:t)
        "$local_dir"/*(*DN:t) "$local_dir"/*(@DN:t) "$local_dir"/*(.DN:t)
        "$local_dir"/*~*/.(_zplugin|svn|git)(/DN:t) "$local_dir"/*(=DN:t)
        "$local_dir"/*(pDN:t) "$local_dir"/*(%DN:t)
    )
    (( !${#files} )) && files=( "no files?" )
    files=( ${(@)files[1,4]} ${files[4]+more…} )

    if (( is_snippet )); then
        if [[ "${+ZPLG_ICE[svn]}" = "1" ]] {
            if [[ -e "$local_dir" ]]
            then
                -zplg-confirm "Delete $local_dir? (it holds: ${(j:, :)${(@u)files}})" \
                    "-zplg-run-delete-hooks snippet \"${ZPLG_ICE[teleid]}\" \"\" \"$the_id\" \
                    \"$local_dir\"; \
                    command rm -rf ${(q)${${local_dir:#/}:-/tmp/abcYZX321}}"
            else
                print "No such snippet"
                return 1
            fi
        } else {
            if [[ -e "$local_dir" ]]; then
                -zplg-confirm "Delete $local_dir? (it holds: ${(j:, :)${(@u)files}})" \
                    "-zplg-run-delete-hooks snippet \"${ZPLG_ICE[teleid]}\" \"\" \"$the_id\" \
                    \"$local_dir\"; command rm -rf \
                        ${(q)${${local_dir:#/}:-/tmp/abcYZX321}}"
            else
                print "No such snippet"
                return 1
            fi
        }
    else
        -zplg-any-to-user-plugin "${ZPLG_ICE[teleid]}"
        if [[ -e "$local_dir" ]]; then
            -zplg-confirm "Delete $local_dir? (it holds: ${(j:, :)${(@u)files}})" \
                "-zplg-run-delete-hooks plugin \"${reply[-2]}\" \"${reply[-1]}\" \"$the_id\" \
                \"$local_dir\"; \
                command rm -rf ${(q)${${local_dir:#/}:-/tmp/abcYZX321}}"
        else
            print -r -- "No such plugin or snippet"
            return 1
        fi
    fi

    return 0
} # }}}
# FUNCTION: -zplg-confirm {{{
# Prints given question, waits for "y" key, evals
# given expression if "y" obtained
#
# $1 - question
# $2 - expression
-zplg-confirm() {
    if (( ICE_OPTS[opt_-y,--yes] )); then
        integer retval
        eval "$2"; retval=$?
        (( ICE_OPTS[opt_-q,--quiet] )) || print "\nDone (action executed, exit code: $retval)"
    else
        print "$1"
        print "[yY/n…]"
        local ans
        read -q ans
        [[ "$ans" = "y" ]] && { eval "$2"; print "\nDone (action executed, exit code: $?)"; } || { print "\nBreak, no action"; return 1; }
    fi
    return 0
}
# }}}
# FUNCTION: -zplg-changes {{{
# Shows `git log` of given plugin.
#
# User-action entry point.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-changes() {
    -zplg-any-to-user-plugin "$1" "$2"
    local user="${reply[-2]}" plugin="${reply[-1]}"

    -zplg-exists-physically-message "$user" "$plugin" || return 1

    (
        builtin cd -q "${ZPLGM[PLUGINS_DIR]}/${user:+${user}---}${plugin//\//---}" && \
        command git log -p --graph --decorate --date=relative -C -M
    )
} # }}}
# FUNCTION: -zplg-recently {{{
# Shows plugins that obtained commits in specified past time.
#
# User-action entry point.
#
# $1 - time spec, e.g. "1 week"
-zplg-recently() {
    builtin setopt localoptions nullglob extendedglob nokshglob noksharrays

    local IFS="."
    local gitout
    local timespec="${*// ##/.}"
    timespec="${timespec//.##/.}"
    [[ -z "$timespec" ]] && timespec="1.week"

    typeset -a plugins
    plugins=( "${ZPLGM[PLUGINS_DIR]}"/*(DN) )

    local p uspl1
    for p in "${plugins[@]}"; do
        uspl1="${p:t}"
        [[ "$uspl1" = "custom" || "$uspl1" = "_local---zplugin" ]] && continue

        pushd "$p" >/dev/null
        if [[ -d ".git" ]]; then
            gitout=`command git log --all --max-count=1 --since=$timespec 2>/dev/null`
            if [[ -n "$gitout" ]]; then
                -zplg-any-colorify-as-uspl2 "$uspl1"
                print -r -- "$REPLY"
            fi
        fi
        popd >/dev/null
    done
} # }}}
# FUNCTION: -zplg-create {{{
# Creates a plugin, also on Github (if not "_local/name" plugin).
#
# User-action entry point.
#
# $1 - (optional) plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - (optional) plugin (only when $1 - i.e. user - given)
-zplg-create() {
    emulate -LR zsh
    setopt localoptions extendedglob warncreateglobal typesetsilent \
        noshortloops rcquotes 

    -zplg-any-to-user-plugin "$1" "$2"
    local user="${reply[-2]}" plugin="${reply[-1]}"

    if (( ${+commands[curl]} == 0 || ${+commands[git]} == 0 )); then
        print "${ZPLGM[col-error]}curl and git are needed${ZPLGM[col-rst]}"
        return 1
    fi

    # Read whether to create under organization
    local isorg
    vared -cp 'Create under an organization? (y/n): ' isorg

    if [[ $isorg = (y|yes) ]]; then
        local org="$user"
        vared -cp "Github organization name: " org
    fi

    # Read user
    local compcontext="user:User Name:(\"$USER\" \"$user\")"
    vared -cp "Github user name or just \"_local\" (or leave blank, for an userless plugin): " user

    # Read plugin
    unset compcontext
    vared -cp 'Plugin name: ' plugin

    if [[ "$plugin" = "_unknown" ]]; then
        print "${ZPLGM[col-error]}No plugin name entered${ZPLGM[col-rst]}"
        return 1
    fi

    plugin="${plugin//[^a-zA-Z0-9_]##/-}"
    -zplg-any-colorify-as-uspl2 "${${${(M)isorg:#(y|yes)}:+$org}:-$user}" "$plugin"
    local uspl2col="$REPLY"
    print "Plugin is $uspl2col"

    if -zplg-exists-physically "${${${(M)isorg:#(y|yes)}:+$org}:-$user}" "$plugin"; then
        print "${ZPLGM[col-error]}Repository${ZPLGM[col-rst]} $uspl2col ${ZPLGM[col-error]}already exists locally${ZPLGM[col-rst]}"
        return 1
    fi

    builtin cd -q "${ZPLGM[PLUGINS_DIR]}"

    if [[ "$user" != "_local" && -n "$user" ]]; then
        print "${ZPLGM[col-info]}Creating Github repository${ZPLGM[col-rst]}"
        if [[ $isorg = (y|yes) ]]; then
            curl --silent -u "$user" https://api.github.com/orgs/$org/repos -d '{"name":"'"$plugin"'"}' >/dev/null
        else
            curl --silent -u "$user" https://api.github.com/user/repos -d '{"name":"'"$plugin"'"}' >/dev/null
        fi
        command git clone "https://github.com/${${${(M)isorg:#(y|yes)}:+$org}:-$user}/${plugin}.git" "${${${(M)isorg:#(y|yes)}:+$org}:-$user}---${plugin//\//---}" || {
            print "${ZPLGM[col-error]}Creation of remote repository $uspl2col ${ZPLGM[col-error]}failed${ZPLGM[col-rst]}"
            print "${ZPLGM[col-error]}Bad credentials?${ZPLGM[col-rst]}"
            return 1
        }
        builtin cd -q "${${${(M)isorg:#(y|yes)}:+$org}:-$user}---${plugin//\//---}"
        command git config credential.https://github.com.username "${user}"
    else
        print "${ZPLGM[col-info]}Creating local git repository${${user:+.}:-, ${ZPLGM[col-pname]}free-style, without the \"_local/\" part${ZPLGM[col-info]}.}${ZPLGM[col-rst]}"
        command mkdir "${user:+${user}---}${plugin//\//---}"
        builtin cd -q "${user:+${user}---}${plugin//\//---}"
        command git init || {
            print "Git repository initialization failed, aborting"
            return 1
        }
    fi

    local user_name="$(command git config user.name 2>/dev/null)"
    local year="${$(command date "+%Y"):-2019}"

    command cat >! "${plugin:t}.plugin.zsh" <<EOF
# -*- mode: sh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-

# Copyright (c) $year $user_name

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0=\${\${ZERO:-\${0:#\$ZSH_ARGZERO}}:-\${(%):-%N}}
0=\${\${(M)0:#/*}:-\$PWD/\$0}

# Then \${0:h} to get plugin's directory

if [[ \${zsh_loaded_plugins[-1]} != */${plugin:t} && -z \${fpath[(r)\${0:h}]} ]]
then
    fpath+=( "\${0:h}" )
fi

typeset -g ${${(U)plugin:t}//-/_}_DIR=\${0:h}

autoload -Uz example-script

# vim:ft=zsh:sw=4:sts=4:et
EOF

    print -r -- "# $plugin" >! "README.md"
    command cp -vf "${ZPLGM[BIN_DIR]}/LICENSE" LICENSE
    command cp -vf "${ZPLGM[BIN_DIR]}/doc/Zsh.gitignore" .gitignore
    command cp -vf "${ZPLGM[BIN_DIR]}/doc/example-script" .

    command sed -i -e "s/MY_PLUGIN_DIR/${${(U)plugin:t}//-/_}_DIR/g" example-script
    command sed -i -e "s/USER_NAME/$user_name/g" example-script
    command sed -i -e "s/YEAR/$year/g" example-script

    if [[ "$user" != "_local" && -n "$user" ]]; then
        print "Remote repository $uspl2col set up as origin."
        print "You're in plugin's local folder, the files aren't added to git."
        print "Your next step after commiting will be:"
        print "git push -u origin master"
    else
        print "Created local $uspl2col plugin."
        print "You're in plugin's repository folder, the files aren't added to git."
    fi
} # }}}
# FUNCTION: -zplg-glance {{{
# Shows colorized source code of plugin. Is able to use pygmentize,
# highlight, GNU source-highlight.
#
# User-action entry point.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-glance() {
    -zplg-any-to-user-plugin "$1" "$2"
    local user="${reply[-2]}" plugin="${reply[-1]}"

    -zplg-exists-physically-message "$user" "$plugin" || return 1

    -zplg-first "$1" "$2" || {
        print "${ZPLGM[col-error]}No source file found, cannot glance${ZPLGM[col-rst]}"
        return 1
    }

    local fname="${reply[-1]}"

    integer has_256_colors=0
    [[ "$TERM" = xterm* || "$TERM" = "screen" ]] && has_256_colors=1

    {
        if (( ${+commands[pygmentize]} )); then
            print "Glancing with ${ZPLGM[col-info]}pygmentize${ZPLGM[col-rst]}"
            pygmentize -l bash -g "$fname"
        elif (( ${+commands[highlight]} )); then
            print "Glancing with ${ZPLGM[col-info]}highlight${ZPLGM[col-rst]}"
            if (( has_256_colors )); then
                highlight -q --force -S sh -O xterm256 "$fname"
            else
                highlight -q --force -S sh -O ansi "$fname"
            fi
        elif (( ${+commands[source-highlight]} )); then
            print "Glancing with ${ZPLGM[col-info]}source-highlight${ZPLGM[col-rst]}"
            source-highlight -fesc --failsafe -s zsh -o STDOUT -i "$fname"
        else
            cat "$fname"
        fi
    } | {
        if [[ -t 1 ]]; then
            -zplg-pager
        else
            cat
        fi
    }
} # }}}
# FUNCTION: -zplg-edit {{{
# Runs $EDITOR on source of given plugin. If the variable is not
# set then defaults to `vim'.
#
# User-action entry point.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-edit() {
    local -A ZPLG_ICE
    local local_dir filename is_snippet the_id="$1${${1:#(%|/)*}:+${2:+/}}$2"

    -zplg-compute-ice "$the_id" "pack" \
        ZPLG_ICE local_dir filename is_snippet || return 1

    ZPLG_ICE[teleid]="${ZPLG_ICE[teleid]:-${ZPLG_ICE[id-as]}}"

    if (( is_snippet )); then
        if [[ ! -e "$local_dir" ]]; then
            print "No such snippet"
            return 1
        fi
    else
        if [[ ! -e "$local_dir" ]]; then
            print -r -- "No such plugin or snippet"
            return 1
        fi
    fi

    "${EDITOR:-vim}" "$local_dir"
    return 0
} # }}}
# FUNCTION: -zplg-stress {{{
# Compiles plugin with various options on and off to see
# how well the code is written. The options are:
#
# NO_SHORT_LOOPS, IGNORE_BRACES, IGNORE_CLOSE_BRACES, SH_GLOB,
# CSH_JUNKIE_QUOTES, NO_MULTI_FUNC_DEF.
#
# User-action entry point.
#
# $1 - plugin spec (4 formats: user---plugin, user/plugin, user, plugin)
# $2 - plugin (only when $1 - i.e. user - given)
-zplg-stress() {
    -zplg-any-to-user-plugin "$1" "$2"
    local user="${reply[-2]}" plugin="${reply[-1]}"

    -zplg-exists-physically-message "$user" "$plugin" || return 1

    -zplg-first "$1" "$2" || {
        print "${ZPLGM[col-error]}No source file found, cannot stress${ZPLGM[col-rst]}"
        return 1
    }

    local pdir_path="${reply[-2]}" fname="${reply[-1]}"

    integer compiled=1
    [[ -e "${fname}.zwc" ]] && command rm -f "${fname}.zwc" || compiled=0

    local -a ZPLG_STRESS_TEST_OPTIONS
    ZPLG_STRESS_TEST_OPTIONS=(
        "NO_SHORT_LOOPS" "IGNORE_BRACES" "IGNORE_CLOSE_BRACES"
        "SH_GLOB" "CSH_JUNKIE_QUOTES" "NO_MULTI_FUNC_DEF"
    )

    (
        emulate -LR ksh
        builtin unsetopt shglob kshglob
        for i in "${ZPLG_STRESS_TEST_OPTIONS[@]}"; do
            builtin setopt "$i"
            print -n "Stress-testing ${fname:t} for option $i "
            zcompile -R "$fname" 2>/dev/null && {
                print "[${ZPLGM[col-success]}Success${ZPLGM[col-rst]}]"
            } || {
                print "[${ZPLGM[col-failure]}Fail${ZPLGM[col-rst]}]"
            }
            builtin unsetopt "$i"
        done
    )

    command rm -f "${fname}.zwc"
    (( compiled )) && zcompile "$fname"
} # }}}
# FUNCTION: -zplg-list-compdef-replay {{{
# Shows recorded compdefs (called by plugins loaded earlier).
# Plugins often call `compdef' hoping for `compinit' being
# already ran. Zplugin solves this by recording compdefs.
#
# User-action entry point.
-zplg-list-compdef-replay() {
    print "Recorded compdefs:"
    local cdf
    for cdf in "${ZPLG_COMPDEF_REPLAY[@]}"; do
        print "compdef ${(Q)cdf}"
    done
} # }}}
# FUNCTION: -zplg-ls {{{
-zplg-ls() {
    (( ${+commands[tree]} )) || {
        print "${ZPLGM[col-error]}No \`tree' program, it is required by the subcommand \`ls\'${ZPLGM[col-rst]}"
        print "Download from: http://mama.indstate.edu/users/ice/tree/"
        print "It is also available probably in all distributions and Homebrew, as package \`tree'"
    }
    (
        setopt localoptions extendedglob nokshglob noksharrays
        builtin cd -q "${ZPLGM[SNIPPETS_DIR]}"
        local -a list
        list=( "${(f@)"$(LANG=en_US.utf-8 tree -L 3 --charset utf-8)"}" )
        # Oh-My-Zsh single file
        list=( "${list[@]//(#b)(https--github.com--robbyrussell--oh-my-zsh--raw--master(--)(#c0,1)(*))/$ZPLGM[col-info]Oh-My-Zsh$ZPLGM[col-error]${match[2]/--//}$ZPLGM[col-pname]${match[3]//--/$ZPLGM[col-error]/$ZPLGM[col-pname]} $ZPLGM[col-info](single-file)$ZPLGM[col-rst] ${match[1]}}" )
        # Oh-My-Zsh SVN
        list=( "${list[@]//(#b)(https--github.com--robbyrussell--oh-my-zsh--trunk(--)(#c0,1)(*))/$ZPLGM[col-info]Oh-My-Zsh$ZPLGM[col-error]${match[2]/--//}$ZPLGM[col-pname]${match[3]//--/$ZPLGM[col-error]/$ZPLGM[col-pname]} $ZPLGM[col-info](SVN)$ZPLGM[col-rst] ${match[1]}}" )
        # Prezto single file
        list=( "${list[@]//(#b)(https--github.com--sorin-ionescu--prezto--raw--master(--)(#c0,1)(*))/$ZPLGM[col-info]Prezto$ZPLGM[col-error]${match[2]/--//}$ZPLGM[col-pname]${match[3]//--/$ZPLGM[col-error]/$ZPLGM[col-pname]} $ZPLGM[col-info](single-file)$ZPLGM[col-rst] ${match[1]}}" )
        # Prezto SVN
        list=( "${list[@]//(#b)(https--github.com--sorin-ionescu--prezto--trunk(--)(#c0,1)(*))/$ZPLGM[col-info]Prezto$ZPLGM[col-error]${match[2]/--//}$ZPLGM[col-pname]${match[3]//--/$ZPLGM[col-error]/$ZPLGM[col-pname]} $ZPLGM[col-info](SVN)$ZPLGM[col-rst] ${match[1]}}" )

        # First-level names
        list=( "${list[@]//(#b)(#s)(│   └──|    └──|    ├──|│   ├──) (*)/${match[1]} $ZPLGM[col-error]${match[2]}$ZPLGM[col-rst]}" )

        list[-1]+=", located at ZPLGM[SNIPPETS_DIR], i.e. ${ZPLGM[SNIPPETS_DIR]}"
        print -rl -- "${list[@]}"
    )
}
# }}}
# FUNCTION: -zplg-get-path {{{
# Returns path of given ID-string, which may be a plugin-spec
# (like "user/plugin" or "user" "plugin"), an absolute path
# ("%" "/home/..." and also "%SNIPPETS/..." etc.), or a plugin
# nickname (i.e. id-as'' ice-mod), or a snippet nickname.
-zplg-get-path() {
    setopt localoptions extendedglob nokshglob noksharrays
    local the_id="$1${${1:#(%|/)*}:+${2:+/}}$2"

    -zplg-two-paths "$the_id"
    local s_path="${reply[-4]}" s_svn="${reply[-3]}" _path="${reply[-2]}" _filename="${reply[-1]}"

    reply=()
    REPLY=""

    if [[ -d "$s_path" || -d "$_path" ]]; then
        local -A sice
        local -a tmp
        tmp=( "${(z@)ZPLG_SICE[$the_id]}" )
        (( ${#tmp} > 1 && ${#tmp} % 2 == 0 )) && sice=( "${(Q)tmp[@]}" )

        [[ "${+sice[svn]}" = "1" || -n "$s_svn" ]] && {
            [[ -e "$s_path" ]] && REPLY="$s_path"
        } || {
            reply=( ${_filename:+"$_filename"} )
            [[ -e "$_path" ]] && REPLY="$_path"
        }
    else
        -zplg-any-to-user-plugin "$1" "$2"
        local user="${reply[-2]}" plugin="${reply[-1]}"
        reply=()

        -zplg-exists-physically "$user" "$plugin" || return 1

        -zplg-shands-exp "$1" "$2" && {
            :
        } || {
            REPLY="${ZPLGM[PLUGINS_DIR]}/${user:+${user}---}${plugin//\//---}"
        }
    fi

    return 0
}
# }}}
# FUNCTION: -zplg-recall {{{
-zplg-recall() {
    local -A ice
    local el val cand1 cand2 local_dir filename is_snippet

    local -a ice_order nval_ices output
    ice_order=(
        svn proto from teleid bindmap cloneopts id-as depth if wait load
        unload blockf pick bpick src as ver silent lucid notify mv cp
        atinit atclone atload atpull nocd run-atpull has cloneonly make
        service trackbinds multisrc compile nocompile nocompletions
        reset-prompt wrap-track reset sh \!sh bash \!bash ksh \!ksh csh
        \!csh aliases countdown ps-on-unload ps-on-update trigger-load
        light-mode is-snippet atdelete pack git verbose on-update-of
        subscribe
        # Include all additional ices – after
        # stripping them from the possible: ''
        ${(@us.|.)${ZPLG_EXTS[ice-mods]//\'\'/}}
    )
    nval_ices=(
            blockf silent lucid trackbinds cloneonly nocd run-atpull
            nocompletions sh \!sh bash \!bash ksh \!ksh csh \!csh
            aliases countdown light-mode is-snippet git verbose

            # Include only those additional ices,
            # don't have the '' in their name, i.e.
            # aren't designed to hold value
            ${(@)${(@s.|.)ZPLG_EXTS[ice-mods]}:#*\'\'*}

            # Must be last
            svn
    )
    -zplg-compute-ice "$1${${1:#(%|/)*}:+${2:+/}}$2" "pack" \
        ice local_dir filename is_snippet || return 1

    [[ -e "$local_dir" ]] && {
        for el in "${ice_order[@]}"; do
            val="${ice[$el]}"
            cand1="${(qqq)val}"
            cand2="${(qq)val}"
            if [[ -n "$val" ]]; then
                [[ "${cand1/\\\$/}" != "$cand1" || "${cand1/\\\!/}" != "$cand1" ]] && output+=( "$el$cand2" ) || output+=( "$el$cand1" )
            elif [[ ${+ice[$el]} = 1 && ( -n "${nval_ices[(r)$el]}" || "$el" = (make|nocompile|notify|reset) ) ]]; then
                output+=( "$el" )
            fi
        done

        if [[ "${#output}" = 0 ]]; then
            print -zr "# No Ice modifiers"
        else
            print -zr "zplugin ice ${output[*]}; zplugin "
        fi
        -zplg-deploy-message @rst
    } || print -r -- "No such plugin or snippet"
}
# }}}
# FUNCTION: -zplg-module {{{
# Function that has sub-commands passed as long-options (with two dashes, --).
# It's an attempt to plugin only this one function into `zplugin' function
# defined in zplugin.zsh, to not make this file longer than it's needed.
-zplg-module() {
    if [[ "$1" = "build" ]]; then
        -zplg-build-module "${@[2,-1]}"
    elif [[ "$1" = "info" ]]; then
        if [[ "$2" = "--link" ]]; then
              print -r "You can copy the error messages and submit"
              print -r "error-report at: https://github.com/zdharma/zplugin/issues"
        else
            print -r "To load the module, add following 2 lines to .zshrc, at top:"
            print -r "    module_path+=( \"${ZPLGM[BIN_DIR]}/zmodules/Src\" )"
            print -r "    zmodload zdharma/zplugin"
            print -r ""
            print -r "After loading, use command \`zpmod' to communicate with the module."
            print -r "See \`zpmod -h' for more information."
        fi
    elif [[ "$1" = (help|usage) ]]; then
        print -r "Usage: zplugin module {build|info|help} [options]"
        print -r "       zplugin module build [--clean]"
        print -r "       zplugin module info [--link]"
        print -r ""
        print -r "To start using the zplugin Zsh module run: \`zplugin module build'"
        print -r "and follow the instructions. Option --clean causes \`make distclean'"
        print -r "to be run. To display the instructions on loading the module, run:"
        print -r "\`zplugin module info'."
    fi
}
# }}}
# FUNCTION: -zplg-build-module {{{
# Performs ./configure && make on the module and displays information
# how to load the module in .zshrc.
-zplg-build-module() {
    setopt localoptions localtraps
    trap 'return 1' INT TERM
    ( builtin cd -q "${ZPLGM[BIN_DIR]}"/zmodules
      print -r -- "${ZPLGM[col-pname]}== Building module zdharma/zplugin, running: make clean, then ./configure and then make ==${ZPLGM[col-rst]}"
      print -r -- "${ZPLGM[col-pname]}== The module sources are located at: "${ZPLGM[BIN_DIR]}"/zmodules ==${ZPLGM[col-rst]}"
      [[ -f Makefile ]] && { [[ "$1" = "--clean" ]] && {
              print -r -- ${ZPLGM[col-p]}-- make distclean --${ZPLGM[col-rst]}
              make distclean
              ((1))
          } || {
              print -r -- ${ZPLGM[col-p]}-- make clean --${ZPLGM[col-rst]}
              make clean
          }
      }
      print -r -- ${ZPLGM[col-p]}-- ./configure --${ZPLGM[col-rst]}
      CPPFLAGS=-I/usr/local/include CFLAGS="-g -Wall -O3" LDFLAGS=-L/usr/local/lib ./configure --disable-gdbm --without-tcsetpgrp && {
          print -r -- ${ZPLGM[col-p]}-- make --${ZPLGM[col-rst]}
          make && {
            [[ -f Src/zdharma/zplugin.so ]] && cp -vf Src/zdharma/zplugin.{so,bundle}
            print -r -- "${ZPLGM[col-info]}Module has been built correctly.${ZPLGM[col-rst]}"
            -zplg-module info
          } || {
              print -rn -- "${ZPLGM[col-error]}Module didn't build.${ZPLGM[col-rst]} "
              -zplg-module info --link
          }
      }
    )
}
# }}}

#
# Help function
#

# FUNCTION: -zplg-help {{{
# Shows usage information.
#
# User-action entry point.
-zplg-help() {
           print -r -- "${ZPLGM[col-p]}Usage${ZPLGM[col-rst]}:
—— -h|--help|help                – usage information
—— man                           – manual
—— self-update                   – updates and compiles Zplugin
—— times [-s] [-m]               – statistics on plugin load times, sorted in order of loading; -s – use seconds instead of milliseconds, -m – show plugin loading moments
—— zstatus                       – overall Zplugin status
—— load ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}                 – load plugin, can also receive absolute local path
—— light [-b] ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}           – light plugin load, without reporting/tracking (-b – do track but bindkey-calls only)
—— unload ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}               – unload plugin loaded with \`zplugin load ...', -q – quiet
—— snippet [-f] ${ZPLGM[col-pname]}{url}${ZPLGM[col-rst]}            – source local or remote file (by direct URL), -f: force – don't use cache
—— ls                            – list snippets in formatted and colorized manner
—— ice <ice specification>       – add ICE to next command, argument is e.g. from\"gitlab\"
—— update [-q] ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}|URL      – Git update plugin or snippet (or all plugins and snippets if ——all passed); besides -q accepts also ——quiet, and also -r/--reset – this option causes to run git reset --hard / svn revert before pulling changes
—— status ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}|URL           – Git status for plugin or svn status for snippet (or for all those if ——all passed)
—— report ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}               – show plugin's report (or all plugins' if ——all passed)
—— delete [--all|--clean] ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}|URL – remove plugin or snippet from disk (good to forget wrongly passed ice-mods); --all – purge, --clean – delete plugins and snippets that are not loaded
—— loaded|list [keyword]         – show what plugins are loaded (filter with \'keyword')
—— cd ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}                   – cd into plugin's directory; also support snippets, if feed with URL
—— create ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}               – create plugin (also together with Github repository)
—— edit ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}                 – edit plugin's file with \$EDITOR
—— glance ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}               – look at plugin's source (pygmentize, {,source-}highlight)
—— stress ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}               – test plugin for compatibility with set of options
—— changes ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}              – view plugin's git log
—— recently ${ZPLGM[col-info]}[time-spec]${ZPLGM[col-rst]}          – show plugins that changed recently, argument is e.g. 1 month 2 days
—— clist|completions             – list completions in use
—— cdisable ${ZPLGM[col-info]}cname${ZPLGM[col-rst]}                – disable completion \`cname'
—— cenable ${ZPLGM[col-info]}cname${ZPLGM[col-rst]}                 – enable completion \`cname'
—— creinstall ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}           – install completions for plugin, can also receive absolute local path; -q – quiet
—— cuninstall ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}           – uninstall completions for plugin
—— csearch                       – search for available completions from any plugin
—— compinit                      – refresh installed completions
—— dtrace|dstart                 – start tracking what's going on in session
—— dstop                         – stop tracking what's going on in session
—— dunload                       – revert changes recorded between dstart and dstop
—— dreport                       – report what was going on in session
—— dclear                        – clear report of what was going on in session
—— compile ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}              – compile plugin (or all plugins if ——all passed)
—— uncompile ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}            – remove compiled version of plugin (or of all plugins if ——all passed)
—— compiled                      – list plugins that are compiled
—— cdlist                        – show compdef replay list
—— cdreplay [-q]                 – replay compdefs (to be done after compinit), -q – quiet
—— cdclear [-q]                  – clear compdef replay list, -q – quiet
—— srv {service-id} [cmd]        – control a service, command can be: stop,start,restart,next,quit; \`next' moves the service to another Zshell
—— recall ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]}|URL           – fetch saved ice modifiers and construct \`zplugin ice ...' command
—— env-whitelist [-v|-h] {env..} – allows to specify names (also patterns) of variables left unchanged during an unload. -v – verbose
—— bindkeys                      – lists bindkeys set up by each plugin
—— module                        – manage binary Zsh module shipped with Zplugin, see \`zplugin module help'
—— add-fpath|fpath ${ZPLGM[col-info]}[-f|--front]${ZPLGM[col-rst]} \\
    ${ZPLGM[col-pname]}plg-spec ${ZPLGM[col-info]}[subdirectory]${ZPLGM[col-rst]}      – adds given plugin directory to \$fpath; if the second argument is given, it is appended to the directory path; if the option -f/--front is given, the directory path is prepended instead of appended to \$fpath. The ${ZPLGM[col-pname]}plg-spec${ZPLGM[col-rst]} can be absolute path
—— run [-l] [plugin] {command}   – runs the given command in the given plugin's directory; if the option -l will be given then the plugin should be skipped – the option will cause the previous plugin to be reused"

    integer idx
    local type key
    local -a arr
    for type in subcommand hook; do
        for (( idx=1; idx <= ZPLG_EXTS[seqno]; ++ idx )); do
            key="${(k)ZPLG_EXTS[(r)$idx *]}"
            [[ -z "$key" || "$key" != "z-annex $type:"* ]] && continue
            arr=( "${(Q)${(z@)ZPLG_EXTS[$key]}[@]}" )
            (( ${+functions[${arr[6]}]} )) && { "${arr[6]}"; ((1)); } || \
                { print -rl -- "(Couldn't find the help-handler \`${arr[6]}' of the z-annex \`${arr[3]}')"; }
        done
    done

print "
Available ice-modifiers:
        svn proto from teleid bindmap cloneopts id-as depth if wait load
        unload blockf on-update-of subscribe pick bpick src as ver silent
        lucid notify mv cp atinit atclone atload atpull nocd run-atpull has
        cloneonly make service trackbinds multisrc compile nocompile
        nocompletions reset-prompt wrap-track reset aliases sh bash ksh csh
        countdown trigger-load light-mode is-snippet atdelete pack git verbose"
} # }}}

# vim:ft=zsh:sw=4:sts=4:et

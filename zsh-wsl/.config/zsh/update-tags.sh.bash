#!/usr/bin/env bash

_complete_update_tags() {
	local cur tags commits

	# Set current argument
	cur="${COMP_WORDS[COMP_CWORD]}"

	# If two arguments are provided, complete SHA
	if [[ ${COMP_CWORD} -ge 2 ]]; then
		# Get list of commit SHAs
		commits=$(git rev-list --abbrev-commit HEAD)

		# Generate completion
		COMPREPLY=($(compgen -W "${commits}" -- "${cur}"))

	# Otherwise, get list of tags and generate completion
	elif [[ ${COMP_CWORD} -eq 1 ]]; then
		tags=$(git tag -l)
		COMPREPLY=($(compgen -W "${tags}" -- "${cur}"))
	fi
}

complete -F _complete_update_tags ut

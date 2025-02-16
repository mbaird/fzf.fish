function _fzf_search_git_log --description "Search the output of git log. Replace the current token with the selected commit hash."
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo '_fzf_search_git_log: Not in a git repository.' >&2
    else
        if not set --query fzf_git_log_format
            # %h gives you the abbreviated commit hash, which is useful for saving screen space, but we will have to expand it later below
            set -f fzf_git_log_format '%C(magenta)%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset'
        end

        set -f selected_log_lines (
            git log --no-show-signature --color=always --format=format:$fzf_git_log_format --date=short | \
            _fzf_wrapper --ansi \
                --multi \
                --scheme=history \
                --prompt="> " \
                --query=(commandline --current-token) \
                $fzf_git_log_opts
        )
        if test $status -eq 0
            for line in $selected_log_lines
                set -f abbreviated_commit_hash (string split --field 1 " " $line)
                set -f --append commit_hashes $abbreviated_commit_hash
            end
            commandline --current-token --replace (string join ' ' $commit_hashes)
        end
    end

    commandline --function repaint
end

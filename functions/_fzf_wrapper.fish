function _fzf_wrapper --description "Wraps `fzf` with some fish-specific options"
    set -l fish_fzf_opts --layout=reverse --height=60%
    fzf $fish_fzf_opts $argv
end

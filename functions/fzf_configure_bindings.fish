# Always installs bindings for insert and default mode for simplicity and b/c it has almost no side-effect
# https://gitter.im/fish-shell/fish-shell?at=60a55915ee77a74d685fa6b1
function fzf_configure_bindings --description "Installs the default key bindings for fzf.fish with user overrides passed as options."
    # no need to install bindings if not in interactive mode or running tests
    status is-interactive || test "$CI" = true; or return

    set -f options_spec h/help 'directory=?' 'git_log=?' 'history=?'
    argparse --max-args=0 --ignore-unknown $options_spec -- $argv 2>/dev/null
    if test $status -ne 0
        echo "Invalid option or a positional argument was provided." >&2
        _fzf_configure_bindings_help
        return 22
    else if set --query _flag_help
        _fzf_configure_bindings_help
        return
    else
        # Initialize with default key sequences and then override or disable them based on flags
        # index 1 = directory, 2 = git_log, 3 = history
        set -f key_sequences \ct \cl \cr # \c = control
        set --query _flag_directory && set key_sequences[1] "$_flag_directory"
        set --query _flag_git_log && set key_sequences[2] "$_flag_git_log"
        set --query _flag_history && set key_sequences[3] "$_flag_history"

        # If fzf bindings already exists, uninstall it first for a clean slate
        if functions --query _fzf_uninstall_bindings
            _fzf_uninstall_bindings
        end

        for mode in default insert
            test -n $key_sequences[1] && bind --mode $mode $key_sequences[1] _fzf_search_directory
            test -n $key_sequences[2] && bind --mode $mode $key_sequences[2] _fzf_search_git_log
            test -n $key_sequences[3] && bind --mode $mode $key_sequences[3] _fzf_search_history
        end

        function _fzf_uninstall_bindings --inherit-variable key_sequences
            bind --erase -- $key_sequences
            bind --erase --mode insert -- $key_sequences
        end
    end
end

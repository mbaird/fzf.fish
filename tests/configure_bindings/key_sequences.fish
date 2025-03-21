function binding_contains_func --argument-names sequence function_
    string match --entire $function_ (bind $sequence) >/dev/null
end

@test "default binding for directory works" (binding_contains_func \ct _fzf_search_directory) $status -eq 0
@test "default binding for git log works" (binding_contains_func \cl _fzf_search_git_log) $status -eq 0
@test "default binding for history works" (binding_contains_func \cr _fzf_search_history) $status -eq 0

fzf_configure_bindings --directory=\ca --git_log=\cb --history=\cc
@test "can override the default binding for directory" (binding_contains_func \ca _fzf_search_directory) $status -eq 0
@test "can override the default binding for git log" (binding_contains_func \cb _fzf_search_git_log) $status -eq 0
@test "can override the default binding for history" (binding_contains_func \cc _fzf_search_history) $status -eq 0

bind --mode insert \ca >/dev/null && bind --mode insert \cc >/dev/null
@test "installs bindings for insert mode" $status -eq 0

_fzf_uninstall_bindings
@test "custom key sequences are properly erased on uninstalling bindings" -z (bind --user | string match --entire _fzf_)

# intentionally test both style of passing options with no value
fzf_configure_bindings --directory
@test "can erase bindings by passing no key sequence" -z (bind --user | string match --entire --regex '_fzf_search_directory')
binding_contains_func \cl _fzf_search_git_log && binding_contains_func \cr _fzf_search_history
@test "installs default bindings that aren't customized" $status -eq 0

fzf_configure_bindings --unknown=\cq &>/dev/null
@test "fails if passed unknown option" $status -ne 0

fzf_configure_bindings arg --directory &>/dev/null
@test "fails if passed a positional arg" $status -ne 0

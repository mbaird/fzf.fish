# fzf.fish

Personal fork of [PatrickF1/fzf.fish](https://github.com/PatrickF1/fzf.fish).

Augment your [Fish][] command line with key bindings to find things with [fzf][].

## Dependencies

| CLI      | Minimum version required | Description                             |
| -------- | ------------------------ | --------------------------------------- |
| [fish][] | 3.4.0                    | a modern shell                          |
| [fzf][]  | 0.33.0                   | fuzzy finder that powers this plugin    |
| [fd][]   | 8.5.0                    | faster, colorized alternative to `find` |

## Installation

Install this plugin with [Fisher][].

```fish
fisher install mbaird/fzf.fish
```

## Configuration

### Customize key bindings

`fzf.fish` includes an ergonomic function for configuring its key bindings. Read [its documentation](/functions/_fzf_configure_bindings_help.fish):

```fish
fzf_configure_bindings --help
```

Call `fzf_configure_bindings` in your `config.fish` in order to persist your custom bindings.

### Change fzf options for all commands

fzf supports global default options via the [FZF_DEFAULT_OPTS](https://github.com/junegunn/fzf#environment-variables) environment variable.

`fzf.fish` sets [a sane `FZF_DEFAULT_OPTS` whenever it executes fzf](functions/_fzf_wrapper.fish). If you export your own `FZF_DEFAULT_OPTS`, then yours will be used instead.

### Change fzf options for a specific command

Each command's fzf options can be configured via a variable:

| Command          | Variable             |
| ---------------- | -------------------- |
| Search Directory | `fzf_directory_opts` |
| Search Git Log   | `fzf_git_log_opts`   |
| Search History   | `fzf_history_opts`   |

The value of each variable is appended last to fzf's options list. Because fzf uses the last instance of an option if it is specified multiple times, custom options take precedence. Custom fzf options unlock a variety of augmentations:

### Change what files are listed by Search Directory

To pass custom options to `fd` when [Search Directory][] executes it to populate the list of files, set them in `fzf_fd_opts`:

```fish
set fzf_fd_opts --hidden --max-depth 5
```

### Change Search Git Log's commit formatting

[Search Git Log][] executes `git log --format` to format the list of commits. To use your own [commit log format](https://git-scm.com/docs/git-log#Documentation/git-log.txt-emnem), set it in `fzf_git_log_format`. For example, this shows the hash and subject for each commit:

```fish
set fzf_git_log_format "%H %s"
```

The format must be one line per commit and the hash must be the first field, or else Search Git Log will fail to determine which commits you selected.

[cd docs]: https://fishshell.com/docs/current/cmds/cd.html
[fd]: https://github.com/sharkdp/fd
[fish]: https://fishshell.com
[fisher]: https://github.com/jorgebucaran/fisher
[fzf]: https://github.com/junegunn/fzf
[search directory]: #-search-directory
[search git log]: #-search-git-log
[search history]: #-search-history

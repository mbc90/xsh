# xsh

A lightweight, interactive shell written in Swift for macOS.

## Overview

xsh is a simple yet functional command-line shell that demonstrates shell implementation concepts using Swift. It provides a REPL (Read-Eval-Print Loop) interface with support for both built-in commands and external program execution. This shell is missing some features, such as job control, redirection, and pipes. Whether or not you find it useful, it was not made with the intention of being a full-featured shell, but rather as a learning tool for understanding shell internals and system calls with Swift.

## Features

### Built-in Commands

- **`exit`** - Exit the shell gracefully
- **`pwd`** - Print the current working directory
- **`cd [path]`** - Change directory
  - `cd` or `cd ~` - Navigate to home directory
  - `cd <path>` - Navigate to specified path (relative or absolute)
- **`hostname`** - Display the system hostname
- **`mkdir [options] <path>`** - Create directories
  - `mkdir <path>` - Create a single directory
  - `mkdir -p <path>` - Create directory with parent directories

### External Command Execution

xsh can execute any external command available in your system's `PATH`. It uses `posix_spawn` for efficient process creation and properly handles:
- Command path resolution from `PATH` environment variable
- Direct execution of commands with absolute or relative paths
- Argument passing to child processes
- Environment variable inheritance
- Process wait and status handling

`posix_spawn` is a necessary system call for efficient process creation and handling in xsh, the Foundation.Process() module in Swift does not provide a direct replacement for `posix_spawn`. Instead, it provides a higher-level API for managing processes and will not relinquish control to the interactive programs one may run like `htop` or `nvim`. You can pass `/bin/zsh` to `Foundation.Process` to execute interactive processes but I wanted xsh to stand on its own, without relying on external shells.

### User Interface

- **Smart Path Display**: Home directory is abbreviated with `~` in the prompt
- **Clean Prompt**: Shows current directory followed by `>`
- **Interactive**: Continuous REPL until explicitly exited

## Limitations

- **No Job Control**: Background jobs are not supported.
- **No Redirection**: Input/output redirection is not implemented.
- **No Pipes**: Pipeline support is missing.
- **No Aliases**: Command aliases are not supported.
- **No History**: Command history is not saved or displayed.
- **No Completion**: Tab completion is not implemented.
- **No Signals**: Signal handling is not implemented.
- **No Scripting**: Scripting features are not implemented.

## Requirements

- Swift 6.0 or later

## Installation

### Building from Source

1. Clone the repository:
```bash
git clone <repository-url>
cd xsh

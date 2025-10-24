# xsh

A lightweight, interactive shell written in Swift for macOS.

## Overview

xsh is a simple yet functional command-line shell that demonstrates shell implementation concepts using Swift. It provides a REPL (Read-Eval-Print Loop) interface with support for both built-in commands and external program execution.

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

### User Interface

- **Smart Path Display**: Home directory is abbreviated with `~` in the prompt
- **Clean Prompt**: Shows current directory followed by `>`
- **Interactive**: Continuous REPL until explicitly exited

## Requirements

- macOS 13.0 or later
- Swift 6.0 or later
- Xcode (for building)

## Installation

### Building from Source

1. Clone the repository:
```bash
git clone <repository-url>
cd xsh

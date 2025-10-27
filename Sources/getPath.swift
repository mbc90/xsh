//
// getPath.swift
// xsh - Path resolution and command execution utilities
//
// This file provides utilities for:
// 1. Resolving command names to executable paths
// 2. Spawning external processes using POSIX APIs
// 3. Path display formatting
//

import Foundation

/// Resolves a command name to its full executable path
///
/// - Parameter command: The command name to resolve (e.g., "ls" or "/bin/cat")
/// - Returns: Full path to the executable, or nil if not found
///
/// Resolution strategy:
/// 1. If command contains "/" - treat as direct path and verify it exists/is executable
/// 2. Otherwise, search each directory in the PATH environment variable
/// 3. Return the first executable match found

func getPath(command: String) -> String? {
    // If it contains a slash, treat it as a direct path
    if command.contains("/") {
        if FileManager.default.fileExists(atPath: command)
            && FileManager.default.isExecutableFile(atPath: command)
        {
            return command
        }
        return command

    }

    // Search in PATH
    guard let pathEnv = ProcessInfo.processInfo.environment["PATH"] else {
        return command
    }

    let paths = pathEnv.components(separatedBy: ":")

    // Search each directory in PATH for the command
    for directory in paths {
        let fullPath = directory + "/" + command
        if FileManager.default.isExecutableFile(atPath: fullPath) {
            return fullPath
        }
    }

    return command // Return the command if not found in PATH for debugging purposes

}

/// Executes an external command using posix_spawn
///
/// - Parameters:
///   - execPath: Full path to the executable
///   - args: Array of command-line arguments (not including the command itself)
///
/// This function:
/// 1. Prepares C-style argument array with the executable path as args[0]
/// 2. Converts current environment to C-style format
/// 3. Spawns the process and waits for it to complete
/// 4. Cleans up allocated memory

func runInteractiveCommand(execPath: String, args: [String]) {
    // Convert Swift strings to C strings (A lot easier than Zig...)
    var cArgs = args.map { strdup($0) } // null terminated char array
    cArgs.insert(strdup(execPath), at: 0)
    cArgs.append(nil) // Null terminated the entire array

    // Prepare environment variables in C-style format (Key=Value strings)
    var env = ProcessInfo.processInfo.environment.map { strdup("\($0.key)=\($0.value)") }
    env.append(nil) // Null terminated the entire array again!

    var pid = pid_t(0)

    // Spawn the process with POSIX API
    let status = posix_spawn(
        &pid,
        execPath,
        nil,  // file_actions - not used
        nil,  // attrp - not used
        cArgs,
        env
    )

    if status == 0 {
        // Wait for the child process to complete
        var childStatus = Int32(0)
        waitpid(pid, &childStatus, 0)
    } else {
        print("Failed to spawn process: \(status)")
    }

    // Free allocated memory
    cArgs.forEach { free($0) }
    env.forEach { free($0) }
}

/// Abbreviates the home directory path with ~ for cleaner display
///
/// - Parameter path: Full filesystem path
/// - Returns: Path with home directory replaced by ~ if applicable
///
/// Example: /Users/username/Documents -> ~/Documents

func abbrivateHomePath(path: String) -> String {
    let homePath = FileManager.default.homeDirectoryForCurrentUser.path
    if path.hasPrefix(homePath) {
        return path.replacingOccurrences(of: homePath, with: "~")
    }
    return path
}

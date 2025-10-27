// executeCommands.swift

//xsh/Sources/executeCommands.swift#L1-70
//
// executeCommands.swift
// xsh - Command execution and dispatch
//
// This file contains the command dispatcher that routes user input to either
// built-in shell commands or external executables found in PATH.
//


import Foundation
import Swift

#if canImport(Darwin)
    import Darwin
#elseif canImport(Glibc)
    import Glibc
#endif

/// Matches and executes commands, dispatching to built-ins or external executables
///
/// - Parameters:
///   - args: Array of command arguments where args[0] is the command name
///   - fileManager: FileManager instance for file system operations
///   - homeUser: Path to the current user's home directory
///
/// Built-in commands handled:
/// - exit: Terminates the shell
/// - pwd: Prints working directory
/// - cd: Changes directory (supports ~ for home)
/// - hostname: Displays the computer's hostname
/// - mkdir: Creates directories (supports -p flag for parent directories)
func matchProc(args: [String], fileManager: FileManager, homeUser: String) {
    switch args[0] {
    case "exit":
        print("Goodbye!")
        exit(0)

    case "pwd":
        print(fileManager.currentDirectoryPath)

    case "cd":
        // Handle cd command; if user did not give a path or if path is ~ go to home directory
        if args.count < 1 || args[1] == "~" {  // user did not give a path or path is ~
            guard fileManager.changeCurrentDirectoryPath(homeUser) else {
                print("Directory not found")
                return
            }

        } else {
            // change directory to the given path
            guard fileManager.changeCurrentDirectoryPath(args[1]) else {
                print("Directory not found")
                return
            }

        }

    case "hostname":
        print(Host.current().localizedName!)

    case "mkdir":
        // check for -p flag
        if args[1] == "-p" {  // if user wants to create parent directories
            do {
                try fileManager.createDirectory(
                    at: URL.init(filePath: args[2]), withIntermediateDirectories: true)
            } catch {
                print("Error creating Directory: \(error.localizedDescription)")
            }
        } else {
            // create directory without parent directories
            do {
                try fileManager.createDirectory(
                    at: URL.init(filePath: args[1]), withIntermediateDirectories: false)
            } catch {
                print("Error creating Directory: \(error.localizedDescription)")
            }
        }
    default:
        // not a built-in command - try to find and execute external command
        guard let execPath = getPath(command: args[0]) else {
            print("\(args[0]): Command Not Found")
            break
        }
        // Execute external command
        runInteractiveCommand(execPath: execPath, args: Array(args.dropFirst()))

    }

}

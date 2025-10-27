//
// main.swift
// xsh - A simple shell implementation in Swift
//
// This file contains the main REPL (Read-Eval-Print Loop) for the xsh shell.
// It handles user input, displays the prompt, and delegates command execution
// to the appropriate handlers.

import Foundation
import Swift

#if canImport(Darwin)
    import Darwin
#elseif canImport(Glibc)
    import Glibc
#endif
let fileManager = FileManager.default
let homeUser = fileManager.homeDirectoryForCurrentUser.path

print("Welcome to xsh!")
while true {
    let displayPath = abbrivateHomePath(path: fileManager.currentDirectoryPath)
    print(displayPath + " > ", terminator: "")
    // read the line
    let cmd = readLine()
    let args = cmd!.components(separatedBy: .whitespacesAndNewlines)  // unwrap it and split by whitespace and new lines
    // if args[0] is empty continue on
    if args[0].isEmpty {
        continue
    }
    // Start matching built ins
    matchProc(args: args, fileManager: fileManager, homeUser: homeUser)

}

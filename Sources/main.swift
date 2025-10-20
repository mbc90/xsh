// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import Swift
#if os(MacOS)
import Darwin
#endif

let fileManager = FileManager.default
let homeUser = fileManager.homeDirectoryForCurrentUser.path
import Foundation

print("Welcome to xsh!")
while true {
    let displayPath = abbrivateHomePath(path: fileManager.currentDirectoryPath)
    print(displayPath + " > ", terminator: "")
    // read the line
    let cmd = readLine()
    let args = cmd!.components(separatedBy: .whitespacesAndNewlines) // unwrap it and split by whitespace and new lines
    // if args[0] is empty print continure on
    if args[0].isEmpty {
       continue
    }
    // Start matching built ins
    matchProc(args: args, fileManager: fileManager, homeUser: homeUser)
    
}



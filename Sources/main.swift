// The Swift Programming Language
// https://docs.swift.org/swift-book
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

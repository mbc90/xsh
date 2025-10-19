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
    print(fileManager.currentDirectoryPath + " > ", terminator: "")
    // read the line
    let cmd = readLine()
    let args = cmd!.components(separatedBy: .whitespacesAndNewlines) // unwrap it and split by whitespace and new lines
    // if args[0] is empty print continure on
    if args[0].isEmpty {
       continue
    }
    // Start matching built ins
    switch args[0] {
    case "pwd":
        print(fileManager.currentDirectoryPath)
    case "cd":
        if args.count > 1 { // user did not give a path
           fileManager.changeCurrentDirectoryPath(args[1])
        } else {
            fileManager.changeCurrentDirectoryPath(homeUser)
            
        }
    case "hostname":
        print(Host.current().localizedName!)

    case "mkdir":
        if args[1] == "-p"{ // if user wants to create parent directories 
            do {
                try fileManager.createDirectory(at: URL.init(filePath: args[2]) , withIntermediateDirectories: true)
            } catch {
                print("Error creating Directory: \(error)")
            }
        } else {
            
            do {
                try fileManager.createDirectory(at: URL.init(filePath: args[1]) , withIntermediateDirectories: false)
            } catch {
                print("Error creating Directory: \(error)")
            }
        }
    default:
        guard let execPath = getPath(command: args[0]) else {
            print("\(args[0]): Command Not Found") 
            break
        }
        runInteractiveCommand(execPath: execPath, args: Array(args.dropFirst()))
        
    }

    
}



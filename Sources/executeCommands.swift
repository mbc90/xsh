import Foundation
import Swift
#if os(MacOS)
import Darwin
#endif

func matchProc(args: Array<String>, fileManager: FileManager, homeUser: String){
        switch args[0] {
    case "exit":
        print("Goodbye!")
        exit(0)

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

import Foundation
import Swift

#if canImport(Darwin)
    import Darwin
#elseif canImport(Glibc)
    import Glibc
#endif

func matchProc(args: [String], fileManager: FileManager, homeUser: String) {
    switch args[0] {
    case "exit":
        print("Goodbye!")
        exit(0)

    case "pwd":
        print(fileManager.currentDirectoryPath)

    case "cd":
        if args.count < 1 || args[1] == "~" {  // user did not give a path
            guard fileManager.changeCurrentDirectoryPath(homeUser) else {
                print("Directory not found")
                return
            }

        } else {
            guard fileManager.changeCurrentDirectoryPath(args[1]) else {
                print("Directory not found")
                return
            }

        }

    case "hostname":
        print(Host.current().localizedName!)

    case "mkdir":
        if args[1] == "-p" {  // if user wants to create parent directories
            do {
                try fileManager.createDirectory(
                    at: URL.init(filePath: args[2]), withIntermediateDirectories: true)
            } catch {
                print("Error creating Directory: \(error.localizedDescription)")
            }
        } else {

            do {
                try fileManager.createDirectory(
                    at: URL.init(filePath: args[1]), withIntermediateDirectories: false)
            } catch {
                print("Error creating Directory: \(error.localizedDescription)")
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

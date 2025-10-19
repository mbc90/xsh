import Foundation

func getPath(command: String) -> String? {
      // If it contains a slash, treat it as a direct path
    if command.contains("/") {
        if FileManager.default.fileExists(atPath: command) && 
           FileManager.default.isExecutableFile(atPath: command) {
            return command
        }
        print(command + " Found!")
        return command
        
    }
    
    // Search in PATH
    guard let pathEnv = ProcessInfo.processInfo.environment["PATH"] else {
        print(command + " Found!")
        return command
    }
    
    let paths = pathEnv.components(separatedBy: ":")
    
    for directory in paths {
        let fullPath = directory + "/" + command
        if FileManager.default.isExecutableFile(atPath: fullPath) {
            print(command + " Found at " + fullPath)
            return fullPath
        }
    }
    
    print(command + "Found!")
    return command

}

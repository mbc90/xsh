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
func runInteractiveCommand(execPath: String, args: [String]) {
    var cArgs = args.map { strdup($0) }
    cArgs.insert(strdup(execPath), at: 0)
    cArgs.append(nil)

    // Prepare environment
    var env = ProcessInfo.processInfo.environment.map { strdup("\($0.key)=\($0.value)") }
    env.append(nil)

    var pid = pid_t(0)
    let status = posix_spawn(
        &pid,
        execPath,
        nil, // file_actions
        nil, // attrp
        cArgs,
        env
    )

    if status == 0 {
        var childStatus = Int32(0)
        waitpid(pid, &childStatus, 0)
    } else {
        print("Failed to spawn process: \(status)")
    }

    // Free allocated memory
    cArgs.forEach { free($0) }
    env.forEach { free($0) }
}

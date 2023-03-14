import AppKit

extension Command {
  static func start(configFileAt: String) throws {
    let config = try loadConfig(from: configFileAt)

    if config.os == "linux" {
      let vm = try makeLinuxVM(with: config)

      let windowController = WindowController(
        virtualMachine: vm,
        width: config.displayWidth,
        height: config.displayHeight
      )
      let delegate = AppDelegate(windowController: windowController)
      vm.delegate = delegate
      vm.start { result in
        if case .failure(let error) = result {
          fatalError("Start failed. \(error)")
        }
      }

      NSApplication.shared.delegate = delegate
      NSApplication.shared.setActivationPolicy(.regular)
      _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    } else {
      fatalError("OS \"\(config.os)\" is not supported")
    }
  }
}

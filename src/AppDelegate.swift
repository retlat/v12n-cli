import AppKit
import Virtualization

final class AppDelegate: NSObject, NSApplicationDelegate, VZVirtualMachineDelegate {
  let windowController: WindowController

  init(windowController: WindowController) {
    self.windowController = windowController
  }

  func applicationWillFinishLaunching(_ notification: Notification) {
    let submenu = NSMenu(title: "")
    submenu.addItem(
      withTitle: "Quit",
      action: #selector(NSApplication.terminate(_:)),
      keyEquivalent: "q"
    )
    let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    item.submenu = submenu

    let menu = NSMenu()
    menu.addItem(item)
    NSApplication.shared.mainMenu = menu

    NSApplication.shared.activate(ignoringOtherApps: true)
  }

  func guestDidStop(_ virtualMachine: VZVirtualMachine) {
    NSApplication.shared.terminate(nil)
  }
}

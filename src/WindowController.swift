import AppKit
import Virtualization

final class WindowController: NSWindowController {
  init(virtualMachine: VZVirtualMachine, width: Int, height: Int) {
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: width, height: height),
      styleMask: NSWindow.StyleMask(
        arrayLiteral: .titled, .closable, .miniaturizable, .resizable
      ),
      backing: .buffered,
      defer: true
    )
    super.init(window: window)

    let view = VZVirtualMachineView()
    view.virtualMachine = virtualMachine

    window.contentView = view
    window.makeKeyAndOrderFront(self)
    window.center()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

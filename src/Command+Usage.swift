extension Command {
  static func usage() {
    print("""
    v12n-cli is a thin wrapper tool of Virtualization.Framework.

    Usage:
    v12n-cli start <config file path>
        Launch a virtual machine.

    v12n-cli print-config
        Print config template.
    """)
  }
}

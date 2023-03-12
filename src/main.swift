func main() throws {
  if CommandLine.arguments.count == 1 {
    Command.usage()
    return
  }

  guard CommandLine.arguments.indices.contains(1) else {
    fatalError()
  }

  switch CommandLine.arguments[1] {
  case "start":
    guard CommandLine.arguments.indices.contains(2) else {
      Command.usage()
      return
    }
    try Command.start(configFileAt: CommandLine.arguments[2])
  case "print-config":
    Command.printConfig()
  default:
    Command.usage()
  }
}

try main()

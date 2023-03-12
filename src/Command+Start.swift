extension Command {
  static func start(configFileAt: String) throws {
    let config = try loadConfig(from: configFileAt)
    print(config)
  }
}

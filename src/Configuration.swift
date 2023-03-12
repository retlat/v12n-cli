struct Configuration {
  let os: String
  let cpuCount: Int
  let memorySize: UInt64
  let dataDirectory: String
  let displayWidth: Int
  let displayHeight: Int
  let enableAudioOutput: Bool
  let enableAudioInput: Bool
  let installMediaPath: String?
  let diskSize: Int?
}

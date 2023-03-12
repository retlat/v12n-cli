import Foundation

func loadConfig(from path: String) throws -> Configuration {
  let content = try String(contentsOfFile: path)

  var os: String?
  var cpuCount: Int?
  var memorySize: UInt64?
  var dataDirectory: String?
  var displayWidth: Int?
  var displayHeight: Int?
  var enableAudioOutput = true
  var enableAudioInput = true
  var installMediaPath: String?
  var diskSize: Int?

  for line in content.split(separator: "\n") {
    if line == "" || line.hasPrefix("//") {
      continue
    }

    let s = line.split(separator: "=", maxSplits: 1)
    guard s.count == 2 else {
      continue
    }

    let value = s[1].trimmingCharacters(in: .whitespaces)
    switch s[0].trimmingCharacters(in: .whitespaces) {
    case "os":
      guard value == "mac" || value == "linux" else {
        fatalError("os must be \"mac\" or \"linux\"")
      }
      os = value
    case "cpu":
      guard let v = Int(value), v > 0 else {
        fatalError("cpuCount must be integer and larger than 0")
      }
      cpuCount = v
    case "memory":
      guard let v = Float(value) else {
        fatalError("memory must be float")
      }
      memorySize = UInt64(v * 1024 * 1024 * 1024)
    case "vm_directory":
      guard !value.isEmpty && value.hasPrefix("/") && !value.hasSuffix("/") else {
        fatalError("vm_directory must start with \"/\" and don't ends with \"/\"")
      }
      dataDirectory = value
    case "display_resolution":
      let v = value.split(separator: ",", maxSplits: 1)
      guard v.count == 2,
            let width = Int(v[0]),
            width > 0,
            let height = Int(v[1]),
            height > 0 else {
        fatalError(
          "display_resolution must be format like \"1280,720\"" +
          " and both values are integer larger than 0"
        )
      }
      displayWidth = width
      displayHeight = height
    case "enable_audio_output":
      guard value == "yes" || value == "no" else {
        fatalError("enable_audio_output must be \"yes\" or \"no\"")
      }
      enableAudioOutput = value == "yes"
    case "enable_audio_input":
      guard value == "yes" || value == "no" else {
        fatalError("enable_audio_input must be \"yes\" or \"no\"")
      }
      enableAudioInput = value == "yes"
    case "network_type":
      guard value == "nat" else {
        fatalError("network_type only supports \"nat\" type")
      }
    case "install_media":
      if value.isEmpty {
        continue
      }
      guard value.hasPrefix("/") && !value.hasSuffix("/") else {
        fatalError("vm_directory must start with \"/\" and don't ends with \"/\"")
      }
      installMediaPath = value
    case "storage_size":
      guard let v = Int(value), v > 0 else {
        fatalError("cpuCount must be integer and larger than 0")
      }
      diskSize = v
    default:
      continue
    }
  }

  guard let os = os,
        let cpuCount = cpuCount,
        let memorySize = memorySize,
        let dataDirectory = dataDirectory,
        let displayWidth = displayWidth,
        let displayHeight = displayHeight else {
    fatalError(
      "Config key \"os\", \"cpu\", \"memory\", \"vm_directory\"," +
      " \"display_resolution\" is required"
    )
  }

  return Configuration(
    os: os,
    cpuCount: cpuCount,
    memorySize: memorySize,
    dataDirectory: dataDirectory,
    displayWidth: displayWidth,
    displayHeight: displayHeight,
    enableAudioOutput: enableAudioOutput,
    enableAudioInput: enableAudioInput,
    installMediaPath: installMediaPath,
    diskSize: diskSize
  )
}

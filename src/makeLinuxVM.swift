import Foundation
import Virtualization

func makeLinuxVM(with loadedConfig: Configuration) throws -> VZVirtualMachine {
  let idPath = "\(loadedConfig.dataDirectory)/ID"
  let efiVarsPath = "\(loadedConfig.dataDirectory)/EFI_VARS"
  let diskPath = "\(loadedConfig.dataDirectory)/disk.img"

  let useInstallMedia = !FileManager.default.fileExists(atPath: diskPath)
  if
    useInstallMedia &&
    (loadedConfig.installMediaPath == nil || loadedConfig.diskSize == nil)
  {
    fatalError("Missing \"install_media\" or \"storage_size\".")
  }

  // Create data files if not exists

  if useInstallMedia {
    guard FileManager.default.createFile(atPath: diskPath, contents: nil) else {
      fatalError("Failed to create disk.")
    }
    let handle = try FileHandle(forWritingTo: URL(fileURLWithPath: diskPath))
    try handle.truncate(atOffset: UInt64(loadedConfig.diskSize! * 1024 * 1024 * 1024))
  }
  if !FileManager.default.fileExists(atPath: idPath) {
    try VZGenericMachineIdentifier().dataRepresentation
      .write(to: URL(fileURLWithPath: idPath))
  }
  if !FileManager.default.fileExists(atPath: efiVarsPath) {
    _ = try VZEFIVariableStore(creatingVariableStoreAt: URL(fileURLWithPath: efiVarsPath))
  }

  // Make configuration

  let config = VZVirtualMachineConfiguration()

  config.cpuCount = max(
    min(loadedConfig.cpuCount, VZVirtualMachineConfiguration.maximumAllowedCPUCount),
    VZVirtualMachineConfiguration.minimumAllowedCPUCount
  )
  config.memorySize = max(
    min(loadedConfig.memorySize, VZVirtualMachineConfiguration.maximumAllowedMemorySize),
    VZVirtualMachineConfiguration.minimumAllowedMemorySize
  )

  let platform = VZGenericPlatformConfiguration()
  guard let data = try? Data(contentsOf: URL(fileURLWithPath: idPath)),
        let machineID = VZGenericMachineIdentifier(dataRepresentation: data) else {
    fatalError("Failed to get machine ID")
  }
  platform.machineIdentifier = machineID
  config.platform = platform

  let bootLoader = VZEFIBootLoader()
  bootLoader.variableStore = VZEFIVariableStore(url: URL(fileURLWithPath: efiVarsPath))
  config.bootLoader = bootLoader

  let mainDiskAttachment = try VZDiskImageStorageDeviceAttachment(
    url: URL(fileURLWithPath: diskPath),
    readOnly: false
  )
  config.storageDevices = useInstallMedia
    ? [
      try VZUSBMassStorageDeviceConfiguration(
        attachment: VZDiskImageStorageDeviceAttachment(
          url: URL(fileURLWithPath: loadedConfig.installMediaPath!),
          readOnly: true
        )
      ),
      VZVirtioBlockDeviceConfiguration(attachment: mainDiskAttachment)
    ]
    : [VZVirtioBlockDeviceConfiguration(attachment: mainDiskAttachment)]

  let networkDevice = VZVirtioNetworkDeviceConfiguration()
  networkDevice.attachment = VZNATNetworkDeviceAttachment()
  config.networkDevices = [networkDevice]

  let graphicsDevice = VZVirtioGraphicsDeviceConfiguration()
  graphicsDevice.scanouts = [
    VZVirtioGraphicsScanoutConfiguration(
      widthInPixels: loadedConfig.displayWidth,
      heightInPixels: loadedConfig.displayHeight
    )
  ]
  config.graphicsDevices = [graphicsDevice]

  if loadedConfig.enableAudioInput{
    let audioInputStream = VZVirtioSoundDeviceInputStreamConfiguration()
    audioInputStream.source = VZHostAudioInputStreamSource()
    let audioInputDevice = VZVirtioSoundDeviceConfiguration()
    audioInputDevice.streams = [audioInputStream]
    config.audioDevices.append(audioInputDevice)
  }
  if loadedConfig.enableAudioOutput {
    let audioOutputStream = VZVirtioSoundDeviceOutputStreamConfiguration()
    audioOutputStream.sink = VZHostAudioOutputStreamSink()
    let audioOutputDevice = VZVirtioSoundDeviceConfiguration()
    audioOutputDevice.streams = [audioOutputStream]
    config.audioDevices.append(audioOutputDevice)
  }

  config.keyboards = [VZUSBKeyboardConfiguration()]
  config.pointingDevices = [VZUSBScreenCoordinatePointingDeviceConfiguration()]

  try config.validate()

  return VZVirtualMachine(configuration: config)
}

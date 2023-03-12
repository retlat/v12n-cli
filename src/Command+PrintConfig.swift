extension Command {
  static func printConfig() {
    print("""
    // Configuration file is plain text file consists of Key=Value pair.

    // Type of OS (mac / linux)
    os=linux

    // Number of CPU. Minimum is 1 (Integer)
    cpu=1

    // Amount of memory in GiB (Float)
    memory=2

    // Path of directory that contains storage and machine data (Absolute path)
    vm_directory=

    // Display resolution (width,height Integer)
    display_resolution=1280,720

    // Connect virtual machine audio output/input to host system's default one (yes / no)
    enable_audio_output=yes
    enable_audio_input=yes

    // Network type (nat)
    network_type=nat

    // Install media path (Absolute path)
    // Only use this value when disk.img is absent in vm_directory
    install_media=

    // Storage size in GiB (Integer)
    // Only use this value when to create disk.img
    storage_size=20
    """)
  }
}

// swift-tools-version:4.0

import PackageDescription

#if os(macOS)

let package = Package(
  name: "Morse_GUI",
  dependencies: [
    .package(url: "https://github.com/uraimo/SwiftyGPIO.git", .branch("master")),
    .package(url: "https://github.com/Brett-Best/SwiftGtk.git", .branch("master")),
  ],
  targets: [
    .target(name: "Morse_GUI", dependencies: ["SwiftyGPIO", "Gtk"]),
  ]
)

#else

let package = Package(
  name: "Morse_GUI",
  dependencies: [
    .package(url: "https://github.com/uraimo/SwiftyGPIO.git", .branch("master")),
    .package(url: "https://github.com/Brett-Best/SwiftGtk.git", .branch("bb-pkg-dev")),
  ],
  targets: [
    .target(name: "Morse_GUI", dependencies: ["SwiftyGPIO", "Gtk"]),
  ]
)

#endif

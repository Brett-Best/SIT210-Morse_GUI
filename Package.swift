// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "Morse_GUI",
  dependencies: [
    .package(url: "https://github.com/uraimo/SwiftyGPIO.git", .branch("master")),
    .package(url: "https://github.com/rhx/SwiftGtk.git", .branch("master")),
  ],
  targets: [
    .target(name: "Morse_GUI", dependencies: ["SwiftyGPIO", "Gtk"]),
  ]
)

import Gtk
import CGtk
import GLib
import Foundation

print("""
# Project
Morse_GUI - SIT210-5.3D

## Wiring Information
------------------
LED | Physical Pin
------------------
Any | 13\n\n
## Logging:\n
""")

let status = Application.run { app in
  let ledController = LEDController()
  let windowController = WindowController(application: app, ledController: ledController)
  windowController.window.showAll()
}

guard let status = status else {
  fatalError("Could not create Application, unknown status.")
}

guard status == 0 else {
  fatalError("Application exited with status \(status).")
}

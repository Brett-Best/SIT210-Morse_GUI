import Gtk
import CGtk
import GLib

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

let ledController = LEDController()

func createWindow(application: ApplicationProtocol) -> ApplicationWindow {
  var window = ApplicationWindow(application: application)
  
  window.title = "Morse_GUI - LED"
  window.set(position: .center)
  window.setDefaultSize(width: 300, height: 200)
  
  let box = createBox(exitButtonTouched: {
    ledController.reset()
    application.quit()
  })
  
  window.add(widget: box)
  
  return window
}

func createBox(exitButtonTouched: @escaping (() -> Void)) -> Box {
  var box = Box(orientation: .vertical, spacing: 8)
  box.marginStart = 8
  box.marginEnd = 8
  box.halign = .center
  
  let label = Label(str: "Type alphabetical characters to blink in morsecode.")
  box.packStart(child: label, expand: true, fill: true, padding: 8)
  
  var wordEntry = Entry()
  wordEntry.placeholderText = "A word..."
  wordEntry.maxLength = 12
  wordEntry.inputPurpose = .alpha
  box.packStart(child: wordEntry, expand: true, fill: true, padding: 8)
  
  var blinkButton = Button(label: "Blink")
  box.packStart(child: blinkButton, expand: true, fill: true, padding: 8)
  
  var exitButton = Button(label: "Exit")
  exitButton.halign = .fill
  
  box.packStart(child: exitButton, expand: true, fill: true, padding: 8)
  
  blinkButton.onButton { (_, _) in
    blinkButton.sensitive = false
    wordEntry.sensitive = false
    
    ledController.send(string: "grhr") {
      blinkButton.sensitive = true
      wordEntry.sensitive = true
    }
  }
  
  exitButton.onButton { (_, _) in
    exitButtonTouched()
  }
  
  return box
}

let status = Application.run { app in
  let window = createWindow(application: app)
  window.showAll()
}

guard let status = status else {
  fatalError("Could not create Application, unknown status.")
}

guard status == 0 else {
  fatalError("Application exited with status \(status).")
}

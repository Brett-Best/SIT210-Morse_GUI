import Gtk
import CGtk
import GLib
import Foundation

class WindowController {
  let window: Window
  
  let application: ApplicationProtocol
  let ledController: LEDController
  
  var wordEntry: Entry
  var blinkButton: Button
  var exitButton: Button
  
  init(application: ApplicationProtocol, ledController: LEDController) {
    self.application = application
    self.ledController = ledController
    
    self.window = WindowController.createWindow(application: application)
    
    let box = WindowController.createBox()
    
    wordEntry = WindowController.createWordEntry()
    blinkButton = WindowController.createBlinkButton()
    exitButton = WindowController.createExitButton()
    
    box.packStart(child: wordEntry, expand: true, fill: true, padding: 8)
    box.packStart(child: blinkButton, expand: true, fill: true, padding: 8)
    box.packStart(child: exitButton, expand: true, fill: true, padding: 8)
    
    addControlActions()
    
    window.add(widget: box)
  }
  
  func test() {
    
  }
  
  static func createWindow(application: ApplicationProtocol) -> ApplicationWindow {
    var window = ApplicationWindow(application: application)
    
    window.title = "Morse_GUI - LED"
    window.set(position: .center)
    window.setDefaultSize(width: 300, height: 200)
    
    return window
  }
  
  static func createBox() -> Box {
    var box = Box(orientation: .vertical, spacing: 8)
    box.marginStart = 8
    box.marginEnd = 8
    box.halign = .center
    
    let label = Label(str: "Type alphabetical characters to blink in morsecode.")
    box.packStart(child: label, expand: true, fill: true, padding: 8)
    
    return box
  }
  
  static func createWordEntry() -> Entry {
    var wordEntry = Entry()
    wordEntry.placeholderText = "A word..."
    wordEntry.maxLength = 12
    wordEntry.inputPurpose = .alpha
    
    return wordEntry
  }
  
  static func createExitButton() -> Button {
    var exitButton = Button(label: "Exit")
    exitButton.halign = .fill
    
    return exitButton
  }
  
  static func createBlinkButton() -> Button {
    return Button(label: "Blink")
  }
  
  func addControlActions() {
    blinkButton.onButton { (_, _) in
      self.blinkButtonTouched()
    }
    
    exitButton.onButton { (_, _) in
      self.exitButtonTouched()
    }
  }
  
  func blinkButtonTouched() {
    wordEntry.text = wordEntry.text.components(separatedBy: CharacterSet.letters.inverted).joined(separator: "")
    
    blinkButton.sensitive = false
    wordEntry.sensitive = false
    
    ledController.send(string: wordEntry.text) {
      let selfPointer: gpointer = gpointer(Unmanaged.passUnretained(self).toOpaque())
      g_idle_add({ (pointer) -> gboolean in
        guard let pointer = pointer else {
          return 0
        }
        
        let strongSelf = Unmanaged<WindowController>.fromOpaque(pointer).takeUnretainedValue()
        
        strongSelf.blinkButton.sensitive = true
        strongSelf.wordEntry.sensitive = true
        
        return 0
      }, selfPointer)
    }
  }
  
  func exitButtonTouched() {
    ledController.reset()
    application.quit()
  }
  
}

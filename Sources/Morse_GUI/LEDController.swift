import Foundation
import SwiftyGPIO

class LEDController {
  private let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi3)
  
  private let LEDGPIO: GPIO
  
  let morseCodeUnit = 0.5
  
  let morseCodeMap: [Character: [TimeInterval]] = ["A": [1,3], "B": [3,1,1,1], "C": [3,1,3,1], "D": [3,1,1], "E": [1], "F": [1,1,3,1], "G": [3,3,1], "H": [1,1,1,1], "I": [1,1], "J": [1,3,3,3], "K": [3,1,3], "L": [1,3,1,1], "M": [3,3], "N": [3,1], "O": [3,3,3], "P": [1,3,3,1], "Q": [3,3,1,3], "R": [1,3,1], "S": [1,1,1], "T": [3], "U": [1,1,3], "V": [1,1,13], "W": [1,3,3], "X": [3,1,1,3], "Y": [3,1,3,3], "Z": [3,3,1,1]]
  
  init() {
    // Physical Pin -> GPIO Mapping
    // 7 -> P4
    
    guard let LEDGPIO = gpios[.P4] else {
      fatalError("Unable to configure GPIOs")
    }
    
    self.LEDGPIO = LEDGPIO
    
    #if !os(macOS)
    LEDGPIO.direction = .OUT
    #endif
  }
  
  func send(string: String, completion: @escaping (() -> Void)) {
    DispatchQueue.global(qos: .background).async {
      func turnOn(for seconds: TimeInterval) {
        self.set(on: true)
        Thread.sleep(forTimeInterval: seconds)
      }
      
      func turnOff(for seconds: TimeInterval) {
        self.set(on: false)
        Thread.sleep(forTimeInterval: seconds)
      }
      
      string.uppercased().forEach { character in
        self.morseCodeMap[character]!.forEach { timeInterval in
          turnOn(for: timeInterval)
          turnOff(for: 1 * self.morseCodeUnit)
        }
        
        turnOff(for: 3 * self.morseCodeUnit)
      }
      
      DispatchQueue.main.async {
        completion()
      }
    }
  }
  
  func set(on: Bool) {
    print("Set LED to '\(on ? "on" : "off")'")
    #if !os(macOS)
    GPIO(for: led)?.value = on ? 1 : 0
    #endif
  }
  
  func reset() {
    #if !os(macOS)
    print("Set LED GPIO to OFF and direction IN!")
    
    LEDGPIO.value = 0
    LEDGPIO.direction = .IN
    
    #endif
  }
  
}

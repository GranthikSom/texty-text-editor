import Cocoa
import FlutterMacOS
import bitsdojo_window

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Configure bitsdojo_window for custom title bar
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Set window properties for bitsdojo
    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    self.styleMask.insert(.fullSizeContentView)
    
    RegisterGeneratedPlugins(registry: flutterViewController)
  }
}

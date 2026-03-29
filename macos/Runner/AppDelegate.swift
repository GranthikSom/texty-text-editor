import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  var flutterWindow: NSWindow?

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    flutterWindow = NSApplication.shared.windows.first
    setupMainMenu()
    super.applicationDidFinishLaunching(notification)
  }

  private func setupMainMenu() {
    let mainMenu = NSMenu()

    // App Menu
    let appMenuItem = NSMenuItem()
    let appMenu = NSMenu()
    appMenu.addItem(withTitle: "About Zephyr Editor", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Preferences...", action: nil, keyEquivalent: ",")
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Hide Zephyr Editor", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
    let hideOthersItem = appMenu.addItem(withTitle: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
    hideOthersItem.keyEquivalentModifierMask = [.command, .option]
    appMenu.addItem(withTitle: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Quit Zephyr Editor", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    appMenuItem.submenu = appMenu
    mainMenu.addItem(appMenuItem)

    // File Menu
    let fileMenuItem = NSMenuItem()
    let fileMenu = NSMenu(title: "File")
    fileMenu.addItem(withTitle: "New File", action: #selector(newFile(_:)), keyEquivalent: "n")
    fileMenu.addItem(withTitle: "Open...", action: #selector(openFile(_:)), keyEquivalent: "o")
    fileMenu.addItem(NSMenuItem.separator())
    fileMenu.addItem(withTitle: "Save", action: #selector(saveFile(_:)), keyEquivalent: "s")
    let saveAsItem = fileMenu.addItem(withTitle: "Save As...", action: #selector(saveFileAs(_:)), keyEquivalent: "s")
    saveAsItem.keyEquivalentModifierMask = [.command, .shift]
    fileMenu.addItem(NSMenuItem.separator())
    let closeItem = fileMenu.addItem(withTitle: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
    closeItem.keyEquivalentModifierMask = .command
    fileMenuItem.submenu = fileMenu
    mainMenu.addItem(fileMenuItem)

    // Edit Menu
    let editMenuItem = NSMenuItem()
    let editMenu = NSMenu(title: "Edit")
    editMenu.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
    let redoItem = editMenu.addItem(withTitle: "Redo", action: Selector(("redo:")), keyEquivalent: "z")
    redoItem.keyEquivalentModifierMask = [.command, .shift]
    editMenu.addItem(NSMenuItem.separator())
    editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
    editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
    editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
    editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
    editMenuItem.submenu = editMenu
    mainMenu.addItem(editMenuItem)

    // View Menu
    let viewMenuItem = NSMenuItem()
    let viewMenu = NSMenu(title: "View")
    let toggleSidebarItem = viewMenu.addItem(withTitle: "Toggle Sidebar", action: #selector(toggleSidebar(_:)), keyEquivalent: "b")
    toggleSidebarItem.keyEquivalentModifierMask = .command
    let toggleTerminalItem = viewMenu.addItem(withTitle: "Toggle Terminal", action: #selector(toggleTerminal(_:)), keyEquivalent: "`")
    toggleTerminalItem.keyEquivalentModifierMask = .command
    viewMenu.addItem(NSMenuItem.separator())
    let fullScreenItem = viewMenu.addItem(withTitle: "Toggle Full Screen", action: #selector(NSWindow.toggleFullScreen(_:)), keyEquivalent: "f")
    fullScreenItem.keyEquivalentModifierMask = [.command, .control]
    viewMenuItem.submenu = viewMenu
    mainMenu.addItem(viewMenuItem)

    // Run Menu
    let runMenuItem = NSMenuItem()
    let runMenu = NSMenu(title: "Run")
    runMenu.addItem(withTitle: "Run", action: #selector(runCode(_:)), keyEquivalent: "r")
    runMenu.addItem(withTitle: "Debug", action: #selector(debugCode(_:)), keyEquivalent: "")
    runMenu.addItem(NSMenuItem.separator())
    runMenu.addItem(withTitle: "Build", action: #selector(buildCode(_:)), keyEquivalent: "b")
    let buildItem = runMenu.item(at: runMenu.indexOfItem(withTitle: "Build"))
    buildItem?.keyEquivalentModifierMask = [.command, .shift]
    runMenuItem.submenu = runMenu
    mainMenu.addItem(runMenuItem)

    // Terminal Menu
    let terminalMenuItem = NSMenuItem()
    let terminalMenu = NSMenu(title: "Terminal")
    terminalMenu.addItem(withTitle: "New Terminal", action: #selector(newTerminal(_:)), keyEquivalent: "`")
    let newTermItem = terminalMenu.item(at: 0)
    newTermItem?.keyEquivalentModifierMask = [.command, .shift]
    terminalMenu.addItem(withTitle: "Split Terminal", action: #selector(splitTerminal(_:)), keyEquivalent: "")
    terminalMenu.addItem(NSMenuItem.separator())
    terminalMenu.addItem(withTitle: "Clear Terminal", action: #selector(clearTerminal(_:)), keyEquivalent: "k")
    terminalMenuItem.submenu = terminalMenu
    mainMenu.addItem(terminalMenuItem)

    // Window Menu
    let windowMenuItem = NSMenuItem()
    let windowMenu = NSMenu(title: "Window")
    windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
    windowMenu.addItem(withTitle: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: "")
    windowMenu.addItem(NSMenuItem.separator())
    windowMenu.addItem(withTitle: "Bring All to Front", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: "")
    windowMenuItem.submenu = windowMenu
    mainMenu.addItem(windowMenuItem)

    // Help Menu
    let helpMenuItem = NSMenuItem()
    let helpMenu = NSMenu(title: "Help")
    helpMenu.addItem(withTitle: "Zephyr Editor Help", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "?")
    helpMenuItem.submenu = helpMenu
    mainMenu.addItem(helpMenuItem)

    NSApplication.shared.mainMenu = mainMenu
  }

  @objc func newFile(_ sender: Any?) {}
  @objc func openFile(_ sender: Any?) {}
  @objc func saveFile(_ sender: Any?) {}
  @objc func saveFileAs(_ sender: Any?) {}
  @objc func toggleSidebar(_ sender: Any?) {}
  @objc func toggleTerminal(_ sender: Any?) {}
  @objc func runCode(_ sender: Any?) {}
  @objc func debugCode(_ sender: Any?) {}
  @objc func buildCode(_ sender: Any?) {}
  @objc func newTerminal(_ sender: Any?) {}
  @objc func splitTerminal(_ sender: Any?) {}
  @objc func clearTerminal(_ sender: Any?) {}
}

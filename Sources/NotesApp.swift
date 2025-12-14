import SwiftUI
import AppKit

/// AppDelegate для активации приложения
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Активируем приложение и выносим на передний план
        NSApp.activate(ignoringOtherApps: true)
        
        // Убеждаемся что окно получает фокус
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NSApp.windows.first?.makeKeyAndOrderFront(nil)
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

/// Главная точка входа приложения
@main
struct NotesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var store = NotesStore()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 900, height: 600)
        .commands {
            // Меню File
            CommandGroup(replacing: .newItem) {
                Button("Новая заметка") {
                    _ = store.createNote()
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
    }
}

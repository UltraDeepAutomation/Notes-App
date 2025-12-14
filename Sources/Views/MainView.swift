import SwiftUI

/// Главное окно приложения
struct MainView: View {
    @EnvironmentObject var store: NotesStore
    
    var body: some View {
        NavigationSplitView {
            // Sidebar со списком заметок
            NoteListView()
                .navigationSplitViewColumnWidth(min: 220, ideal: 260, max: 350)
        } detail: {
            // Редактор или пустое состояние
            if let selectedId = store.selectedNoteId,
               let binding = store.binding(for: selectedId) {
                NoteEditorView(note: binding)
            } else {
                EmptyEditorView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: createNewNote) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .medium))
                }
                .keyboardShortcut("n", modifiers: .command)
                .help("Новая заметка (⌘N)")
            }
            
            ToolbarItem(placement: .destructiveAction) {
                if store.selectedNoteId != nil {
                    Button(action: deleteSelectedNote) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                    }
                    .keyboardShortcut(.delete, modifiers: .command)
                    .help("Удалить заметку (⌘⌫)")
                }
            }
        }
        .frame(minWidth: 600, minHeight: 400)
    }
    
    private func createNewNote() {
        _ = store.createNote()
    }
    
    private func deleteSelectedNote() {
        guard let selectedId = store.selectedNoteId,
              let note = store.notes.first(where: { $0.id == selectedId }) else {
            return
        }
        store.delete(note)
    }
}

import SwiftUI

/// Список заметок (sidebar)
struct NoteListView: View {
    @EnvironmentObject var store: NotesStore
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 2) {
                ForEach(store.notes) { note in
                    NoteRowView(
                        note: note,
                        isSelected: store.selectedNoteId == note.id
                    )
                    .onTapGesture {
                        store.selectedNoteId = note.id
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            store.delete(note)
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(8)
        }
        .frame(minWidth: 220)
        .background(VisualEffectBackground(material: .sidebar, blendingMode: .behindWindow))
    }
}

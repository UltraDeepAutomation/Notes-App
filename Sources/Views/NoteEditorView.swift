import SwiftUI

/// Редактор заметки
struct NoteEditorView: View {
    @Binding var note: Note
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isContentFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Заголовок
            TextField("Заголовок", text: $note.title)
                .font(.system(size: 24, weight: .bold))
                .textFieldStyle(.plain)
                .focused($isTitleFocused)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 8)
            
            // Дата изменения
            Text("Изменено: \(note.modifiedAt.formatted(date: .abbreviated, time: .shortened))")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            
            Divider()
                .padding(.horizontal, 16)
            
            // Содержимое
            TextEditor(text: $note.content)
                .font(.system(size: 14))
                .scrollContentBackground(.hidden)
                .focused($isContentFocused)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
        }
        .background(VisualEffectBackground(material: .contentBackground, blendingMode: .behindWindow))
        .onAppear {
            // Фокус на заголовок если заметка новая
            if note.title.isEmpty && note.content.isEmpty {
                isTitleFocused = true
            }
        }
    }
}

/// Пустое состояние когда нет выбранной заметки
struct EmptyEditorView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 48))
                .foregroundColor(.secondary.opacity(0.5))
            
            Text("Выберите заметку")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
            
            Text("или создайте новую нажав +")
                .font(.system(size: 13))
                .foregroundColor(.secondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(VisualEffectBackground(material: .contentBackground, blendingMode: .behindWindow))
    }
}

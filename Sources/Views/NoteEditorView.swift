import SwiftUI

/// Редактор заметки
struct NoteEditorView: View {
    @Binding var note: Note
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Заголовок с placeholder из контента
            TextField(titlePlaceholder, text: $note.title)
                .font(.system(size: 24, weight: .bold))
                .textFieldStyle(.plain)
                .focused($focusedField, equals: .title)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 16)
                .onSubmit {
                    // Enter переводит фокус на контент
                    focusedField = .content
                }
            
            Divider()
                .padding(.horizontal, 16)
            
            // Содержимое
            TextEditor(text: $note.content)
                .font(.system(size: 14))
                .scrollContentBackground(.hidden)
                .focused($focusedField, equals: .content)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            
            Spacer(minLength: 0)
            
            // Дата внизу
            HStack {
                Spacer()
                Text(note.modifiedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .background(VisualEffectBackground(material: .contentBackground, blendingMode: .behindWindow))
        .onAppear {
            if note.title.isEmpty && note.content.isEmpty {
                focusedField = .title
            }
        }
        .onChange(of: note.content) { _, newValue in
            // Авто-заголовок из первых 20 символов если заголовок пуст
            if note.title.isEmpty {
                // Заголовок подставится в placeholder
            }
        }
    }
    
    /// Placeholder для заголовка - первые 20 символов контента или "Заголовок"
    private var titlePlaceholder: String {
        if note.title.isEmpty && !note.content.isEmpty {
            let firstLine = note.content.components(separatedBy: .newlines).first ?? ""
            let preview = String(firstLine.prefix(20))
            return preview.isEmpty ? "Заголовок" : preview
        }
        return "Заголовок"
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

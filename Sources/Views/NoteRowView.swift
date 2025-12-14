import SwiftUI

/// Элемент списка заметок
struct NoteRowView: View {
    let note: Note
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Заголовок
            Text(note.displayTitle)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .lineLimit(1)
            
            // Дата и превью
            HStack(spacing: 8) {
                Text(note.modifiedAt, style: .date)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .white.opacity(0.7) : .secondary)
                
                if !note.preview.isEmpty {
                    Text(note.preview)
                        .font(.system(size: 11))
                        .foregroundColor(isSelected ? .white.opacity(0.5) : .secondary.opacity(0.8))
                        .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.accentColor : Color.clear)
        )
        .contentShape(Rectangle())
    }
}

import Foundation

/// Модель заметки
struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var modifiedAt: Date
    
    init(id: UUID = UUID(), title: String = "", content: String = "", createdAt: Date = Date(), modifiedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
    
    /// Название для отображения (первая строка или placeholder)
    var displayTitle: String {
        if !title.isEmpty {
            return title
        }
        let firstLine = content.components(separatedBy: .newlines).first ?? ""
        if firstLine.isEmpty {
            return "Новая заметка"
        }
        return String(firstLine.prefix(50))
    }
    
    /// Превью содержимого
    var preview: String {
        let lines = content.components(separatedBy: .newlines)
        let startIndex = title.isEmpty ? 1 : 0
        let previewLines = lines.dropFirst(startIndex).prefix(2).joined(separator: " ")
        return String(previewLines.prefix(100))
    }
}

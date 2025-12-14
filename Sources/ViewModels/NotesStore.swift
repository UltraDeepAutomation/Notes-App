import Foundation
import SwiftUI

/// Хранилище заметок с сохранением в файлы
@MainActor
class NotesStore: ObservableObject {
    @Published var notes: [Note] = []
    @Published var selectedNoteId: UUID?
    
    private let fileManager = FileManager.default
    
    /// URL папки для хранения заметок
    private var storageURL: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let notesFolder = appSupport.appendingPathComponent("NotesApp", isDirectory: true)
        
        if !fileManager.fileExists(atPath: notesFolder.path) {
            try? fileManager.createDirectory(at: notesFolder, withIntermediateDirectories: true)
        }
        
        return notesFolder
    }
    
    /// URL файла индекса (метаданные заметок)
    private var indexURL: URL {
        storageURL.appendingPathComponent("index.json")
    }
    
    init() {
        load()
    }
    
    // MARK: - CRUD операции
    
    /// Создать новую заметку
    func createNote() -> Note {
        let note = Note()
        notes.insert(note, at: 0)
        selectedNoteId = note.id
        save(note)
        saveIndex()
        return note
    }
    
    /// Обновить заметку
    func update(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.modifiedAt = Date()
            notes[index] = updatedNote
            save(updatedNote)
            saveIndex()
        }
    }
    
    /// Удалить заметку
    func delete(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        deleteFile(for: note)
        saveIndex()
        
        if selectedNoteId == note.id {
            selectedNoteId = notes.first?.id
        }
    }
    
    /// Получить binding для заметки
    func binding(for noteId: UUID) -> Binding<Note>? {
        guard let index = notes.firstIndex(where: { $0.id == noteId }) else {
            return nil
        }
        
        return Binding(
            get: { self.notes[index] },
            set: { self.update($0) }
        )
    }
    
    // MARK: - Persistance
    
    /// Загрузить заметки
    private func load() {
        guard fileManager.fileExists(atPath: indexURL.path),
              let data = try? Data(contentsOf: indexURL),
              let loadedNotes = try? JSONDecoder().decode([Note].self, from: data) else {
            return
        }
        
        notes = loadedNotes.sorted { $0.modifiedAt > $1.modifiedAt }
        
        // Загружаем контент из .txt файлов
        for i in notes.indices {
            let contentURL = storageURL.appendingPathComponent("\(notes[i].id.uuidString).txt")
            if let content = try? String(contentsOf: contentURL, encoding: .utf8) {
                notes[i].content = content
            }
        }
    }
    
    /// Сохранить индекс (метаданные всех заметок)
    private func saveIndex() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Сохраняем без контента (контент в отдельных файлах)
        var notesForIndex = notes
        for i in notesForIndex.indices {
            notesForIndex[i].content = ""
        }
        
        if let data = try? encoder.encode(notesForIndex) {
            try? data.write(to: indexURL)
        }
    }
    
    /// Сохранить содержимое заметки в .txt файл
    private func save(_ note: Note) {
        let contentURL = storageURL.appendingPathComponent("\(note.id.uuidString).txt")
        try? note.content.write(to: contentURL, atomically: true, encoding: .utf8)
    }
    
    /// Удалить файл заметки
    private func deleteFile(for note: Note) {
        let contentURL = storageURL.appendingPathComponent("\(note.id.uuidString).txt")
        try? fileManager.removeItem(at: contentURL)
    }
}

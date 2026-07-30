//
//  BufferPagesManager.swift
//  EdgeMenu
//
//  Created by mac on 30.07.2026.
//

import Foundation
import Combine
import AppKit
import UniformTypeIdentifiers

struct BufferPage: Identifiable, Hashable {
    let id: UUID
    var title: String
    var iconName: String
    var files: [URL]
    var isPinned: Bool
    
    init(id: UUID = UUID(), title: String, iconName: String = "doc.on.clipboard", files: [URL] = [], isPinned: Bool = false) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.files = files
        self.isPinned = isPinned
    }
    
    mutating func addFile(_ newFile: URL) {
        files.insert(newFile, at: 0)
    }
    
    mutating func addFiles(_ newFiles: [URL]) {
        let existingSet = Set(files)
        let uniqueNew = newFiles.filter { !existingSet.contains($0) }
        files.insert(contentsOf: uniqueNew, at: 0)
    }
    
    mutating func clear() {
        files.removeAll()
    }
}


final class BufferPagesManager: ObservableObject {
    static let shared = BufferPagesManager()

    
    @Published var pages: [BufferPage] = []
    @Published var selectedPageId: UUID?
    
    
    /// Выбор страницы
    func setSelectedPage(id: UUID) {
        selectedPageId = id
    }
    
    /// МЕТОДЫ ВЗАИМОДЕЙСТВИЯ С МАССИВОМ СТРАНИЦ
    
    /// Создание новой страницы
    func createNewPage(_ title: String = "Новая страница") {
        pages.append(.init(title: title, files: []))
    }
    
    /// Удаление страницы
    func deletePage(at id: UUID) {
        pages.removeAll { $0.id == id }
        if selectedPageId == id {
            selectedPageId = pages.first?.id
        }
    }
    
    /// МЕТОДЫ ВЗАИМОДЕЙСТВИЯ С ОБЪЕКТОМ СТРАНИЦЫ

    func getCurrentPage() -> BufferPage? {
        pages.first(where: { $0.id == selectedPageId })
    }
    
    func currentPageIsEmpty() -> Bool {
        guard let currentPage = pages.first(where: { $0.id == selectedPageId }) else { return true }
        return currentPage.files.isEmpty
    }
    
    func renameCurrentPage(to title: String) {
        // Убираем лишние пробелы по краям
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            
        // Проверяем, что название не пустое и что выбранная страница существует
        guard !trimmedTitle.isEmpty,
        let index = pages.firstIndex(where: { $0.id == selectedPageId }) else { return }
            
        // Переименовываем
        pages[index].title = trimmedTitle
    }
    
    /// Обработчик нажатия на кнопку очистки буфера выделенной страницы
    func clearSelectedPage() {
        guard let index = pages.firstIndex(where: { $0.id == selectedPageId }) else {return}

        pages[index].clear()
    }
    
    /// Обработчик добавления файла в буфер выделенной страницы
    func newFilesToSelectedPage(_ urls: [URL]) {
        print("newFilesToSelectedPage")
        guard let index = pages.firstIndex(where: { $0.id == selectedPageId }) else {return}

        
        let fileList = pages[index].files
        print(pages[index].title)
        
        /// проверка на повторы в urls
        for url in urls {
            var isUnique: Bool = true
            for currentURL in fileList {
                if currentURL == url {
                    isUnique = false
                    break
                }
            }
            
            if isUnique {
                print(url)
                pages[index].addFile(url)
            }
        }
    }

    /// Добавление файлов из буфера
    func addFilesFromBuffer() {
        print("addFilesFromBuffer")
        let pasteboard = NSPasteboard.general

        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], !urls.isEmpty {
            print(urls)
            newFilesToSelectedPage(urls)
        }

    }

    func copyAllBufferOfPage() {
        guard let currentPage = pages.first(where: { $0.id == selectedPageId }) else { return }
        let fileList = currentPage.files
        
        /// начальные проверки
        guard !fileList.isEmpty else { return }
        let fileURLs = fileList.filter { $0.isFileURL }
        guard !fileURLs.isEmpty else { return }
        
        /// открытие и очистка буфера
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()

        
        for url in fileURLs {
            
            /// создание объекта для буфера
            let item = NSPasteboardItem()
            print(url)
            
            
            /// получение типа объекта
            guard let resourceValues = try? url.resourceValues(forKeys: [.contentTypeKey]),
                  let utType = resourceValues.contentType else { return }
            let pboardType = NSPasteboard.PasteboardType(utType.identifier)
            
            
            /// получение и запись битовых данных
            if let data = try? Data(contentsOf: url) {
                item.setData(data, forType: pboardType)
            }
            
            /// запись url и имени объекта
            item.setString(url.absoluteString, forType: .fileURL)
            item.setString(url.lastPathComponent, forType: .string)
            
            /// дублирование url старого формата
            let plistPaths = [url.path]
            if let plistData = try? PropertyListSerialization.data(fromPropertyList: plistPaths, format: .xml, options: 0) {
                item.setData(plistData, forType: .init(rawValue: "NSFilenamesPboardType"))
            }
            
            /// добавление объекта в буфер
            pasteboard.writeObjects([item])
            
        }

    }

   
    
}

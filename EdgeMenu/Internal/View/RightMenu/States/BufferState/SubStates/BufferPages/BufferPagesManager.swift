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

/// СТРУКТУРА ВКЛАДКИ БУФЕРА

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
    
    /// Добавить файл во вкладку
    mutating func addFile(_ newFile: URL) {
        files.insert(newFile, at: 0)
    }
    
    /// Добавить файлы во вкладку
    mutating func addFiles(_ newFiles: [URL]) {
        let existingSet = Set(files)
        let uniqueNew = newFiles.filter { !existingSet.contains($0) }
        files.insert(contentsOf: uniqueNew, at: 0)
    }
    
    /// Очистить вкладку
    mutating func clearAll() {
        files.removeAll()
    }
    
    /// Удалить файл из вкладки
    mutating func remove(file: URL) {
        files.removeAll { $0 == file }
    }
}

/// МЕНЕДЖЕР СУБСОСТОЯНИЯ СПИСКА ВКЛАДОК БУФЕРА

final class BufferPagesManager: ObservableObject {
    static let shared = BufferPagesManager()

    /// Страницы
    @Published var pages: [BufferPage] = []
    /// Выделенная страница
    @Published var selectedPageId: UUID?
    /// Выделенные файлы
    @Published var selectedFiles: Set<URL> = []

    
    /// Выбор страницы
    func setSelectedPage(id: UUID) {
        print("setSelectedPage")
        if (selectedPageId != id) {
            /// при смене на другую вкладку
            /// список выделенных файлов
            /// обнуляется
            selectedFiles.removeAll()
        }
        selectedPageId = id
        
    }
    
    /// Изменение состояния выделения для конкретного url
    /// если файл находился в списке выделенных
    /// `selectedFiles.contains(url) == true`
    /// то он удалется из списка, в ином случае добавляется в него
    func toggleSelection(for url: URL) {
        if selectedFiles.contains(url) {
            selectedFiles.remove(url)
        } else {
            selectedFiles.insert(url)
        }
    }
    
    /// Скопировать в буффер выделенные объекты
    func copySelectedFiles() {
        inToOSBuffer(urls: Array(selectedFiles))
    }

    
    /// `МЕТОДЫ ВЗАИМОДЕЙСТВИЯ С МАССИВОМ ВКЛАДОК`
    
    /// Создание новой страницы
    func createNewPage(_ title: String = "Новая страница") {
        print("createNewPage")
        pages.append(.init(title: title, files: []))
    }
    
    /// Удаление страницы
    func deletePage(at id: UUID) {
        print("deletePage")
        pages.removeAll { $0.id == id }
        if selectedPageId == id {
            selectedPageId = pages.first?.id
        }
    }
    
    /// `МЕТОДЫ ВЗАИМОДЕЙСТВИЯ С ОБЪЕКТОМ ВКЛАДКИ`

    /// Получить выбранную страницу
    func getCurrentPage() -> BufferPage? {
        pages.first(where: { $0.id == selectedPageId })
    }
    
    // Проверить пуста ли выбранная страница
    func currentPageIsEmpty() -> Bool {
        guard let currentPage = pages.first(where: { $0.id == selectedPageId }) else { return true }
        return currentPage.files.isEmpty
    }
    
    /// Удалить выбранную страницу
    func renameCurrentPage(to title: String) {
        // Убираем лишние пробелы по краям
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            
        // Проверяем, что название не пустое и что выбранная страница существует
        guard !trimmedTitle.isEmpty,
        let index = pages.firstIndex(where: { $0.id == selectedPageId }) else { return }
            
        // Переименовываем
        pages[index].title = trimmedTitle
    }
    
    /// Обработчик нажатия на кнопку очистки буфера выделенной вкладки
    func clearSelectedPage() {
        guard let index = pages.firstIndex(where: { $0.id == selectedPageId }) else {return}

        pages[index].clearAll()
        selectedFiles.removeAll()
    }
    
    /// Обработчик удаления выделенных файлов
    func removeSelectedFiles() {
        guard let index = pages.firstIndex(of: pages.first(where: { $0.id == selectedPageId })!) else {return}
        
        for url in selectedFiles {
            pages[index].remove(file: url)
            selectedFiles.remove(url)
        }
    }
    
    /// Обработчик добавления файла в буфер выделенной вкладки
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
            /// если уникален то добавляем
            if isUnique {
                print(url)
                pages[index].addFile(url)
            }
        }
    }

    /// Добавление файлов в буфер вкладки из буфера системы
    func addFilesFromBuffer() {
        print("addFilesFromBuffer")
        let pasteboard = NSPasteboard.general

        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], !urls.isEmpty {
            print(urls)
            newFilesToSelectedPage(urls)
        }

    }
    
    /// Скопировать все объекты выделенной вкладки
    func copyAllBufferOfPage() {
        guard let currentPage = pages.first(where: { $0.id == selectedPageId }) else { return }
        let fileList = currentPage.files
        
        /// начальные проверки
        guard !fileList.isEmpty else { return }
        let fileURLs = fileList.filter { $0.isFileURL }
        guard !fileURLs.isEmpty else { return }
        
        inToOSBuffer(urls: fileURLs)
    }
    
    
    /// Скопировать объекты в буфер системы
    func inToOSBuffer(urls: [URL]) {
        /// открытие и очистка буфера
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()

        
        for url in urls {
            
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

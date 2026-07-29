//
//  BufferStateManager.swift
//  EdgeMenu
//
//  Created by mac on 10.06.2026.
//

import Foundation
import Combine
import AppKit
import UniformTypeIdentifiers

// Менеджер состояни буфера

class BufferStateManager: ObservableObject {
    static let shared = BufferStateManager()
    
    // Состояние буфера
    @Published var subState: BufferSubState = .empty
    
    // Список файлов буфера
    // Используем стандартный lowerCamelCase
    @Published var fileList: [URL] = []
    // [URL(fileURLWithPath: "/Users/mac/Desktop/test1.png"),
    // URL(fileURLWithPath: "/Users/mac/Desktop/text.txt")]
    
    // класс мониторига за буфером
    var clipboardMonitor: ClipboardMonitor = ClipboardMonitor()
    
    init() {
        clipboardMonitor.onNewFilesDetected = { [weak self] urls in
            self?.newFileInPasteboard(urls)
        }
    }
    
    func start() {
        clipboardMonitor.startMonitoring()
        print("BufferStateManager: start")
    }
        
    func stop() {
        clipboardMonitor.stopMonitoring()
        print("BufferStateManager: stop")
    }
        
    func changeState(_ state: BufferSubState) {
        subState = state
    }
    // Обработчик нажатия на кнопку очистки буфера
    func clearBuffer() {
        changeState(.empty)
        fileList.removeAll()
        
        // открытие и очистка буфера
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
    }
    
    // обработчик добавления файла
    func newFileInPasteboard(_ urls: [URL]) {
        print("add files")
        
        // проверка на повторы в urls
        for url in urls {
            var isUnique: Bool = true
            for currentURL in fileList {
                if currentURL == url {
                    isUnique = false
                    break
                }
            }
            
            if isUnique {
                self.fileList.insert(contentsOf: urls, at: 0)
            }
        }
        print(fileList)
        changeState(.fileList)
    }
    
    // Копирование всех элементов буфера в системный буфер обмена
    func copyAllBuffer() {
        // начальные проверки
        guard !fileList.isEmpty else { return }
        let fileURLs = fileList.filter { $0.isFileURL }
        guard !fileURLs.isEmpty else { return }
        
        // открытие и очистка буфера
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()

        
        for url in fileURLs {
            
            // создание объекта для буфера
            let item = NSPasteboardItem()
            print(url)
            
            
            // получение типа объекта
            guard let resourceValues = try? url.resourceValues(forKeys: [.contentTypeKey]),
                  let utType = resourceValues.contentType else { return }
            let pboardType = NSPasteboard.PasteboardType(utType.identifier)
            
            
            // получение и запись битовых данных
            if let data = try? Data(contentsOf: url) {
                item.setData(data, forType: pboardType)
            }
            
            // запись url и имени объекта
            item.setString(url.absoluteString, forType: .fileURL)
            item.setString(url.lastPathComponent, forType: .string)
            
            // дублирование url старого формата
            let plistPaths = [url.path]
            if let plistData = try? PropertyListSerialization.data(fromPropertyList: plistPaths, format: .xml, options: 0) {
                item.setData(plistData, forType: .init(rawValue: "NSFilenamesPboardType"))
            }
            
            // добавление объекта в буфер
            pasteboard.writeObjects([item])
            
        }
//        do {
//            let data = try Data(contentsOf: url)
//            print("2 - Успешно прочитали данные!")
//            
//            item.setData(data, forType: pboardType)
//            
//            print(pboardType)
//            
//            let pasteboard = NSPasteboard.general
//            pasteboard.clearContents()
//            pasteboard.writeObjects([item])
//            
//        } catch {
//            // Xcode напечатает точную причину (например: Permission Denied или File Not Found)
//            print("Ошибка чтения файла в Data: \(error.localizedDescription)")
//            print("Полная ошибка для дебага: \(error)")
//        }
    }
    
}


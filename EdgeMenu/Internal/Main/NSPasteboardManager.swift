//
//  NSPasteboardManager.swift
//  EdgeMenu
//
//  Created by mac on 31.07.2026.
//

import Foundation
import AppKit
import UniformTypeIdentifiers


final class NSPasteboardManager {
    static let shared = NSPasteboardManager()
    
    /// Очистка буфера системы
    func clearPasteboard() {
        NSPasteboard.general.clearContents()
    }
    
    /// Получение файлов буфера системы
    func getpasteboardFiles() -> [URL] {
        
        let pasteboard = NSPasteboard.general
        
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], !urls.isEmpty {
            return urls
        }
        
    return []
    }
        
    /// Добавление файла в системный буфер
    func addFileToPasteboard(_ url: URL) {
        let pasteboard = NSPasteboard.general

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
    
    func replacePasteboard(_ urls: [URL]) {
        clearPasteboard()
        
        for url in urls {
            addFileToPasteboard(url)
        }
    }
}

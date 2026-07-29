//
//  ClipboardMonitor.swift
//  EdgeMenu
//
//  Created by mac on 29.07.2026.
//

import AppKit

final class ClipboardMonitor {
    private let pasteboard = NSPasteboard.general
    private var lastChangeCount: Int
    private var timer: Timer?
    
    // Замыкание, которое вызовется при обнаружении изменений
    var onNewFilesDetected: (([URL]) -> Void)?

    init() {
        // Запоминаем текущий счетчик при старте
        self.lastChangeCount = pasteboard.changeCount
    }

    func startMonitoring(interval: TimeInterval = 0.5) {
        print("ClipboardMonitor start")
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.checkPasteboard()
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        print("ClipboardMonitor stop")
    }

    private func checkPasteboard() {
        // 1. Дешевая проверка: изменилось ли число операций копирования?
        guard pasteboard.changeCount != lastChangeCount else { return }
        
        // Обновляем сохраненный счетчик
        lastChangeCount = pasteboard.changeCount

        // 2. Достаем файлы только если счетчик действительно изменился
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], !urls.isEmpty {
            onNewFilesDetected?(urls)
        }
    }
}

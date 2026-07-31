//
//  WidgetWindowManager.swift
//  EdgeMenu
//
//  Created by mac on 31.07.2026.
//

import Foundation
import AppKit
import SwiftUI


final class WidgetWindowManager {
    static let shared = WidgetWindowManager()
    
    weak var window: NSWindow?
    
    func createWidgetWindow() {
        /// Создаем окно
        let window = NSWindow(
            contentRect: NSRect(x: 100, y: 100, width: 320, height: 400),
            styleMask: [.borderless, .resizable], // Первичная маска
            backing: .buffered,
            defer: false
        )
        
        /// Назначаем SwiftUI View как содержимое окна
        window.contentView = NSHostingView(rootView: WidgetRootView())
        
        /// ПРИМЕНЯЕМ НАШ МЕТОД
        configureWidgetWindow(window)
        
        /// Показываем окно
        window.makeKeyAndOrderFront(nil)
        self.window = window
    }
    
    func getContentRect() -> NSRect {
        window?.contentLayoutRect ?? .zero
    }
    
    /// Настройка прозрачного окна без рамок
    func configureWidgetWindow(_ window: NSWindow) {
        self.window = window
        
        window.styleMask = [.borderless, .resizable]
        window.isOpaque = false
        window.backgroundColor = .clear
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        
        window.isMovableByWindowBackground = true
        window.level = .floating
        window.hasShadow = true
    }
    
    /// Изменение размера
    func changeHeight(deltaY: CGFloat, minHeight: CGFloat = 200, maxHeight: CGFloat = 800) {
        guard let window = window else { return }
        
        var frame = window.frame
        let oldHeight = frame.height
        let newHeight = min(max(oldHeight + deltaY, minHeight), maxHeight)
        
        guard newHeight != oldHeight else { return }
        
        frame.origin.y -= (newHeight - oldHeight)
        frame.size.height = newHeight
        
        window.setFrame(frame, display: true, animate: false)
    }
    
}

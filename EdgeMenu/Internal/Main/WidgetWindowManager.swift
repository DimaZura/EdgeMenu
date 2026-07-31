//
//  WidgetWindowManager.swift
//  EdgeMenu
//
//  Created by mac on 31.07.2026.
//

import Foundation
import AppKit
import SwiftUI
import Combine


final class WidgetWindowManager {
    static let shared = WidgetWindowManager()
    
    /// Объект окна
    var window: NSWindow?
    /// Флаг открытия виджета
    @Published var isOpen: Bool = false
    /// Размер текущего окна
    var windowSize : CGSize {
        return NSScreen.main?.frame.size ?? .zero
    }
    
    /// Ссылка на глобальный подписчик кликов мыши
    private var globalClickMonitor: Any?
    
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        /// подписка на изменение свойства CursoreManager::CoursorDetectedInAngle
        /// [$ обозначает обращение не самому параметру а к потоку его изменения]
        /// sink создает саму подписку на этот поток
        /// weak self необходимо во избежение утечек памяти
        CursoreManager.shared.$CoursorDetectedInAngle
            .sink{ [weak self] value in
                // Разворачиваем weak self, чтобы безопасно использовать его как координатор
                guard let self = self else { return }
    
                if value {
                    showWindow()
                }
            }
            .store(in: &cancellables)
        
    }

    
    func showWindow() {
        print("showWindow")
        guard let window = window else {print("guard let window = window"); return}
        
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        isOpen = true
        
        startOutsideClickMonitoring()
    }
    
    func hideWindow() {
        print("hideWindow")
        window?.orderOut(nil)
        isOpen = false
        
        stopOutsideClickMonitoring()
    }
    
    private func startOutsideClickMonitoring() {
        stopOutsideClickMonitoring()
        
        ///
        globalClickMonitor = NSEvent.addGlobalMonitorForEvents(
                    matching: [.leftMouseDown, .rightMouseDown]
        ) { [weak self] event in
            guard let self = self, let window = self.window, self.isOpen else { return }
            
            let clickLocation = NSEvent.mouseLocation
            
            /// Проверяем, попал ли клик ВНУТРЬ нашего окна
            /// (Нюанс: window.frame находится в экранных координатах)
            if !NSPointInRect(clickLocation, window.frame) {
                // Клик был снаружи — закрываем наше окно
                self.hideWindow()
            }
        }
    }
    
    private func stopOutsideClickMonitoring() {
        if let monitor = globalClickMonitor {
            NSEvent.removeMonitor(monitor)
            globalClickMonitor = nil
        }
    }
    
    /// Функция создания окна виджета
    func createWidgetWindow() {

        let windowWidth = windowSize.width*0.1
        let windowHeight = windowSize.height*0.2

        /// Создаем окно
        let window = NSWindow(
            contentRect: NSRect(x: windowSize.width-windowWidth, y: windowSize.height-windowHeight, width: windowWidth, height: windowHeight),
            styleMask: [.borderless, .resizable], // Первичная маска
            backing: .buffered,
            defer: false
        )
        
        /// Назначаем RightMenuView как содержимое окна
        window.contentView = NSHostingView(rootView: RightMenuView())
        
        /// преминение метода настройки кофигурации
        configureWidgetWindow(window)
        
        /// Показываем окно
        window.makeKeyAndOrderFront(nil)
        self.window = window
        
        hideWindow()
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
        
        // Удаляем .resizable из маски
        window.styleMask = [.borderless] // (или [.titled] если окно обычное)
    }
    
    func getContentRect() -> NSRect {
        window?.contentLayoutRect ?? .zero
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

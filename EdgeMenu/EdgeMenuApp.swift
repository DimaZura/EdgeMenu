//
//  EdgeMenuApp.swift
//  EdgeMenu
//
//  Created by mac on 06.06.2026.
//

import SwiftUI
import AppKit


//  Добавить состояние истории скопированных


@main
struct EdgeMenuApp: App {
    /// Подключаем Delegate, который сработает при старте
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // Заменяем WindowGroup на Settings, чтобы SwiftUI
        // не создавал стандартное окно сам
        Settings {
            EmptyView()
        }
    }
}

/// Управляет стартом приложения
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        /// Запускаем создание нашего плавающего прозрачного окна
        WidgetWindowManager.shared.createWidgetWindow()
    }
}

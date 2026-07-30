//
//  ActionButtonListView.swift
//  EdgeMenu
//
//  Created by mac on 30.07.2026.
//

import Foundation
import SwiftUI

// MARK: - ОТОБРАЖЕНИЕ КНОПОК ДЕЙСТВИЙ
struct ActionButtonListView: View {
    @StateObject var manager: BufferPagesManager = .shared

    var body: some View {
        HStack(spacing: 12) {
            /// Кнопка удаления всех файлов из буфера
            ActionButtonView(
                systemName: "trash",
                title: "Всё",
                role: .destructive, // Делает акцент на опасном действии (красноватый оттенок при наведении)
                isDisabled: manager.currentPageIsEmpty(),
                onTap: manager.clearSelectedPage
            )
            
            Spacer()
            
            /// Кнопка удаления выделенных файлов из буфера
            ActionButtonView(
                systemName: "trash",
                title: "Выбранное",
                role: .destructive, // Делает акцент на опасном действии (красноватый оттенок при наведении)
                isDisabled: manager.currentPageIsEmpty(),
                onTap: manager.removeSelectedFiles
            )
            
            Spacer()
            
            /// Кнопка копирования выделенных файлов
            ActionButtonView(
                systemName: "document.on.document.fill",
                title: "Выделенное",
                isDisabled: manager.selectedFiles.isEmpty,
                onTap: manager.copySelectedFiles
            )
            
            Spacer()
            
            /// Кнопка вставки  файлов из буфера системы
            ActionButtonView(
                systemName: "square.and.arrow.up",
                title: "Вставить",
                onTap: manager.addFilesFromBuffer

            )
            
            Spacer()
            
            /// Кнопка копирования всех файлов
            ActionButtonView(
                systemName: "doc.on.doc.fill",
                title: "Всё",
                isDisabled: manager.currentPageIsEmpty(),
                onTap: manager.copyAllBufferOfPage
            )
            
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - ШАБЛОН ОТОБРАЖЕНИЯ КНОПКИ ДЕЙСТВИЯ
struct ActionButtonView: View {
    let systemName: String
    var title: String? = nil
    var role: ButtonRole? = nil
    var isDisabled: Bool = false
    let onTap: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(role: role, action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: systemName)
                    .font(.system(size: 13, weight: .semibold))
                
                if let title = title {
                    Text(title)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.4 : 1.0)
        // Визуальный отклик при наведении курсора в стиле macOS
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(buttonBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
    
    private var buttonBackgroundColor: Color {
        guard !isDisabled else { return Color.clear }
        
        if isHovered {
            return role == .destructive
                ? Color.red.opacity(0.15)
                : Color.primary.opacity(0.1)
        } else {
            return Color(NSColor.controlBackgroundColor).opacity(0.5)
        }
    }
}

#Preview {
    ActionButtonListView(manager: BufferPagesManager.shared)
        .padding()
        .frame(width: 300)
}

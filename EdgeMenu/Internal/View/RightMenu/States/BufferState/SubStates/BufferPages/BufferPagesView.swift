//
//  BufferPagesView.swift
//  EdgeMenu
//
//  Created by mac on 30.07.2026.
//

import Foundation
import SwiftUI

// MARK: - ОТОБРАЖЕНИЕ СУБСОСТОЯНИЯ СПИСКА ВКЛАДОК
struct BufferPagesView: View {
    @ObservedObject var manager: BufferPagesManager = .shared
    
    var body: some View {
        VStack(spacing: 8) {
            /// `Панель вкладок (Horizontal Scroll)`
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    /// список вкладок
                    ForEach(manager.pages) { page in
                        PageHeader(
                            page: page,
                            isSelected: manager.selectedPageId == page.id,
                            onSelect: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                    manager.setSelectedPage(id: page.id)
                                }
                            },
                            onDelete: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    manager.deletePage(at: page.id)
                                }
                            }
                        )
                    }
                    /// кнопка создания вкладки
                    CreatePageButton(onTap: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                            manager.createNewPage()
                        }
                    })
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
            }
            .frame(height: 36)
            
            /// `Отображение контента ТЕКУЩЕЙ страницы`
            if let currentPage = manager.getCurrentPage() {
                PageView(page: currentPage)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                EmptyBufferView()
            }
        }
    }
}

#Preview {
    BufferPagesView()
        .padding()
        .frame(width: 500, height: 500)
}

// MARK: - Шапка отдельной вкладки
struct PageHeader: View {
    let page: BufferPage
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    @ObservedObject var manager: BufferPagesManager = .shared
    
    /// Состояния для редактирования имени
    @State private var isEditing = false
    @State private var tempTitle = ""
    @State private var isHovered = false
    @State private var isCloseHovered = false
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: page.iconName)
                .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
            
            /// `ОТОБРАЖЕНИЕ ИМЕНИ С ВОЗСОЖНОСТЬЮ РЕДАКТИРОВАНИЯ`
            if isEditing {
                /// Если включен режим редактирования — показываем поле ввода TextField
                TextField("Название", text: $tempTitle, onCommit: saveTitle)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .frame(minWidth: 40, maxWidth: 120)
                    .onSubmit {
                        saveTitle()
                    }
            } else {
                /// В обычном режиме — просто текст с реакцией на клики
                Text(page.title)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .medium, design: .rounded))
                    .lineLimit(1)
                    .onTapGesture {
                        onSelect()
                    }
            }

            /// `КНОПКА УДАЛЕНИЯ ВКАДКИ`
            if !page.isPinned && !isEditing {
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(isCloseHovered ? .primary : .secondary)
                        .padding(3)
                        .background(
                            Circle()
                                .fill(isCloseHovered ? Color.primary.opacity(0.15) : Color.clear)
                        )
                }
                .buttonStyle(.plain)
                .opacity(isHovered || isSelected ? 1.0 : 0.0)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isCloseHovered = hovering
                    }
                }
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, page.isPinned ? 10 : 6)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isSelected
                      ? Color(NSColor.controlBackgroundColor)
                      : (isHovered ? Color.primary.opacity(0.06) : Color.clear))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(isSelected ? Color.gray.opacity(0.2) : Color.clear, lineWidth: 1)
        )
        .shadow(color: isSelected ? Color.black.opacity(0.05) : Color.clear, radius: 2, x: 0, y: 1)
        /// включение редактирования через контекстное меню (правый клик)
        .contextMenu {
            Button("Переименовать") {
                startEditing()
            }
            if !page.isPinned {
                Button("Удалить страницу", role: .destructive) {
                    onDelete()
                }
            }
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
    
    /// Метод инициальзатор режима редактирования
    private func startEditing() {

        tempTitle = page.title
        onSelect() // Делаем страницу активной при переименовании
        isEditing = true

    }
    
    /// Завершение редактирования и сохранение результатов
    private func saveTitle() {
        guard isEditing else { return }
        isEditing = false
        print("saveTitle")
        
        /// вызов метода переименования
        if !tempTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print (tempTitle)
            manager.renameCurrentPage(to: tempTitle)
        }
    }
}

// MARK: - Кнопка создания новой страницы (+)
struct CreatePageButton: View {
    let onTap: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: "plus")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
                .padding(6)
                .background(
                    Circle()
                        .fill(isHovered ? Color.primary.opacity(0.1) : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - ОТОБРАЖЕНИЕ ВКАЛАДКИ
struct PageView: View {
    let page: BufferPage
    @ObservedObject var manager: BufferPagesManager = .shared
    
    var body: some View {
        VStack(spacing: 8) {
        
            /// Отображение списка файлов
            ListOfFilesWrapperView(files: page.files)
            /// Отображение кнопок действий
            ActionButtonListView()

            
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.gray.opacity(0.12), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        // Вариант с файлами
        PageView(
            page: BufferPage(
                title: "Основной",
                files: [
                    URL(fileURLWithPath: "/Users/demo/Documents/Presentation.pdf"),
                    URL(fileURLWithPath: "/Users/demo/Desktop/Project.swift")
                ]
            )
        )
        
        // Вариант с пустым буфером
        PageView(
            page: BufferPage(title: "Пустая", files: [])
        )
    }
    .padding()
    .frame(width: 340, height: 400)
}

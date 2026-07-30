//
//  FileListView.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import Foundation
import SwiftUI
import Combine

struct FileListView: View {
    @StateObject var manager: BufferPagesManager = .shared
    var files: [URL] = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                if files.isEmpty {
                    EmptyBufferView()
                } else {
                    ListOfFilesView(files: files)
                }
                ActionButtonListView(manager: manager)
                
            }
        }

    }
}
#Preview {
    FileListView(manager: BufferPagesManager.shared)
}


// Отображение списка файлов
//  files - список отображаемых файлов
struct ListOfFilesView: View {
    let files: [URL]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 6) {
                ForEach(files, id: \.self) { url in
                    BufferFileComponent(
                        url: url,
                    )
                    // Плавное появление при добавлении новых файлов
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .padding(6)
        }
        // Нативный фоновый полупрозрачный контейнер вместо агрессивного синего
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        // Анимация изменений в списке
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: files)
    }
}
#Preview {
    ListOfFilesView(files: [
        URL(fileURLWithPath: "/Users/mac/Desktop/test1.png"),
        URL(fileURLWithPath: "/Users/mac/Desktop/text.txt"),
    ])
    .frame(width: 320, height: 200)
    .padding()
}


// Отображение списка кнопок
struct ActionButtonListView: View {
    // Используем @ObservedObject, чтобы кнопки могли динамически
    // меняться (например, блокироваться, если буфер пуст)
    @ObservedObject var manager: BufferPagesManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Кнопка очистки буфера
            ActionButtonView(
                systemName: "trash",
                title: "Очистить",
                role: .destructive, // Делает акцент на опасном действии (красноватый оттенок при наведении)
                isDisabled: manager.currentPageIsEmpty(),
                onTap: manager.clearSelectedPage
            )
            
            Spacer()
            
            ActionButtonView(
                systemName: "square.and.arrow.up",
                title: "Вставить",
                onTap: manager.addFilesFromBuffer

            )
            
            Spacer()
            
            // Кнопка скопировать всё
            ActionButtonView(
                systemName: "doc.on.doc.fill",
                title: "Скопировать всё",
                isDisabled: manager.currentPageIsEmpty(),
                onTap: manager.copyAllBufferOfPage
            )
            
          
        }
        .padding(.horizontal, 4)
    }
}

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

// MARK: - Preview для Xcode
#Preview {
    ActionButtonListView(manager: BufferPagesManager.shared)
        .padding()
        .frame(width: 300)
}

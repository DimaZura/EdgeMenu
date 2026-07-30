//
//  BufferFileComponent.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import SwiftUI
import AppKit

// MARK: - ОТОБРАЖЕНИЕ ОБЪЕКТА КМПОНЕНТА БУФЕРА
struct BufferFileComponent: View {
    let url: URL
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var isHovered: Bool = false
    
    private var defaultAppIcon: NSImage {
        // 1. Находим URL приложения, зарегистрированного в система для этого файла
        if let defaultAppURL = NSWorkspace.shared.urlForApplication(toOpen: url) {
            return NSWorkspace.shared.icon(forFile: defaultAppURL.path)
        }
        // 2. Фоллбек: если приложение по умолчанию не найдено, берем стандартную иконку файла
        return NSWorkspace.shared.icon(forFile: url.path)
    }
    
    private var fileName: String {
        let name = url.deletingPathExtension().lastPathComponent
        return name.isEmpty ? url.lastPathComponent : name
    }
    
    private var fileExtension: String {
        url.pathExtension.uppercased()
    }
    
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(spacing: 10) {
                /// Иконка приложения
                Image(nsImage: defaultAppIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .shadow(color: .black.opacity(0.12), radius: 1, x: 0, y: 1)
                
                /// Имя файла
                Text(fileName)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? .white : .primary) // Изменение цвета текста при выделении
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                /// Расширение файла
                if !fileExtension.isEmpty {
                    Text(fileExtension)
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : .secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.white.opacity(0.25) : Color.primary.opacity(0.06))
                        )
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            /// Фон с реакцией на isSelected и isHovered
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        isSelected
                        ? Color.accentColor // Систентный акцентный цвет macOS при выделении
                        : (isHovered ? Color.primary.opacity(0.08) : Color(NSColor.controlBackgroundColor).opacity(0.4))
                    )
            )
            /// Обводка
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(
                        isSelected
                        ? Color.accentColor
                        : (isHovered ? Color.primary.opacity(0.15) : Color.gray.opacity(0.12)),
                        lineWidth: 1
                    )
            )
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.15)) {
                    isHovered = hovering
                }
            }
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    VStack(spacing: 8) {
        BufferFileComponent(
            url: URL(fileURLWithPath: "/Users/demo/Documents/Presentation.pdf"),
            isSelected: true,
            onTap: {  })
        BufferFileComponent(
            url: URL(fileURLWithPath: "/Users/demo/Desktop/Project.swift"),
            isSelected: false,
            onTap: {  })
        BufferFileComponent(
            url: URL(fileURLWithPath: "/Users/mac/Desktop/test1.png"),
            isSelected: true,
            onTap: {  })
    }
    .padding()
    .frame(width: 320)
}
#Preview {
    BufferFileComponent(
        url: URL(fileURLWithPath: "/Users/mac/Desktop/test1.png"),
        isSelected: false,
        onTap: {  })
}





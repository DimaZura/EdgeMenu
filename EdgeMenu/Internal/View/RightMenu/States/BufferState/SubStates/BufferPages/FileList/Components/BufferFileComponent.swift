//
//  BufferFileComponent.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import SwiftUI
import AppKit


struct BufferFileComponent: View {
    let url: URL
    
    @State private var isHovered = false

    // MARK: - Иконка приложения по умолчанию
    private var defaultAppIcon: NSImage {
        // 1. Находим URL приложения, зарегистрированного в система для этого файла
        if let defaultAppURL = NSWorkspace.shared.urlForApplication(toOpen: url) {
            return NSWorkspace.shared.icon(forFile: defaultAppURL.path)
        }
        
        // 2. Фоллбек: если приложение по умолчанию не найдено, берем стандартную иконку файла
        return NSWorkspace.shared.icon(forFile: url.path)
    }

    // MARK: - Вычисляемые свойства для текста
    private var fileName: String {
        let name = url.deletingPathExtension().lastPathComponent
        return name.isEmpty ? url.lastPathComponent : name
    }
    
    private var fileExtension: String {
        url.pathExtension.uppercased()
    }

    // MARK: - Body
    var body: some View {
        HStack(spacing: 10) {
            // 1. Иконка приложения, открывающего этот файл
            Image(nsImage: defaultAppIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .shadow(color: .black.opacity(0.12), radius: 1, x: 0, y: 1)

            // 2. Имя файла (занимает всё свободное место)
            Text(fileName)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.middle)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 3. Расширение файла в аккуратной капсуле
            if !fileExtension.isEmpty {
                Text(fileExtension)
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.primary.opacity(0.06))
                    )
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        // Адаптивная системная плашка с откликом на hover
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isHovered ? Color.primary.opacity(0.08) : Color(NSColor.controlBackgroundColor).opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(isHovered ? Color.primary.opacity(0.15) : Color.gray.opacity(0.12), lineWidth: 1)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}
#Preview {
    VStack(spacing: 8) {
        BufferFileComponent(url: URL(fileURLWithPath: "/Users/demo/Documents/Presentation.pdf"))
        BufferFileComponent(url: URL(fileURLWithPath: "/Users/demo/Desktop/Project.swift"))
        BufferFileComponent(url: URL(fileURLWithPath: "/Users/demo/Downloads/Archive.zip"))
    }
    .padding()
    .frame(width: 320)
}
#Preview {
    BufferFileComponent(url: URL(fileURLWithPath: "/Users/mac/Desktop/test1.png"))
}

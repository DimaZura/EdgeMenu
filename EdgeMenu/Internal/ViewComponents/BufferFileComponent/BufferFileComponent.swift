//
//  BufferFileComponent.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import Foundation
import SwiftUI
import AppKit

struct BufferFileComponent: View {
    var url: URL

    // Получаем системную иконку файла (как в Finder)
    private var fileIcon: NSImage {
        // icon(forFileURL:) доступен на macOS 11+, на более старых можно использовать icon(forFile:)
        if #available(macOS 11.0, *) {
            return NSWorkspace.shared.icon(forFile: url.path())
        } else {
            return NSWorkspace.shared.icon(forFile: url.path)
        }
    }

    var body: some View {
        HStack(spacing: 10) {
            // Оборачиваем NSImage в SwiftUI Image
            Image(nsImage: fileIcon)
//
            Text(url.lastPathComponent)
                .lineLimit(1)
                .truncationMode(.middle)

            Spacer()
        }
    }
}

#Preview {
    BufferFileComponent(url: URL(fileURLWithPath: "/Users/mac/Desktop/test2.pages"))
}

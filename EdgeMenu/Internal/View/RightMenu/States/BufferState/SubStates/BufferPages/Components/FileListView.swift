//
//  FileListView.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import Foundation
import SwiftUI
import Combine

// MARK: - ОБОЛОЧКА ОТОБРАЖЕНИЯ СПИСКА ФАЙЛОВ
struct ListOfFilesWrapperView: View {
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
                
            }
        }

    }
}
#Preview {
    ListOfFilesWrapperView()
}


// MARK: - ОТОБРАЖЕНИЕ СПИСКА ФАЙЛОВ
struct ListOfFilesView: View {
    @StateObject var manager: BufferPagesManager = .shared
    let files: [URL]
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 6) {
                ForEach(files, id: \.self) { url in
                    BufferFileComponent(
                        url: url,
                        isSelected: manager.selectedFiles.contains(url),
                        onTap: {
                            if manager.selectedFiles.contains(url) {
                                manager.selectedFiles.remove(url)
                            } else {
                                manager.selectedFiles.insert(url)
                            }
                        },
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



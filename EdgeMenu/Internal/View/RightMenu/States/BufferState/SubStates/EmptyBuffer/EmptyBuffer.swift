//
//  EmptyBuffer.swift
//  EdgeMenu
//
//  Created by mac on 03.07.2026.
//

import Foundation
import SwiftUI

import SwiftUI

struct EmptyBufferView: View {
    // Если менеджер передается снаружи из родителя,
    // лучше использовать @ObservedObject вместо @StateObject
    @ObservedObject var manager: BufferStateManager

    var body: some View {
        VStack(spacing: 8) {
            // Системная иконка пустой папки / буфера
            Image(systemName: "doc.on.clipboard")
                .font(.system(size: 28, weight: .light))
                .foregroundColor(.secondary)
                .symbolEffect(.bounce.byLayer, options: .repeating.speed(0.2)) // Легкая пульсация иконки
            
            VStack(spacing: 2) {
                Text("Буфер обмена пуст")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Скопируйте файлы, чтобы они появились здесь")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Аккуратная плашка с полупрозрачным фоном в стиле macOS
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}

// Превью для удобной отладки прямо в Xcode
#Preview {
    EmptyBufferView(manager: BufferStateManager.shared)
        .frame(width: 280, height: 120)
        .padding()
}
#Preview {
    EmptyBufferView(manager: BufferStateManager.shared)
}

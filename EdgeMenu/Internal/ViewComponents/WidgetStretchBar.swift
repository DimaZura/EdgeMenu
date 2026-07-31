//
//  WidgetStretchBar.swift
//  EdgeMenu
//
//  Created by mac on 31.07.2026.
//

import SwiftUI

struct WidgetStretchBar: View {
    // Передаем замыкание, принимающее дельту сдвига мыши
    let onResize: (CGFloat) -> Void
    
    @State private var isHovered = false
    @State private var isDragging = false
    
    var body: some View {
        HStack {
            Spacer()
            // Визуальный индикатор хватания (ручка)
            Capsule()
                .fill(isHovered || isDragging ? Color.primary.opacity(0.4) : Color.primary.opacity(0.15))
                .frame(width: isHovered || isDragging ? 136 : 42, height: 4)
            Spacer()
        }
        .frame(height: 12)
        .contentShape(Rectangle()) // Делаем всю плашку кликабельной
        // Меняем курсор мыши на стрелки изменения размера (вверх-вниз)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        // Обработка самого жеста перетаскивания
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isDragging = true
                    // value.translation.height — это смещение относительно точки нажатия.
                    // При потягивании ВНИЗ value.translation.height Положительный.
                    // Если мы хотим УВЕЛИЧИВАТЬ высоту при потягивании вниз:
                    let deltaY = value.translation.height
                    onResize(deltaY)
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
    }
}
#Preview {
    WidgetStretchBar(onResize: { _ in
})
}

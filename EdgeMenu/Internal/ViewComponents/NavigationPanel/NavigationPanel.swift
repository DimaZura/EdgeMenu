//
//  NavigationPanel.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import Foundation
import SwiftUI

struct NavigationPanel: View {
    
    // Current selected mode
    @State var currentMode: WidgetMode
    // Возможные состояния
    private let modes: [WidgetMode] = [.general, .appCommands, .buffer]
    // Обработчик изменения состояния
    let onModeChange: (WidgetMode) -> Void
    // Пространство для плавной анимации
    @Namespace private var menuAnimation

    var body: some View {
        ZStack{
            // Задний фон
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: 180, height: 40)
                .cornerRadius(10)
            
            // Список состояний
            HStack {
                ForEach(modes.indices, id: \.self) { index in
                    NavigationPanel_Button(
                        mode: modes[index],
                        currentMode: $currentMode,
                        matchedGeometryId: "capsule",
                        menuAnimation: menuAnimation
                    )
                    .padding(10)
                }
            }
            .onChange(of: currentMode) { newValue in
                onModeChange(currentMode)
            }
        }
    }
}

// Кнопка изменения состояния
struct NavigationPanel_Button: View {
    // состояние этой кнопки
    var mode: WidgetMode
    // текущее состояние виджета
    @Binding var currentMode: WidgetMode
    // индекс фигуры для плавной анимации
    var matchedGeometryId: String
    var menuAnimation: Namespace.ID
    
    // Динамическая схема (светлая/темная)
    @Environment(\.colorScheme) private var colorScheme
    // Цвет текста/иконки: в светлой теме — белый, в темной — черный
    private var dynamicForeground: Color {
        colorScheme == .dark ? .black : .white
    }
    
    
    var body: some View {
        Button(
        action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                // сменить состояние
                currentMode = mode
            }
        },
        label: {
            if currentMode == mode {
                Text("\(title(for: mode))")
                    .padding(6)
                    .foregroundStyle(dynamicForeground)
            } else {
                image(for: mode)
            }
        })
        .background(
            Group {
                if currentMode == mode {
                    RoundedRectangle(cornerRadius: 8)
                        .matchedGeometryEffect(id: matchedGeometryId, in: menuAnimation)
                }
            }
        )
        .buttonStyle(.plain)
    }
    
    private func title(for mode: WidgetMode) -> String {
        switch mode {
        case .general: return "Общее"
        case .appCommands: return "Команды"
        case .buffer: return "Буфер"
        }
    }
    
    private func image(for mode: WidgetMode) -> Image {
        switch mode {
        case .general: return Image(systemName: "circle.hexagongrid.fill")
        case .appCommands: return Image(systemName: "command")
        case .buffer: return Image(systemName: "document.on.document")
        }
    }
}

#Preview {
    NavigationPanel(currentMode: .general, onModeChange: { _ in })
        .padding(100)
}


//struct ListOfModes_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationPanel(currentMode: .buffer, onModeChange: { _ in })
//        
//        NavigationPanel(currentMode: .general, onModeChange: { _ in })
//    }
//}

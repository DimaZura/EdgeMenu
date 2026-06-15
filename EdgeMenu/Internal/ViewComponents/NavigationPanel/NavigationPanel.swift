//
//  NavigationPanel.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import Foundation
import SwiftUI

struct NavigationPanel: View {
    
    // current selected mode
    @State var currentMode: WidgetMode
    
    @Namespace private var menuAnimation
    
    private let modes: [WidgetMode] = [.general, .appCommands, .buffer]
    
    let onModeChange: (WidgetMode) -> Void
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: 180, height: 40)
                .cornerRadius(10)
            
            HStack {
                ForEach(modes.indices, id: \.self) { index in
                    NavigationPanel_Button(
                        mode: modes[index],
                        matchedGeometryId: "capsule",
                        currentMode: $currentMode,
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

struct NavigationPanel_Button: View {
    var mode: WidgetMode
    var matchedGeometryId: String
    @Binding var currentMode: WidgetMode
    var menuAnimation: Namespace.ID
    
    // Динамическая схема (светлая/темная)
    @Environment(\.colorScheme) private var colorScheme
    // Цвет текста/иконки: в светлой теме — белый, в темной — черный
    private var dynamicForeground: Color {
        colorScheme == .dark ? .black : .white
    }
    
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                currentMode = mode
            }
        }, label: {
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

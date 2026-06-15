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
    @State var selectedTab: Int
    
    @Namespace private var menuAnimation
    
    init(currentMode: WidgetMode, onModeChange: @escaping (WidgetMode) -> Void) {
        self.currentMode = currentMode
        self.onModeChange = onModeChange
        
        self.selectedTab = modes.firstIndex(of: currentMode) ?? 0
    }
    
    private let modes: [WidgetMode] = [.general, .appCommands, .buffer]
    
    let onModeChange: (WidgetMode) -> Void
    
    var body: some View {
        
        HStack {
            ForEach(modes.indices, id: \.self) { index in
                NavigationPanel_Button(
                    index: index,
                    matchedGeometryId: "capsule",
                    selectedTab: $selectedTab,
                    menuAnimation: menuAnimation
                )
            }
        }
        .onChange(of: selectedTab) { newValue in
            let mode = modes[newValue]
            currentMode = mode
            onModeChange(mode)
        }
    }
}


struct NavigationPanel_Button: View {
    var index: Int
    var matchedGeometryId: String
    @Binding var selectedTab: Int
    var menuAnimation: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        }, label: {
            Text("\(index)")
                .padding(6)
        })
        .background(
            Group {
                if selectedTab == index {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accentColor.opacity(0.1))
                        .matchedGeometryEffect(id: matchedGeometryId, in: menuAnimation)
                }
            }
        )
    }
    
    private func title(for mode: WidgetMode) -> String {
        switch mode {
        case .general: return "Общее"
        case .appCommands: return "Команды"
        case .buffer: return "Буфер"
        }
    }
}

#Preview {
    NavigationPanel(currentMode: .general, onModeChange: { _ in })
        .padding(100)
}

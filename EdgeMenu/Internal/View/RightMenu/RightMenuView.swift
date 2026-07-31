//
//  RightMenuView.swift
//  EdgeMenu
//
//  Created by mac on 08.06.2026.
//

import SwiftUI

// MARK: - Головной класс отображения бокорого меню

struct RightMenuView: View {
    @StateObject var manager = RightMenuManager.shared
    
    var body: some View {
        VStack {
            /// хедер - меню навигации
            NavigationPanel(currentMode: manager.getMode(), onModeChange: manager.switchMode)


            Group {
                if manager.State is IdleState {
                  
                } else if manager.State is GeneralState {
                    GeneralStateView()
                } else if manager.State is AppCommandsState {
                    AppCommandsStateView()
                } else if manager.State is BufferState {
                    BufferStateView()
                } else {
                    // fallback
                    Text("Unknown state")
                }
            }
            
            Spacer()
            
            // TODO: - Плашка для растягивания виджета
            Rectangle()
                .frame(width: 120, height: 3)
                .cornerRadius(12)
                .padding(8)
        }
//        .liquidGlassStyle(cornerRadius: 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Системный эффект размытия (Material) для macOS
        .background(.ultraThinMaterial)
        // Скругляем углы самого виджета
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        // Добавляем аккуратную обводку по краю
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        // Небольшой отступ, чтобы тень окна не обрезалась
        .padding(1)
    }
}



#Preview {
    RightMenuView()
}

//
//  WidgetRootView.swift
//  EdgeMenu
//
//  Created by mac on 31.07.2026.
//

import SwiftUI

struct WidgetRootView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Ваш контент виджета
            RightMenuView()
            .padding(5)
            
            Spacer()
            
            // TODO: - Плашка для растягивания виджета
            Rectangle()
                .frame(width: 120, height: 3)
                .cornerRadius(12)
                .padding(8)
        }
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
    WidgetRootView()
}

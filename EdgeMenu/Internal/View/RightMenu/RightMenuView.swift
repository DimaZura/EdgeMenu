//
//  RightMenuView.swift
//  EdgeMenu
//
//  Created by mac on 08.06.2026.
//

import SwiftUI


struct RightMenuView: View {
    @StateObject var RightMenuManaget = RightMenuManager.shared
    
    var body: some View {
       
        VStack{
            if (RightMenuManaget.isOpen) {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("\(RightMenuManaget.windowWidth) - \(RightMenuManaget.windowHeight)")
                    Text("\(RightMenuManaget.activeAppName)")
                }
                .padding()
                .frame(width: RightMenuManaget.windowWidth*0.15, height: RightMenuManaget.windowHeight*0.2)
                .background(.orange)
            }
        }
        .frame(width: RightMenuManaget.windowWidth*0.15, height: RightMenuManaget.windowHeight*0.2)
                // Ключевой момент: используем системный материал как фон
                .background(.ultraThinMaterial)
                // Добавляем скругление углов, как у всех окон macOS
                .cornerRadius(12)
                // Рекомендуется добавить тонкую обводку, чтобы меню не сливалось с фоном
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 0.5)
                )
                .padding(10) // Отступ от краев окна
    }
}

#Preview {
    RightMenuView()
}

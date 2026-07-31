//
//  LiquidGlassModifier.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import Foundation
import SwiftUI

struct LiquidGlassModifier: ViewModifier {
    var cornerRadius: CGFloat = 24
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // 1. Размытие заднего плана (матовая стеклянная основа)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(0.05))
                        .background(.ultraThinMaterial) // Системное преломление macOS
                    
                    // 2. Внутренний объем (глянцевый градиент)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.25), // Блик сверху
                                    Color.clear,               // Прозрачная середина
                                    Color.black.opacity(0.15)  // Тень снизу
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // 3. Тонкая стеклянная грань (Border)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6), // Яркий свет на грани
                                    Color.white.opacity(0.1),
                                    Color.black.opacity(0.3)  // Затемнение на нижней грани
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                }
            )
            // 4. Мягкая внешняя объемная тень
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 8)
            // 5. Вторая жесткая тень для ощущения "веса" капли
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

// Расширение для удобного вызова
extension View {
    func liquidGlassStyle(cornerRadius: CGFloat = 24) -> some View {
        self.modifier(LiquidGlassModifier(cornerRadius: cornerRadius))
    }
}

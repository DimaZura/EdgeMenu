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
        VStack {
            // Отладочная подпись текущего типа состояния
            Text("\(String(describing: type(of: RightMenuManaget.State)))")

            if RightMenuManaget.isOpen {
                Group {
                    if RightMenuManaget.State is IdleState {
                        
                    } else if RightMenuManaget.State is GeneralState {
                        GeneralStateView()
                    } else if RightMenuManaget.State is AppCommandsState {
                        AppCommandsStateView()
                    } else if RightMenuManaget.State is BufferState {
                        BufferStateView()
                    } else {
                        // fallback
                        Text("Unknown state")
                    }
                }
            }
        }
        .frame(width: RightMenuManaget.windowWidth, height: RightMenuManaget.windowHeight)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .padding(0)
    }
}



#Preview {
    RightMenuView()
}

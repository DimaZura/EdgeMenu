//
//  RightMenuView.swift
//  EdgeMenu
//
//  Created by mac on 08.06.2026.
//

import SwiftUI


struct RightMenuView: View {
    @StateObject var manager = RightMenuManager.shared
    
    var body: some View {
        VStack {
            if manager.isOpen {
                // хедер - меню навигации
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
            }
        }
        .frame(width: manager.windowWidth, height: manager.windowHeight)
        .liquidGlassStyle(cornerRadius: 24)

//        .background(.ultraThinMaterial)
//        .background(Color.init( red: 0.8, green: 0.8, blue: 0.8, opacity: 1))
//        .cornerRadius(12)
//        .padding(0)
    }
    
    
    
}



#Preview {
    RightMenuView()
}

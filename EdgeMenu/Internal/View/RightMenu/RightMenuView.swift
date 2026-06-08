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
        
    }
}

#Preview {
    RightMenuView()
}

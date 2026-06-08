//
//  ContentView.swift
//  EdgeMenu
//
//  Created by mac on 06.06.2026.
//

import SwiftUI
import Combine


struct ContentView: View {
    @StateObject var globalManager = GlobalManager.shared
    
    var body: some View {
        VStack {
            RightMenuView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

//
//  BufferStateView.swift
//  EdgeMenu
//
//  Created by mac on 10.06.2026.
//

import Foundation
import Combine
import SwiftUI

//  Отображение режима буффера обмена

struct BufferStateView: View {
    @StateObject var manager = BufferStateManager.shared
    
    var body: some View {
        VStack {
            switch manager.subState {
            case .empty:
                EmptyBufferView(manager: manager)
            case .fileList: 
                FileListView(manager: manager)
            }
        }
        
        .padding(20)
    }
}


#Preview {
    BufferStateView()
        .onAppear {
            BufferStateManager.shared.start()
        }
        .onDisappear {
            BufferStateManager.shared.stop()
        }
        .frame(width: 500, height: 500)
}


//            case .filePreview(let fileURL):
//                // Пол
//                FilePreviewView(manager: manager, url: fileURL)
//                //URL(fileURLWithPath: "/file") - для формирования url

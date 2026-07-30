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
            BufferPagesView()

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
        .frame(width: 600, height: 600)
}


//            case .filePreview(let fileURL):
//                // Пол
//                FilePreviewView(manager: manager, url: fileURL)
//                //URL(fileURLWithPath: "/file") - для формирования url

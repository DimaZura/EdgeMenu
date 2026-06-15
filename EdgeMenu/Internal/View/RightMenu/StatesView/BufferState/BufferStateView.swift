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
                Text("Буфер пуст")
            case .fileList:
                FileListView(manager: manager)
//            case .filePreview(let fileURL):
//                // Пол
//                FilePreviewView(manager: manager, url: fileURL)
//                //URL(fileURLWithPath: "/file") - для формирования url
            }
        }
        .padding(20)
    }
}

#Preview {
    BufferStateView()
}

//
//  FilePreviewView.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import Foundation
import SwiftUI

struct FilePreviewView: View {
    @StateObject var manager: BufferStateManager
    var url: URL
    
    var body: some View {
        Text("FilePreviewView \(url.absoluteString)")
    }
}

#Preview {
    FilePreviewView(manager: BufferStateManager.shared, url: URL(fileURLWithPath: "testfile"))
}

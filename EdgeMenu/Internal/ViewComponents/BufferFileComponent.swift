//
//  BufferFileComponent.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import Foundation
import SwiftUI

struct BufferFileComponent: View {
    var url: URL
    
    var body: some View {
        HStack {
            Spacer()
            Text(url.lastPathComponent)
        }
        .frame(minWidth: 100, maxWidth: 300, minHeight: 50, maxHeight: 150)
        .background(Color.init(red: 0.5, green: 0.3, blue: 0.7))
        .cornerRadius(30)
        .padding(10)
    }
}


#Preview {
    BufferFileComponent(url: URL(fileURLWithPath: "testfile"))
}

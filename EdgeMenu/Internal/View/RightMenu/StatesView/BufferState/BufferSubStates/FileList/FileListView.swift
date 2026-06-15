//
//  FileListView.swift
//  EdgeMenu
//
//  Created by mac on 15.06.2026.
//

import Foundation
import SwiftUI

struct FileListView: View {
    @StateObject var manager: BufferStateManager
    
    var body: some View {
        VStack{
            VStack{
                ForEach(manager.FileList, id: \.self) { url in
                    VStack{
                        BufferFileComponent(url: url)
                    }
                }
                
            }
            .padding(10)
            .background(Color.init(red: 0.2, green: 0.3, blue: 0.8))
            .cornerRadius(15)
            
            HStack{
                
                Rectangle()
                    .fill(Color(red: 0.2, green: 0.3, blue: 1))
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                    .overlay {
                        Image(systemName: "trash")
                    }
                
                Spacer()
               
            }
            .padding(20)
        }
        .frame(maxWidth: 350, maxHeight: 400)
    }
}

#Preview {
    FileListView(manager: BufferStateManager.shared)
}

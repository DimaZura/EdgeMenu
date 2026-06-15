//
//  BufferStateManager.swift
//  EdgeMenu
//
//  Created by mac on 10.06.2026.
//

import Foundation
import Combine

//  Управлящий класс отображения режима буфера обмена
//
//  1 - 
//
//


enum BufferSubState {
    case empty
    case fileList
    
}

class BufferStateManager: ObservableObject {
    static var shared: BufferStateManager = BufferStateManager()
    
    var FileList: [URL] = [URL(fileURLWithPath: "testfile"), URL(fileURLWithPath: "testfile2")]
    
    @Published var subState: BufferSubState = .fileList
}

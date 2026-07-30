//
//  BufferStateManager.swift
//  EdgeMenu
//
//  Created by mac on 10.06.2026.
//

import Foundation
import Combine
import AppKit
import UniformTypeIdentifiers

// Менеджер состояни буфера

class BufferStateManager: ObservableObject {
    static let shared = BufferStateManager()
    
    // Состояние буфера
    @Published var subState: BufferSubState = .empty
            
    init() {

    }
    
    /// Запускается при переходе в состояние буфера
    func start() {
        print("BufferStateManager: start")
    }
        
    /// Запускается при выходе из состояние буфера
    func stop() {
        print("BufferStateManager: stop")
    }
        
    func changeState(_ state: BufferSubState) {
        subState = state
    }
    
        
    
    

    
    
}


//
//  CursorDetector.swift
//  EdgeMenu
//
//  Created by mac on 07.06.2026.
//

import Foundation
import Combine
import AppKit


// Класс детектор действий и окружения
//
//  1 - Проводит фоновый мониторинг нахождения курсора
//      Если курсор оказывается в верхнем правом углу то
//      подает сигнал и переводит программц в активоное состояние
//
//  2 - Проврдит фоновый мониторинг открытого приложения
//      По этим данным отправляет сигнал в головной класс
//      на вызов определенных для этого приложения виджетов

class CursorDetector : ObservableObject{
    
    // флаг попадания курсора в угол
    @Published var CoursorDetectedInAngle: Bool = false
    
    // текущая локация
    var Location: CGPoint?
    
    init(){
        StartCousorDetection()
    }
    
    
    func StartCousorDetection(){

        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { event in
            
            self.Location = NSEvent.mouseLocation
            print("Глобальный курсор: \(self.Location?.x ?? 0)")
            
            NSEvent.
        }
    }
    
}



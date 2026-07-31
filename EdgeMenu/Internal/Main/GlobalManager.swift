//
//  GlobalManager.swift
//  EdgeMenu
//
//  Created by mac on 07.06.2026.
//

import Foundation
import Combine
import AppKit


// Класс взаимодействия с системой,
// проводит основной мониторинг действий
//
//  1 - локация курсора
//      Если курсор оказывается в верхнем правом углу то
//      переводит флаг CoursorDetectedInAngle в активное состояние
//
//  2 - текущее приложение
//      При переводе флага в активное состояние проводит
//      определение текущего приложения
//

class GlobalManager : ObservableObject{
    static var shared = GlobalManager()
    var log: Bool = false

    // Размер текущего окна
    var CurrentWindowSize : CGSize {
        return NSScreen.main?.frame.size ?? .zero
    }
    
    // Флаг попадания курсора в угол
    @Published var CoursorDetectedInAngle: Bool = false

    // Текущая локация
    @Published var Location: CGPoint = .zero {
        didSet {
            // проведение проверки попадания в угол
            CheckTheCorners()
            if log {print(Location)}
        }
    }
    
    
    // Инифиализация
    init(){
        // запуск детектора положения курсора
        StartCousorDetection()
    }
    
    
    // подписка на получение данных о положении курсора
    func StartCousorDetection(){
        // происходит регистрация блока кода, описанного ниже, в список выполняемых операций при
        // при выполнении event смещение курсора. Регистрация занимает минимальное количество времени
        // и функция продолжает свое выполнение дальше.
        // Если системы поймала перемещение мыши то она проходит по зарегестрированным функциям и выполняет их
        // в главном потоке выполнения текущей программы
        // Главный поток обрабатывает рендеринг и пользовательский ввод
        
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .leftMouseDragged]) { event in
            self.Location = NSEvent.mouseLocation
        }
        
    }
    
    
    // Проверка на попадание курсора в угол
    func CheckTheCorners() {
        if let MainScreen = NSScreen.main {
            let x = MainScreen.frame.width
            let y = MainScreen.frame.height
            
//            print("Location: \(self.Location) \n x: \(x) y: \(y)")
            
            if (!CoursorDetectedInAngle && (Location.x > x-10 && Location.y > y-10)){
                if log {print("IN ANGLE")}
                CoursorDetectedInAngle = true
            }
            else if (CoursorDetectedInAngle) && (Location.x < x-10 || Location.y < y-10){
                if log {print("OUT OF ANGLE")}
                CoursorDetectedInAngle = false
            }
        }
        
    }
    
    
    // Определение текущего приложения
    func DetectedActiveApplication() -> String{
        
        var activeAppName: String = "none"

        if let activeApp = NSWorkspace.shared.frontmostApplication {
            if log{
                print("Открытое приложение: \(activeApp.localizedName ?? "none")")
                print("Bundle ID: \(activeApp.bundleIdentifier ?? "none")")
            }
            activeAppName = activeApp.localizedName ?? activeAppName
        }
        
        return activeAppName
    }
    
    // Проверка на выход за пределы виджета
    func outOfRightCornerBounds(width: CGFloat, height: CGFloat) -> Bool {
        
        guard let MainScreen = NSScreen.main else {return false}

        let x = MainScreen.frame.width
        let y = MainScreen.frame.height
        
        
        print("outOfRightCornerBounds: \((Location.x <= x-width || Location.y < y-height))")

        
        return (Location.x <= x-width || Location.y < y-height)
        
    }
}



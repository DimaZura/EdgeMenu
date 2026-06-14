//
//  GlobalManager.swift
//  EdgeMenu
//
//  Created by mac on 07.06.2026.
//

import Foundation
import Combine
import AppKit


// Мозговой класс проекта,
// проводит основной мониторинг действий
//
//  1 - нахождения курсора
//      Если курсор оказывается в верхнем правом углу то
//      переводит флаг CoursorDetectedInAngle в активное состояние
//
//  2 - текущее приложение
//      При переводе флага в активное состояние проводит
//      определение текущего приложения
//

class GlobalManager : ObservableObject{
    var log: Bool = false
    
    static var shared = GlobalManager()
    
    // размер текущего окна
    var CurrentWindowSize : CGSize {
        return NSScreen.main?.frame.size ?? .zero
    }
    
    
    // флаг попадания курсора в угол
    @Published var CoursorDetectedInAngle: Bool = false
//    {
//        // при изменении
//        didSet {
//            // при изменении в активное состояние
//            if CoursorDetectedInAngle {
////                // провести определение текущей программы
////                DetectedActiveApplication()
//            }
//        }
//    }
    
    
    // текущая локация
    @Published var Location: CGPoint = .zero {
        // при изменении
        didSet {
            // провести проверку попадания в угол
            CheckTheCorners()
        }
    }
    
    
    
    
    // при инициализации
    init(){
        // запустить детектор положения курсора
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
        
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { event in
        
            self.Location = NSEvent.mouseLocation
            
//            print("Глобальный курсор: \(self.Location.x) \(self.Location.y)")
            
        }
        
    }
    
    
    // проверка на попадание курсора в угол
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
    
    
    // получение данных о текуем открытом окне
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
    
    func outOfRightCornerBounds(width: CGFloat, height: CGFloat) -> Bool {
        
        guard let MainScreen = NSScreen.main else {return false}

        let x = MainScreen.frame.width
        let y = MainScreen.frame.height
        
        return (Location.x <= x-width || Location.y < y-height)
        
    }
}



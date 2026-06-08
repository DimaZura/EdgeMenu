//
//  RightMenuManager.swift
//  EdgeMenu
//
//  Created by mac on 08.06.2026.
//

import Foundation
import Combine


class RightMenuManager : ObservableObject {
    static var shared = RightMenuManager()
    
    var CoursorDetectedInAngle: Bool = false {
        didSet{
            if CoursorDetectedInAngle == true {
                SetupWindowSize()
                SetupActiveAppName()
                isOpen = true
            }
            else {
                isOpen = false
            }
        }
    }
    
    @Published var isOpen: Bool = false
    
    var windowWidth: CGFloat = 1000
    var windowHeight: CGFloat = 1000
    var activeAppName: String = ""
    
    // множество всех подписок
    // [подписки необходимо добовлять во множество иначе они удалятся из памяти при завершении метода
    //  а пока они в множестве то существуют до удаления (deinit) самого класса ]
    private var cancellables = Set<AnyCancellable>()
    
    
    
    init() {
        // подписка на изменение свойства CoursorDetectedInAngle
        // [$ обозначает обращение не самому параметру в к потоку его изменения]
        // sink создает саму подписку на этот поток
        // weak sekf необходимо во избежение утечек памяти
        GlobalManager.shared.$CoursorDetectedInAngle
            .sink{ [weak self] value in
                self?.CoursorDetectedInAngle = value
            }
            .store(in: &cancellables)
    }
     
    
    // получение размеров текущего экрана
    func SetupWindowSize() {
        let windowSize = GlobalManager.shared.CurrentWindowSize
        
        windowWidth = windowSize.width
        windowHeight = windowSize.height
        
        print("\(windowWidth) \(windowHeight)")
    }
    
    
    // получение имени текущего приложения
    func SetupActiveAppName() {
        activeAppName = GlobalManager.shared.DetectedActiveApplication()
    }
}

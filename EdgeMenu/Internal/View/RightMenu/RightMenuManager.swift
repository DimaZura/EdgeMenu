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
    
    
    @Published var State: WidgetStates = IdleState()
    
    
    // Параметр флага открытия приложения
    @Published var isOpen: Bool = false

    // Параметр флага выделения (переноса курсором) файла
    var isFileFetch: Bool = false

    // Параметр названия активного приложения
    var activeAppName: String = ""
    
    // Параметр индекса ассета для отображения в виджете
    var activeAssetIndex: Int = 0

    

    
    // Ширина окна виджета
    var windowWidth: CGFloat = 1000
    // Высота окна виджета
    var windowHeight: CGFloat = 1000
    
    // Множество всех подписок
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
                // Разворачиваем weak self, чтобы безопасно использовать его как координатор
                guard let self = self else { return }
                
                // ПЕРЕДАЕМ self ВМЕСТО RightMenuManager.shared!
                self.State.handleCursor(inAngle: value, coordinator: self)
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
    
    // изменение состояние автомата виджета
    func changeState(to state: WidgetStates) {
        State = state
    }
    
    // скрыть виджет
    func hideWidget() {
        isOpen = false
    }
    // отобразить виджет
    func showWidget() {
        isOpen = true
    }
    
    // сменить ассет виждета на текущий
    func changeAsset(){
        
    }
}

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
    
    var log: Bool = true
    
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
    var windowWidth: CGFloat = 300
    // Высота окна виджета
    var windowHeight: CGFloat = 300
    
    
    // Множество всех подписок
    // [подписки необходимо добовлять во множество иначе они удалятся из памяти при завершении метода
    //  а пока они в множестве то существуют до удаления (deinit) самого класса ]
    private var cancellables = Set<AnyCancellable>()
    
    
    // ссылка на асинхронный метод определения выходы за границы меню
    private var outOfBoundsTask: Task<Void, Never>?
    
    
    init() {
        // подписка на изменение свойства CoursorDetectedInAngle
        // [$ обозначает обращение не самому параметру в к потоку его изменения]
        // sink создает саму подписку на этот поток
        // weak sekf необходимо во избежение утечек памяти
        GlobalManager.shared.$CoursorDetectedInAngle
            .sink{ [weak self] value in
                // Разворачиваем weak self, чтобы безопасно использовать его как координатор
                guard let self = self else { return }
                
                if value {
                    self.State.handleCursor(inAngle: true, coordinator: self)
                }
            }
            .store(in: &cancellables)
    }
     
    
    // получение размеров текущего экрана
    func SetupWindowSize() {
        let windowSize = GlobalManager.shared.CurrentWindowSize
        
        windowWidth = windowSize.width*0.1
        windowHeight = windowSize.height*0.2
        
        print("\(windowWidth) \(windowHeight)")
    }
    
    
    func monitorOutOfBounds() async {
        if log {print("monitorOutOfBounds")}
        
        while !Task.isCancelled {
            let isOut = GlobalManager.shared.outOfRightCornerBounds(width: windowWidth, height: windowHeight)
            
            if isOut {
                await MainActor.run {
                    self.State.handleCursor(inAngle: false, coordinator: self)
                }
                break
            }
            
            do {
                try await Task.sleep(nanoseconds: 50_000_000)
            }
            catch {
                break
            }
        }
        
        if log {print("monitorOutOfBounds done")}

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
        
        outOfBoundsTask?.cancel()
        outOfBoundsTask = nil
    }
    // отобразить виджет
    func showWidget() {
        isOpen = true
        
        outOfBoundsTask?.cancel()
        
        outOfBoundsTask = Task {
            await monitorOutOfBounds()
        }
    }
    
    // сменить ассет виждета на текущий
    func changeAsset(){
        
    }
}

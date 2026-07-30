//
//  RightMenuManager.swift
//  EdgeMenu
//
//  Created by mac on 08.06.2026.
//

import Foundation
import Combine

// Головной менеджер вью бокового меню

class RightMenuManager : ObservableObject {
    static var shared = RightMenuManager()
    
    var log: Bool = false
    
    // Текущее состояние виджета                    (Параметр автомата)
    // GeneralState - начальное состояние
    @Published var State: WidgetStates = GeneralState()
    
    // Флаг открытия виджета                        (Параметр автомата)
    @Published var isOpen: Bool = true

    // Флаг выделения файла (переноса курсором)     (Параметр автомата)
    var isFileFetch: Bool = false

    // Названиу активного приложения                (Параметр автомата)
    var activeAppName: String = ""
    
    // Название открытого приложения                (Параметр автомата)
    var OpenApplicationName: String = ""

    

    
    // Ширина окна виджета
    var windowWidth: CGFloat = 600
    // Высота окна виджета
    var windowHeight: CGFloat = 600
    
    
    // Множество всех подписок
    // [подписки необходимо добовлять во множество иначе они удалятся из памяти при завершении метода
    //  а пока они в множестве то существуют до удаления (deinit) самого класса ]
    private var cancellables = Set<AnyCancellable>()
    
        
    
    init() {
        // подписка на изменение свойства GlobalManager::CoursorDetectedInAngle
        // [$ обозначает обращение не самому параметру а к потоку его изменения]
        // sink создает саму подписку на этот поток
        // weak self необходимо во избежение утечек памяти
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
        
        windowWidth = 400
        windowHeight = 500
        
        if log {print("\(windowWidth) \(windowHeight)")}
    }
    
    
    // ссылка на асинхронный метод определения выходы за границы меню
    private var outOfBoundsTask: Task<Void, Never>?

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
        if log {print("monitorOutOfBounds - end")}
    }
    
    
    // получение имени текущего приложения
    func SetupActiveAppName() {
        activeAppName = GlobalManager.shared.DetectedActiveApplication()
    }
    
    // изменение состояние автомата виджета
    func changeState(to newState: WidgetStates) {
        State.onExit(coordinator: self)
        State = newState
        State.onEnter(coordinator: self)
    }
    
    // изменение мода работы виджета
    func switchMode(to mode: WidgetMode) {
        State.switchMode(to: mode, coordinator: self)
    }
    
    // получить значение текущего мода
    func getMode() -> WidgetMode {
        if State is GeneralState {
            return .general
        } else if State is AppCommandsState {
            return .appCommands
        } else if State is BufferState {
            return .buffer
        } else {
            return .general
        }
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

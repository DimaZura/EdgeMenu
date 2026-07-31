//
//  RightMenuManager.swift
//  EdgeMenu
//
//  Created by mac on 08.06.2026.
//

import Foundation
import Combine

// MARK: - ГОЛОВНОЙ МЕНЕДЖЕР ВЬЮ БОКОВОГО МЕНЮ
class RightMenuManager : ObservableObject {
    static var shared = RightMenuManager()
    
    var log: Bool = false
    
    /// Текущее состояние виджета                                       (Параметр автомата)
    @Published var State: WidgetStates = GeneralState()
    
    /// Флаг выделения файла (переноса курсором)            (Параметр автомата)
    var isFileFetch: Bool = false

    /// Названиу активного приложения                                (Параметр автомата)
    var activeAppName: String = ""
    
    /// Название открытого приложения                               (Параметр автомата)
    var OpenApplicationName: String = ""

    
    /// `ИЗМЕНЕНИЕ СОСТОЯНИЙ И ПАРАМЕТРОВ`
    
    /// Получение имени текущего приложения
    func SetupActiveAppName() {
        activeAppName = CursoreManager.shared.DetectedActiveApplication()
    }
    
    /// изменение состояние автомата виджета
    func changeState(to newState: WidgetStates) {
        /// выполнить комманды выхода из текущего состояния
        State.onExit(coordinator: self)
        State = newState
        /// выполнить комманды входа в новое состояние
        State.onEnter(coordinator: self)
    }
    
    /// Изменение мода работы виджета
    func switchMode(to mode: WidgetMode) {
        State.switchMode(to: mode, coordinator: self)
    }
        
    
    /// `ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ`
    
    /// Получить значение текущего мода
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

    
    /// сменить ассет виждета на текущий
    func changeAsset(){
    }
}


//@Published var isOpen: Bool = false
//
///// Скрыть виджет
//func hideWidget() {
//    isOpen = false
//    
//    outOfBoundsTask?.cancel()
//    outOfBoundsTask = nil
//}
///// Отобразить виджет
//func showWidget() {
//    isOpen = true
//    
//    outOfBoundsTask?.cancel()
//    
//    outOfBoundsTask = Task {
//        await monitorOutOfBounds()
//    }
//}


///// Множество всех подписок
///// [подписки необходимо добовлять во множество иначе они удалятся из памяти при завершении метода
/////  а пока они в множестве то существуют до удаления (deinit) самого класса ]
//private var cancellables = Set<AnyCancellable>()
//
//    
//
//init() {
//    /// подписка на изменение свойства CursoreManager::CoursorDetectedInAngle
//    /// [$ обозначает обращение не самому параметру а к потоку его изменения]
//    /// sink создает саму подписку на этот поток
//    /// weak self необходимо во избежение утечек памяти
//    CursoreManager.shared.$CoursorDetectedInAngle
//        .sink{ [weak self] value in
//            // Разворачиваем weak self, чтобы безопасно использовать его как координатор
//            guard let self = self else { return }
//            
//            if value {
//                self.State.handleCursor(inAngle: true, coordinator: self)
//            }
//        }
//        .store(in: &cancellables)
//}

///// `МЕТОДЫ ВЗАИМОДЕЙСТВИЯ С ГЛОБАЛЬНЫМ МЕНЕДЖЕРОМ`
//
///// Ссылка на асинхронный метод определения выходы за границы меню
//private var outOfBoundsTask: Task<Void, Never>?
///// Метод определения выхода за границы меню
//func monitorOutOfBounds() async {
//    if log {print("monitorOutOfBounds")}
//    
//    while !Task.isCancelled {
//        let isOut = CursoreManager.shared.outOfRightCornerBounds()
//
//        if isOut {
//            await MainActor.run {
//                self.State.handleCursor(inAngle: false, coordinator: self)
//            }
//            break
//        }
//    
//        do {
//            try await Task.sleep(nanoseconds: 50_000_000)
//        }
//        catch {
//            break
//        }
//    }
//    if log {print("monitorOutOfBounds - end")}
//}

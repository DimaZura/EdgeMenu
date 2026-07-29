//
//  RightMenuStates.swift
//  EdgeMenu
//
//  Created by mac on 14.06.2026.
//

import Foundation


struct WidgetFrameConfig {
    let minWidth: CGFloat
    let maxWidth: CGFloat
    let minHeight: CGFloat
    let maxHeight: CGFloat
}

// состояния работы виджета
enum WidgetMode {
    case general        // Общее меню
    case appCommands    // Меню приложения
    case buffer         // Меню буфера
}

protocol WidgetStates {
    // изменение состояние наведения курсора на угол
    func handleCursor(inAngle: Bool, coordinator: RightMenuManager)
    // изменение состояние открытия приложения
    func handleOpenApplication(appName: String, coordinator: RightMenuManager)
    // изменение состояния выделение файла курсором
    func handleFileFetch(isFileFetch: Bool, coordinator: RightMenuManager)

    
    // изменение мода отображение (пользовательское действие)
    func switchMode(to mode: WidgetMode, coordinator: RightMenuManager)
    
    func onEnter(coordinator: RightMenuManager)
    func onExit(coordinator: RightMenuManager)
}


extension WidgetStates {
    func onEnter(coordinator: RightMenuManager) {}
    func onExit(coordinator: RightMenuManager) {}
    
    var frameConfig: WidgetFrameConfig {
            switch self {
            case is IdleState:
                return WidgetFrameConfig(minWidth: 100, maxWidth: 300, minHeight: 40, maxHeight: 55)
            case is BufferState:
                return WidgetFrameConfig(minWidth: 200, maxWidth: 400, minHeight: 150, maxHeight: 400)
            default:
                return WidgetFrameConfig(minWidth: 150, maxWidth: 350, minHeight: 100, maxHeight: 300)
            }
        }
}



class IdleState: WidgetStates {
    func handleCursor(inAngle: Bool, coordinator: RightMenuManager) {
        if inAngle {
            coordinator.SetupActiveAppName()
            coordinator.SetupWindowSize()
            
            if coordinator.isFileFetch {
                coordinator.changeState(to: BufferState())
            }
            else if coordinator.OpenApplicationName != "" {
                coordinator.changeState(to: AppCommandsState())
            }
            else {
                coordinator.changeState(to: GeneralState())
            }
            
            coordinator.showWidget()
        }
    }
    func handleOpenApplication(appName: String, coordinator: RightMenuManager) {
        // запрос ассета
        // coordinator.activeAssetIndex = ...
    }
    func handleFileFetch(isFileFetch: Bool, coordinator: RightMenuManager){
        coordinator.isFileFetch = isFileFetch
    }

    
    func switchMode(to mode: WidgetMode, coordinator: RightMenuManager)
    {
        // в данном состянии не активно
    }
}

class AppCommandsState: WidgetStates {
    func handleCursor(inAngle: Bool, coordinator: RightMenuManager) {
        if !inAngle {
            coordinator.changeState(to: IdleState())
            coordinator.hideWidget()
        }
    }
    func handleOpenApplication(appName: String, coordinator: RightMenuManager) {
        if coordinator.activeAppName != appName {
            // запрос ассета
            // coordinator.activeAssetIndex = ...
            coordinator.changeAsset()
        }

    }
    func handleFileFetch(isFileFetch: Bool, coordinator: RightMenuManager){
        coordinator.isFileFetch = isFileFetch
        if isFileFetch {
            coordinator.changeState(to: BufferState())
        }
    }

    
    func switchMode(to mode: WidgetMode, coordinator: RightMenuManager)
    {
        switchModeTemplate(to: mode, coordinator: coordinator)
    }
}

class GeneralState: WidgetStates {
    func handleCursor(inAngle: Bool, coordinator: RightMenuManager) {
        if !inAngle {
            coordinator.changeState(to: IdleState())
            coordinator.hideWidget()
        }
    }
    func handleOpenApplication(appName: String, coordinator: RightMenuManager) {
        // coordinator.activeAssetIndex = ...
        if coordinator.OpenApplicationName != ""{
            coordinator.changeState(to: AppCommandsState())
        }
    }
    func handleFileFetch(isFileFetch: Bool, coordinator: RightMenuManager){
        
    }

    
    func switchMode(to mode: WidgetMode, coordinator: RightMenuManager)
    {
        switchModeTemplate(to: mode, coordinator: coordinator)
    }
}

class BufferState: WidgetStates
{
    func handleCursor(inAngle: Bool, coordinator: RightMenuManager) {
        if !inAngle {
            coordinator.changeState(to: IdleState())
            coordinator.hideWidget()
        }
    }
    func handleOpenApplication(appName: String, coordinator: RightMenuManager) {
        
    }
    func handleFileFetch(isFileFetch: Bool, coordinator: RightMenuManager){
        
    }

    
    func switchMode(to mode: WidgetMode, coordinator: RightMenuManager)
    {
        switchModeTemplate(to: mode, coordinator: coordinator)
    }
    
    func onEnter(coordinator: RightMenuManager) {
        BufferStateManager.shared.start()
    }
    func onExit(coordinator: RightMenuManager) {
        BufferStateManager.shared.stop()
    }

}


func switchModeTemplate(to mode: WidgetMode, coordinator: RightMenuManager)
{
    switch mode {
    case .appCommands:
        coordinator.changeState(to: AppCommandsState())
    case .general:
        coordinator.changeState(to: GeneralState())
    case .buffer:
        coordinator.changeState(to: BufferState())
    }
}

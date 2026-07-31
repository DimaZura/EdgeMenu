//
//  RightMenuStates.swift
//  EdgeMenu
//
//  Created by mac on 14.06.2026.
//

import Foundation




// состояния работы виджета
enum WidgetMode {
    case general        // Общее меню
    case appCommands    // Меню приложения
    case buffer         // Меню буфера
}


protocol WidgetStates {
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
}



class IdleState: WidgetStates {
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

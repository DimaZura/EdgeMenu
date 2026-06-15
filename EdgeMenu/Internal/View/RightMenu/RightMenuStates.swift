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
    // изменение состояние наведения курсора на угол
    func handleCursor(inAngle: Bool, coordinator: RightMenuManager)
    // изменение состояние открытия приложения
    func handleOpenApplication(appName: String, coordinator: RightMenuManager)
    // изменение состояния выделение файла курсором
    func handleFileFetch(isFileFetch: Bool, coordinator: RightMenuManager)

    
    // изменение мода отображение (пользовательское действие)
    func switchMode(to mode: WidgetMode, coordinator: RightMenuManager)
}



class IdleState: WidgetStates {
    func handleCursor(inAngle: Bool, coordinator: RightMenuManager) {
        if inAngle {
            coordinator.SetupActiveAppName()
            coordinator.SetupWindowSize()
            
            if coordinator.isFileFetch {
                coordinator.changeState(to: BufferState())
            }
            else if coordinator.activeAssetIndex != 0 {
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
        if coordinator.activeAssetIndex != 0 {
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

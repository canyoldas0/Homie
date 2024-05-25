//
//  HomeKitManager.swift
//  MyHome
//
//  Created by Can Yoldas on 25/05/2024.
//

import Foundation
import HomeKit

class HomeKitManager: NSObject, ObservableObject, HMHomeManagerDelegate {
    @Published var homes: [HMHome] = []
    private var homeManager: HMHomeManager!
    
    override init() {
        super.init()
        homeManager = HMHomeManager()
        homeManager.delegate = self
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        self.homes = manager.homes
    }
    
    func getLightAccessories(from home: HMHome) -> [HMAccessory] {
        return home.accessories.filter { accessory in
            accessory.services.contains { service in
                service.serviceType == HMServiceTypeLightbulb
            }
        }
    }
    
    func toggleLight(_ accessory: HMAccessory, on: Bool) {
        if let lightService = accessory.services.first(where: { $0.serviceType == HMServiceTypeLightbulb }) {
            if let powerCharacteristic = lightService.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypePowerState }) {
                powerCharacteristic.writeValue(on) { error in
                    if let error = error {
                        print("Failed to write value: \(error)")
                    }
                }
            }
        }
    }
    
    func setBrightness(_ accessory: HMAccessory, brightness: Float) {
        if let lightService = accessory.services.first(where: { $0.serviceType == HMServiceTypeLightbulb }) {
            if let brightnessCharacteristic = lightService.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypeBrightness }) {
                brightnessCharacteristic.writeValue(brightness) { error in
                    if let error = error {
                        print("Failed to set brightness: \(error)")
                    }
                }
            }
        }
    }
    
    func setColor(_ accessory: HMAccessory, hue: Float, saturation: Float) {
        if let lightService = accessory.services.first(where: { $0.serviceType == HMServiceTypeLightbulb }) {
            if let hueCharacteristic = lightService.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypeHue }) {
                hueCharacteristic.writeValue(hue) { error in
                    if let error = error {
                        print("Failed to set hue: \(error)")
                    }
                }
            }
            if let saturationCharacteristic = lightService.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypeSaturation }) {
                saturationCharacteristic.writeValue(saturation) { error in
                    if let error = error {
                        print("Failed to set saturation: \(error)")
                    }
                }
            }
        }
    }
}

//
//  LightAccessoryDetail.swift
//  MyHome
//
//  Created by Can Yoldas on 25/05/2024.
//

import SwiftUI
import HomeKit

struct LightAccessoryDetailView: View {
    var accessory: HMAccessory
    @ObservedObject var homeKitManager: HomeKitManager
    
    @State private var isOn: Bool = false
    @State private var brightness: Float = 0
    @State private var hue: Float = 0
    @State private var saturation: Float = 0
    
    var body: some View {
        Form {
            Section(header: Text("Power")) {
                Toggle("On/Off", isOn: $isOn)
                    .onAppear {
                        if let lightService = accessory.services.first(where: { $0.serviceType == HMServiceTypeLightbulb }) {
                            if let powerCharacteristic = lightService.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypePowerState }) {
                                powerCharacteristic.readValue { error in
                                    if let error = error {
                                        print("Error reading power state: \(error)")
                                    } else {
                                        isOn = powerCharacteristic.value as? Bool ?? false
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: isOn) { newValue in
                        homeKitManager.toggleLight(accessory, on: newValue)
                    }
            }
            
            if let lightService = accessory.services.first(where: { $0.serviceType == HMServiceTypeLightbulb }) {
                if lightService.characteristics.contains(where: { $0.characteristicType == HMCharacteristicTypeBrightness }) {
                    Section(header: Text("Brightness")) {
                        Slider(value: $brightness, in: 0...100, step: 1)
                            .onAppear {
                                if let brightnessCharacteristic = lightService.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypeBrightness }) {
                                    brightnessCharacteristic.readValue { error in
                                        if let error = error {
                                            print("Error reading brightness: \(error)")
                                        } else {
                                            brightness = brightnessCharacteristic.value as? Float ?? 0
                                        }
                                    }
                                }
                            }
                            .onChange(of: brightness) { newValue in
                                homeKitManager.setBrightness(accessory, brightness: newValue)
                            }
                    }
                }
                
                if lightService.characteristics.contains(where: { $0.characteristicType == HMCharacteristicTypeHue }) &&
                   lightService.characteristics.contains(where: { $0.characteristicType == HMCharacteristicTypeSaturation }) {
                    Section(header: Text("Color")) {
                        VStack {
                            Text("Hue")
                            Slider(value: $hue, in: 0...360, step: 1)
                                .onAppear {
                                    if let hueCharacteristic = lightService.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypeHue }) {
                                        hueCharacteristic.readValue { error in
                                            if let error = error {
                                                print("Error reading hue: \(error)")
                                            } else {
                                                hue = hueCharacteristic.value as? Float ?? 0
                                            }
                                        }
                                    }
                                }
                                .onChange(of: hue) { newValue in
                                    homeKitManager.setColor(accessory, hue: newValue, saturation: saturation)
                                }
                        }
                        VStack {
                            Text("Saturation")
                            Slider(value: $saturation, in: 0...100, step: 1)
                                .onAppear {
                                    if let saturationCharacteristic = lightService.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypeSaturation }) {
                                        saturationCharacteristic.readValue { error in
                                            if let error = error {
                                                print("Error reading saturation: \(error)")
                                            } else {
                                                saturation = saturationCharacteristic.value as? Float ?? 0
                                            }
                                        }
                                    }
                                }
                                .onChange(of: saturation) { newValue in
                                    homeKitManager.setColor(accessory, hue: hue, saturation: newValue)
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle(accessory.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


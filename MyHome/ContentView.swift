//
//  ContentView.swift
//  MyHome
//
//  Created by Can Yoldas on 25/05/2024.
//

import SwiftUI
import HomeKit

import SwiftUI
import HomeKit

struct ContentView: View {
    @StateObject private var homeKitManager = HomeKitManager()
    
    var body: some View {
        NavigationStack {
            List(homeKitManager.homes, id: \.uniqueIdentifier) { home in
                NavigationLink(destination: HomeDetailView(home: home, homeKitManager: homeKitManager)) {
                    Text(home.name)
                }
            }
            .navigationTitle("Homes")
        }
    }
}



struct HomeDetailView: View {
    var home: HMHome
    @ObservedObject var homeKitManager: HomeKitManager
    
    var body: some View {
        List(homeKitManager.getLightAccessories(from: home), id: \.uniqueIdentifier) { accessory in
            NavigationLink(destination: LightAccessoryDetailView(accessory: accessory, homeKitManager: homeKitManager)) {
                Text(accessory.name)
            }
        }
        .navigationTitle(home.name)
    }
}

struct AccessoryDetailView: View {
    var accessory: HMAccessory
    
    var body: some View {
        List(accessory.services, id: \.uniqueIdentifier) { service in
            Section(header: Text(service.name)) {
                ForEach(service.characteristics, id: \.uniqueIdentifier) { characteristic in
                    CharacteristicView(characteristic: characteristic)
                }
            }
        }
        .navigationTitle(accessory.name)
    }
}

struct CharacteristicView: View {
    var characteristic: HMCharacteristic
    
    @State private var value: Any?
    
    var body: some View {
        HStack {
            Text(characteristic.metadata?.manufacturerDescription ?? "Unknown")
            Spacer()
            Text(value as? String ?? "N/A")
        }
        .onAppear {
            characteristic.readValue { error in
                if let error = error {
                    print("Error reading value: \(error)")
                } else {
                    value = characteristic.value
                }
            }
        }
    }
}


#Preview {
    ContentView()
}

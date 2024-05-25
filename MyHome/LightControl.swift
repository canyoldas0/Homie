//
//  LightControl.swift
//  MyHome
//
//  Created by Can Yoldas on 25/05/2024.
//

import SwiftUI

struct LightControlView: View {
    
    @State var kitchen: Bool = false
    @State var livingRoom: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .opacity(0.25)
                .blur(radius: 3, opaque: true)
                
            List {
                Group {
                    LightRow(name: "Kitchen", isOn: $kitchen)
                    LightRow(name: "Living Room", isOn: $livingRoom)
                }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 16, leading: 0, bottom: 0, trailing: 0))
            }
            
            
        }
        .scrollContentBackground(.hidden)
    }
}

struct LightRow: View {
    
    var name: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Button {
                withAnimation(.easeInOut) {
                    isOn.toggle()
                }
            } label: {
                Image(systemName: "light.cylindrical.ceiling.fill")
                    .padding(12)
                    .foregroundStyle(.white.opacity(0.8))
                    .background(.yellow, in: .circle)
            }.buttonStyle(.plain).containerShape(Circle())
            Text(name)
            Spacer()
        }
        .frame(width: 160)
        .padding(20)
        .background(isOn ? Material.regular : Material.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        LightControlView()
    }
}

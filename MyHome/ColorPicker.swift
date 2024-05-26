//
//  ColorPicker.swift
//  MyHome
//
//  Created by Can Yoldas on 26/05/2024.
//

import SwiftUI

extension UIColor {
    func toHSV() -> (hue: CGFloat, saturation: CGFloat, value: CGFloat, alpha: CGFloat)? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return nil
        }
        
        return (hue, saturation, brightness, alpha)
    }
}

struct LightLevelDragger: View {
    @State private var dragAmount: CGFloat = 50
    @Binding var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color(white: 0.9)
                    .edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .fill(.gray.opacity(0.6))
                    .frame(height: geometry.size.height - dragAmount)
                
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(.gray.opacity(0.6))
                        .frame(width: geometry.size.width, height: 25)
                        .offset(y: dragAmount - geometry.size.height / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragAmount = lightLevel(in: value.location.y)
                                }
                        )
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    Image(systemName: "lightbulb.fill")
                        .foregroundStyle(.gray)
                }
                .padding(.bottom, 16)
                
            }
            .contentShape(Rectangle()) // Makes the entire GeometryReader tappable
            .onTapGesture { location in
                dragAmount = max(0, location.y)
            }
        }
        .frame(width: 100, height: 240)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    func lightLevel(in height: CGFloat) -> CGFloat {
        // Convert dragAmount to light level (0-100)
        return 100 - (dragAmount / height) * 100
    }
}

struct ColorPickerView: View {
    
    @State var color: Color = .red
    @State private var dragAmount: CGFloat = 0.0
      
    
    var body: some View {
        VStack {
            Text("Picker")
            
            LightLevelDragger(color: $color)
//            RoundedRectangle(cornerRadius: 16)
//                .frame(width: 60, height: 160)
//                .foregroundStyle(.thinMaterial)
//                .overlay {
//                    VStack {
//                        Spacer()
//                        Image(systemName: "lightbulb.fill")
//                            .foregroundStyle(.gray)
//                    }
//                    .padding(.bottom, 16)
//                }
            
            
            ScrollView {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Circle()
                            .frame(width: 28)
                            .foregroundStyle(.red)
                    })
                    ColorPicker(selection: $color, label: { })
                        .frame(width: 50)
                }
            }
                
        }
    }
    
    func hsv() {
        let uiColor = UIColor(color)
        uiColor.toHSV()
    }
}

#Preview {
    ColorPickerView()
        
}

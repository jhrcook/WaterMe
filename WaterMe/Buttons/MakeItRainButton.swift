//
//  MakeItRainButton.swift
//  WaterMe
//
//  Created by Joshua on 7/17/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI



struct MakeItRainButtonStyle: ButtonStyle {
    
    @Binding var activated: Bool
    
    var colorScheme: ColorScheme
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 20)
            .foregroundColor(activated ? Color.white : colorScheme == .light ? Color.white : Color.black)
//            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.8) : Color.white)
            .background(
                Circle()
                    .foregroundColor(activated ? Color.blue : colorScheme == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.8))
            )
            .shadow(color: Color.black.opacity(0.5),
                    radius: configuration.isPressed ? 1 : 3,
                    x: configuration.isPressed ? 1 : 3,
                    y: configuration.isPressed ? 1 : 3)
            .animation(.linear(duration: 0.1))
            .padding()
    }
}


struct MakeItRainButton: View {
    
    @Binding var activated: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "cloud.rain")
            }
            .font(.title)
        }
        .buttonStyle(MakeItRainButtonStyle(activated: $activated, colorScheme: colorScheme))
    }
}


struct MakeItRainButton_Previews: PreviewProvider {
    
    static let modes = [true, false]
    
    static var previews: some View {
        Group {
            
            ForEach(modes, id: \.self) { mode in
                MakeItRainButton(activated: .constant(mode), action: {})
                    .previewLayout(.sizeThatFits)
                    .padding(mode ? 30 : 10)
                    .background(Color.lightBlue)
                    .previewDisplayName("normal")
                
            }
            
            ForEach(modes, id: \.self) { mode in
                MakeItRainButton(activated: .constant(mode), action: {})
                    .previewLayout(.sizeThatFits)
                    .padding(mode ? 30 : 10)
                    .background(Color.lightBlue)
                    .environment(\.colorScheme, .dark)
                    .previewDisplayName("dark mode")
            }
        }
    }
}

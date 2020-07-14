//
//  WaterMeButton.swift
//  WaterMe
//
//  Created by Joshua on 7/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct WaterMeButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.8) : Color.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(Color.blue)
                    .shadow(color: Color.black.opacity(0.5),
                            radius: configuration.isPressed ? 1 : 3,
                            x: configuration.isPressed ? 1 : 3,
                            y: configuration.isPressed ? 1 : 3)
            )
    }
}


struct WaterMeButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            
            HStack {
                Image(systemName: "cloud.rain")
                Text("Water me")
            }
            .font(.title)
        }
        .buttonStyle(WaterMeButtonStyle())
    }
}


struct WaterMeButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WaterMeButton(action: {})
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("normal")
            
            WaterMeButton(action: {})
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark mode")
            
            WaterMeButton(action: {})
                .previewLayout(.sizeThatFits)
                .padding()
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("accessbility XL")
        }
    }
}

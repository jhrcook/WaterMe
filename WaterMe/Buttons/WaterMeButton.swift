//
//  WaterMeButton.swift
//  WaterMe
//
//  Created by Joshua on 7/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct WaterMeButtonStyle: ButtonStyle {
    
    var hasBeenWatered: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.8) : hasBeenWatered ? .blue : Color.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(hasBeenWatered ? Color.clear : .blue)
                    .shadow(color: Color.black.opacity(hasBeenWatered ? 0 : 0.5),
                            radius: configuration.isPressed ? 1 : 3,
                            x: configuration.isPressed ? 1 : 3,
                            y: configuration.isPressed ? 1 : 3)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(hasBeenWatered ? Color.blue : .clear, style: StrokeStyle(lineWidth: 3))
                )
            )
    }
}


struct WaterMeButton: View {
    
    var hasBeenWatered: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            
            HStack {
                Image(systemName: hasBeenWatered ? "hand.thumbsup" : "cloud.rain")
                Text(hasBeenWatered ? "Watered!" : "Water me")
            }
            .font(.title)
        }
        .buttonStyle(WaterMeButtonStyle(hasBeenWatered: hasBeenWatered))
    }
}


struct WaterMeButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WaterMeButton(hasBeenWatered: false, action: {})
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("normal")
            
            WaterMeButton(hasBeenWatered: true, action: {})
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("watered")
            
            WaterMeButton(hasBeenWatered: false, action: {})
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark mode")
            
            WaterMeButton(hasBeenWatered: false, action: {})
                .previewLayout(.sizeThatFits)
                .padding()
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("accessbility XL")
        }
    }
}

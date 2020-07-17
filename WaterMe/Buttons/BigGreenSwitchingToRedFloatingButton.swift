//
//  BigGreenSwitchingToRedFloatingButton.swift
//  WaterMe
//
//  Created by Joshua on 7/17/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct BigGreenSwitchingToRedFloatingButtonStyle: ButtonStyle {
        
    @Binding var setToRed: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.7) : Color.white)
            .animation(.linear(duration: 0.2))
            .background(self.setToRed ? Color.red : Color.green)
            .clipShape(Circle())
            .animation(.linear(duration: 0.06))
            .shadow(color: Color.black.opacity(0.5),
                    radius: configuration.isPressed ? 1 : 3,
                    x: configuration.isPressed ? 1 : 3,
                    y: configuration.isPressed ? 1 : 3)
            .padding()
    }
}

struct BigGreenSwitchingToRedFloatingButton: View {
    
    @Binding var setToRed: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(.title))
                .rotationEffect(self.setToRed ? .degrees(45) : .degrees(0))
                .padding(.all, 20)
        }
        .buttonStyle(BigGreenSwitchingToRedFloatingButtonStyle(setToRed: $setToRed))
    }
}


struct BigGreenSwitchingToRedFloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BigGreenSwitchingToRedFloatingButton(setToRed: .constant(false), action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
            
            BigGreenSwitchingToRedFloatingButton(setToRed: .constant(true), action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
                .previewDisplayName("red")
            
            BigGreenSwitchingToRedFloatingButton(setToRed: .constant(false), action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
            
            BigGreenSwitchingToRedFloatingButton(setToRed: .constant(true), action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode; red")
            
            BigGreenSwitchingToRedFloatingButton(setToRed: .constant(false), action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("accessbility XL")
            
            BigGreenSwitchingToRedFloatingButton(setToRed: .constant(true), action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("accessbility XL; red")
            
        }
    }
}

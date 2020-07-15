//
//  BigGreenFloatingButton.swift
//  WaterMe
//
//  Created by Joshua on 7/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct BigGreenFloatingButtonStyle: ButtonStyle {
        
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.7) : Color.white)
            .background(Color.green)
            .clipShape(Circle())
            .padding()
            .shadow(color: Color.black.opacity(0.5),
                    radius: configuration.isPressed ? 1 : 3,
                    x: configuration.isPressed ? 1 : 3,
                    y: configuration.isPressed ? 1 : 3)
    }
}

struct BigGreenFloatingButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(.title))
                .padding(.all, 20)
        }
        .buttonStyle(BigGreenFloatingButtonStyle())
    }
}


struct BigGreenFloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BigGreenFloatingButton(action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
            
            BigGreenFloatingButton(action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
            
            BigGreenFloatingButton(action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .previewDisplayName("XXXL")
            
            BigGreenFloatingButton(action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("accessbility XL")
            
            BigGreenFloatingButton(action: {})
                .previewLayout(.sizeThatFits)
                .padding(.horizontal, 50)
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
                .previewDisplayName("accessbility XXXL")
            
        }
    }
}

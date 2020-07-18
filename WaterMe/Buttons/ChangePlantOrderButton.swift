//
//  ChangePlantOrderButton.swift
//  WaterMe
//
//  Created by Joshua on 7/18/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct ChangePlantOrderButtonStyle: ButtonStyle {
    
    var colorScheme: ColorScheme
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(colorScheme == .light ? Color.white : Color.black)
            .background(
                Circle()
                    .foregroundColor(colorScheme == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.8))
            )
            .shadow(color: Color.black.opacity(0.5),
                    radius: configuration.isPressed ? 1 : 3,
                    x: configuration.isPressed ? 1 : 3,
                    y: configuration.isPressed ? 1 : 3)
            .animation(.linear(duration: 0.1))
    }
}


struct ChangePlantOrderButton: View {
    
    @Binding var showOptions: Bool
    var colorScheme: ColorScheme
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.up.arrow.down")
                .rotationEffect(showOptions ? .degrees(-180) : .degrees(0))
                .animation(.easeInOut(duration: 0.3))
                .padding(12)
        }
        .buttonStyle(ChangePlantOrderButtonStyle(colorScheme: colorScheme))
    }
}

struct ChangePlantOrderButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChangePlantOrderButton(showOptions: .constant(false), colorScheme: .light) {}
                .padding(10)
                .previewLayout(.sizeThatFits)
            ChangePlantOrderButton(showOptions: .constant(false), colorScheme: .dark) {}
                .padding(10)
                .previewLayout(.sizeThatFits)
            ChangePlantOrderButton(showOptions: .constant(true), colorScheme: .light) {}
                .padding(10)
                .previewLayout(.sizeThatFits)
            ChangePlantOrderButton(showOptions: .constant(true), colorScheme: .dark) {}
            .padding(10)
            .previewLayout(.sizeThatFits)
        }
    }
}

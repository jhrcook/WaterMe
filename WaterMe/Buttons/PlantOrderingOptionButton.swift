//
//  PlantOrderingOptionButton.swift
//  WaterMe
//
//  Created by Joshua on 7/18/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct PlantOrderingOptionButtonStyle: ButtonStyle {
    
    var colorScheme: ColorScheme
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 5, leading: 6, bottom: 5, trailing: 6))
            .foregroundColor(colorScheme == .light ? Color.white : Color.black)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .foregroundColor(colorScheme == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.8))
            )
            .shadow(color: Color.black.opacity(0.5),
                    radius: configuration.isPressed ? 1 : 3,
                    x: configuration.isPressed ? 1 : 3,
                    y: configuration.isPressed ? 1 : 3)
//            .animation(.linear(duration: 0.05))
    }
}


struct PlantOrderingOptionButton: View {
    
    var orderOption: PlantOrder
    var colorScheme: ColorScheme

    var action: () -> Void
    
    
    var imageName: String {
        switch orderOption {
        case .alphabetically:
            return "a.circle"
        case .lastWatered:
            return "calendar"
        case .frequencyOfWatering:
            return "stopwatch"
        }
    }
    
    var text: String {
        switch orderOption {
        case .alphabetically:
            return "alphabetically"
        case .lastWatered:
            return "last watered"
        case .frequencyOfWatering:
            return "watering frequency"
        }
    }
    
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: imageName)
                Text(text)
            }
        }
        .buttonStyle(PlantOrderingOptionButtonStyle(colorScheme: colorScheme))
    }
}


struct PlantOrderingOptionButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(PlantOrder.allCases, id: \.self) { orderOption in
                ForEach([ColorScheme.light, .dark], id: \.self) { colorScheme in
                    PlantOrderingOptionButton(orderOption: orderOption, colorScheme: colorScheme, action: {})
                        .padding(10)
                        .previewLayout(.sizeThatFits)
                }
            }
        }
    }
}

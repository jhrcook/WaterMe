//
//  SmallFloatingTextButtonStyle.swift
//  WaterMe
//
//  Created by Joshua on 7/14/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SmallFloatingTextButtonStyle: ButtonStyle {
    
    var padding: EdgeInsets = EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
    var cornerRadius: CGFloat = 10
    var colorScheme: ColorScheme
    
    
    init() {
        self.colorScheme = .light
    }
    
    init(padding: EdgeInsets, colorScheme: ColorScheme) {
        self.padding = padding
        self.colorScheme = colorScheme
    }
    
    init(padding: EdgeInsets) {
        self.padding = padding
        self.colorScheme = ColorScheme.light
    }
    
    init(padding: CGFloat, colorScheme: ColorScheme) {
        self.padding = EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        self.colorScheme = colorScheme
    }
    
    init(padding: CGFloat, cornerRadius: CGFloat, colorScheme: ColorScheme) {
        self.padding = EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        self.cornerRadius = cornerRadius
        self.colorScheme = colorScheme
    }
    
    init(padding: EdgeInsets, cornerRadius: CGFloat, colorScheme: ColorScheme) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.colorScheme = colorScheme
    }
    
    init(padding: CGFloat) {
        self.padding = EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        self.colorScheme = ColorScheme.light
    }
    
    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        self.colorScheme = .light
    }
    
    
    init(cornerRadius: CGFloat, colorScheme: ColorScheme) {
        self.cornerRadius = cornerRadius
        self.colorScheme = colorScheme
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body))
            .padding(padding)
            .foregroundColor(Color.white)
            .background(colorScheme == .light ? Color.black.opacity(0.2) : Color.white.opacity(0.3))
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.3),
                    radius: configuration.isPressed ? 1 : 3,
                    x: configuration.isPressed ? 1 : 3,
                    y: configuration.isPressed ? 1 : 3)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}


fileprivate struct ExampleButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 30) {
            Button(action: {}) {
                Image(systemName: "trash")
            }
            .buttonStyle(SmallFloatingTextButtonStyle(padding: 10, colorScheme: colorScheme))
        }
    }
}



struct SmallFloatingTextButtonStyle_Previews: PreviewProvider {
    
    @Environment(\.colorScheme) var colorScheme
    
    static var previews: some View {
        Group {
            ExampleButton()
                .padding()
                .previewLayout(.sizeThatFits)
            
            ExampleButton()
                .padding()
                .previewLayout(.sizeThatFits)
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
        }
    }
}

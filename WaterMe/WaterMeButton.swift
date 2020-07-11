//
//  WaterMeButton.swift
//  WaterMe
//
//  Created by Joshua on 7/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct WaterMeButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            
            HStack {
                Image(systemName: "cloud.drizzle")
                Text("Water me")
            }
            .font(.title)
            .foregroundColor(Color.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(Color.blue)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
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

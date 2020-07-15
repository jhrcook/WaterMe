//
//  Color-extension.swift
//  WaterMe
//
//  Created by Joshua on 7/15/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

extension Color {
    
    /// Describe a color using the metrics available from the Adobe Color web application.
    /// - Parameters:
    ///   - adobeH: Hue (out of 360)
    ///   - adobeS: Saturation (out of 100)
    ///   - adobeB: Brightness (out of 100)
    init(adobeH: Double, adobeS: Double, adobeB: Double) {
        self.init(hue: adobeH / 360.0, saturation: adobeS / 100.0, brightness: adobeB / 100.0)
    }
    
    static let darkBlue = Color(adobeH: 205, adobeS: 62, adobeB: 66)
    static let lightBlue = Color(adobeH: 205, adobeS: 52, adobeB: 96)
    static let lightTomato = Color(adobeH: 1, adobeS: 52, adobeB: 96)
}


fileprivate struct ExampleColorText: View {
    
    let text: String
    let backgroundColor: Color
    var foregroundColor: Color = .white
    
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundColor(foregroundColor)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(backgroundColor)
            )
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName(text)
    }
}


struct CustomColors_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            ExampleColorText(text: "Dark Blue", backgroundColor: .darkBlue)
            ExampleColorText(text: "Light Blue", backgroundColor: .lightBlue)
            ExampleColorText(text: "Light Tomato", backgroundColor: .lightTomato)
        }
        
    }
}

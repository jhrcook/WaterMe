//
//  BigGreenFloatingButton.swift
//  WaterMe
//
//  Created by Joshua on 7/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct BigGreenFloatingButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(.title))
                .frame(width: 65, height: 65)
                .foregroundColor(Color.white)
        }
        .background(Color.green)
        .cornerRadius(38.5)
        .padding()
        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
    }
}


struct BigGreenFloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        BigGreenFloatingButton(action: { print("tap") })
    }
}

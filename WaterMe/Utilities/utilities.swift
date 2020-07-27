//
//  utilities.swift
//  WaterMe
//
//  Created by Joshua on 7/11/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}





#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

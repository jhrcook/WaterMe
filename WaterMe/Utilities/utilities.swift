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

func deleteFileInBackground(at URL: URL) {
    DispatchQueue.global(qos: .background).async {
        do {
            try FileManager.default.removeItem(at: URL)
        } catch {
            print("Unable to delete old image file: \(URL.absoluteString).")
        }
    }
}

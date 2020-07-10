//
//  Plant.swift
//  WaterMe
//
//  Created by Joshua on 7/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

struct Plant: Identifiable, Codable {
    
    let id = UUID()

    static let defaultImageNames: [String] = {
        var a = [String]()
        for i in 1...5 {
            a.append("default-plant-image-\(i)")
        }
        return a
    }()
    
    static func randomDefaultImage() -> String {
        return Plant.defaultImageNames.randomElement()!
    }
    
    var name = ""
    var imageName: String = Plant.defaultImageNames.randomElement()!
    
    var datesWatered = [Date]()
    
    var dateLastWatered: Date {
        return datesWatered.last ?? Date()
    }
    
    var formattedDateLastWatered: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter.string(from: dateLastWatered)
    }
}

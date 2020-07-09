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
    
    static let defaultImageName = "default-plant-image-1"
    
    var name = ""
    var imageName = Plant.defaultImageName
    
    var datesWatered = [Date]()
    
    var dateLastWatered: Date {
        return datesWatered.last ?? Date()
    }
    
    var formattedDateLastWatered: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dateLastWatered)
    }
}

//
//  PlantWatch.swift
//  WaterMe
//
//  Created by Joshua on 8/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

enum PlantWatchVersion: Int, Codable {
    case one = 1
}

struct PlantWatch: Identifiable, Codable {
    let version: PlantWatchVersion = .one
    var id: String
    
    var name: String
    var imageName: String? = nil
    var randomImageIndex: Int
    
    var dateLastWatered: Date? = nil
    var wasWateredToday: Bool {
        if let date = dateLastWatered {
            return Calendar.current.isDateInToday(date)
        }
        return false
    }
    
    var daysSinceLastWatering: Int? {
        if let date = dateLastWatered {
            return Calendar.current.dateComponents([.day], from: date, to: Date()).day
        }
        return nil
    }
    
    var dateOfNextNotification: Date? = nil
    var notificationWasTriggered: Bool {
        if let dateOfNextNotification = dateOfNextNotification {
            return dateOfNextNotification < Date()
        }
        return false
    }
    
    static let defaultImageNames: [String] = {
        var a = [String]()
        for i in 1...5 {
            a.append("default-plant-image-\(i)")
        }
        return a
    }()
    
    var idForForEach = UUID().uuidString
    
    init() {
        self.name = ""
        self.id = UUID().uuidString
        self.randomImageIndex = 1
    }
    
    init(name: String) {
        self.name = name
        self.id = UUID().uuidString
        self.randomImageIndex = 1
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.randomImageIndex = 1
    }
    
    init(id: String, name: String, imageName: String?, dateLastWatered: Date?,
         dateOfNextNotification: Date?, randomImageIndex: Int) {
        self.init(id: id, name: name)
        self.imageName = imageName
        self.dateLastWatered = dateLastWatered
        self.dateOfNextNotification = dateOfNextNotification
        self.randomImageIndex = randomImageIndex
    }
    
    
    func deletePlantImageFile() {
        if let imageName = imageName {
            deleteFileInBackground(at: getDocumentsDirectory().appendingPathComponent(imageName))
        }
    }
    
    
    func loadPlantImage() -> Image {
        if let imageName = self.imageName {
            let fileName = getDocumentsDirectory().appendingPathComponent(imageName)
            if let imageData = try? Data(contentsOf: fileName) {
                if let uiImage = UIImage(data: imageData) {
                    return Image(uiImage: uiImage)
                }
            }
        }
        return Image(PlantWatch.defaultImageNames[self.randomImageIndex])
    }
    
    mutating func water() {
        self.dateLastWatered = Date()
        dateOfNextNotification = nil
    }
}

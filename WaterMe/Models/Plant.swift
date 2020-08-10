//
//  Plant.swift
//  WaterMe
//
//  Created by Joshua on 7/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

enum PlantVersion: Int, Codable {
    case one = 1
}


struct Plant: Identifiable, Codable {
    
    let version: PlantVersion = .one
    let id: String

    static let defaultImageNames: [String] = {
        var a = [String]()
        for i in 1...5 {
            a.append("default-plant-image-\(i)")
        }
        return a
    }()
    
    private let randomImageIndex: Int = (0..<Plant.defaultImageNames.count).randomElement()!
    
    var name = ""
    private var imageName: String? = nil
    
    var datesWatered = [Date]() {
        didSet {
            datesWatered.sort()
        }
    }
    
    var wasWateredToday: Bool {
        if let date = dateLastWatered {
            return Calendar.current.isDate(date, inSameDayAs: Date())
        }
        return false
    }
    
    var dateLastWatered: Date? {
        get {
            datesWatered.max()
        }
    }
    
    var daysSinceLastWatering: Int? {
        if let date = dateLastWatered {
            return Calendar.current.dateComponents([.day], from: date, to: Date()).day
        }
        return nil
    }
    
    var formattedDaysSinceLastWatering: String {
        if wasWateredToday {
            return "Today"
        } else if daysSinceLastWatering == 1 {
            return "Yesterday"
        } else if let days = daysSinceLastWatering {
            return "\(days) days"
        }
        return "Never"
    }
    
    var formattedDateLastWatered: String {
        if let dateLastWatered = self.dateLastWatered {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd"
            return formatter.string(from: dateLastWatered)
        }
        return "Never"
    }
    
    
    /// The watering notification.
    var wateringNotification: WaterNotification? = nil
    
    
    init() {
        id = UUID().uuidString
    }
    
    init(name: String, datesWatered: [Date]) {
        id = UUID().uuidString
        self.name = name
        self.datesWatered = datesWatered
    }
    
    init(name: String) {
        id = UUID().uuidString
        self.name = name
    }
    
    
    mutating func changeDateLastWatered(to newDate: Date) {
        self.datesWatered = datesWatered.filter({ $0 < newDate })
        addNewDateLastWatered(to: newDate)
    }
    
    
    mutating func addNewDateLastWatered(to newDate: Date) {
        let sameDates = datesWatered.filter({ Calendar.current.isDate($0, inSameDayAs: newDate) })
        if sameDates.count == 0 {
            datesWatered.append(newDate)
            datesWatered.sort()
        }
    }
    
    mutating func water() {
        addNewDateLastWatered(to: Date())
        scheduleNotification()
    }
    
    
    mutating func savePlantImage(uiImage: UIImage) {
        if let data = uiImage.jpegData(compressionQuality: 1.0) {
            let oldImageName = self.imageName
            imageName = "\(UUID().uuidString)_image.jpeg"
            let fileName = getDocumentsDirectory().appendingPathComponent(imageName!)
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try data.write(to: fileName)
                } catch {
                    print("Unable to save image file.")
                }
            }
            
            if let oldImageName = oldImageName {
                deleteFile(at: getDocumentsDirectory().appendingPathComponent(oldImageName))
            }
        }
    }
    
    
    func deletePlantImageFile() {
        if let imageName = imageName {
            deleteFile(at: getDocumentsDirectory().appendingPathComponent(imageName))
        }
    }
    
    
    private func deleteFile(at URL: URL) {
        DispatchQueue.global(qos: .background).async {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                print("Unable to delete old image file: \(URL.absoluteString).")
            }
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
        return Image(Plant.defaultImageNames[self.randomImageIndex])
    }
    
    
    /// Calculates the frequency of watering for a plant in days per watering.
    /// - Returns: The average number of days between waterings (kind of).
    func calculateFrequencyOfWatering() -> Float {
        if datesWatered.count == 0 {
            return 0
        }
        let totalInterval = Calendar.current.dateComponents([.day], from: datesWatered.first!, to: Date())
        if let days = totalInterval.day {
            return Float(days) / Float(datesWatered.count)
        } else {
            return 0
        }
    }
    
    
    
}



// Watering Notifications

extension Plant {
    /// Schedule a watering notification based off of the `wateringNotification` property.
    func scheduleNotification() {
        if let notification = wateringNotification {
            print("Schedule notification for plant \(name)")
            notification.scheduleNotificationFor(self)
        }
    }
}

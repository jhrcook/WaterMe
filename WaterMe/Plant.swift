//
//  Plant.swift
//  WaterMe
//
//  Created by Joshua on 7/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct Plant: Identifiable, Codable {
    
    let id = UUID()

    static let defaultImageNames: [String] = {
        var a = [String]()
        for i in 1...5 {
            a.append("default-plant-image-\(i)")
        }
        return a
    }()
    
    private let randomImageIndex: Int = (0..<Plant.defaultImageNames.count).randomElement()!
    
    var name = ""
    var imageName: String? = nil
    
    var datesWatered = [Date]() {
        didSet {
            datesWatered.sort()
        }
    }
    
    var dateLastWatered: Date {
        return datesWatered.last ?? Date()
    }
    
    var formattedDateLastWatered: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter.string(from: dateLastWatered)
    }
    
    
    mutating func changeDateLastWatered(to newDate: Date) {
        self.datesWatered = datesWatered.filter({ $0 < newDate })
        addNewDateLastWatered(to: newDate)
    }
    
    mutating func addNewDateLastWatered(to newDate: Date) {
        if (!datesWatered.contains(newDate)) {
            datesWatered.append(newDate)
        }
    }
    
    mutating func savePlantImage(uiImage: UIImage) {
//        if let data = uiImage.pngData() {
        if let data = uiImage.jpegData(compressionQuality: 0.7) {
            let imageName = "\(self.id.uuidString)_image.jpeg"
            let fileName = getDocumentsDirectory().appendingPathComponent(imageName)
            do {
                try data.write(to: fileName)
                self.imageName = imageName
            } catch {
                print("Unable to save image file.")
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
}

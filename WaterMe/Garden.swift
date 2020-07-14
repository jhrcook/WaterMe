//
//  Garden.swift
//  WaterMe
//
//  Created by Joshua on 7/8/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

enum GardenVersion: Int, Codable {
    case one = 1
}

class Garden: ObservableObject {
    
    let version: GardenVersion = .one
    
    static private let plantsArrayKey = "plants"
    static private let inTesting = true
    
    @Published var plants = [Plant]() {
        didSet {
            savePlants()
        }
    }
    
    var numberOfPlants: Int {
        return plants.count
    }
    
    
    init() {
        
        if (Garden.inTesting) {
            print("Making mock plants for testing.")
            self.plants = mockPlants()
            return
        }
        
        if let encodedPlants = UserDefaults.standard.data(forKey: Garden.plantsArrayKey) {
            let decoder = JSONDecoder()
            if let decodedPlants = try? decoder.decode([Plant].self, from: encodedPlants) {
                self.plants = decodedPlants
                return
            }
        }
        
        print("Unable to read in plants - setting empty array.")
        self.plants = [Plant]()
    }
    
    
    /// Save plants to file.
    func savePlants() {
        print("Saving plants.")
        let encoder = JSONEncoder()
        if let encodedData  = try? encoder.encode(plants) {
            UserDefaults.standard.set(encodedData, forKey: Garden.plantsArrayKey)
        }
    }
    
    
    /// Generate fake plants.
    private func mockPlants() -> [Plant] {
        var mockPlants = [Plant]()
        for i in 0..<10 {
            mockPlants.append(
                Plant(name: "Plant \(i)", datesWatered: arrayOfDates(i))
            )
        }
        return mockPlants
    }
    
    
    private func arrayOfDates(_ n: Int) -> [Date] {
        var dates = [Date]()
        for _ in 0..<n {
            let nextDate = Calendar.current.date(byAdding: .day, value: -(1...15).randomElement()!, to: Date())
            dates.append(nextDate!)
        }
        return dates
    }
}

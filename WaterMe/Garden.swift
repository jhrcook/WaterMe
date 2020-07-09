//
//  Garden.swift
//  WaterMe
//
//  Created by Joshua on 7/8/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

class Garden: ObservableObject {
    
    static private let plantsArrayKey = "plants"
    static private let inTesting = true
    
    @Published var plants = [Plant]() {
        didSet {
            let encoder = JSONEncoder()
            if let encodedData  = try? encoder.encode(plants) {
                UserDefaults.standard.set(encodedData, forKey: Garden.plantsArrayKey)
            }
        }
    }
    
    
    var numberOfPlants: Int {
        return plants.count
    }
    
    
    init() {
        
        if (Garden.inTesting) {
            print("Making mock plants for testing.")
            self.plants = MockPlants()
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
    
    
    // Generate fake plants
    private func MockPlants() -> [Plant] {
        var mockPlants = [Plant]()
        for i in 1...10 {
            mockPlants.append(
                Plant(name: "Plant \(i)", imageName: Plant.defaultImageName, datesWatered: [Date]())
            )
        }
        return mockPlants
    }
    
}

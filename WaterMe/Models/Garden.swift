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


enum PlantOrder: String, CaseIterable {
    case alphabetically
    case lastWatered
    case frequencyOfWatering
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
    
    var ordering: PlantOrder = .alphabetically {
        didSet {
            sortPlants()
        }
    }
    
    
    init() {
        
        if (Garden.inTesting) {
            print("Making mock plants for testing.")
            self.plants = mockPlants()
            sortPlants()
            return
        }
        
        if let encodedPlants = UserDefaults.standard.data(forKey: Garden.plantsArrayKey) {
            let decoder = JSONDecoder()
            if let decodedPlants = try? decoder.decode([Plant].self, from: encodedPlants) {
                self.plants = decodedPlants
                sortPlants()
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
    
    
    func sortPlants() {
        print("sorting plants by '\(ordering.rawValue)'")
        switch ordering {
        case .alphabetically:
            sortPlantsByALphabeticalOrder()
        case .lastWatered:
            sortPlantsByDaysSinceLastWatering()
        case .frequencyOfWatering:
            sortPlantsByFrequencyOfWatering()
        }
    }
    
    
    /// Sort the plants alphabetically by their name.
    func sortPlantsByALphabeticalOrder() {
        plants = plants.sorted { $0.name < $1.name }
    }
    
    
    /// Sort plants by the number of days since their last watering.
    func sortPlantsByDaysSinceLastWatering() {
        plants = plants.sorted {
            let d1 = $0.dateLastWatered
            let d2 = $1.dateLastWatered
            if d1 == nil && d2 == nil {
                return true
            } else if d1 == nil {
                return true
            } else if d2 == nil {
                return false
            } else {
                return d1! < d2!
            }
        }
    }
    
    
    /// Sort plants by their average frequency of being watered
    func sortPlantsByFrequencyOfWatering() {
        plants = plants.sorted {
            $0.calculateFrequencyOfWatering() < $1.calculateFrequencyOfWatering()
        }
    }
    
    
    /// Generate fake plants.
    private func mockPlants() -> [Plant] {
        var mockPlants = [Plant]()
        for i in 0..<20 {
            mockPlants.append(
                Plant(name: "Plant \(i)", datesWatered: arrayOfDates(i))
            )
        }
        return mockPlants
    }
    
    
    private func arrayOfDates(_ n: Int) -> [Date] {
        var dates = [Date]()
        for _ in 0..<n {
            let nextDate = Calendar.current.date(byAdding: .day, value: -(1...15).randomElement()!, to: Date())!
            
            let sameDates = dates.filter({ Calendar.current.isDate($0, inSameDayAs: nextDate) })
            if sameDates.count == 0 {
                dates.append(nextDate)
            }
        }
        dates.sort()
        return dates
    }
    
    
    func update(_ plant: Plant) {
        let idx = self.plants.firstIndex(where: { $0.id == plant.id })!
        self.plants[idx] = plant
    }
}

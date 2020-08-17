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
    
    static private let inTesting = false
    
    @Published var plants = [Plant]() {
        didSet {
            savePlants()
        }
    }
    
    var numberOfPlants: Int {
        return plants.count
    }
    
    var ordering: PlantOrder = readOrderingMethodFromUserDefaults() {
        didSet {
            saveOrderingMethodToUserDefaults()
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
        loadPlants()
    }
    
    
    private func loadPlants() {
        if let encodedPlants = UserDefaults.standard.data(forKey: UserDefaultKeys.plantsArrayKey) {
            let decoder = JSONDecoder()
            if let decodedPlants = try? decoder.decode([Plant].self, from: encodedPlants) {
                plants = decodedPlants
                sortPlants()
                print("Loaded \(plants.count) plants.")
                return
            }
        }
        print("Unable to read in plants - setting empty array.")
    }
    
    
    func reloadPlants() {
        loadPlants()
    }
    
    
    /// Save plants to file.
    func savePlants() {
        print("Saving plants.")
        let encoder = JSONEncoder()
        if let encodedData  = try? encoder.encode(plants) {
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.plantsArrayKey)
        }
    }
    
    
    /// Sort the plants per the `ordering` value.
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
    
    
    /// Get an array of unique dates for making a mock garden.
    /// - Parameter n: The number of dates.
    /// - Returns: An array of dates.
    ///
    /// This function is used to create the plants for a mock garden.
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
    
    
    /// Update a plant in the array of plants.
    /// - Parameter plant: The plant to update.
    /// - Parameter addIfNew: If the plant is not already in the array, should it be added?
    /// - Parameter updatePlantOrder: Should the array be sorted?
    func update(_ plant: Plant, addIfNew: Bool = true, updatePlantOrder: Bool = true) {
        if let idx = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[idx] = plant
        } else if addIfNew {
            plants.append(plant)
        }
        
        if updatePlantOrder {
            sortPlants()
        }
    }
    
    /// Water a plant.
    /// - Parameter plant: The plant that gets watered
    ///
    /// Calls the `update(_ plant: Plant)` method at the end to save changes.
    func water(_ plant: Plant) {
        var newPlant = plant
        newPlant.water()
        update(newPlant)
    }
    
    
    func water(plantId: String) {
        if let plant = plants.first(where: { $0.id == plantId}) {
            water(plant)
        }
    }
    
    
    /// Load the saved `ordering` value from UserDefaults.
    /// - Returns: The saved `PlantOrder` value. If `nil`, defaults to `alphabetically`.
    private static func readOrderingMethodFromUserDefaults() -> PlantOrder {
        if let plantOrderString = UserDefaults.standard.string(forKey: UserDefaultKeys.gardenPlantOrder) {
            if let plantOrder = PlantOrder(rawValue: plantOrderString) {
                return plantOrder
            }
        }
        return .alphabetically
    }
    
    /// Save the plant ordering method to UserDefaults.
    private func saveOrderingMethodToUserDefaults() {
        UserDefaults.standard.set(ordering.rawValue, forKey: UserDefaultKeys.gardenPlantOrder)
    }
}

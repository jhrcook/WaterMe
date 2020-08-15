//
//  GardenWatch.swift
//  WaterMe
//
//  Created by Joshua on 8/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

enum GardenWatchVersion: Int, Codable {
    case one = 1
}

class GardenWatch: ObservableObject {
    
    let version = GardenWatchVersion.one
    
    @Published var plants = [PlantWatch]() {
        didSet {
            savePlants()
        }
    }
    
    
    init() {
        loadPlants()
    }
    
    private func loadPlants() {
        if let encodedPlants = UserDefaults.standard.data(forKey: UserDefaultKeys.plantsArrayKey) {
            let decoder = JSONDecoder()
            if let decodedPlants = try? decoder.decode([PlantWatch].self, from: encodedPlants) {
                self.plants = decodedPlants
                sortPlants()
                return
            }
        }
        print("Unable to read in plants - setting empty array.")
    }
    
    
    func savePlants() {
        print("Saving plants.")
        let encoder = JSONEncoder()
        if let encodedData  = try? encoder.encode(plants) {
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.plantsArrayKey)
        }
    }
    
    func reloadPlants() {
        loadPlants()
    }
    
    
    func sortPlants() {
        plants = plants.sorted {
            if $0.notificationWasTriggered && $1.notificationWasTriggered {
                return $0.name < $1.name
            } else if $0.notificationWasTriggered {
                return true
            } else if $1.notificationWasTriggered {
                return false
            } else {
                return was($0, wateredBefore: $1) ?? ($0.name < $1.name)
            }
        }
    }
    
    /// Was one plant watered before another plant?
    /// - Parameters:
    ///   - plantOne: a plant
    ///   - plantTwo: a plant
    /// - Returns: True if the first plant was watered before the second. Returns `nil` if neither plant has been watered.
    private func was(_ plantOne: PlantWatch, wateredBefore plantTwo: PlantWatch) -> Bool? {
        if let dateOne = plantOne.dateLastWatered {
            if let dateTwo = plantTwo.dateLastWatered {
                return dateOne < dateTwo
            }
            return false
        } else {
            if plantTwo.dateLastWatered != nil {
                return true
            }
        }
        return nil
    }
    
    
    func update(_ plant: PlantWatch, addIfNew: Bool = true, updatePlantOrder: Bool = true) {
        if let idx = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[idx] = plant
        } else if addIfNew {
            plants.append(plant)
        }
        
        if updatePlantOrder {
            sortPlants()
        }
    }
    
    
    func water(_ plant: PlantWatch) {
        var newPlant = plant
        newPlant.water()
        update(newPlant)
    }
    
    
    func delete(plantIds: [String]) {
        for id in plantIds {
            if let plant = plants.first(where: { $0.id == id }) {
                plant.deletePlantImageFile()
            }
        }
        plants = plants.filter { !plantIds.contains($0.id) }
        sortPlants()
    }
    
    
    func deleteAllPlants() {
        for plant in plants {
            plant.deletePlantImageFile()
        }
        plants = []
    }
}

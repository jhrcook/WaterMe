//
//  SwiftUIView.swift
//  WaterMeWatchApp Extension
//
//  Created by Joshua on 8/1/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct GardenListView: View {
    
    @ObservedObject var garden: GardenWatch
    var phoneCommunicator: WatchToPhoneCommunicator
    
    var body: some View {
        GeometryReader { geo in
            List {
                ForEach(self.garden.plants) { plant in
                    PlantRowView(garden: self.garden, plant: plant, phoneCommunicator: self.phoneCommunicator, outerGeo: geo)
                        .frame(height: 80)
                        .buttonStyle(PlainButtonStyle())
                }
                .listRowBackground(Color.clear)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct GardenListView_Previews: PreviewProvider {
    static var previews: some View {
        let garden = GardenWatch()
        garden.plants = []
        var plant = PlantWatch(name: "Plant one")
        plant.dateLastWatered = Date()
        garden.plants.append(plant)
        
        plant = PlantWatch(name: "Plant two")
        plant.dateLastWatered = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        garden.plants.append(plant)
        
        garden.plants.append(PlantWatch(name: "Plant three"))
        
        return GardenListView(garden: garden, phoneCommunicator: WatchToPhoneCommunicator())
    }
}

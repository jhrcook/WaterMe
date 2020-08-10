//
//  SwiftUIView.swift
//  WaterMeWatchApp Extension
//
//  Created by Joshua on 8/1/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct GardenListView: View {
    
    @ObservedObject var garden: Garden
    
    var body: some View {
        GeometryReader { geo in
            List {
                ForEach(self.garden.plants) { plant in
                    PlantRowView(garden: self.garden, plant: plant, outerGeo: geo)
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
        let garden = Garden()
        garden.plants = []
        var plant = Plant(name: "Plant one")
        plant.addNewDateLastWatered(to: Date())
        garden.plants.append(plant)
        
        plant = Plant(name: "Plant two")
        plant.addNewDateLastWatered(to: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)
        garden.plants.append(plant)
        
        garden.plants.append(Plant(name: "Plant three"))
        
        return GardenListView(garden: garden)
    }
}

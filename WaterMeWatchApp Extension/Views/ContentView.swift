//
//  ContentView.swift
//  WaterMeWatchApp Extension
//
//  Created by Joshua on 7/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var garden = GardenWatch()
    
    var body: some View {
        GardenListView(garden: garden)
            .onAppear {
                self.garden.plants = []
                self.garden.plants.append(PlantWatch(name: "Plant one"))
                self.garden.plants.append(PlantWatch(name: "Plant two"))
                self.garden.plants.append(PlantWatch(name: "Plant three"))
                self.garden.plants.append(PlantWatch(name: "Plant four"))
                self.garden.plants.append(PlantWatch(name: "Plant five"))
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

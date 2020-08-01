//
//  SwiftUIView.swift
//  WaterMeWatchApp Extension
//
//  Created by Joshua on 8/1/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI



struct PlantRowView: View {
    
    @ObservedObject var garden: Garden
    var plant: Plant
    
    @State private var showWaterMeButton = true
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                ZStack {
                    self.plant.loadPlantImage()
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 65)
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "bell.fill")
                                .padding(EdgeInsets(top: 0, leading: 1, bottom: 8, trailing: 10))
                                .foregroundColor(.blue)
                                .opacity(self.plant.wateringNotification?.notificationTriggered ?? false ? 1 : 0)
                            Spacer()
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text(self.plant.name)
                        .font(.headline)
                    Text(self.plant.formattedDaysSinceLastWatering)
                        .font(.caption)
                }
                .frame(width: geo.size.width * 7/12)
            }
        }
    }
}


struct GardenListView: View {
    
    @ObservedObject var garden: Garden
    
    var body: some View {
        List {
            ForEach(garden.plants) { plant in
                NavigationLink(destination: Text("Hi")) {
                    PlantRowView(garden: self.garden, plant: plant)
                        .frame(height: 80)
                }
            }
        }
    }
}

struct GardenListView_Previews: PreviewProvider {
    static var previews: some View {
        let garden = Garden()
        garden.plants = []
        garden.plants.append(Plant(name: "Plant one"))
        garden.plants.append(Plant(name: "Plant two"))
        garden.plants.append(Plant(name: "Plant three"))
        return GardenListView(garden: garden)
    }
}

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
    
    @State private var showWaterMeButton = false
    
    var body: some View {
        
        ZStack {
            HStack(alignment: .center, spacing: 10) {
                
//                Spacer(minLength: 5)
                
                Button(action: {
                    self.showWaterMeButton.toggle()
                }) {
                    Image(systemName: "cloud.rain").font(.system(size: 30))
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .foregroundColor(.blue)
                        )
                }
                .padding()
                .disabled(!showWaterMeButton)
                
//                Spacer(minLength: 30)
                
                Button(action: {
                    self.showWaterMeButton.toggle()
                }) {
                    Image(systemName: "plus").font(.system(size: 30))
                        .rotationEffect(.degrees(45))
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .foregroundColor(.red)
                        )
                }
                .padding()
                .disabled(!showWaterMeButton)
                
//                Spacer(minLength: 5)
                
            }
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .opacity(showWaterMeButton ? 1 : 0)
            
            Button(action: {
                self.showWaterMeButton.toggle()
            }) {
                HStack {
                    plant.loadPlantImage()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .clipShape(Circle())
                    Spacer()
                    Text(plant.name)
                    Spacer()
                }
            }
            .disabled(showWaterMeButton)
            .opacity(showWaterMeButton ? 0 : 1)
        }
        .rotation3DEffect(showWaterMeButton ? .degrees(180) : .degrees(0), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut)
    }
}


struct GardenListView: View {
    
    @ObservedObject var garden: Garden
    
    var body: some View {
        List {
            ForEach(garden.plants) { plant in
                PlantRowView(garden: self.garden, plant: plant)
                    .padding(.vertical, 10)
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

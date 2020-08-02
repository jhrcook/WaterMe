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
    var outerGeo: GeometryProxy
    
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
                .padding(.horizontal, 5)
                
                VStack(alignment: .leading) {
                    Text(self.plant.name)
                        .font(.headline)
                    Text(self.plant.formattedDaysSinceLastWatering)
                        .font(.caption)
                }
                .frame(width: geo.size.width * 7/12)
            }
            .background(Color.mySystemGrey6)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .scaleEffect(self.calculateScaleSizeBasedOnFrameLocation(geo: geo))
        }
    }
    
    func calculateScaleSizeBasedOnFrameLocation(geo: GeometryProxy) -> CGFloat {
        
        let topY: CGFloat = outerGeo.frame(in: .global).minY
        let bottomY = outerGeo.frame(in: .global).maxY
        
        let effectRangePercent: CGFloat = 0.2
        let topRange = topY + (bottomY - topY) * effectRangePercent
        let bottomRange = bottomY - topRange
        
        let midY = geo.frame(in: .global).midY
        
        if plant.name == "Plant one" {
            print("bottomY: \(bottomY), bottomRange: \(bottomRange), topY: \(topY), topRange: \(topRange)")
            print("local midY: \(geo.frame(in: .local).midY), global midY: \(geo.frame(in: .global).midY), midY: \(midY)")
        }
        
        
        if midY > topRange && midY < bottomRange {
            if plant.name == "Plant one" {
                print("scaled to: 1")
            }
            return 1
        }
        
        if midY < topRange {
            let s = map(midY, fromMin: topY, fromMax: topRange)
            if plant.name == "Plant one" {
                print("scaled to: \(s)")
            }
            return s
        } else {
            let s = map(midY, fromMin: bottomRange, fromMax: bottomY, toMin: 1.0, toMax: 0.85)
            if plant.name == "Plant one" {
                print("scaled to: \(s)")
            }
            return s
        }
    }
    
    func map(_ x: CGFloat, fromMin: CGFloat, fromMax: CGFloat, toMin: CGFloat = 0.8, toMax: CGFloat = 1) -> CGFloat {
        return (x - fromMin) * (toMax - toMin) / (fromMax - fromMin) + toMin
    }
    
}


struct GardenListView: View {
    
    @ObservedObject var garden: Garden
    
    var body: some View {
        GeometryReader { geo in
            List {
                ForEach(self.garden.plants) { plant in
                    NavigationLink(destination: Text("Hi")) {
                        PlantRowView(garden: self.garden, plant: plant, outerGeo: geo)
                            .frame(height: 80)
                    }
                }
                .listRowPlatterColor(.clear)
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
        garden.plants.append(Plant(name: "Plant one"))
        garden.plants.append(Plant(name: "Plant two"))
        garden.plants.append(Plant(name: "Plant three"))
        return GardenListView(garden: garden)
    }
}

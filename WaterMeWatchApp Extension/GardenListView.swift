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
            .opacity(Double(self.calculateScaleSizeBasedOnFrameLocation(geo: geo)))
        }
    }
    
    func calculateScaleSizeBasedOnFrameLocation(geo: GeometryProxy) -> CGFloat {
        
        let topY: CGFloat = outerGeo.frame(in: .global).minY
        let bottomY = outerGeo.frame(in: .global).maxY
        
        let effectRangePercent: CGFloat = 0.2
        let topRange = topY + (bottomY - topY) * effectRangePercent
        let bottomRange = bottomY - topRange
        
        let midY = geo.frame(in: .global).midY
        
        if midY > topRange && midY < bottomRange {
            return 1
        } else if midY < topRange {
            return map(midY, fromMin: topY, fromMax: topRange)
        } else {
            return map(midY, fromMin: bottomRange, fromMax: bottomY, toMin: 1.0, toMax: 0.85)
        }
    }
    
    
    /// A copy of the Arduino `map()` function.
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

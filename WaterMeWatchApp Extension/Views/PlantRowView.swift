//
//  PlantRowView.swift
//  WaterMeWatchApp Extension
//
//  Created by Joshua on 8/2/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct BackOfPlantRowButton: View {
    var imageSystemName: String
    var backgroundColor: Color
    var geo: GeometryProxy
    var rotateImage: Double = 0
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageSystemName)
                .font(.system(size: 30))
                .rotationEffect(.degrees(rotateImage))
        }
        .padding()
        .frame(width: geo.size.width / 2 - 10, height: geo.size.height - 20)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}


struct PlantRowView: View {
    
    @ObservedObject var garden: Garden
    var plant: Plant
    var outerGeo: GeometryProxy
    
    @State private var showWaterMeButton = false
    
    var formattedDaysSinceLastWatering: String {
        if plant.wasWateredToday {
            return "Today"
        } else if plant.daysSinceLastWatering == 1 {
            return "Yesterday"
        } else if let days = plant.daysSinceLastWatering {
            return "\(days) days ago"
        }
        return "Never watered"
    }
    
    let rotationAnimation = Animation.easeInOut(duration: 0.3)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                HStack {
                    
                    Spacer()
                    
                    BackOfPlantRowButton(imageSystemName: "cloud.rain", backgroundColor: .blue, geo: geo) {
                        print("tap button 1")
                        withAnimation(self.rotationAnimation) {
                            self.showWaterMeButton.toggle()
                        }
                    }
                    
                    Spacer()
                    
                    BackOfPlantRowButton(imageSystemName: "plus", backgroundColor: .red, geo: geo, rotateImage: 45) {
                        print("tap button 2")
                        withAnimation(self.rotationAnimation) {
                            self.showWaterMeButton.toggle()
                        }
                    }
                    
                    Spacer()
                    
                }
                .opacity(!self.showWaterMeButton ? 0 : Double(self.calculateScaleSizeBasedOnFrameLocation(geo: geo)))
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                
                
                
                HStack(spacing: 0) {
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
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                    
                    VStack(alignment: .center) {
                        Text(self.plant.name)
                            .font(.headline)
                            .padding(.vertical, 5)
                        Text(self.formattedDaysSinceLastWatering)
                            .font(.footnote)
                    }
                    .padding(.horizontal, 3)
                    .frame(width: geo.size.width * 8/12)
                }
                .onTapGesture {
                    print("tap front")
                    withAnimation(self.rotationAnimation) {
                        self.showWaterMeButton.toggle()
                    }
                }
                .opacity(self.showWaterMeButton ? 0 : Double(self.calculateScaleSizeBasedOnFrameLocation(geo: geo)))
            }
            .background(Color.mySystemGrey5)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(self.calculateScaleSizeBasedOnFrameLocation(geo: geo))
            .rotation3DEffect(self.showWaterMeButton ? .degrees(180) : .degrees(0), axis: (x: 0, y: 1, z: 0))
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


struct PlantRowView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            PlantRowView(garden: Garden(), plant: Plant(name: "Test plant"), outerGeo: geo)
                .previewLayout(.fixed(width: 400, height: 80))
        }
    }
}

//
//  PlantDetailView.swift
//  WaterMe
//
//  Created by Joshua on 7/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct PlantDetailView: View {
    
    @ObservedObject var garden: Garden
    var plant: Plant
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Image(plant.imageName)
                .resizable()
                .frame(height: 400)
                .edgesIgnoringSafeArea(.all)
                .scaledToFit()
                .padding(.bottom, 10)
            
            Text(plant.name)
                .font(.largeTitle)
                .padding()
            Text("Last watered on \(plant.formattedDateLastWatered)")
                .font(.title)
                .padding()
            
            Spacer()
            
            Button(action: {
                print("tap")
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .frame(width: 220, height: 70)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                    
                    HStack {
                        Image(systemName: "trash")
                        Text("Water me")
                    }
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                }
            }
            
            Spacer()
        }
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant", imageName: Plant.defaultImageName, datesWatered: [Date()]))
    }
}

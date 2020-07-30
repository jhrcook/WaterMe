//
//  PlantCellView.swift
//  WaterMe
//
//  Created by Joshua on 7/15/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct PlantCellTextBackgroundView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .foregroundColor(Color(UIColor.systemBackground))
            .opacity(0.5)
            .shadow(color: Color.black.opacity(0.6), radius: 4, x: 2, y: 2)
    }
}


struct PlantCellView: View {
    
    var plant: Plant
    
    @Binding var multiselectMode: Bool
    var isSelected: Bool
    
    var foregroundColor: Color {
        if plant.wateringNotification == nil || self.multiselectMode {
            return .clear
        } else {
            return .white
        }
    }
    
    var notificationImageName: String {
        plant.wateringNotification!.notificationTriggered ? "bell.fill" : "bell"
    }
    
    var body: some View {
        GeometryReader {  geo in
            ZStack {
                self.plant.loadPlantImage()
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.width, alignment: .center)
                
                HStack{
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text(self.plant.name)
                            .font(.headline)
                            .padding(.horizontal, 3)
                            .background(PlantCellTextBackgroundView())
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))

                        Text(self.plant.formattedDaysSinceLastWatering)
                            .font(.body)
                            .padding(.horizontal, 3)
                            .background(PlantCellTextBackgroundView())
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        
                        Spacer()
                        
                        Image(systemName: self.notificationImageName)
                            .font(.footnote)
                            .foregroundColor(self.foregroundColor)
                            .opacity(0.6)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 7, trailing: 0))
                    }
                    Spacer()
                }
                
                if self.multiselectMode {
                    Color.white.opacity(0.5)
                    Image(systemName: self.isSelected ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(self.isSelected ? .blue : .white)
                        .padding()
                        .background(
                            Image(systemName: "checkmark.circle")
                                .font(.largeTitle)
                                .foregroundColor(self.isSelected ? .white : .clear)
                                .padding()
                        )
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct PlantCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlantCellView(plant: Plant(name: "Test plant"), multiselectMode: .constant(false), isSelected: false)
                .frame(width: 150, height: 150)
                .padding()
                .previewLayout(.sizeThatFits)
            
            PlantCellView(plant: Plant(name: "Test plant"), multiselectMode: .constant(true), isSelected: false)
                .frame(width: 150, height: 150)
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("multi-select mode")
            
            PlantCellView(plant: Plant(name: "Test plant"), multiselectMode: .constant(true), isSelected: true)
                .frame(width: 150, height: 150)
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("multi-select mode; selected")
            
            PlantCellView(plant: Plant(name: "Test plant"), multiselectMode: .constant(true), isSelected: false)
                .frame(width: 150, height: 150)
                .padding()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("dark; multi-select mode")
            
            PlantCellView(plant: Plant(name: "Test plant"), multiselectMode: .constant(true), isSelected: true)
                .frame(width: 150, height: 150)
                .padding()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("dark; multi-select mode; selected")
        }
    }
}

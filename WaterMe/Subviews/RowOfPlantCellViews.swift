//
//  RowOfPlantCellViews.swift
//  WaterMe
//
//  Created by Joshua on 7/15/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct RowOfPlantCellViews: View {
    
    @ObservedObject var garden: Garden
    var rowIndex: Int
    let numberOfPlantsPerRow: Int
    
    var plants: [Plant] {
        plantsFor(row: rowIndex)
    }
    
    @State private var selectedPlant = Plant()
    @State private var showPlantInformation = false
    
    @Binding var multiselectMode: Bool
    @Binding var multiselectedPlants: [Plant]
    
    var cellSpacing: CGFloat = 0
    
    @State private var angleOfHiddenImage: Double = 90
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(systemName: "trash").opacity(0).rotationEffect(.degrees(self.angleOfHiddenImage))
                HStack(spacing: self.cellSpacing) {
                    Spacer(minLength: 0.0)
                    ForEach(self.plants) { plant in
                        Button(action: {}) {
                            PlantCellView(plant: plant, multiselectMode: self.$multiselectMode, isSelected: self.multiselectedPlants.contains(where: {$0.id == plant.id}))
                                .frame(width: self.calculateCellWidth(from: geo.size.width, withCellSpacing: self.cellSpacing), height: geo.size.height)
                                .onTapGesture {
                                    if self.multiselectMode {
                                        if self.multiselectedPlants.contains(where: { $0.id == plant.id }) {
                                            self.multiselectedPlants.removeAll(where: { $0.id == plant.id })
                                        } else {
                                            self.multiselectedPlants.append(plant)
                                        }
                                    } else {
                                        self.selectedPlant = plant
                                        self.showPlantInformation.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    if UserDefaults.standard.bool(forKey: UserDefaultKeys.allowLongPressWatering) {
                                        self.garden.water(plant)
                                        self.pointlessAnimationToUpdateView()
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Spacer(minLength: 0.0)
                }
            }
        }
        .sheet(isPresented: $showPlantInformation) {
            PlantDetailView(garden: self.garden, plant: self.selectedPlant)
        }
    }
    
    func pointlessAnimationToUpdateView() {
        self.angleOfHiddenImage += 90
    }
    
    
    func calculateCellWidth(from totalWidth: CGFloat, withCellSpacing cellSpacing: CGFloat) -> CGFloat {
        var x: CGFloat = totalWidth / CGFloat(self.numberOfPlantsPerRow)
        x -= (cellSpacing * (CGFloat(self.numberOfPlantsPerRow) - 1))
        return x
    }
    
    
    func plantsFor(row rowIndex: Int) -> [Plant] {
        var plantsForRow = [Plant]()
        let start = rowIndex * numberOfPlantsPerRow
        
        var numberOfRowsTotal = Double(garden.numberOfPlants) / Double(self.numberOfPlantsPerRow)
        numberOfRowsTotal.round(.up)
        
        if rowIndex < Int(numberOfRowsTotal)-1 {
            plantsForRow = Array(garden.plants[start..<start + numberOfPlantsPerRow])
        } else if start <= garden.plants.count {
            plantsForRow = Array(garden.plants[start..<garden.plants.count])
        }
        
        return plantsForRow
    }
}



struct RowOfPlantCellViews_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            RowOfPlantCellViews(garden: Garden(), rowIndex: 0, numberOfPlantsPerRow: 3, multiselectMode: .constant(false), multiselectedPlants: .constant([Plant]()), cellSpacing: 5)
                .frame(width: 400, height: 125)
                .padding()
                .previewLayout(.sizeThatFits)
            
            RowOfPlantCellViews(garden: Garden(), rowIndex: 0, numberOfPlantsPerRow: 3, multiselectMode: .constant(true), multiselectedPlants: .constant([Plant]()), cellSpacing: 5)
                .frame(width: 400, height: 125)
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("multi-select mode")
        }
    }
}

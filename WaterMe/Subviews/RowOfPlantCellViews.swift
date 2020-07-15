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
    
    var cellSpacing: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: self.cellSpacing) {
                Spacer(minLength: 0.0)
                ForEach(self.plants) { plant in
                    Button(action: {
                        self.selectedPlant = plant
                        self.showPlantInformation.toggle()
                    }) {
                        PlantCellView(plant: plant)
                            .frame(width: self.calculateCellWidth(from: geo.size.width, withCellSpacing: self.cellSpacing), height: geo.size.height)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer(minLength: 0.0)
            }
        }
        .sheet(isPresented: $showPlantInformation) {
            PlantDetailView(garden: self.garden, plant: self.selectedPlant)
        }
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
        RowOfPlantCellViews(garden: Garden(), rowIndex: 0, numberOfPlantsPerRow: 3, cellSpacing: 5)
            .frame(width: 400, height: 125)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

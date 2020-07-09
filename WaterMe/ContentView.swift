//
//  ContentView.swift
//  WaterMe
//
//  Created by Joshua on 7/8/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct PlantCellView: View {
    
    var plant: Plant
    
    var body: some View {
        ZStack {
            Image(plant.imageName)
            VStack(alignment: .leading, spacing: 10) {
                Text(plant.name)
                Text(plant.formattedDateLastWatered)
            }
        }
    }
}


struct RowOfPlantCellViews: View {
    
    var plants: [Plant]
    
    var body: some View {
        HStack {
            ForEach(plants) { plant in
                PlantCellView(plant: plant)
            }
        }
    }
}


struct ContentView: View {
    
    @State private var showNewPlantView = false
    @ObservedObject var garden = Garden()
    
    let numberOfPlantsPerRow: Int = 3
    private var numberOfRows: Int {
        let x: Double = Double(garden.numberOfPlants) / Double(self.numberOfPlantsPerRow)
        return Int(x.rounded(.up))
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                        /// TODO: put the following logic into a function and pass it the row index.
//                        var plantsForRow = [Plant]()
//                        if rowIndex < numberOfRows-1 {
//                            plantsForRow = garden.plants[0..<3]
//                        } else {
//                            plantsForRow = garden.plants[0..<3]
//                        }
                        Text("hi")
//                        return RowOfPlantCellViews(plants: plantsForRow)
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        BigGreenFloatingButton {
                            self.showNewPlantView.toggle()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showNewPlantView) {
            MakeNewPlantView(garden: self.garden)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
                .resizable()
                .scaledToFit()
            HStack{
                VStack(alignment: .leading, spacing: 5) {
                    Text(plant.name)
                        .padding(.leading, 5)
                        .font(.headline)
                    Text(plant.formattedDateLastWatered)
                        .padding(.leading, 5)
                        .font(.body)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}


struct RowOfPlantCellViews: View {
    
    @ObservedObject var garden: Garden
    var rowIndex: Int
    let numberOfPlantsPerRow: Int
    var numberOfRowsTotal: Int {
        get{
            let x: Double = Double(garden.numberOfPlants) / Double(self.numberOfPlantsPerRow)
            return Int(x.rounded(.up))
        }
    }
    
    var plants: [Plant] {
        plantsFor(row: rowIndex)
    }
    
    @State private var selectedPlant = Plant()
    @State private var showPlantInformation = false
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(self.plants) { plant in
                Button(action: {
                    self.selectedPlant = plant
                    self.showPlantInformation.toggle()
                }) {
                    PlantCellView(plant: plant)
                }
            .buttonStyle(PlainButtonStyle())
            }
        }
        .sheet(isPresented: $showPlantInformation) {
            PlantDetailView(garden: self.garden, plant: self.selectedPlant)
        }
    }
    
    func plantsFor(row rowIndex: Int) -> [Plant] {
        var plantsForRow = [Plant]()
        let start = rowIndex * numberOfPlantsPerRow
        
        if rowIndex < numberOfRowsTotal-1 {
            plantsForRow = Array(garden.plants[start..<start + numberOfPlantsPerRow])
        } else if start <= garden.plants.count {
            plantsForRow = Array(garden.plants[start..<garden.plants.count])
        }
        
        return plantsForRow
    }
}


struct ContentView: View {
    
    @State private var showNewPlantView = false
    @ObservedObject var garden = Garden()
    
    let numberOfPlantsPerRow: Int = 3
    private var numberOfRows: Int {
        get{
            let x: Double = Double(garden.numberOfPlants) / Double(self.numberOfPlantsPerRow)
            return Int(x.rounded(.up))
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(0..<self.numberOfRows, id: \.self) { rowIndex in
                        RowOfPlantCellViews(garden: self.garden, rowIndex: rowIndex, numberOfPlantsPerRow: self.numberOfPlantsPerRow)
                            .listRowInsets(EdgeInsets())
                            .padding(.bottom, 2)
                    }
                }
                .listStyle(PlainListStyle())
                
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
            .navigationBarTitle("Plants", displayMode: .automatic)
        }
        .sheet(isPresented: $showNewPlantView) {
            MakeNewPlantView(garden: self.garden)
        }
        .onAppear {
            print("There are \(self.garden.plants.count) plants in `garden`.")
            UITableView.appearance().separatorStyle = .none
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

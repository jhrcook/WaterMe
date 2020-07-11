//
//  ContentView.swift
//  WaterMe
//
//  Created by Joshua on 7/8/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


fileprivate let cellSpacing: CGFloat = 5


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
    
    var body: some View {
        ZStack {
            Image(plant.imageName)
                .resizable()
                .scaledToFit()
            HStack{
                VStack(alignment: .leading, spacing: 5) {
                    Text(plant.name)
                        .font(.headline)
                        .padding(.horizontal, 3)
                        .background(PlantCellTextBackgroundView())
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
                    Text(plant.formattedDateLastWatered)
                        .font(.body)
                        .padding(.horizontal, 3)
                        .background(PlantCellTextBackgroundView())
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    Spacer()
                }
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
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
        HStack(spacing: cellSpacing) {
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
                            .padding(.bottom, cellSpacing)
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
        Group {
            ContentView()
                .previewDevice(PreviewDevice(stringLiteral: "iPhone 11"))
                .previewDisplayName("iPhone 11")
            
            ContentView()
                .previewDevice(PreviewDevice(stringLiteral: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE")
            
            ContentView()
                .previewDevice(PreviewDevice(stringLiteral: "iPhone 11"))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("iPhone 11 (dark mode)")
            
            ContentView()
                .previewDevice(PreviewDevice(stringLiteral: "iPhone SE (2nd generation)"))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("iPhone SE (dark mode)")
            
            ContentView()
                .previewDevice(PreviewDevice(stringLiteral: "iPhone 11"))
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("iPhone 11 (large text)")
            
            ContentView()
                .previewDevice(PreviewDevice(stringLiteral: "iPhone SE (2nd generation)"))
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("iPhone SE (large text)")
        }
    }
}

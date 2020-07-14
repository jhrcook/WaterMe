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
                        Text(self.plant.formattedDateLastWatered)
                            .font(.body)
                            .padding(.horizontal, 3)
                            .background(PlantCellTextBackgroundView())
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct RowOfPlantCellViews: View {
    
    @ObservedObject var garden: Garden
    var rowIndex: Int
    let numberOfPlantsPerRow: Int
    
    var plants: [Plant] {
        plantsFor(row: rowIndex)
    }
    
    @State private var selectedPlant = Plant()
    @State private var showPlantInformation = false
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: cellSpacing) {
                Spacer(minLength: 0.0)
                ForEach(self.plants) { plant in
                    Button(action: {
                        self.selectedPlant = plant
                        self.showPlantInformation.toggle()
                    }) {
                        PlantCellView(plant: plant)
                            .frame(width: self.calculateCellWidth(from: geo.size.width, withCellSpacing: cellSpacing), height: geo.size.height)
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


struct ContentView: View {
    
    @State private var showNewPlantView = false
    @ObservedObject var garden = Garden()
    
    @Environment(\.colorScheme) var colorScheme
    
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
                GeometryReader { geo in
                    ScrollView(.vertical) {
                        VStack(spacing: cellSpacing) {
                            ForEach(0..<self.numberOfRows, id: \.self) { rowIndex in
                                RowOfPlantCellViews(garden: self.garden, rowIndex: rowIndex, numberOfPlantsPerRow: self.numberOfPlantsPerRow)
                                    .frame(width: geo.size.width, height: self.calculateHeightForCell(from: geo.size.width, withCellSpacing: cellSpacing))
                            }
                        }
                    }.frame(maxHeight: .infinity)
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
            .navigationBarTitle("Plants", displayMode: .automatic)
            .navigationBarItems(trailing:
                Button(action: { print("tap water button") }) {
                    HStack {
                        Image(systemName: "cloud.rain")
                        Text("Water")
                    }
                }
                .buttonStyle(SmallFloatingTextButtonStyle(cornerRadius: 8, colorScheme: colorScheme))
            )
        }
        .sheet(isPresented: $showNewPlantView) {
            MakeNewPlantView(garden: self.garden)
        }
        .onAppear {
            print("There are \(self.garden.plants.count) plants in `garden`.")
            UITableView.appearance().separatorStyle = .none
        }
    }
    
    
    func calculateHeightForCell(from totalHeight: CGFloat, withCellSpacing cellSpacing: CGFloat) -> CGFloat {
        var x: CGFloat = totalHeight / CGFloat(self.numberOfPlantsPerRow)
        x -= (CGFloat(self.numberOfPlantsPerRow - 1) * cellSpacing)
        return x
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
                .previewDevice(PreviewDevice(stringLiteral: "iPhone SE (2nd generation)"))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("iPhone SE (dark mode)")
            
//            ContentView()
//                .previewDevice(PreviewDevice(stringLiteral: "iPhone SE (2nd generation)"))
//                .environment(\.colorScheme, .dark)
//                .previewDisplayName("iPhone SE (dark mode)")
//
//            ContentView()
//                .previewDevice(PreviewDevice(stringLiteral: "iPhone 11"))
//                .environment(\.sizeCategory, .accessibilityExtraLarge)
//                .previewDisplayName("iPhone 11 (large text)")
//
//            ContentView()
//                .previewDevice(PreviewDevice(stringLiteral: "iPhone SE (2nd generation)"))
//                .environment(\.sizeCategory, .accessibilityExtraLarge)
//                .previewDisplayName("iPhone SE (large text)")
        }
    }
}

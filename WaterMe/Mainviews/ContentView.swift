 //
//  ContentView.swift
//  WaterMe
//
//  Created by Joshua on 7/8/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

/// The spacing between cells and rows.
fileprivate let cellSpacing: CGFloat = 5


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
    
    @State private var isInMultiselectMode = false
    @State private var multiselectedPlants = [Plant]()
    
    @State private var showOrderingOptions = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.lightBlue, .lightTomato]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
                
                GeometryReader { geo in
                    ScrollView(.vertical) {
                        VStack(spacing: cellSpacing) {
                            ForEach(0..<self.numberOfRows, id: \.self) { rowIndex in
                                RowOfPlantCellViews(garden: self.garden,
                                                    rowIndex: rowIndex,
                                                    numberOfPlantsPerRow: self.numberOfPlantsPerRow,
                                                    multiselectMode: self.$isInMultiselectMode,
                                                    multiselectedPlants: self.$multiselectedPlants,
                                                    cellSpacing: cellSpacing)
                                    .frame(width: geo.size.width, height: self.calculateHeightForCell(from: geo.size.width, withCellSpacing: cellSpacing))
                            }
                        }
                    }.frame(maxHeight: .infinity)
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            PlantOrderingOptionButton(orderOption: .alphabetically, colorScheme: self.colorScheme, action: {})
                                .offset(x: self.showOrderingOptions ? 0 : 200, y: 0)
                                .animation(Animation.easeInOut(duration: 0.3).delay(0.2))

                            PlantOrderingOptionButton(orderOption: .lastWatered, colorScheme: self.colorScheme, action: {})
                                .offset(x: self.showOrderingOptions ? 0 : 200, y: 0)
                                .animation(Animation.easeInOut(duration: 0.3).delay(0.1))
                            
                            PlantOrderingOptionButton(orderOption: .frequencyOfWatering, colorScheme: self.colorScheme, action: {})
                                .offset(x: self.showOrderingOptions ? 0 : 200, y: 0)
                                .animation(.easeInOut(duration: 0.3))
                            
                            ChangePlantOrderButton(showOptions: self.$showOrderingOptions, colorScheme: self.colorScheme) {
                                self.showOrderingOptions.toggle()
                                print("button tappy tap!")
    //                            switch self.garden.ordering {
    //                            case .alphabetically:
    //                                self.garden.ordering = .lastWatered
    //                            case .lastWatered:
    //                                self.garden.ordering = .frequencyOfWatering
    //                            case .frequencyOfWatering:
    //                                self.garden.ordering = .alphabetically
    //                            }
                            }
                            .animation(.linear(duration: 0.3))
                            .offset(x: self.isInMultiselectMode ? 100 : 0, y: 0)
                        }
                        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                    }
                    
                    HStack {
                        MakeItRainButton(activated: $isInMultiselectMode) {
                            self.isInMultiselectMode.toggle()
                            if !self.isInMultiselectMode {
                                for selectedPlant in self.multiselectedPlants {
                                    for i in 0..<self.garden.plants.count {
                                        var plant = self.garden.plants[i]
                                        if selectedPlant.id == plant.id {
                                            plant.addNewDateLastWatered(to: Date())
                                            self.garden.plants[i] = plant
                                        }
                                    }
                                }
                                self.multiselectedPlants = [Plant]()
                            }
                        }
                        .padding(EdgeInsets(top: 2, leading: 6, bottom: 10, trailing: 6))
                        
                        Spacer()
                        
                        BigGreenSwitchingToRedFloatingButton(setToRed: self.$isInMultiselectMode) {
                            if self.isInMultiselectMode {
                                self.isInMultiselectMode = false
                                self.multiselectedPlants = [Plant]()
                            } else {
                                self.showNewPlantView.toggle()
                            }
                        }
                        .padding(EdgeInsets(top: 2, leading: 10, bottom: 10, trailing: 10))
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
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

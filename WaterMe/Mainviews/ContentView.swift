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
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.lightBlue, .lightTomato]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
                
                GeometryReader { geo in
                    ScrollView(.vertical) {
                        VStack(spacing: cellSpacing) {
                            ForEach(0..<self.numberOfRows, id: \.self) { rowIndex in
                                RowOfPlantCellViews(garden: self.garden, rowIndex: rowIndex, numberOfPlantsPerRow: self.numberOfPlantsPerRow, cellSpacing: cellSpacing)
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

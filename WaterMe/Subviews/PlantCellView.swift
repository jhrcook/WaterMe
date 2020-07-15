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


struct PlantCellView_Previews: PreviewProvider {
    static var previews: some View {
        PlantCellView(plant: Plant(name: "Test plant"))
            .frame(width: 150, height: 150)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

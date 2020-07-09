//
//  MakeNewPlantView.swift
//  WaterMe
//
//  Created by Joshua on 7/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct MakeNewPlantView: View {
    
    @ObservedObject var garden: Garden
    @State private var plantName = ""
    @State private var dateLastWatered = Date()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Plant name", text: $plantName)
                    DatePicker("Date last watered", selection: $dateLastWatered, displayedComponents: .date)
                }
            }
            .navigationBarTitle("New plant")
            .navigationBarItems(leading: Button("Cancel", action: {
                self.presentationMode.wrappedValue.dismiss()
            }), trailing: Button("Save") {
                let newPlant = Plant(name: self.plantName, imageName: Plant.defaultImageName, datesWatered: [self.dateLastWatered])
                self.garden.plants.append(newPlant)
                self.presentationMode.wrappedValue.dismiss()
            }.disabled(self.plantName.isEmpty))
        }
    }
}

struct MakeNewPlantView_Previews: PreviewProvider {
    static var previews: some View {
        MakeNewPlantView(garden: Garden())
    }
}

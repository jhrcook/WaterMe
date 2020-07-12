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
    
    @State private var alertIsShown = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Plant name", text: $plantName)
                    DatePicker("Date last watered", selection: $dateLastWatered, displayedComponents: .date)
                }
                
                Section {
                    Button(action: {
                        self.alertIsShown.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add image...")
                        }
                    }
                }
            }
            .navigationBarTitle("New plant")
            .navigationBarItems(leading: Button("Cancel", action: {
                self.presentationMode.wrappedValue.dismiss()
            }), trailing: Button("Save") {
                let newPlant = Plant(name: self.plantName, datesWatered: [self.dateLastWatered])
                self.garden.plants.append(newPlant)
                self.presentationMode.wrappedValue.dismiss()
            }.disabled(self.plantName.isEmpty))
                .alert(isPresented: $alertIsShown) {
                    Alert(title: Text("Feature not built, yet."), message: Text("Sad."), dismissButton: .default(Text("Okay")))
            }
        }
    }
}

struct MakeNewPlantView_Previews: PreviewProvider {
    static var previews: some View {
        MakeNewPlantView(garden: Garden())
    }
}

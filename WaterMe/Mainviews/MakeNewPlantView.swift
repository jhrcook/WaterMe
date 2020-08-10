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
    
    @State private var setDateLastWatered = true
    @State private var dateLastWatered = Date()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingImagePicker = false
    
    @State private var userSelectedImage: UIImage?
    
    var watchCommunicator: PhoneAndWatchCommunicator?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Plant name", text: $plantName)
                }
                
                Section {
                    Toggle(isOn: $setDateLastWatered.animation()) {
                        Text("Set the date last watered?")
                    }
                    
                    if setDateLastWatered {
                        DatePicker(selection: $dateLastWatered, in: ...Date(), displayedComponents: .date, label: { Text("Date last watered") })
                    }
                }
                
                Section {
                    Button(action: {
                        self.showingImagePicker.toggle()
                    }) {
                        HStack {
                            Image(systemName: userSelectedImage == nil ? "plus" : "camera.rotate")
                            Text(userSelectedImage == nil ? "Add image..." : "Change image...")
                        }
                    }
                    
                    if userSelectedImage != nil {
                        HStack {
                            Spacer()
                            Image(uiImage: userSelectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            Spacer()
                        }
                    }
                }
                
                
            }
            .navigationBarTitle("New plant")
            .navigationBarItems(leading: Button("Cancel", action: {
                self.presentationMode.wrappedValue.dismiss()
            }), trailing: Button("Save", action: savePlant)
            .disabled(self.plantName.isEmpty))
            .sheet(isPresented: self.$showingImagePicker) {
                ImagePicker(image: self.$userSelectedImage)
            }
        }
    }
    
    func savePlant() {
        var datesWatered = [Date]()
        if setDateLastWatered {
            datesWatered.append(self.dateLastWatered)
        }
        
        var newPlant = Plant(name: self.plantName, datesWatered: datesWatered)
        if let uiImage = userSelectedImage {
            newPlant.savePlantImage(uiImage: uiImage)
        }
        
        self.garden.plants.append(newPlant)
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct MakeNewPlantView_Previews: PreviewProvider {
    static var previews: some View {
        MakeNewPlantView(garden: Garden())
    }
}

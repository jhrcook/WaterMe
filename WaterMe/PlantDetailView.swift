//
//  PlantDetailView.swift
//  WaterMe
//
//  Created by Joshua on 7/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct SmallFloatingTextButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body))
            .frame(width: 60, height: 30)
            .foregroundColor(Color.white)
            .background(Color.black.opacity(0.2))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
    }
}




struct PlantDetailView: View {
    
    @ObservedObject var garden: Garden
    @State var plant: Plant
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var plantName: String
    @State private var dateLastWatered: Date
    @State private var showDatePicker = false
    @State private var showMoreOptionsActionSheet = false
    
    init(garden: Garden, plant: Plant) {
        self.garden = garden
        _plant = State(initialValue: plant)
        _plantName = State(initialValue: plant.name)
        _dateLastWatered = State(initialValue: plant.dateLastWatered)
    }
    
    var body: some View {
        ZStack {
            VStack {
                Image(plant.imageName)
                    .resizable()
                    .frame(height: 400)
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFit()
                
                TextField("", text: $plantName)
                    .font(.largeTitle)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                
                Button(action: {
                    withAnimation(Animation.easeInOut) {
                        self.showDatePicker.toggle()
                    }
                }) {
                    Text("Last watered on \(plant.formattedDateLastWatered)")
                        .font(.title)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
                
                if showDatePicker {
                    DatePicker(selection: $dateLastWatered, displayedComponents: .date) {
                        Text("Change the last date of watering.")
                    }.labelsHidden()
                }
                
                
                Button(action: {
                    self.dateLastWatered = Date()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundColor(Color.blue)
                            .frame(width: 220, height: 70)
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                        
                        HStack {
                            Image(systemName: "cloud.drizzle")
                            Text("Water me")
                        }
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                    }
                }
                
                Spacer(minLength: 30)
            }
            
            
            
            
            VStack {
                HStack {
                    Button(action: {
                        self.updatePlant()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save").font(.headline)
                    }
                    .buttonStyle(SmallFloatingTextButtonStyle())
                    .padding(10)
                    
                    Spacer()
                    
                    Button(action: {
                        self.showMoreOptionsActionSheet.toggle()
                    }) {
                        Image(systemName: "ellipsis").font(.title)
                    }
                    .buttonStyle(SmallFloatingTextButtonStyle())
                    .padding(10)
                }
                Spacer()
            }
        }
        .actionSheet(isPresented: $showMoreOptionsActionSheet) {
            ActionSheet(title: Text("More options"), buttons: [
                ActionSheet.Button.default(Text("Change image"), action: {}),
                ActionSheet.Button.destructive(Text("Delete"), action: {})
            ])
        }
    }
    
    func updatePlant() {
        plant.name = plantName
        plant.changeDateLastWatered(to: dateLastWatered)
        
        print("Updating plant!")
        print("plant name: \(plant.name); date: \(plant.formattedDateLastWatered)")
        
        let idx = garden.plants.firstIndex(where: { $0.id == plant.id })!
        garden.plants.insert(plant, at: idx)
        garden.plants.remove(at: idx + 1)
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant", imageName: Plant.defaultImageNames[1], datesWatered: [Date()]))
            
            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant with a reallly long name", imageName: Plant.defaultImageNames[1], datesWatered: [Date()]))
        }
    }
}

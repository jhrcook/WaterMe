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
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .animation(Animation.easeInOut(duration: 0.1))
    }
}

struct PlantDetailView: View {
    
    @ObservedObject var garden: Garden
    @State var plant: Plant
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var plantName: String
    @State private var dateLastWatered: Date
    private var formattedDateLastWatered: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter.string(from: dateLastWatered)
    }
    @State private var showDatePicker = false
    @State private var showMoreOptionsActionSheet = false
    @State private var confirmDeletion = false
    
    init(garden: Garden, plant: Plant) {
        self.garden = garden
        _plant = State(initialValue: plant)
        _plantName = State(initialValue: plant.name)
        _dateLastWatered = State(initialValue: plant.dateLastWatered)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image(plant.imageName)
                    .resizable()
                    .frame(height: 400)
                    .scaledToFit()
                    .padding(0.0)
                    
                VStack {
                    
                    TextField("", text: $plantName)
                        .font(.largeTitle)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding(5)
                    
                    Button(action: {
                        withAnimation(Animation.easeInOut) {
                            self.showDatePicker.toggle()
                        }
                    }) {
                        Text("Last watered on \(formattedDateLastWatered)")
                            .font(.title)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .padding(5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer(minLength: 5.0)
                    
                    if showDatePicker {
                        DatePicker(selection: $dateLastWatered, in: ...Date(), displayedComponents: .date) {
                            Text("Change the last date of watering.")
                        }
                        .labelsHidden()
                    }
                    
                    Spacer()
                    
                    WaterMeButton(action: { self.dateLastWatered = Date() })
                    
                    Spacer()
                }
                .background(
                    Rectangle()
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.9), radius: 50, x: 0, y: 10)
                )
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
                    .padding(EdgeInsets(top: showDatePicker ? 13 : 10, leading: 10, bottom: 10, trailing: 10))
                    .animation(Animation.easeInOut)
                    
                    Spacer()
                    
                    Button(action: {
                        self.showMoreOptionsActionSheet.toggle()
                    }) {
                        Image(systemName: "ellipsis").font(.title)
                    }
                    .buttonStyle(SmallFloatingTextButtonStyle())
                    .padding(EdgeInsets(top: showDatePicker ? 13 : 10, leading: 10, bottom: 10, trailing: 10))
                    .animation(Animation.easeInOut)
                }
                Spacer()
            }
        }
        .actionSheet(isPresented: $showMoreOptionsActionSheet) {
            ActionSheet(title: Text("More options"), buttons: [
                .default(Text("Change image"), action: {}),
                .destructive(Text("Delete"), action: { self.confirmDeletion.toggle() }),
                .cancel()
            ])
        }
        .alert(isPresented: $confirmDeletion) {
            Alert(title: Text("Delete the \(plant.name)"), message: Text("Are you sure you want to remove \(plant.name) from your collection?"), primaryButton: .destructive(Text("Delete"), action: deletePlantFromGarden), secondaryButton: .cancel())
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
    
    
    func deletePlantFromGarden() {
        
        
        
        garden.plants.removeAll(where: { $0.id == plant.id })
        presentationMode.wrappedValue.dismiss()
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

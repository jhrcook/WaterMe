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
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    Image(self.plant.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: geo.size.height / 2.0)
                        .padding(0.0)
                        
                    VStack {
                        
                        TextField("", text: self.$plantName)
                            .font(.title)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .padding(EdgeInsets(top: 12, leading: 8, bottom: 8, trailing: 8))
                        
                        Button(action: {
                            withAnimation(Animation.easeInOut) {
                                self.showDatePicker.toggle()
                            }
                        }) {
                            Text("Last watered on \(self.formattedDateLastWatered)")
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .padding(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer(minLength: 5.0)
                        
                        if self.showDatePicker {
                            DatePicker(selection: self.$dateLastWatered, in: ...Date(), displayedComponents: .date) {
                                Text("Change the last date of watering.")
                            }
                            .labelsHidden()
                        }
                        
                        Spacer()
                        
                        WaterMeButton(action: { self.dateLastWatered = Date() })
                        
                        Spacer()
                        
                        Button("Set up watering reminders") {
                            print("Still need to set this feature up...")
                        }
                        
                        Spacer()
                    }
                    .background(
                        ZStack{
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .edgesIgnoringSafeArea(.all)
                                .foregroundColor(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.9), radius: 50, x: 0, y: 10)
                            
                            VStack{
                                Spacer()
                                Rectangle()
                                    .edgesIgnoringSafeArea(.all)
                                    .foregroundColor(Color(.systemBackground))
                                    .padding(.top, 100)
                            }
                        }
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
                        
                        Spacer()
                        
                        Button(action: {
                            self.showMoreOptionsActionSheet.toggle()
                        }) {
                            Image(systemName: "ellipsis").font(.title)
                        }
                        .buttonStyle(SmallFloatingTextButtonStyle())
                        
                    }
                    .padding(EdgeInsets(top: 10 , leading: 10, bottom: 10, trailing: 10))
                    .animation(Animation.easeInOut)
                    
                    Spacer()
                }
            }
            .actionSheet(isPresented: self.$showMoreOptionsActionSheet) {
                ActionSheet(title: Text("More options"), buttons: [
                    .default(Text("Change image"), action: {}),
                    .destructive(Text("Delete"), action: { self.confirmDeletion.toggle() }),
                    .cancel()
                ])
            }
            .alert(isPresented: self.$confirmDeletion) {
                Alert(title: Text("Delete the \(self.plant.name)"), message: Text("Are you sure you want to remove \(self.plant.name) from your collection?"), primaryButton: .destructive(Text("Delete"), action: self.deletePlantFromGarden), secondaryButton: .cancel())
            }
        }
    }
    
    
    func updatePlant() {
        plant.name = plantName
        plant.changeDateLastWatered(to: dateLastWatered)
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
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            
//            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant with a reallly long name", imageName: Plant.defaultImageNames[1], datesWatered: [Date()]))
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            
            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant", imageName: Plant.defaultImageNames[1], datesWatered: [Date()]))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            
//            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant with a reallly long name", imageName: Plant.defaultImageNames[1], datesWatered: [Date()]))
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
    }
}

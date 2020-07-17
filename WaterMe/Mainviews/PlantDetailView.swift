//
//  PlantDetailView.swift
//  WaterMe
//
//  Created by Joshua on 7/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI



struct BackgroundView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: -10)
            
            VStack {
                Spacer(minLength: 100)
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(Color(.secondarySystemBackground))
            }
        }
    }
}



struct PlantDetailView: View {
    
    @ObservedObject var garden: Garden
    @State var plant: Plant
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State private var image: Image
    
    @State private var showMoreOptionsActionSheet = false
    @State private var confirmDeletion = false
    
    @State private var showingImagePicker = false
    @State private var userSelectedImage: UIImage?
    
    @State private var editLoggedWateringDates = false
            
    let offsetToShowShadowOnImage: CGFloat = -21
    
    @State var selectableDataDates: SelectableData
    
    init(garden: Garden, plant: Plant) {
        self.garden = garden
        _plant = State(initialValue: plant)
        _image = State(initialValue: plant.loadPlantImage())
        
        _selectableDataDates = State(initialValue: SelectableData(dates: plant.datesWatered))
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ZStack {
                    VStack(spacing: 0) {
                        GeometryReader { innergeo in
                            ZStack {
                                ParallaxHeaderImage(image: self.$image,
                                                    outerGeoSize: geo.size, outerGeoFrame: geo.frame(in: .global),
                                                    innerGeoSize: innergeo.size, innerGeoFrame: innergeo.frame(in: .global))
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.1)) {
                                                self.showMoreOptionsActionSheet.toggle()
                                            }
                                        }) {
                                            Image(systemName: "ellipsis").font(.title)
                                        }
                                        .buttonStyle(SmallFloatingTextButtonStyle())
                                        
                                    }
                                    .offset(y: geo.frame(in: .global).minY - innergeo.frame(in: .global).minY)
                                    .padding(EdgeInsets(top: 10 , leading: 10, bottom: 10, trailing: 10))
                                    .animation(nil)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: geo.size.height / 2.0)
                        
                        
                        VStack {
                            Spacer()
                            TextField("", text: self.$plant.name, onCommit: self.updatePlant)
                                .font(.title)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .padding(EdgeInsets(top: 12, leading: 8, bottom: 8, trailing: 8))
                            
                            Text("Last watered on \(self.plant.formattedDateLastWatered)")
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .padding(8)
                            
                            Spacer(minLength: 5.0)
                            
                            Spacer()
                            
                            WaterMeButton(hasBeenWatered: self.plant.wasWateredToday) {
                                self.plant.addNewDateLastWatered(to: Date())
                                self.updatePlant()
                            }
                            .disabled(self.plant.wasWateredToday)
                            
                            Spacer()
                            
                            Button("Set up watering reminders") {
                                print("Still need to set this feature up...")
                            }
                            .disabled(true)
                            
                            Spacer()
                        }
                        .frame(width: geo.size.width, height: (geo.size.height / 2) - self.offsetToShowShadowOnImage + 5)
                        .background(BackgroundView())
                        .padding(.top, self.offsetToShowShadowOnImage)
                        
                        VStack {
                            Spacer(minLength: 30)
                            
                            if (self.plant.datesWatered.count == 0) {
                                Text("No waterings reported, yet.")
                                    .foregroundColor(Color.secondary)
                            } else if self.editLoggedWateringDates {
                                Text("Edit logged watering dates")
                                    .padding()
                                
                                SelectableTableView(selectableData: self.selectableDataDates, deleteAction: {
                                    withAnimation(.linear(duration: 0.3)) {
                                        self.selectableDataDates.data = self.selectableDataDates.data.filter({ !$0.isSelected })
                                    }
                                    self.plant.datesWatered = self.selectableDataDates.data.map({ $0.date })
                                    self.updatePlant()
                                }, doneAction: {
                                    withAnimation(.linear(duration: 0.3)) {
                                        self.editLoggedWateringDates.toggle()
                                    }
                                })
                                .padding(EdgeInsets(top: 18, leading: 15, bottom: 18, trailing: 15))
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundColor(Color(.tertiarySystemBackground))
                                        .padding(12)
                                )
                            } else {
                                VerticalTimeLine(dates: self.plant.datesWatered)
                            }
                            
                            Spacer(minLength: 10)
                        }
                        .background(
                            Color(.secondarySystemBackground)
                                .edgesIgnoringSafeArea(.all)
                        )
                        
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
            .actionSheet(isPresented: self.$showMoreOptionsActionSheet) {
                ActionSheet(title: Text("More options"), buttons: [
                    .default(Text("Change image"), action: {
                        self.showingImagePicker.toggle()
                    }),
                    .default(Text("Edit logged watering dates"), action: {
                        withAnimation(.linear(duration: 0.3)) {
                            self.editLoggedWateringDates.toggle()
                        }
                    }),
                    .destructive(Text("Delete"), action: {
                        self.confirmDeletion.toggle()
                    }),
                    .cancel()
                ])
            }
            .alert(isPresented: self.$confirmDeletion) {
                Alert(title: Text("Delete the \(self.plant.name)"),
                      message: Text("Are you sure you want to remove \(self.plant.name) from your collection?"),
                      primaryButton: .destructive(Text("Delete"), action: self.deletePlantFromGarden),
                      secondaryButton: .cancel())
            }
            .sheet(isPresented: self.$showingImagePicker, onDismiss: self.loadImage) {
                ImagePicker(image: self.$userSelectedImage)
            }
        }
    }
    
    
    func updatePlant() {
        let idx = garden.plants.firstIndex(where: { $0.id == plant.id })!
        garden.plants[idx] = plant
        selectableDataDates = SelectableData(dates: plant.datesWatered)
    }
    
    
    func deletePlantFromGarden() {
        plant.deletePlantImageFile()
        garden.plants.removeAll(where: { $0.id == plant.id })
        presentationMode.wrappedValue.dismiss()
    }
    
    
    func loadImage() {
        if let uiImage = userSelectedImage {
            image = Image(uiImage: uiImage)
            plant.savePlantImage(uiImage: uiImage)
        }
        updatePlant()
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    func deleteDatesWatered(at offsets: IndexSet) {
        plant.datesWatered.remove(atOffsets: offsets)
        updatePlant()
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant", datesWatered: [Date()]))
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            
            //            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant with a reallly long name", imageName: Plant.defaultImageNames[1], datesWatered: [Date()]))
            //                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            
            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant", datesWatered: [Date()]))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            
//            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant", datesWatered: [Date()]))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            
            //            PlantDetailView(garden: Garden(), plant: Plant(name: "Test plant with a reallly long name", imageName: Plant.defaultImageNames[1], datesWatered: [Date()]))
            //                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
    }
}
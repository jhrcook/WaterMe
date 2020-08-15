//
//  ContentView.swift
//  WaterMeWatchApp Extension
//
//  Created by Joshua on 7/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct ContentView: View, GardenDelegate {
    func gardenDidChange() {
        garden.reloadPlants()
    }
    
    
    @ObservedObject var garden = GardenWatch()
    var phoneCommunicator = WatchToPhoneCommunicator()
    
    var body: some View {
        GardenListView(garden: garden, phoneCommunicator: phoneCommunicator)
            .onAppear {
                self.phoneCommunicator.gardenDelegate = self
                self.checkFirstTimeDataRequest()
            }
    }
    
    func checkFirstTimeDataRequest() {
        let watchHasRequestedInitalData: Bool = UserDefaults.standard.bool(forKey: UserDefaultKeys.watchHasRequestedInitalData)
        if !watchHasRequestedInitalData {
            phoneCommunicator.requestAllApplicationData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

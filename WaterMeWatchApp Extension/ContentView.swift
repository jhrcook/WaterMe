//
//  ContentView.swift
//  WaterMeWatchApp Extension
//
//  Created by Joshua on 7/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var garden = Garden()
    
    var body: some View {
        GardenListView(garden: garden)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

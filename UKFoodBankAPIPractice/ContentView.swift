//
//  ContentView.swift
//  UKFoodBankAPIPractice
//
//  Created by Kimberly Brewer on 10/17/23.
//
// TODO: Create AppIcon
// TODO: Add online status tester to alert user if they are online then the app won't work
// TODO: Pretty up the app
// TODO: Add a "I donated" button
// TODO: Add an award section for when the user visits a specific num of food banks and makes a specific donation

import SwiftUI

struct ContentView: View {
    @Environment(DataController.self) var dataController
    var body: some View {
        if let selectedFoodbank = dataController.selectedFoodbank {
            TabView {
                HomeView(foodbank: selectedFoodbank)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                Text("My Foodbank")
                    .tabItem {
                        Label("My Foodbank", systemImage: "building.2")
                    }
                DropoffView(foodbank: selectedFoodbank)
                    .tabItem {
                        Label("Dropoff Points", systemImage: "basket")
                    }
            }
        } else {
            EnterLocationView()
        }
    }
}

#Preview {
    ContentView()
}

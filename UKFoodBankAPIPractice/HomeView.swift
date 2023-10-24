//
//  HomeView.swift
//  UKFoodBankAPIPractice
//
//  Created by Kimberly Brewer on 10/23/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(DataController.self) var dataController
    var foodbank: Foodbank
    var body: some View {
        NavigationStack {
            List {
                Section("\(foodbank.name) foodbank needs...") {
                    ForEach(foodbank.neededItems, id: \.self) { item in
                        // TODO: Add some formatting here
                    Text(item)
                    }
                }
            }
            .navigationTitle("Share a Meal")
            .toolbar {
                Button("Change Location") {
                    withAnimation {
                        dataController.select(nil)
                    }
                }
            }
        }
    }
}


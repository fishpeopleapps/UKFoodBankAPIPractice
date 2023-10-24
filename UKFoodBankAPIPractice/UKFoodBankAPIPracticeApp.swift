//
//  UKFoodBankAPIPracticeApp.swift
//  UKFoodBankAPIPractice
//
//  Created by Kimberly Brewer on 10/17/23.
//

import SwiftUI

@main
struct UKFoodBankAPIPracticeApp: App {
    // make it once and keep it alive the whole time
    @State private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataController) // and share it to all views
        }
    }
}

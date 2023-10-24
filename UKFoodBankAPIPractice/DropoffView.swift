//
//  DropoffView.swift
//  UKFoodBankAPIPractice
//
//  Created by Kimberly Brewer on 10/24/23.
//
import MapKit
import SwiftUI

struct DropoffView: View {
    var foodbank: Foodbank
    var body: some View {
        NavigationStack {
            Map {
                if let coordinate = foodbank.coordinate {
                    Marker("Your foodbank", coordinate: coordinate)
                }
                if let locations = foodbank.locations {
                    ForEach(locations) { location in
                        if let coordinate = location.coordinate {
                            Marker(location.name, coordinate: coordinate)
                        }
                    }
                }
            }
            .navigationTitle("Dropoff Points")
        }
    }
}

#Preview {
    DropoffView(foodbank: .example)
}

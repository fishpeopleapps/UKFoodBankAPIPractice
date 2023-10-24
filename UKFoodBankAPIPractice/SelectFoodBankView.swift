//
//  SelectFoodBankView.swift
//  UKFoodBankAPIPractice
//
//  Created by Kimberly Brewer on 10/20/23.
//

import SwiftUI

struct SelectFoodBankView: View {
    @Environment(DataController.self) var dataController
    var postCode: String
    @State private var state = LoadState.loading
    var body: some View {
        Group {
            switch state {
            case .loading:
                ProgressView("Loading...")
            case .failed:
                ContentUnavailableView {
                    Label("Load Failed", systemImage: "exclamationmark.triangle")
                } description: {
                    Text("Loading failed; please try again")
                } actions: {
                    Button("Retry", systemImage: "arrow.circlepath", action: fetchFoodbanks)
                        .buttonStyle(.borderedProminent)
                }
            case .loaded(let foodbanks):
                List {
                    ForEach(foodbanks) { foodbank in
                        Section(foodbank.distanceFormatted) {
                            VStack(alignment: .leading) {
                                Text(foodbank.name)
                                    .font(.title)
                                Text(foodbank.address)
                                Button("Select this foodbank") {
                                    // select the foodbank
                                    withAnimation {
                                        dataController.select(foodbank)
                                    }
                                }
                                .buttonStyle(.borderless)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .navigationTitle("Nearby foodbanks")
        // as soon as our view is shown we want the below code to run
        .task {
            fetchFoodbanks()
        }
    }
    func fetchFoodbanks() {
        state = .loading
        Task {
            try await Task.sleep(for: .seconds(0.5))
            state = try await dataController.loadFoodBanks(near: postCode)
        }
    }
}

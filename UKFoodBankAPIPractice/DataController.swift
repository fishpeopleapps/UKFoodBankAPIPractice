//
//  DataController.swift
//  UKFoodBankAPIPractice
//
//  Created by Kimberly Brewer on 10/17/23.
//

import Foundation

enum LoadState {
    case loading, failed, loaded([Foodbank])
}

@Observable
class DataController {
    // once they select a foodbank it will be stored here
    private(set) var selectedFoodbank: Foodbank?
    // we're going to persist their choice ------
    private let savePath = URL.documentsDirectory.appending(path: "SelectedFoodBank")
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let savedFoodbank = try JSONDecoder().decode(Foodbank.self, from: data)
            select(savedFoodbank)
        } catch {
            // not sure what we're doing here?
        }
    }
    func save() {
        do {
            let data = try JSONEncoder().encode(selectedFoodbank)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
                           } catch {
                print("Unable to save data")
            }
    }
    func loadFoodBanks(near postCode: String) async -> LoadState {
        let fullURL = "https://www.givefood.org.uk/api/2/foodbanks/search/?address=\(postCode)"
        guard let url = URL(string: fullURL) else {
            return .failed
        }
        // if we're here, the URL is correct
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let foodbanks = try JSONDecoder().decode([Foodbank].self, from: data)
            return .loaded(foodbanks)
        } catch {
            // url worked, but we didn't get back an array of foodbanks
            return .failed
        }
    }
    // this is so we can set the private var above
    func select(_ foodbank: Foodbank?) {
        selectedFoodbank = foodbank
        save()
        Task {
            await updateSelected()
        }
    }
    private func updateSelected() async {
        // do we have a current foodbank? if not, bail out
        guard let current = selectedFoodbank else { return }
        
        let fullURL = "https://www.givefood.org.uk/api/2/foodbank/\(current.slug)"
        // if we don't get a URL (which we definitely should), bail out
        guard let url = URL(string: fullURL) else { return }
        // if we're here, the URL is correct
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            selectedFoodbank = try JSONDecoder().decode(Foodbank.self, from: data)
        } catch {
            print("Failed to update foodbank: \(error.localizedDescription)")
        }
    }
}

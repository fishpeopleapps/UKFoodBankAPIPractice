//
//  EnterLocationView.swift
//  UKFoodBankAPIPractice
//
//  Created by Kimberly Brewer on 10/20/23.
//

import SwiftUI

struct EnterLocationView: View {
    @State private var postCode = "SW1 1AA"
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome")
                    .font(.largeTitle)
                Text("To get started, enter your post code")
                
                HStack {
                    TextField("Your post code: ", text: $postCode)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 200)
                    
                    NavigationLink("Go") {
                        SelectFoodBankView(postCode: postCode)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    EnterLocationView()
}

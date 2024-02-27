//
//  ModalView.swift
//  RandomUsersApp
//
//  Created by Raul Linio Alonso on 27/2/24.
//

import SwiftUI

struct ModalView: View {
    @Environment(\.presentationMode) var presentationMode
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
            }
            Text(title)
                .font(.title)
                .foregroundColor(.black)
                .padding()
            Text(description)
                .font(.body)
                .foregroundColor(.black)
                .padding()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
    }
}

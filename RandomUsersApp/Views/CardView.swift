//
//  CardView.swift
//  RandomUsersApp
//
//  Created by Raul Linio Alonso on 27/2/24.
//

import SwiftUI

struct CardView: View {
    var imageURLString: String
    var name: String
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .onAppear {
                        loadImage(from: imageURLString)
                    }
            }
            Spacer()
            Text(name)
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.black)
                .font(.headline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

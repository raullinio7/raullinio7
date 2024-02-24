//
//  RandomUserView.swift
//  RandomUsersApp
//
//  Created by Raul Linio Alonso on 16/2/24.
//
import SwiftUI

struct RandomUserView: View {
    @StateObject private var presenter = RandomUserPresenter()
    
    var body: some View {
        NavigationView {
            ScrollView() {
                VStack {
                    if let users = presenter.users {
                        ForEach(users, id: \.id.value) { user in
                            NavigationLink(destination: UserDetailsView(user: user, email: user.email, password: user.login.password, isPasswordHidden: true)) {
                                CardView(imageURLString: user.picture.large, name: user.name.first + " " + user.name.last)
                                    .padding()
                            }
                        }
                    } else {
                        Text("Cargando...")
                    }
                }
                .navigationBarTitle("Usuarios") // Configurar título en la barra de navegación
                .navigationBarTitleDisplayMode(.inline) // Mostrar el título en línea
            }
            .background(Color.pink.edgesIgnoringSafeArea(.all))
            .onAppear {
                presenter.fetchRandomUser()
            }
            .refreshable {
                presenter.fetchRandomUser()
            }
        }
    }
}
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

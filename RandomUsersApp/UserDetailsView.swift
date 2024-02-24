//
//  UserDetailsView.swift
//  RandomUsersApp
//
//  Created by Raul Linio Alonso on 24/2/24.
//

import SwiftUI

struct UserDetailsView: View {
    let user: User
    @State private var isPasswordHidden: Bool
    @State private var email: String
    @State private var password: String
    @State private var image: UIImage? = nil
    
    init(user: User, email: String, password: String, isPasswordHidden: Bool) {
        self.user = user // Inicializa la propiedad user antes de llamar a super.init()
        self._email = State(initialValue: email)
        self._password = State(initialValue: password)
        self._isPasswordHidden = State(initialValue: isPasswordHidden)
    }

    var body: some View {
        ScrollView() {
            VStack {
                VStack {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                            .onAppear {
                                loadImage(from: user.picture.medium)
                            }
                    }
                    // Campo nombre
                    Text(user.name.first)
                        .font(.title)
                        .foregroundColor(.white)
//
//                    // Campo dirección
//                    Text(name + ", " + user.location.city)
//                        .font(.title)
//                        .foregroundColor(.white)
//
                    // Campo editable para el email
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // Campo editable para la contraseña con botón de ojo
                    HStack {
                        if isPasswordHidden {
                            SecureField("Contraseña", text: $password)
                        } else {
                            TextField("Contraseña", text: $password)
                        }
                        Button(action: {
                            isPasswordHidden.toggle()
                        }) {
                            Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                        }
                        .padding(.trailing)
                        .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
//
//                    // Espaciador
//                    Spacer()
                }
            }
        }
    }
    func loadImage(from urlString: String) {
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

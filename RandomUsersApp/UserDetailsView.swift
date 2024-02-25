//
//  UserDetailsView.swift
//  RandomUsersApp
//
//  Created by Raul Linio Alonso on 24/2/24.
//

import SwiftUI
struct UserDetailsView: View {
    let user: User
    @State private var isPasswordHidden: Bool = true
    @State private var modifiedEmail: String // Variable para almacenar el email modificado
    @State private var modifiedPassword: String // Variable para almacenar la contraseña modificada
    @State private var image: UIImage? = nil
    
    init(user: User) {
        self.user = user
        self._modifiedEmail = State(initialValue: user.email)
        self._modifiedPassword = State(initialValue: user.login.password)
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
                                loadImage(from: user.picture.large)
                            }
                    }
                    Text("\(user.name.first) \(user.name.last)")
                        .font(.title)
                        .foregroundColor(.black)
                    
                    Text(user.location.city + ", " + user.location.country)
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    TextField("Email", text: $modifiedEmail)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                        .padding(.horizontal)
                    
                    HStack {
                        if isPasswordHidden {
                            SecureField("Contraseña", text: $modifiedPassword)
                        } else {
                            TextField("Contraseña", text: $modifiedPassword)
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
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                    .padding(.horizontal)
                    
                    Button(action: {
                        // Guardar los cambios en UserDefaults
                        UserDefaults.standard.set(modifiedEmail, forKey: "\(user.id.value)_savedEmail")
                        UserDefaults.standard.set(modifiedPassword, forKey: "\(user.id.value)_savedPassword")
                    }) {
                        Text("Guardar")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            // Cargar los valores de UserDefaults si están disponibles
            if let savedEmail = UserDefaults.standard.string(forKey: "\(user.id.value)_savedEmail") {
                self.modifiedEmail = savedEmail
            }
            if let savedPassword = UserDefaults.standard.string(forKey: "\(user.id.value)_savedPassword") {
                self.modifiedPassword = savedPassword
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

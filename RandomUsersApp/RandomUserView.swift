//
//  RandomUserView.swift
//  RandomUsersApp
//
//  Created by Raul Linio Alonso
//
import SwiftUI

struct RandomUserView: View {

    @StateObject private var presenter = RandomUserPresenter()
    @State private var isFirstAppearance = true
    @State private var showModal = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Comprueba si hay usuarios disponibles en el presenter
                    if let users = presenter.users {
                        ForEach(users, id: \.id.value) { user in
                            // NavigationLink que dirige a UserDetailsView cuando se selecciona un usuario
                            NavigationLink(destination: UserDetailsView(user: user)) {
                                CardView(imageURLString: user.picture.large, name: "\(user.name.first) \(user.name.last)")
                                    .padding()
                            }
                        }
                    } else {
                        // Muestra un mensaje de carga si no hay usuarios disponibles
                        Text("Cargando...")
                    }
                }
                // Configuración de la barra de navegación
                .navigationBarTitle("Usuarios")
                .navigationBarTitleDisplayMode(.inline)
            }
            // Configuración del fondo de la vista
            .background(Color.pink.edgesIgnoringSafeArea(.all))
            // Pull to refresh
            .refreshable {
                presenter.fetchRandomUser()
            }
            .onAppear {
                if isFirstAppearance {
                    presenter.fetchRandomUser()
                    isFirstAppearance = false // Establece isFirstAppearance como false para que no se llame al servicio cada vez que se vuelva de la vista de detalle a esta pantalla.
                }
            }
            // Configuración de elementos de la barra de navegación
            .navigationBarItems(trailing: Button(action: {
                self.showModal = true
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.black)
            })
            // Configuración de la modal que se muestra cuando showModal es verdadero
            .sheet(isPresented: $showModal) {
                ModalView(title: "Ayuda", description: "1. Para actualizar la lista de usuarios realice \"pull to refresh\".\n\n\n2. Para entrar en el detalle de la información de un usuario pulse en su tarjeta correspondiente.\n\n\n3. Dentro del detalle puede cambiar el correo y la contraseña de cualquier usuario, quedando guardada dicha modificación siempre y cuando el formato de email sea válido.")
            }
        }
    }
}

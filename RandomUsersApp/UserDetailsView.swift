//
//  UserDetailsView.swift
//  RandomUsersApp
//
//  Created by Raul Linio Alonso
//

import SwiftUI
struct UserDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let user: User
    
    //Las siguientes variables son @State para que la interfaz de usuario se actualice cuando cambien
    @State private var isPasswordHidden: Bool = true // Estado para controlar la visibilidad de la contraseña
    @State private var modifiedEmail: String // Variable de estado para almacenar el email modificado
    @State private var modifiedPassword: String // Variable de estado para almacenar la contraseña modificada
    @State private var image: UIImage? = nil // Estado para almacenar la imagen del usuario
    @State private var showBanner: Bool = false // Estado para controlar la visibilidad del banner
    
    init(user: User) {
        self.user = user
        // Se inicializan con los valores del usuario recibido
        self._modifiedEmail = State(initialValue: user.email)
        self._modifiedPassword = State(initialValue: user.login.password)
    }
    
    var body: some View {
        ScrollView() {
            VStack {
                VStack {
                    // Mostrar la imagen del usuario, si está disponible
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    } else {
                        // Si no hay imagen disponible, se muestra un rectángulo gris
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                            .onAppear {
                                // Se llama a la función de cargar imagen
                                loadImage(from: user.picture.large)
                            }
                    }
                    Text("\(user.name.first) \(user.name.last)")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.black)
                    Text(user.location.city + ", " + user.location.country)
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    // Campo editable para el email del usuario
                    TextField("Email", text: $modifiedEmail)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                        .padding(.horizontal)
                        .autocapitalization(.none) // Desactiva la autocapitalización del texto
                        .keyboardType(.emailAddress) // Configura el teclado para introducir direcciones de email
                        .modifier(EmailValidationModifier(text: $modifiedEmail))
                    
                    // Campo editable para la contraseña del usuario
                    HStack {
                        if isPasswordHidden {
                            SecureField("Contraseña", text: $modifiedPassword)
                        } else {
                            TextField("Contraseña", text: $modifiedPassword)
                        }
                        Button(action: {
                            //toggle() para cambiar el valor isPasswordHidden
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
                    // Botón para guardar los cambios en UserDefaults
                    Button(action: {
                        // Comprobación para que solo se pueda guardar si el formato del correo es válido.
                        if isValidEmail(email: modifiedEmail) {
                            //Se almacenan los valores modificados y en la key se pone el id para que sea especifico de cada usuario
                            UserDefaults.standard.set(modifiedEmail, forKey: "\(String(describing: user.id.value))_savedEmail")
                            UserDefaults.standard.set(modifiedPassword, forKey: "\(String(describing: user.id.value))_savedPassword")
                        }
                        showBanner = true
                    }) {
                        Text("Guardar")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(isValidEmail(email: modifiedEmail) ? Color.black : Color.gray)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    .alert(isPresented: $showBanner) {
                        // Mostrar el banner dependiendo de si el email es válido o no
                        if isValidEmail(email: modifiedEmail) {
                            return Alert(title: Text("Cambios guardados"), message: nil)
                        } else {
                            return Alert(title: Text("No se han guardado los cambios.\nFormato de email inválido"), message: nil)
                        }
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            //Se cargan los valores guardados para ser mostrados en caso de salir y entrar de la vista detalle.
            if let savedEmail = UserDefaults.standard.string(forKey: "\(String(describing: user.id.value))_savedEmail") {
                self.modifiedEmail = savedEmail
            }
            if let savedPassword = UserDefaults.standard.string(forKey: "\(String(describing: user.id.value))_savedPassword") {
                self.modifiedPassword = savedPassword
            }
        }
        // Se configura la barra de navegación para que solo aparezca una flecha para volver a la pantalla principal.
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
        })
        .background(Color.pink.edgesIgnoringSafeArea(.all)) // Fondo rosa
    }
    
    //Función para cargar la imagen del usuario desde una URL
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
// Modificador de vista para validar el formato de email
struct EmailValidationModifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
        // Verificación del formato de email y muestra de mensaje de error si es necesario
        if !isValidEmail(email: text) {
            Text("Formato de email inválido")
                .foregroundColor(.white)
                .font(.caption)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true) // Permite el desbordamiento del texto si es necesario
        }
    }
}
// Función para verificar el formato de email
 func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

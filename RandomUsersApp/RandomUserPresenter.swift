//
//  RandomUserPresenter.swift
//  RandomUsersApp
//
//  Created by Raul Linio Alonso
//
import SwiftUI

class RandomUserPresenter: ObservableObject {

    @Published var users: [User] = []
    // Instancia privada de RandomUserService para realizar llamadas a la API
    private let apiService = RandomUserService()

    func fetchRandomUser() {
        // Llamada al método de la API para obtener usuarios aleatorios
        apiService.getRandomUser { result in
            switch result {
            // Caso de éxito: se reciben usuarios válidos
            case .success(let users):
                // Actualización de la lista de usuarios en el hilo principal
                DispatchQueue.main.async {
                    self.users = users.results
                }
            // Caso de error: se produce un error al obtener usuarios
            case .failure(let error):
                print("Error fetching random user: \(error)")
            }
        }
    }
}

class RandomUserService {
    func getRandomUser(completion: @escaping (Result<Users, Error>) -> Void) {
        guard let url = URL(string: "https://randomuser.me/api?results=20") else {
            // En caso de URL inválida, se llama al bloque de finalización con un error
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Manejo de errores
            if let error = error {
                // Si hay un error, se llama al bloque de finalización con el error
                completion(.failure(error))
                return
            }
            // Verificación de la existencia de datos recibidos
            guard let data = data else {
                // Si no se recibe ningún dato, se llama al bloque de finalización con un error
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            // Formateo de los datos JSON recibidos para imprimirlos en la consola
            let jsonData = data.prettyPrintedJSONString
            print(jsonData as Any)
            // Decodificación de los datos JSON en objetos de tipo Users utilizando JSONDecoder
            do {
                let randomUser = try JSONDecoder().decode(Users.self, from: data)
                // Llamada al bloque de finalización con los usuarios obtenidos
                completion(.success(randomUser))
            } catch {
                // Si hay un error en la decodificación, se llama al bloque de finalización con el error
                completion(.failure(error))
            }
        }.resume() // Se reanuda la tarea de URLSession
    }
}

// Extensión para imprimir json
extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

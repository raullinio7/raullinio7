//
//  RandomUserPresenter.swift
//  RandomUsersApp
//
//  Created by Raul Linio Alonso on 16/2/24.
//
import SwiftUI

class RandomUserPresenter: ObservableObject {
    @Published var users: [User] = []
    private let apiService = RandomUserService()

    func fetchRandomUser() {
        apiService.getRandomUser { result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self.users = users.results
                }
            case .failure(let error):
                print("Error fetching random user: \(error)")
            }
        }
    }
}

class RandomUserService {
    func getRandomUser(completion: @escaping (Result<Users, Error>) -> Void) {
        guard let url = URL(string: "https://randomuser.me/api?results=20") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            let jsonData = data.prettyPrintedJSONString
            print(jsonData)
            do {
                let randomUser = try JSONDecoder().decode(Users.self, from: data)
                completion(.success(randomUser))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

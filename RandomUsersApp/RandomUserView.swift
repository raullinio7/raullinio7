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
        VStack {
            if let users = presenter.users {
                ForEach(users, id: \.id.value) { user in
                    Text(user.name.title + " " + user.name.first + " " + user.name.last)
                }
            } else {
                Text("Cargando...")
            }
        }.onAppear {
            presenter.fetchRandomUser()
        }
    }
}

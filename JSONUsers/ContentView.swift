//
//  ContentView.swift
//  JSONUsers
//
//  Created by Alvaro Valdes Salazar on 27-06-21.
//

import SwiftUI

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var username: String
    
}



struct ContentView: View {
    @State var users: [User] = []
    enum HttpError: Error { case InvalidResponse  }

    var body: some View {
        ForEach(users) { user in
            Text(user.name)
        }.task {
            do {
                let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 else {
                     throw HttpError.InvalidResponse
                   }
                let u = try JSONDecoder().decode([User].self, from: data)
                users = u
              } catch {
                users = []
         }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

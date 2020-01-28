import Combine
import SwiftUI
import Foundation
import Promises
import FirebaseAuth
import FirebaseFirestore


final class MyStore: ObservableObject {
    @Published var displayBoard = displayBoardData
    @Published var currentUser : User? = userInitialData
}

let displayBoardData: [DisplayBoard] = load("userData.json")
let userInitialData: User? = loadData()

func loadData() -> User?{
    if let user = Auth.auth().currentUser {
        print("have user")
        let obj = try! await(User.getById(id: user.uid))
        return obj
    }else{
        return nil
    }
    
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

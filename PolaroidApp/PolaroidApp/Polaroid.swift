//
//  Polaroid.swift
//  PolaroidApp
//
//  Created by Mo Young on 4/18/24.
//

import Foundation
struct Polaroid: Decodable {
    var id:Int
    var image:String
    var filepath:String
    
    init(id: Int, image: String, filepath: String) {
        self.id = id
        self.image = image
        self.filepath = filepath
    }
}

//extension Polaroid {
//    static var favoritesKey: String {
//        return "Gallery"
//    }
//    
//    
//    // Saving only the filepaths from an array of Polaroid objects
//    static func saveFilepaths(of filepaths: [String], forKey key: String) {
////        let filepaths = polaroids.map { $0.filepath }  // Extracting filepaths
//        let defaults = UserDefaults.standard
//        do {
//            let encodedData = try JSONEncoder().encode(filepaths) // Encoding the array of filepaths
//            defaults.set(encodedData, forKey: key)
//        } catch {
//            print("Failed to encode filepaths: \(error)")
//        }
//    }
//    
//    // Retrieve filepaths from UserDefaults
//    static func getFilepaths(forKey key: String) -> [String] {
//        let defaults = UserDefaults.standard
//        if let data = defaults.data(forKey: key) {
//            do {
//                // Decoding the array of filepaths
//                let decodedFilepaths = try JSONDecoder().decode([String].self, from: data)
//                return decodedFilepaths
//            } catch {
//                print("Failed to decode filepaths: \(error)")
//                return []
//            }
//        } else {
//            return []  // Return empty array if no data is found
//        }
//    }
//    
//    func addToLCFP() {
//        // Retrieve existing favorite filepaths
//        var favoriteFilepaths = Polaroid.getFilepaths(forKey: Polaroid.favoritesKey)
//        
//        // Append the current object's filepath to the favorites list
//        favoriteFilepaths.append(self.filepath)
//        
//        // Save the updated favorites list
//        Polaroid.saveFilepaths(of: favoriteFilepaths, forKey: Polaroid.favoritesKey)
//    }
//    
//    func removeFromLCFP() {
//          // Retrieve the current list of favorite filepaths
//          var favoriteFilepaths = Polaroid.getFilepaths(forKey: Polaroid.favoritesKey)
//          
//          // Remove the current object's filepath from the favorites list
//          favoriteFilepaths.removeAll { filepath in
//              return self.filepath == filepath
//          }
//          
//          // Save the updated list back to UserDefaults
//          Polaroid.saveFilepaths(of: favoriteFilepaths, forKey: Polaroid.favoritesKey)
//      }
//    
//}

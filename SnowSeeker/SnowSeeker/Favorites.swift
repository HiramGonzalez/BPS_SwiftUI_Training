//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Hiram González on 09/07/23.
//

import Foundation

class Favorites: ObservableObject, Codable {
    private var resorts: Set<String>
    private var saveKey = "Favorites"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            do {
                let resortsSet = try JSONDecoder().decode(Set<String>.self, from: data)
                resorts = resortsSet
            } catch {
                resorts = []
                print("Failed to decode Data")
            }
        } else {
            resorts = []
            print("Failed to get data from UserDefaults")
        }
        //resorts = UserDefaults.standard.mutableSetValue(forKey: saveKey) as! Set<String>
        print(resorts)
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        print(resorts)
        do {
            let data = try JSONEncoder().encode(resorts)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Couldn't be saved")
        }
        
    }
}

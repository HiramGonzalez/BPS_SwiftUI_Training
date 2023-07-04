//
//  Prospect.swift
//  HotProspects
//
//  Created by BPS.Dev01 on 7/3/23.
//

import SwiftUI


class Prospect: Codable, Identifiable, Comparable {
    
    var id = UUID()
    var name = "Anonymous"
    var email = ""
    fileprivate(set) var isContacted = false
    var date = Date.now
    
    static func <(lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name < rhs.name
    }
    
    static func ==(lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.id == rhs.id
    }
}

@MainActor class Prospects: ObservableObject { // TIP: Everywhere you set a class as an ObservableObject, add @MainActor wrapper
    @Published fileprivate(set) var people: [Prospect]
    let saveKey = "SaveData"
    
    init() {
        
        let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("people.json")
        
        
        if let data = try? Data(contentsOf: url!) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        
        self.people = []
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            //UserDefaults.standard.set(encoded, forKey: saveKey)
            let url = getDocumentsDirectory().appendingPathComponent("people.json")
            
            do {
                try encoded.write(to: url)
                let input = try String(contentsOf: url)
                print(input)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}

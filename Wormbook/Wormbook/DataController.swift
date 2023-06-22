//
//  DataController.swift
//  Wormbook
//
//  Created by BPS.Dev01 on 6/21/23.
//

import CoreData
import Foundation


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    
    init() {
        //let container = NSPersistentContainer(name: "Bookworm")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
        }
    }
}

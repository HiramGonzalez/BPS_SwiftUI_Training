//
//  ContentView-ModelView.swift
//  BucketList
//
//  Created by BPS.Dev01 on 6/28/23.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView{
    
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations = [Location]()
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        @Published var showFailedAuthenticationAlert = false
        @Published var failedAuthMessage = ""
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        
        func update(location: Location) {
            //guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: location) {
                locations[index] = location
                print(locations)
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        Task {
                            await MainActor.run {
                                self.isUnlocked = true
                            }
                        }
                    } else {
                        Task { @MainActor in
                            self.showFailedAuthenticationAlert = true
                            self.failedAuthMessage = "Biometric Authentication failed. Try again."
                        }
                    }
                }
            } else {
                Task { @MainActor in
                    self.showFailedAuthenticationAlert = true
                    self.failedAuthMessage = "Give permisson to BucketList to use biometric authentication to unlock the app."
                }
            }
        }
    }
}

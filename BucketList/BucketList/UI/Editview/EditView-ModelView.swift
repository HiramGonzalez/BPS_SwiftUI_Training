//
//  EditView-ModelView.swift
//  BucketList
//
//  Created by BPS.Dev01 on 6/29/23.
//

import Foundation

extension EditView {
    
    @MainActor class ViewModel: ObservableObject {
        
        var location: Location
        @Published var name: String
        @Published var description: String
        
        @Published var pages = [Page]()
        
        enum LoadingState {
            case loading, loaded, failed
        }
        
        @Published var loadingState = LoadingState.loading
        
        
        init(location: Location) {
            self.location = location
            
            //We use underscores before the variables' names because we want to assign their values as @State properties
            _name = Published(initialValue: location.name)
            _description = Published(initialValue: location.description)
        }
        
        func saveLocation() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                print("Step 1 done")
                let items = try JSONDecoder().decode(Result.self, from: data)
                print("Step 2 done")
                pages = items.query.pages.values.sorted()
                print("Step 3 done")
                loadingState = .loaded
            } catch let error1 as NSError {
                loadingState = .failed
                print(error1.localizedDescription)
            } catch {
                print(error)
            }
        }
    }
}

//
//  EditView.swift
//  BucketList
//
//  Created by BPS.Dev01 on 6/28/23.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    
    @StateObject private var viewModel: EditView.ViewModel
    
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                    
                }
            }
            
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    onSave(viewModel.saveLocation())
                    dismiss()
                }
            }
            
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        _viewModel = StateObject(wrappedValue: EditView.ViewModel(location: location))
        self.onSave = onSave
    }
    

}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}

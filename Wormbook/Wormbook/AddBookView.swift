//
//  AddBookView.swift
//  Wormbook
//
//  Created by BPS.Dev01 on 6/22/23.
//

import SwiftUI

struct AddBookView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var rating = 3
    @State private var review = ""
    
    var shouldBeDisabled: Bool {
        if title.isEmpty || author.isEmpty || genre.isEmpty || genre == "Choose one" {
            return true
        }
        return false
    }
    
    let genres = ["Choose one", "Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating, label: "Stars")
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.genre = genre
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.review = review
                        newBook.date = Date.now
                        
                        try? moc.save()
                        dismiss()
                    }
                } .disabled(shouldBeDisabled)
            }
            .navigationTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}

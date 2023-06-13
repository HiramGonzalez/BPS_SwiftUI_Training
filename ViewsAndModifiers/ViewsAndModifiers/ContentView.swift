//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by BPS.Dev01 on 6/12/23.
//

import SwiftUI


struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack{
            ForEach(0..<rows, id:\.self) { row in
                HStack{
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}


struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func largeTitle() -> some View {
        modifier(BlueTitle())
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct CapsuleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            //.foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())
    }
    
}

struct Watermark: ViewModifier {
    var text: String
    
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing){
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(.black)
        }
    }
}


extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 10) {
            Text("This is a title")
                .largeTitle()
            Color.blue
                .frame(maxWidth: 500, maxHeight: 500)
                .watermarked(with: "SwiftUI Training")
            GridStack(rows: 4, columns: 4) { row, col in
                HStack{
                    Image(systemName: "\(row * 4 + col).circle")
                    Text("R\(row), C\(col)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

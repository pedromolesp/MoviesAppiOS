//
//  AutoScroller.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 10/10/24.
//

import Foundation
import SwiftUI

struct AutoScroller: View {
    var movies: [Movie]
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    @State private var selectedImageIndex: Int = 0
    init(movies: [Movie]) {
        self.movies = movies
    }
    
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width

        ZStack {
            Color.secondary
                .ignoresSafeArea()
            
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<movies.count, id: \.self) { index in
                    ZStack(alignment: .topLeading) {
                     
                        AsyncImage(url: URL(string:APIConstants.imageUrl.appending(movies[index].posterPath ?? ""  )))
                        { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.framedAspectRatio(contentMode: .fit)

                                    default:
                                        Image(systemName: "checkmark.rectangle")
                                            .clipped()
                                            .foregroundColor(.white)
                                    }
                                }
                                    .tag(index)
                                   
                    }
                    .shadow(radius: 20)
                }
            }
            .frame(height: 200)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(0..<movies.count, id: \.self) { index in
                            Capsule()
                                .fill(Color.white.opacity(selectedImageIndex == index ? 1 : 0.33))
                                .frame(width: 35, height: 8)
                                .onTapGesture {
                                    selectedImageIndex = index
                                }
                        }
                    }
                    .padding(.horizontal) // Agrega padding para centrar en la pantalla
                }
                .frame(width: screenWidth, height: 20) // Limita la altura del ScrollView y el ancho total
                .offset(y: 130)
                .onChange(of: selectedImageIndex) { newIndex in
                    withAnimation {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.default) {
                selectedImageIndex = (selectedImageIndex + 1) % movies.count
            }
        }            .frame(width:screenWidth,height: 280)

    }
}

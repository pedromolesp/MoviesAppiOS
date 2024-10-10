//
//  PopularMoviesListView.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 13/8/24.
//

import SwiftUI

struct PopularMoviesListView: View {
    private var movies: [Movie]?
    init(movies: [Movie]) {
        self.movies = movies
    }
    var body: some View {
        List {
            ForEach(movies ?? [], id: \.id){
                movie in PopularMoviesItemListView(movie: movie )
                
            }
        }.navigationTitle("Populares")
    }
}

struct PopularMoviesItemListView: View {
    let movie: Movie
    var body: some View {
        if let id = movie.id {
            NavigationLink(destination: DetailView(id: id)) {
                HStack{
                    if let posterPath = movie.posterPath {
                        AsyncImage(url: URL(string: APIConstants.imageUrl.appending(posterPath))){ result in
                            result.image?
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 80)
                    } else {
                        Image(systemName: "photo.artframe").frame(width: 80, height: 50)
                    }
                    Spacer().frame(width: 15)
                    VStack(alignment: .leading) {
                        Text(movie.title ?? "Título desconocido")
                            .font(.headline)
                        Text("Fecha de lanzamiento: \(movie.releaseDate ?? "Fecha desconocida")")
                            .font(.subheadline)
                        if  let voteAverage = movie.voteAverage {
                            
                            Text("Puntuación: \(String(format: "%.2f",voteAverage))")
                                .font(.subheadline)
                        }
                    }.listRowSeparator(.hidden) // Oculta el separador de línea
                        .padding(.vertical, 10)
                }
            }
        }
    }
}

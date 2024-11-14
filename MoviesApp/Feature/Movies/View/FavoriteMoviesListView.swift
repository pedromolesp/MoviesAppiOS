//
//  FavoriteMoviesListView.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 28/8/24.
//

import SwiftUI

struct FavoriteMoviesListView: View {
        private var movies: [SwiftDataMovie]?
        init(movies: [SwiftDataMovie]) {
            self.movies = movies
        }
        var body: some View {
            List {
                ForEach(movies ?? [], id: \.id){
                    movie in FavoriteMoviesItemListView(movie: movie )
                    
                }
            }.navigationTitle("Favoritas")
        }
    }

    struct FavoriteMoviesItemListView: View {
        let movie: SwiftDataMovie
        var body: some View {
            if let id = movie.id {
                NavigationLink(destination: DetailView(id: id, isFavorite: true)) {
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


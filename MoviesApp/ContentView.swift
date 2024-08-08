//
//  ContentView.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 5/8/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = MovieViewModelImpl(
        service: MovieServiceImpl()
    )
    
    var body: some View {
        Group{
            if vm.moviesPage.results?.isEmpty ?? true{
                VStack(spacing: 8) {
                    ProgressView()
                    Text("Obteniendo películas")
                }
            }else{
                List {
                    ForEach(vm.moviesPage.results ?? [], id: \.id){
                        movie in
                        VStack(alignment: .leading) {
                            Text(movie.title ?? "Título desconocido")
                                .font(.headline)
                            Text("Fecha de lanzamiento: \(movie.releaseDate ?? "Fecha desconocida")")
                                .font(.subheadline)
                            Text("Director: \(movie.originalTitle ?? "Director desconocido")")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }.task {
            await vm.getPopularMovies()
        }
        
    }
}


#Preview {
    ContentView()
}

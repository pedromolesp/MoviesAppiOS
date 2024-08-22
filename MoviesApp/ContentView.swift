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
                TabView(selection: .constant(1)) {
                    NavigationView {
                        PopularTabBarView(
                            movies: vm.moviesPage
                        )}.tabItem {
                        VStack {
                            Image(systemName: "movieclapper")
                            Text("Populares")
                                .font(.system(size: 38))
                                .bold()
                        }
                    }.toolbarBackground(
                        Color.white,
                        for: .tabBar).tag(1)
                    
                    Text("Contenido de la 2").tabItem {
                        VStack {
                            Image(systemName: "star")
                            Text("Favoritos")
                                .font(.system(size: 24)) // Aplicar tamaño de fuente aquí
                                .bold()
                        }
                    }.toolbarBackground(
                        Color.white,
                        for: .tabBar).tag(2)
                } .background(Color.white.edgesIgnoringSafeArea(.all))
                
            }.task {
                await vm.getPopularMovies()
            }
    }
}

#Preview {
    ContentView()
}



struct PopularTabBarView: View {
    private var moviesPage: MoviesPage?
    init(movies: MoviesPage) {
        self.moviesPage = movies
    }
    var body: some View {
        if moviesPage?.results?.isEmpty ?? true {
            VStack{
                ProgressView()
                Text("Obteniendo películas")
            }
        }else{
            PopularMoviesListView(
                movies: moviesPage?.results ?? [])}
    }
}

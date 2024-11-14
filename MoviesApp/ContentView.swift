//
//  ContentView.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 5/8/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var localViewModel: LocalViewModel

    @StateObject private var vm: MovieViewModelImpl
    
    @Query var movies: [SwiftDataMovie]
    
    init(modelContext: ModelContext) {
        _vm = StateObject(wrappedValue: MovieViewModelImpl(service: MovieServiceImpl()))
        let localViewModel = LocalViewModel(modelContext: modelContext)
                _localViewModel = State(initialValue: localViewModel)
     }
    
    var body: some View {
        NavigationStack{
            
            TabView(selection: .constant(1)) {
                NavigationView {
                    HomeTabBarView(
                        movies: vm.moviesPage,
                        isLoading: vm.isLoadingMoviesPage
                    )
                }.tabItem {
                    VStack {
                        Image(systemName: "movieclapper")
                        Text("Populares")
                            .font(.system(size: 38))
                            .bold()
                    }
                }.toolbarBackground(
                    Color.white,
                    for: .tabBar).tag(1)
                
                NavigationView {
                    FavoritesTabBarView(movies: movies)
                }.tabItem {
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

struct HomeTabBarView: View {
    private var moviesPage: MoviesPage?
    private var isLoading: Bool
    init(movies: MoviesPage, isLoading:Bool) {
        self.moviesPage = movies
        self.isLoading = isLoading
    }
    
    var body: some View {
        VStack{
            
            if isLoading {
                VStack{
                    ProgressView()
                    Text("Cargando datos...")
                }
            }
            else if moviesPage?.results?.isEmpty ?? true {
                Text("No hay datos")
                
            }else{
                AutoScroller(movies: moviesPage?.results ?? []).padding()
                
                Text("Populares")
                PopularMoviesListView(
                    movies: moviesPage?.results ?? [])
            }
            Spacer()
        }
    }
}

struct FavoritesTabBarView: View {
    private var movies: [SwiftDataMovie]?
    init(movies: [SwiftDataMovie]) {
        self.movies = movies
    }
    
    var body: some View {
        if movies?.isEmpty ?? true {
            VStack{
                Text("No hay datos")
            }
        }else{
          
            FavoriteMoviesListView(movies: movies ?? [])
        }
    }
}

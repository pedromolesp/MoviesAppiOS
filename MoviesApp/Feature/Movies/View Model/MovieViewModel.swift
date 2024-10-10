//
//  MovieViewModel.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 5/8/24.
//

import Foundation
import SwiftData

protocol MovieViewModel: ObservableObject{
    func getPopularMovies() async
    func getMovieById(id: Int) async
}

@MainActor
final class MovieViewModelImpl: MovieViewModel{
    @Published var moviesPage: MoviesPage
    @Published var movieDetail: MovieDetail?



    private let service: MovieService
    @Published var isLoadingMoviesPage = true

    
    init(service: MovieService) {
        self.moviesPage =  MoviesPage.empty
        self.service = service

    }
    
    func getPopularMovies() async {
        do {
            self.moviesPage = try await service.fetchPopularMovies()
            isLoadingMoviesPage = false
        } catch{
            print(error)
        }
    }
    
    func getMovieById(id: Int) async {
        do {
            self.movieDetail = try await service.fetchMovieById(id: id)
        } catch{
            print(error)
        }
    }

}

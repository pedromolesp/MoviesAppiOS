//
//  MovieViewModel.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 5/8/24.
//

import Foundation
protocol MovieViewModel: ObservableObject{
    func getPopularMovies() async
    
}
@MainActor
final class MovieViewModelImpl: MovieViewModel{
    @Published var moviesPage: MoviesPage
    @Published var movieDetail: MovieDetail?
    private let service: MovieService
    
    init(service: MovieService) {
        self.moviesPage =  MoviesPage.empty
        self.service = service
    }
    
    func getPopularMovies() async {
        do {
            self.moviesPage = try await service.fetchPopularMovies()
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

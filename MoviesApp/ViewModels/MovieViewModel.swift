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
}
//
//    func fetchMovies(){
//        let urlString = "https://api.themoviedb.org/3/movie/popular"
//        let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYmU5ZWE2MjlkYzhhYmQyMDM2NDAzYzNkNWExZTBjMiIsIm5iZiI6MTcyMjg1MjgzNC4xNDgyMzIsInN1YiI6IjVkYTVlZTI0Mzg3NjUxMDAxMjVkMjgwNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FvyhhMOS5pXV2fMO_QifBLtDAURabz4z48v8ln_FQf0"
//        if let url = URL(string: urlString) {
//            var request = URLRequest(url: url)
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//                DispatchQueue.main.async {
//                    if let error = error {
//                        // TODO: Handle error
//                        print("Error: \(error.localizedDescription)")
//                    } else {
//                        let decoder = JSONDecoder()
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//                        if let data = data {
//                            do {
//                                let moviesPage = try decoder.decode(MoviesPage.self, from: data)
//
//                                self?.moviesPage = moviesPage
//
//                            } catch let decodingError {
//                                // Handle decoding error
//                                print("Error: No se pudo decodificar los datos - \(decodingError)")
//                                if let jsonString = String(data: data, encoding: .utf8) {
//                                    print("Datos recibidos: \(jsonString)")
//                                }
//                            }
//                        } else {
//                            // TODO: Handle error
//                            print("Datos recibidos: \(String(data: data ?? Data(), encoding: .utf8) ?? "N/A")")
//                            print("Error: No se pudo decodificar los datos")
//                        }
//                    }
//                }
//            }.resume()
//        }
//    }


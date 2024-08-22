//
//  MovieService.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 7/8/24.
//

import Foundation

protocol MovieService {
    func fetchPopularMovies() async throws -> MoviesPage
    func fetchMovieById(id:Int) async throws -> MovieDetail
}

final class MovieServiceImpl: MovieService {
    let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYmU5ZWE2MjlkYzhhYmQyMDM2NDAzYzNkNWExZTBjMiIsIm5iZiI6MTcyMjg1MjgzNC4xNDgyMzIsInN1YiI6IjVkYTVlZTI0Mzg3NjUxMDAxMjVkMjgwNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FvyhhMOS5pXV2fMO_QifBLtDAURabz4z48v8ln_FQf0"
    
    func fetchPopularMovies() async throws -> MoviesPage {
        let urlEndpoint: String = "/movie/popular"
        let urlSesion = URLSession.shared
        guard let url = URL(string: APIConstants.baseUrl.appending(urlEndpoint)) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let (data, response) = try await urlSesion.data(for: request)

        // Verificar el código de estado de la respuesta
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401 {
                print("Error: No autorizado. Verifica tu token de acceso.")
                throw URLError(.userAuthenticationRequired)
            } else if httpResponse.statusCode != 200 {
                print("Error: Código de estado HTTP \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }
        }

        do {
            return try JSONDecoder().decode(MoviesPage.self, from: data)
        } catch let decodingError {
            print("Error: No se pudo decodificar los datos - \(decodingError)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos: \(jsonString)")
            }
            throw decodingError
        }
    }
    
    func fetchMovieById(id: Int) async throws -> MovieDetail {
        let urlEndpoint: String = "/movie/\(id)"
        let urlSesion = URLSession.shared
        guard let url = URL(string: APIConstants.baseUrl.appending(urlEndpoint)) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let (data, response) = try await urlSesion.data(for: request)

        // Verificar el código de estado de la respuesta
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401 {
                print("Error: No autorizado. Verifica tu token de acceso.")
                throw URLError(.userAuthenticationRequired)
            } else if httpResponse.statusCode != 200 {
                print("Error: Código de estado HTTP \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }
        }

        do {
            return try JSONDecoder().decode(MovieDetail.self, from: data)
        } catch let decodingError {
            print("Error: No se pudo decodificar los datos - \(decodingError)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos: \(jsonString)")
            }
            throw decodingError
        }
    }

}

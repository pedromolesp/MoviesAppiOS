//
//  extensions.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 25/9/24.
//
import Foundation
import SwiftData

@Observable
class LocalViewModel {
    var modelContext: ModelContext
    var movies = [SwiftDataMovie]()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func insertMovie(movie: MovieDetail) -> Bool {
        modelContext.insert(SwiftDataMovie(
            adult: movie.adult, backdropPath: movie.backdropPath, genreIDS: movie.genres, id: movie.id, originalLanguage: movie.originalLanguage, originalTitle: movie.originalTitle, overview: movie.overview, popularity: movie.popularity, posterPath: movie.posterPath, releaseDate: movie.releaseDate, title: movie.title, video: movie.video, voteAverage: movie.voteAverage, voteCount: movie.voteCount))
        do {
            try modelContext.save()
            return true
        } catch {
            print("Error al guardar después de eliminar: \(error)")
            return false
        }
    }
}


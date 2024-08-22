//
//  Movie.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 5/8/24.
//

import Foundation

// MARK: - MoviesPage
struct MoviesPage: Codable {
    let page: Int?
    let results: [Movie]?
    let totalPages, totalResults: Int?
    static var empty: MoviesPage {
        return MoviesPage(page: 1,
                          results: [],
                          totalPages: 0,
                          totalResults: 0
        )
    }
}

// MARK: - Movie
struct Movie: Codable {
        let adult: Bool?
        let backdropPath: String?
        let genreIDS: [Int]?
        let id: Int?
        let originalLanguage: OriginalLanguage?
        let originalTitle, overview: String?
        let popularity: Double?
        let posterPath, releaseDate, title: String?
        let video: Bool?
        let voteAverage: Double?
        let voteCount: Int?

        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIDS = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title, video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }
enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case zh = "zh"
    case es = "es"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = OriginalLanguage(rawValue: rawValue) ?? .unknown
    }
}

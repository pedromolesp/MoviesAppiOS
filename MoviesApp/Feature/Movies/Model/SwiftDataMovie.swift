//
//  SwiftDataMovie.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 28/8/24.
//

import Foundation
import SwiftData

@Model
class SwiftDataMovie: Identifiable {
    var adult: Bool?
    @Attribute(.unique) var uuid: UUID?
    var backdropPath: String?
    var genreIDS: [Genre]?
    var id: Int?
    var originalLanguage: OriginalLanguage?
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    
    init(adult: Bool?, backdropPath: String?, genreIDS: [Genre]?, id: Int?, originalLanguage: OriginalLanguage?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?) {
        self.uuid = UUID(uuidString: "\(String(describing: id))")
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    
}

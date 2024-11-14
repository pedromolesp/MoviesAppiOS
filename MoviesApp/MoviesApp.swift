//
//  MoviesAppApp.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 5/8/24.
//
import SwiftUI
import SwiftData

@main
struct MoviesApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }

    init() {
        do {
            container = try ModelContainer(for: SwiftDataMovie.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}

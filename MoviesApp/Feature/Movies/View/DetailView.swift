//
//  DetailView.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 21/8/24.
//

import SwiftUI
import _SwiftData_SwiftUI

struct DetailView: View {
    let id: Int
    let isFavorite: Bool

    @StateObject private var vm: MovieViewModelImpl
    @Environment(\.modelContext) private var modelContext

    init(id: Int, isFavorite:Bool = false) {
        self.id = id
        _vm = StateObject(wrappedValue: MovieViewModelImpl(service: MovieServiceImpl()))
        self.isFavorite = isFavorite
    }
    
    var body: some View {
        Group {
            if let movie = vm.movieDetail {
                DetailBody(movie: movie,isFavorite: isFavorite, modelContext: modelContext)
            } else {
                Text("Cargando...")
            }
        }
        .task {
            // print("Task is running for movie ID: \(id)")
            await vm.getMovieById(id: id)
        }
        
    }
}

#Preview {
    DetailView(id: 533535,isFavorite: true)
}

struct DetailBody: View {
    let movie: MovieDetail
    @State private var localViewModel: LocalViewModel

    @StateObject private var viewModel: MovieViewModelImpl
    let isFavorite:Bool
    @Environment(\.modelContext) private var modelContext

    init(movie: MovieDetail, isFavorite:Bool, modelContext: ModelContext) {
        self.movie = movie
        self.isFavorite = isFavorite
        
        _viewModel = StateObject(wrappedValue: MovieViewModelImpl(service: MovieServiceImpl()))
        let localViewModel = LocalViewModel(modelContext: modelContext)
                _localViewModel = State(initialValue: localViewModel)
    }
    
    
    @Environment(\.presentationMode)private var presentationMode
    @Query var movies: [SwiftDataMovie]

    @State private var isPressed = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                if let backdropPath = movie.backdropPath {
                    AsyncImage(url: URL(string: APIConstants.imageUrl.appending(backdropPath))) { result in
                        result.image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                            .clipped()
                    }
                }
                
                LinearGradient(
                    colors: [.black.opacity(0.2), .black],
                    startPoint: .top,
                    endPoint: .center
                )
                VStack(alignment: .leading){
                    HStack(alignment: .top){
                        if let posterPath = movie.posterPath {
                            AsyncImage(url: URL(string: APIConstants.imageUrl.appending(posterPath))){ result in
                                result.image?
                                    .resizable()
                                
                            }
                            .frame(width: 80, height: 150)
                        } else {
                            Image(systemName: "photo.artframe").frame(width: 80, height: 50)
                        }
                        VStack(alignment: .leading){
                            Text(movie.title ?? "Error al obtener el título")
                                .font(.system(size: 30).bold())
                                .foregroundColor(.white) // Color blanco
                                .shadow(color: .black, radius: 2, x: 0, y: 2)
                            Text(String(format: "Calificación: %.2f%", movie.voteAverage ?? 0.0))
                                .foregroundColor(.white)
                            if let spokenLanguages = movie.spokenLanguages {
                                ForEach(spokenLanguages.indices, id: \.self) { index in
                                    Text(spokenLanguages[index].englishName ?? "Idioma desconocido")
                                        .padding(.trailing, 4).foregroundColor(.white) // Espacio entre los textos
                                    
                                    // Solo agrega la coma si no es el último elemento
                                    if index < spokenLanguages.count - 1 {
                                        Text(", ")
                                            .foregroundColor(.white) // Ajusta el color si es necesario
                                    }
                                }
                            }
                        }.padding(10)
                        
                        Spacer()
                    }
                    Text(movie.overview ?? "Sin información disponible").foregroundColor(.white).padding(.top, 20)
                    Spacer()
                    HStack{
                        Spacer()
                        if isFavorite {
                            Button(action: {
                                if let safeId = movie.id {
                                    deleteMovie(movieID: safeId)
                                }
                                presentationMode.wrappedValue.dismiss()
                                
                            }) {
                                Text("Eliminar de favoritos")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .scaleEffect(isPressed ? 0.95 : 1.0)
                                    .animation(.easeOut(duration: 0.2), value: isPressed)
                            }
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in isPressed = true }
                                    .onEnded { _ in isPressed = false }
                            )
                        }else{
                            Button(action: {
                               let hasBeenDeleted = localViewModel.insertMovie(movie: movie)
                                if hasBeenDeleted {
                                    
                                    presentationMode.wrappedValue.dismiss()

                                }
                                
                            }) {
                                Text("Añadir a favoritos")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .scaleEffect(isPressed ? 0.95 : 1.0)
                                    .animation(.easeOut(duration: 0.2), value: isPressed)
                            }
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in isPressed = true }
                                    .onEnded { _ in isPressed = false }
                            )
                        }
                        Spacer()
                    }
                    Spacer()
                }.padding( 20)
            }
        }
    }
    
    func deleteMovie(movieID: Int) {
        // 1. Buscar la película en el contexto usando su ID
        if let movieToDelete = movies.first(where: { $0.id == movieID }) {
            // 2. Si se encontró la película, la eliminamos del contexto
            modelContext.delete(movieToDelete)
            
            // 3. Guarda los cambios si es necesario
            do {
                try modelContext.save()
                print("Película eliminada exitosamente.")
            } catch {
                print("Error al guardar después de eliminar la película: \(error)")
            }
        } else {
            print("No se encontró la película con el ID proporcionado.")
        }
    }}


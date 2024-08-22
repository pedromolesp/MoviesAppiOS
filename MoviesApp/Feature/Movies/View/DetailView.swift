//
//  DetailView.swift
//  MoviesApp
//
//  Created by Molina Espinosa, Pedro on 21/8/24.
//

import SwiftUI

struct DetailView: View {
    let id: Int
    
    @StateObject private var vm: MovieViewModelImpl
    
    init(id: Int) {
        self.id = id
        _vm = StateObject(wrappedValue: MovieViewModelImpl(service: MovieServiceImpl()))
    }
    
    var body: some View {
        Group {
            if let movie = vm.movieDetail {
                DetailBody(movie: movie)
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
    DetailView(id: 533535)
}

struct DetailBody: View {
    let movie: MovieDetail
    @State private var isPressed = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                if let backdropPath = movie.backdropPath {
                    AsyncImage(url: URL(string: APIConstants.imageUrl.appending(backdropPath))) { result in
                        result.image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.6) // 60% de la altura
                            .clipped() // Asegura que la imagen se recorte correctamente
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
                        
                        Button(action: {
                            print("Button tapped")
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
                        Spacer()
                    }
                    Spacer()
                }.padding( 20)
            }
        }
    }
}


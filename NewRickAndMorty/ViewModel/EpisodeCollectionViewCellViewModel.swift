//
//  EpisodeCollectionViewCellViewModel.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 18.11.2023.
//

import Foundation

/// модель для заполнения данными в ячейку 
final class EpisodeCollectionViewCellViewModel{
    let episodeImageUrl: URL?
    let episodeNumber: String
    
    init(episodeImageUrl: URL?, episodeNumber: String) {
        self.episodeImageUrl = episodeImageUrl
        self.episodeNumber = episodeNumber
    }
   
    public func getImage(complition: @escaping (Result<Data,Error>) -> Void) {
        guard let url = episodeImageUrl else {
            complition(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                complition(.failure(URLError(.badServerResponse)))
                return
            }
            complition(.success(data))
        }.resume()
        
    }
}

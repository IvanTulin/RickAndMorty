//
//  CharacterCollectionViewCellViewModel.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 18.11.2023.
//

import Foundation

/// модель для заполнения данными в ячейку
final class CharacterCollectionViewCellViewModel{
    let characterListImageUrl: URL?
    let characterListName: String
    let characterletGender: CharacterGender
    let characterListStatus: CharacterStatus
    let characterSpecies: String
    let characterOrigin: RMOrigin
    let characterType: String
    let characterLocation: RMLocation
    let characterListNumberEpisode: [String]
    
    init(characterListImageUrl: URL?, characterListName: String, characterletGender: CharacterGender, characterListStatus: CharacterStatus, characterSpecies: String, characterOrigin: RMOrigin, characterType: String, characterLocation: RMLocation, characterListNumberEpisode: [String]) {
        self.characterListImageUrl = characterListImageUrl
        self.characterListName = characterListName
        self.characterletGender = characterletGender
        self.characterListStatus = characterListStatus
        self.characterSpecies = characterSpecies
        self.characterOrigin = characterOrigin
        self.characterType = characterType
        self.characterLocation = characterLocation
        self.characterListNumberEpisode = characterListNumberEpisode
    }
    
    
    public var episodeListStatusText: String {
        return "Status: \(characterListStatus.rawValue)"
    }
    
    public func getImage(complition: @escaping (Result<Data,Error>) -> Void) {
        guard let url = characterListImageUrl else {
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

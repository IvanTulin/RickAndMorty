//
//  ModelCharacter.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 18.11.2023.
//

import Foundation

struct ModelCharacter: Codable, Hashable{
    let info: InfoModel
    let results: [ResultCharacter]
}

struct InfoModel: Codable, Hashable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
    
}

struct ResultCharacter: Codable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let origin: RMOrigin
    let location: RMLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

enum CharacterStatus: String, Codable, Hashable{
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
}

enum CharacterGender: String, Codable, Hashable{
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}
     

struct RMOrigin: Codable, Hashable {
    let name: String
    let url: String
}

struct RMLocation: Codable, Hashable{
    let name: String
    let url: String
}

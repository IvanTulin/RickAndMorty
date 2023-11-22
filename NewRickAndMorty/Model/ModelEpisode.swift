//
//  ModelEpisode.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 18.11.2023.
//

import Foundation

struct ModelEpisode: Codable{
    let info: InfoModelEpisode
    let results: [ResultEpisode]
}

struct InfoModelEpisode: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
    
}

struct ResultEpisode: Codable{
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
}

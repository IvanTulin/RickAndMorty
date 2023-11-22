//
//  TestEpisodeVC.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 20.11.2023.
//

import UIKit

class EpisodeVC: UIViewController {
    
    private let episodeView = EpisodeView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Episode"
        createEpisodeView()
        setDataForTestCharacterDetailsVC()
        
        
    }
    
    
    func setDataForTestCharacterDetailsVC() {
        episodeView.didSelectetItem = { [weak self] urlImage, nameText, genders, status, species, origin, types, location  in
            let detailsVC = CharacterDetailsVC()

            guard let url = urlImage else { return}
            let request = URLRequest(url: url)

            ///загрузка фото
            DispatchQueue.global(qos: .userInteractive).async {
                URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {return}
                    DispatchQueue.main.async {
                        detailsVC.photoProfile.image = UIImage(data: data)
                    }
                }.resume()
            }
            detailsVC.nameLabel.text = nameText
            
            detailsVC.charracterArray.append(genders.rawValue)
            detailsVC.charracterArray.append(status.rawValue)
            detailsVC.charracterArray.append(species)
            detailsVC.charracterArray.append(origin.name)
            detailsVC.charracterArray.append("Unknown")
            detailsVC.charracterArray.append(location.name)

            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    

    func createEpisodeView() {
        view.addSubview(episodeView)
        
        episodeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            episodeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodeView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            episodeView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

}

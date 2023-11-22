//
//  ViewController.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 18.11.2023.
//

import UIKit

final class LaunchScreenVC: UIViewController {
    
    //MARK: -private constants
    private var titleRickAndMortyImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "titleRickAndMorty")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private var loadingImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "loadingImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let rotationSpeed: Double = 3
    
    //MARK: -private properties
    private var timer: Timer?
    private var degree = CGFloat(Double.pi / 180)
    
    //MARK: -Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
        createLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.loadingEpisodeVC()
        }


    }
    
    //MARK: -private methods
    
    
    private func createLoading(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(createAnimation), userInfo: nil, repeats: true)
    }
    
    private func loadingEpisodeVC() {
        let tabBarController = MainTabBarController()
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    @objc func createAnimation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveLinear) {
            self.loadingImage.transform = CGAffineTransformMakeRotation(self.degree)
        } completion: { finished in
            self.degree += CGFloat((Double.pi * self.rotationSpeed) / 180)
        }
    }
    
    private func addConstraints() {
        view.addSubview(titleRickAndMortyImage)
        view.addSubview(loadingImage)
        
        NSLayoutConstraint.activate([
            titleRickAndMortyImage.heightAnchor.constraint(equalToConstant: 104),
            titleRickAndMortyImage.widthAnchor.constraint(equalToConstant: 312),

            titleRickAndMortyImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 97),
            titleRickAndMortyImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 44),
            titleRickAndMortyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loadingImage.heightAnchor.constraint(equalToConstant: 150),
            loadingImage.widthAnchor.constraint(equalToConstant: 150),
            loadingImage.topAnchor.constraint(equalTo: titleRickAndMortyImage.bottomAnchor, constant: 97),
            loadingImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 44),
            loadingImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300)
        
            
        ])
        
    }
    
    
    
}

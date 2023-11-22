//
//  NumberEpisodeAndLikeButtonCell.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 20.11.2023.
//

import UIKit

class NumberEpisodeAndLikeButtonCell: UICollectionViewCell {
    
    //MARK: -Properties
    
    static let cellIdentifier = "cellIdentifierEpisodeAndLikeButtonCell"
    
    public let episodeLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.textColor = .secondaryLabel
        statusLabel.font = .systemFont(ofSize: 16, weight: .medium)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return statusLabel
    }()
    
    private var likeEnabled = false
    
    
    public var heartButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setImage(UIImage(named: "Vector"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: -Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabelAndButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Methods
    
    ///заполнение данными в ячейку из модели Episode
    func configureEpisode(viewModel: EpisodeCollectionViewCellViewModel) {
        
        episodeLabel.text = viewModel.episodeNumber
    }
    
    
    private func setupLabelAndButton() {
        addSubview(episodeLabel)
        addSubview(heartButton)
        
        NSLayoutConstraint.activate([
            episodeLabel.heightAnchor.constraint(equalToConstant: 50),
            heartButton.heightAnchor.constraint(equalToConstant: 50),
            
            episodeLabel.topAnchor.constraint(equalTo: topAnchor),
            episodeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            episodeLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            heartButton.topAnchor.constraint(equalTo: topAnchor),
            heartButton.leftAnchor.constraint(equalTo: episodeLabel.rightAnchor, constant: 150),
            heartButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -19),
            heartButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
       
        episodeLabel.layer.cornerRadius = 8
        heartButton.addTarget(self, action: #selector(animationHeartBurron), for: .touchUpInside)
    }
    
    @objc func animationHeartBurron(){

        if likeEnabled {
            heartButton.setImage(UIImage(named: "Vector"), for: .normal)
        } else {
            heartButton.setImage(UIImage(named: "VectorFill"), for: .normal)
        }
        likeEnabled = !likeEnabled
        
        
        let scale = CGFloat(10)
        
        ///анимация нажатия на heartButton
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5,
                           delay: 0,
                           usingSpringWithDamping: 0.1,
                           initialSpringVelocity: 0.5) {[weak self] in
                guard let self = self else {return}
                self.heartButton.frame = CGRect(x: self.heartButton.frame.origin.x - scale / 2,
                                                    y: self.heartButton.frame.origin.y - scale / 2,
                                                    width: self.heartButton.frame.width + scale,
                                                    height: self.heartButton.frame.height + scale)
            }
        }
        
        
        
    }
    
}

//
//  CharacterCollectionViewCell.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 18.11.2023.
//

import UIKit

///протокол для обработки нажатия на image
protocol CharacterCellDelegate: AnyObject {
    func didTapPhoto(in cell: CharacterCollectionViewCell)
}


///представление для создание и настройка ячейки
class CharacterCollectionViewCell: UICollectionViewCell {
    
    //MARK: -Properties
    weak var delegate: CharacterCellDelegate?
    
    static let cellIdentifier = "cellIdentifier"
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    public let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .label //черный или белый цвет в зависимости от цветовой темы
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    public let episodeNumbreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.backgroundColor = .systemGray4
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(episodeNumbreLabel)
        contentView.addSubview(heartButton)
        insertSubview(heartButton, aboveSubview: episodeNumbreLabel)

        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.borderWidth = 2
        
        //setupTapGesture()

        createConstraints()
        setupUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
       // heartButton.setImage(UIImage(named: "Vector"), for: .normal)
    }
    
    //MARK: - Add Layout and Constraints
    
    
    private func setupUpLayout(){
        //contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
        //contentView.layer.shadowOpacity = 0.3
    }
    
    private func createConstraints() {
        //episodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            //nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            episodeNumbreLabel.heightAnchor.constraint(equalToConstant: 50),
            heartButton.heightAnchor.constraint(equalToConstant: 50),
            heartButton.widthAnchor.constraint(equalToConstant: 50),
            
            episodeNumbreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            episodeNumbreLabel.leftAnchor.constraint(equalTo: leftAnchor),
            episodeNumbreLabel.rightAnchor.constraint(equalTo: rightAnchor),
            episodeNumbreLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            heartButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            heartButton.leftAnchor.constraint(equalTo: rightAnchor, constant: 170),
            heartButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -19),
            heartButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
        
        episodeNumbreLabel.layer.cornerRadius = 8
       
        
        heartButton.addTarget(self, action: #selector(animationHeartBurron), for: .touchUpInside)
    }
    
    //MARK: - Create Animation Button
    
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
    

    //MARK: - Configure
    ///заполнение данными в ячейку
    func configure(viewModel: CharacterCollectionViewCellViewModel) {
        
        nameLabel.text = viewModel.characterListName
        
        viewModel.getImage {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
    
    ///заполнение данными в ячейку из модели Episode
    func configureEpisode(viewModel: EpisodeCollectionViewCellViewModel) {
        episodeNumbreLabel.text = viewModel.episodeNumber
    }
}

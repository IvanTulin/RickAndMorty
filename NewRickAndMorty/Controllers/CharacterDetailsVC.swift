//
//  CharacterDetailsVC.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 20.11.2023.
//

import UIKit

class CharacterDetailsVC: UIViewController {

    //MARK: -Properties
    
    public var photoProfile: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "loadingImage")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 84
        image.layer.borderWidth = 4
        image.layer.borderColor = UIColor.systemGray4.cgColor
        
        return image
    }()
   
   private var changePhotoButton: UIButton = {
       let button = UIButton()
       button.setImage(UIImage(named: "Camera"), for: .normal)
       button.isEnabled = true
       button.translatesAutoresizingMaskIntoConstraints = false
       
       return button
   }()
   
    public var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
   
    private var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Informations"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = #colorLiteral(red: 0.5568621755, green: 0.5568631887, blue: 0.5783511996, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    ///массив для наполнения tableView
    public var charracterArray = [String]()
   
   private let tableView = UITableView()
    
    //MARK: -Life Cicle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllElement()
        castomizationNavigationBar()
        
    }
    

    //MARK: -Methods
    
    ////кастомизация navigationBar
    private func castomizationNavigationBar() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-black")
        
        let backButton = UIBarButtonItem()
        backButton.title = "GO BACK"
        let font = UIFont.systemFont(ofSize: 18, weight: .bold)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imageView)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
    }
     
    func setupAllElement() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundColor = .systemBlue
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        tableView.dataSource = self
        
        view.addSubview(photoProfile)
        view.addSubview(changePhotoButton)
        view.addSubview(nameLabel)
        view.addSubview(informationLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            photoProfile.heightAnchor.constraint(equalToConstant: 165),
            photoProfile.widthAnchor.constraint(equalToConstant: 165),
            photoProfile.topAnchor.constraint(equalTo: view.topAnchor, constant: 124),
            photoProfile.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 108),
            photoProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            changePhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 190),
            changePhotoButton.leftAnchor.constraint(equalTo: photoProfile.rightAnchor, constant: 4),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 50),
            changePhotoButton.widthAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: photoProfile.bottomAnchor, constant: 30),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 32),
            nameLabel.widthAnchor.constraint(equalToConstant: 314),
            
            informationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 17),
            informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -200),
            informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            informationLabel.heightAnchor.constraint(equalToConstant: 24),
            informationLabel.widthAnchor.constraint(equalToConstant: 117),
            
            tableView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 12),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 384),
            tableView.widthAnchor.constraint(equalToConstant: 312)
        ])
    }

}

//MARK: -Extension UITableViewDataSource

extension CharacterDetailsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return charracterArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
           return "Gender"
        case 1:
            return "Status"
        case 2:
            return "Spiecies"
        case 3:
            return "Origin"
        case 4:
            return "Type"
        case 5:
            return "Location"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") else {fatalError("Cell not found" )}
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = charracterArray[indexPath.section]
        case 1:
            cell.textLabel?.text = charracterArray[indexPath.section]
        case 2:
            cell.textLabel?.text = charracterArray[indexPath.section]
        case 3:
            cell.textLabel?.text = charracterArray[indexPath.section]
        case 4:
            cell.textLabel?.text = charracterArray[indexPath.section]
        case 5:
            cell.textLabel?.text = charracterArray[indexPath.section]
        default:
            cell.textLabel?.text = "nil"
        
        }
        
        return cell
    }
}

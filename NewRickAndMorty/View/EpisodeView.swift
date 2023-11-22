//
//  EpisodeView.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 20.11.2023.
//

import Foundation
import UIKit

final class EpisodeView: UIView {
    
    //MARK: - properties
    
    ///клоужер для захвата значения и передачи данных в CharacterDetailsVC
    public var didSelectetItem: ((_ chrImageURL: URL?,
                                  _ chrNames: String,
                                  _ chrGenders: CharacterGender,
                                  _ chrStatus: CharacterStatus,
                                  _ chrSpecies: String,
                                  _ chrOrigin: RMOrigin,
                                  _ chrType: String,
                                  _ chrLocation: RMLocation) -> Void)?
    
    ///кеш
    lazy var cachedDataSource: NSCache<AnyObject, UIImage> = {
        
        let cache =  NSCache<AnyObject, UIImage>()
        
        return cache
    }()
    
    var filteredSeries: [EpisodeCollectionViewCellViewModel] = {
        let filteredArray = [EpisodeCollectionViewCellViewModel]()
        
        return filteredArray
    }()
    
    private var titleRickAndMortyImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "titleRickAndMorty")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let searchTextField: UITextField = {
        let searchText = UITextField ()
        searchText.attributedPlaceholder = NSAttributedString(string: "     Name or episode", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.systemGray,
        ])
        searchText.textColor = .systemGray
        searchText.tintColor = .systemGray
        searchText.backgroundColor = .white
        searchText.layer.cornerRadius = 8
        searchText.layer.borderColor = UIColor.gray.cgColor
        searchText.layer.borderWidth = 1
        searchText.translatesAutoresizingMaskIntoConstraints = false
        
        
        return searchText
    }()
    
    
    private var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADVANCHED FILTERS", for: .normal)
        button.isEnabled = true
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 14)
        button.backgroundColor = #colorLiteral(red: 0.8909153342, green: 0.9509342313, blue: 0.9928193688, alpha: 1)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    
    private var collectionView: UICollectionView!
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addConstraints()
        searchTextField.delegate = self
        
        fetchEpisode()
        fetchCharacters()
        
        addLefrImageTo(textField: searchTextField, img: .init(systemName: "magnifyingglass")!)
        deleteLeftSwipe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods Request
    
    ///создаем изменяемый массив в котором проходим по всем свойствам ResultCharacter и добавляем значения в массив cellViewModels
    private var resultCharacter: [ResultCharacter] = [] {
        didSet {
            for character in resultCharacter {
                let viewModel = CharacterCollectionViewCellViewModel(
                    characterListImageUrl: URL(string: character.image),
                    characterListName: character.name,
                    characterletGender: character.gender,
                    characterListStatus: character.status,
                    characterSpecies: character.species,
                    characterOrigin: character.origin,
                    characterType: character.type,
                    characterLocation: character.location,
                    
                    characterListNumberEpisode: character.episode
                )
                
                cellViewModelsCharacter.append(viewModel)
            }
        }
    }
    
    private var cellViewModelsCharacter: [CharacterCollectionViewCellViewModel] = []
    
    
    ///for Episode
    private var resultEpisode: [ResultEpisode] = [] {
        didSet {
            for episode in resultEpisode {
                let viewModel = EpisodeCollectionViewCellViewModel(episodeImageUrl: URL(string: episode.characters[0]), episodeNumber: episode.episode)
                
                cellViewModelsEpisode.append(viewModel)
            }
        }
    }
    
    private var cellViewModelsEpisode: [EpisodeCollectionViewCellViewModel] = []
    
    
    
    private let requestEpisode = RMRequest(endPoint: .episode)
    private let requestCharacter = RMRequest(endPoint: .character)
    
    /// получаем json и далее извлекаем данные в массив resultCharacter
    func fetchCharacters() {
        ServiceRM.shared.execute(requestCharacter, expecting: ModelCharacter.self) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self.resultCharacter = results
                print("---------fetchCharacters---------")
                print(self.resultCharacter.count)
                
            case .failure(let error):
                print(String(describing: error))
                
            }
        }
    }
    
    /// получаем json и далее извлекаем данные в массив requestEpisode
    func fetchEpisode() {
        ServiceRM.shared.execute(requestEpisode, expecting: ModelEpisode.self) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self.resultEpisode = results
                print("---------fetchCharacters---------")
                
            case .failure(let error):
                print(String(describing: error))
                
            }
        }
    }
    
    
    //MARK: - Private methods
    
    private func  addLefrImageTo(textField: UITextField, img: UIImage) {
        let leftImageView = UIImageView(frame:  CGRect(x: 10, y: 0, width: img.size.width, height: img.size.height))
        ///создаем myView, чтобы поместить туда картинку нашу и задать отсупы от текста
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: img.size.height))
        myView.addSubview(leftImageView)
        leftImageView.image = img
        textField.leftView = myView
        textField.leftViewMode = .always
    }
    
    ///метоля удаления ячейки по свайпу влево
    private func deleteLeftSwipe() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        collectionView.addGestureRecognizer(swipeLeftGesture)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            let point = sender.location(in: collectionView)
            
            if let indexPath = collectionView.indexPathForItem(at: point) {
                cellViewModelsCharacter.remove(at: indexPath.item)
                collectionView.deleteItems(at: [indexPath])
            }
        }
    }
    
    private func addConstraints() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.layer.cornerRadius = 8
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleRickAndMortyImage)
        addSubview(searchTextField)
        addSubview(filterButton)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleRickAndMortyImage.heightAnchor.constraint(equalToConstant: 104),
            titleRickAndMortyImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleRickAndMortyImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            titleRickAndMortyImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.topAnchor.constraint(equalTo: titleRickAndMortyImage.bottomAnchor, constant: 30),
            searchTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            searchTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            filterButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            filterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        ///регестрируем ячейку и задаем делегаты
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier)
        collectionView.register(NumberEpisodeAndLikeButtonCell.self, forCellWithReuseIdentifier: NumberEpisodeAndLikeButtonCell.cellIdentifier)
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        //collectionView.isPagingEnabled = true
        
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //задаем расстояние между каждой ячейкой (при горизонтальном скролле)
        layout.minimumLineSpacing = 55
        
        ///настройки для секции
        //layout.minimumLineSpacing = 0
        //layout.sectionInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        
        //layout.itemSize = .init(width: 300, height: 250)
        // растягиваются по высоте и длине нашей ячекйи
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        //layout.minimumInteritemSpacing = 70
        return layout
    }
    
    
    
}


//MARK: - Extension UITextFieldDelegate

extension EpisodeView: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updateText = (text as NSString).replacingCharacters(in: range, with: string)
            
            filterContentForSearchText(updateText)
        }
        return true
    }
    
    /// функция для фильтрации данных на основе введенного текста в поле поиска
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            // если поле поиска пустое отобразить все серии
            filteredSeries = cellViewModelsEpisode
        } else {
            
            filteredSeries = cellViewModelsEpisode.filter({
                $0.episodeNumber.lowercased().contains(searchText.lowercased())
            })
        }
        collectionView.reloadData()
    }
    
    
}


//MARK: - Extension for UICollectionView

extension EpisodeView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    ///решение для секций
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return filteredSeries.count
//        return cellViewModelsEpisode.count
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return filteredSeries.count
        return cellViewModelsCharacter.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        ///создаем ячейку
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell else {fatalError("Cell not Found")}
        //cell.delegate = self

        
        ///кешируем UIimage
        if let image = cachedDataSource.object(forKey: indexPath.row as AnyObject) {
            ///наполняем данными из кеша
            cell.imageView.image = image

        } else {
            ///наполняем данными если ее нет в кеше
            let viewModelCharacter = cellViewModelsCharacter[indexPath.row]
            
            viewModelCharacter.getImage {[weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {return}
                        let image = UIImage(data: data)
                        cell.imageView.image = image
                        
                        collectionView.reloadItems(at: [indexPath] )
                        self.cachedDataSource.setObject(image!, forKey: indexPath.row as AnyObject)
                    }
                case .failure(let error):
                    print(String(describing: error))
                    break
                }
            }
        }
        
        
        
        let viewModelCharacter = cellViewModelsCharacter[indexPath.row]
        cell.configure(viewModel: viewModelCharacter)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        cell.imageView.addGestureRecognizer(tapGesture)
        cell.imageView.isUserInteractionEnabled = true
        
        let viewModelEpisode = cellViewModelsEpisode[indexPath.row]
        cell.configureEpisode(viewModel: viewModelEpisode)
        
        
//        let series = filteredSeries[indexPath.row]
//        cell.configureEpisode(viewModel: series)
        

        return cell
        
        ///Решение для секций
//        switch indexPath.row {
//        case 0:
//            ///создаем ячейку
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell else {fatalError("Cell not Found")}
//            //cell.delegate = self
//
//            ///наполняем данными
//            let viewModelCharacter = cellViewModelsCharacter[indexPath.section]
//            cell.configure(viewModel: viewModelCharacter)
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
//            cell.imageView.addGestureRecognizer(tapGesture)
//            cell.imageView.isUserInteractionEnabled = true
//
//            return cell
//        case 1:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberEpisodeAndLikeButtonCell.cellIdentifier, for: indexPath) as? NumberEpisodeAndLikeButtonCell else {fatalError("Cell not Found")}
//
//            let viewModelEpisode = cellViewModelsEpisode[indexPath.section]
//            cell.configureEpisode(viewModel: viewModelEpisode)
//            cell.backgroundColor = .systemGray4
//
////            let series = filteredSeries[indexPath.section]
////            cell.configureEpisode(viewModel: series)
//
//            return cell
//
//        default:
//            return UICollectionViewCell()
//
//        }
        
    }
    
    ///метод который захватывает значения по нажатию на UIImage
    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        print("Tap")
        guard let collectionView = collectionView, let indexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)) else {return}
        
        let item = cellViewModelsCharacter[indexPath.row]
        
        didSelectetItem?(
            item.characterListImageUrl,
            item.characterListName,
            item.characterletGender,
            item.characterListStatus,
            item.characterSpecies,
            item.characterOrigin,
            item.characterType,
            item.characterLocation )
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 312
                    let height = 380
        
                    return CGSize(width: width, height: height )
        
        
        ///настройка ячеек для секций
//        switch indexPath.row {
//        case 0:
//            let width = 312
//            let height = 380
//
//            return CGSize(width: width, height: height )
//        case 1:
//            let width = 312
//            let height = 70
//
//            return CGSize(width: width, height: height )
//        default:
//            return CGSize(width: 300, height: 100 )
//        }
        
        
    }
}

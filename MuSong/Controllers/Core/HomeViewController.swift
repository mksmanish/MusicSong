//
//  ViewController.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import UIKit

enum BrowseSectionType {
    case newReleases //1
    case featuredPlatlists//2
    case recommendedTracks//3
}
class HomeViewController: UIViewController {
    
    private let collectonview:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ in
        HomeViewController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTappedSettings))
        
        configureCollectionView()
        view.addSubview(spinner)
        fetchdata()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectonview.frame = view.bounds
        
    }
    
    private func configureCollectionView() {
        view.addSubview(collectonview)
        collectonview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectonview.dataSource = self
        collectonview.delegate = self
        collectonview.backgroundColor = .systemBackground
        
    }
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            // items
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                    heightDimension: .absolute(390)), subitem: item, count: 3)
            
            let HorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                                                                        heightDimension: .absolute(390)), subitem: verticalGroup, count: 1)
            // secction
            let section = NSCollectionLayoutSection(group: HorizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        case 1:
            // items
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                                                 heightDimension: .absolute(400)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
           
            // group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                                                                    heightDimension: .absolute(400)), subitem: item, count: 2)
            
            
            let HorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                                                                        heightDimension: .absolute(400)), subitem: verticalGroup, count: 1)
            // secction
            let section = NSCollectionLayoutSection(group: HorizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
            
        case 2:
            // items
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                    heightDimension: .absolute(80)), subitem: item, count: 1)
            
         
            // secction
            let section = NSCollectionLayoutSection(group: verticalGroup)
  
            
            return section
            
        default:
            // items
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
            
            let HorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                                                                        heightDimension: .absolute(390)), subitem: item, count: 1)
            // secction
            let section = NSCollectionLayoutSection(group: HorizontalGroup)

            
            return section
        }
    }
    
    private func fetchdata() {
        //fetuured playlist ,recommemded tracks,new release
        APICaller.shared.getrecommendationsGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { _ in
                    //
                }
                //
                
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
        //        APICaller.shared.getFeaturedPlaylists { result in
        //            switch result
        //            {
        //              case .success(let model):
        //
        //                print(model.playlist[0].owner)
        //            case .failure(let error):
        //                print(error.localizedDescription)
        //
        //            }
        //
        //        }
        
    }
    
    @objc func didTappedSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension HomeViewController :UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.section == 0{
            cell.backgroundColor = .systemGreen
        }else if indexPath.section == 1{
            cell.backgroundColor = .systemPink
        }else if indexPath.section == 2{
            cell.backgroundColor = .systemBlue
        }
       
        return cell
    }
}

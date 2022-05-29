//
//  ViewController.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels:[NewReleasesCellViewModel]) //1
    case featuredPlatlists(viewModels:[FeaturedPlaylistCellViewModel])//2
    case recommendedTracks(viewModels:[RecommenededTrackCellViewModel])//3
    
    var title: String {
        switch self {
        case .newReleases:
            return "New Releases Songs"
        case .featuredPlatlists:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended Tracks"
        }
    }
}
class HomeViewController: UIViewController {
    
    private var newAlbum: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks : [AudioTrack] = []
    
    private let collectonview:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ in
        HomeViewController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    
    private var sections = [BrowseSectionType]()
    
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
        collectonview.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectonview.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectonview.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectonview.register(TitleHeaderCollectionReusableView.self,
                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                               withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectonview.dataSource = self
        collectonview.delegate = self
        collectonview.backgroundColor = .systemBackground
        
    }
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
       let supplementryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(70)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        
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
            section.boundarySupplementaryItems = supplementryViews
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
            section.boundarySupplementaryItems = supplementryViews
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
            section.boundarySupplementaryItems = supplementryViews
            
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
            section.boundarySupplementaryItems = supplementryViews
            
            return section
        }
    }
    
    private func fetchdata() {
        //fetuured playlist ,recommemded tracks,new release
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases : NewReleaseResponse?
        var featurePlaylist: FeaturedPlaylistsResponse?
        var recommendedTrack : RecommendationsResponse?
        
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featurePlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
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
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult
                    {
                    case .success(let model):
                        recommendedTrack  = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
              
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                    let playlists = featurePlaylist?.playlists.items,
                    let tracks = recommendedTrack?.tracks else {return}
            
            self.configureModels(newAlbum: newAlbums, playlists: playlists, tracks: tracks)
        }
      
    }
    
    private func configureModels(newAlbum:[Album],playlists:[Playlist],tracks:[AudioTrack]){
        // congiures models
        
       
        self.newAlbum = newAlbum
        self.playlists = playlists
        self.tracks = tracks
        sections.append(.newReleases(viewModels: newAlbum.compactMap({
            return NewReleasesCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.featuredPlatlists(viewModels: playlists.compactMap{
            return FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), createName: $0.owner.display_name)
        }))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap{
            return RecommenededTrackCellViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "-", artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
        }))
        collectonview.reloadData()
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
        let type = sections[section]
        switch type {
        case .newReleases(viewModels: let viewModels):
            return viewModels.count
        case .featuredPlatlists(viewModels: let viewModels):
            return viewModels.count
        case .recommendedTracks(viewModels: let viewModels):
            return viewModels.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else {
               return UICollectionViewCell()
                
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            cell.backgroundColor = .systemRed
            return cell
        case .featuredPlatlists(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else { return UICollectionViewCell()}
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
         //   cell.backgroundColor = .systemBlue
            return cell
        case .recommendedTracks(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {return UICollectionViewCell()}
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
        //    cell.backgroundColor = .systemOrange
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        
        switch section {
        case .newReleases:
            let album = newAlbum[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .featuredPlatlists:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView else {return UICollectionReusableView() }
        let section = indexPath.section
        let model = sections[section].title
        header.configure(with:model)
        return header
    }
}

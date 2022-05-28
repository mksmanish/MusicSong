//
//  ViewController.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTappedSettings))
        fetchdata()
    }
    
    private func fetchdata() {
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


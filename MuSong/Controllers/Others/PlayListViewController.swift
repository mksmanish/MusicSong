//
//  PlayListViewController.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import UIKit

class PlayListViewController: UIViewController {

    private let playlist: Playlist
    
    init(playlist : Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = playlist.name
        view.backgroundColor = .systemBackground
        fetchdata()
    }
    
    private func fetchdata() {
        APICaller.getPlaylist(for: playlist) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }

}

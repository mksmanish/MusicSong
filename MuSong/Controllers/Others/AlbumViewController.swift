//
//  AlbumViewController.swift
//  MuSong
//
//  Created by Tradesocio on 29/05/22.
//

import UIKit

class AlbumViewController: UIViewController {

    private let album: Album
    
    init(album : Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = album.name
        view.backgroundColor = .systemBackground
        fetchdata()
    }
    
    private func fetchdata() {
        APICaller.getAlbum(for: album) { result in
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

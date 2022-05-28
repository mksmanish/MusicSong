//
//  ProfileViewController.swift
//  MuSong
//
//  Created by Tradesocio on 26/05/22.
//

import UIKit

class ProfileViewController: UIViewController {

    
    private let tableView:UITableView = {
        let tableview = UITableView()
        tableview.isHidden = true
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchProfile()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        navigationItem.title = "Profile"
        view.backgroundColor = .systemBackground
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    private func fetchProfile()  {
        APICaller.shared.getCurrentUserProfile {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.failedToGetProfile()
                }
            }
        }
    }
    
    private func updateUI(with modol :UserProfile) {
        tableView.isHidden = false
        // configure table models
        models.append("FullName: \(modol.display_name)")
        models.append("Country: \(modol.country)")
        models.append("Email Address: \(modol.email)")
        models.append("User ID: \(modol.id)")
        models.append("Plan: \(modol.product)")
        tableView.reloadData()
    }
    
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    

}
// MARK: - tableview datasource and delegates
extension ProfileViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
   
    
    
}

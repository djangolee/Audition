//
//  RootViewController.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/4.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit
import JoUIKit
import SnapKit

class RootViewController: UIViewController {
    
    private let tableView = UITableView()
    
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.jo.dequeueReusableCell(UITableViewCell.self)!
        cell.imageView?.image = UIImage(named: "mp3")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

//MARK: Setup UI

extension RootViewController {
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()
        title = "Audition"
    }
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        
        setupTableView()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.jo.register(cell: UITableViewCell.self)
        view.addSubview(tableView)
    }
    
}

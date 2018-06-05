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
    private var source = [FileManager.FileInfo]()
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.jo.dequeueReusableCell(UITableViewCell.self)!
        let file = source[indexPath.item]
        cell.textLabel?.text = file.name
        cell.imageView?.image = file.fileIcon
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
}

//MARK: Setup UI

extension RootViewController {
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()
        title = "Audition"
        source = FileManager.default.scanAudio() ?? []
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

//
//  LibraryViewController.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/7.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class LibraryNavigationController: UINavigationController {
    
    private let audioTabbar = AudioTabbar()
    
    init() {
        let roor = LibraryViewController.init(FileManager.default.scan() ?? [], title: "Documents")
        super.init(rootViewController: roor)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()
        navigationBar.prefersLargeTitles = true
    }
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupAudioTabbar()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        
        let height = view.safeAreaInsets.bottom + AudioTabbar.TabBarHeight
        additionalSafeAreaInsets.bottom += AudioTabbar.TabBarHeight
        
        audioTabbar.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottomMargin.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(height)
        }
    }
    
    private func setupAudioTabbar() {
        audioTabbar.contentView.jo.setSeparator(.top)
        view.addSubview(audioTabbar)
    }
}


private class LibraryViewController: UIViewController {

    private let source: [FileManager.FileInfo]
    
    private let tableView = UITableView()
    private var selectedIndexPath: IndexPath?
    
    init(_ files: [FileManager.FileInfo], title: String) {
        source = files
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = navigationController?.viewControllers.first == self ? .automatic : .never
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.jo.dequeueReusableCell(LibraryTableViewCell.self) as! LibraryTableViewCell
        let file = source[indexPath.item]
        cell.render(file)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? LibraryTableViewCell
            else { return }

        cell.setSelected(false, animated: true)
        
        if let selectedIndexPath = selectedIndexPath,
            let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? LibraryTableViewCell {
            selectedCell.playControl.isHidden = true
        }

        let file = source[indexPath.item]
        if let source = file.contentsOfDirectory(), source.count > 0 {
            navigationController?.pushViewController(LibraryViewController(source, title: file.name), animated: true)
        } else if file.isSound {
            selectedIndexPath = indexPath
            cell.playControl.isHidden = false
        }
    }
}

//MARK: Setup UI

extension LibraryViewController {
    
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
        tableView.separatorStyle = .none
        tableView.jo.register(cell: LibraryTableViewCell.self)
        view.addSubview(tableView)
    }
    
}

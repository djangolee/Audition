//
//  LibraryTableViewCell.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/7.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit
import JoUIKit
import SnapKit

class LibraryTableViewCell: UITableViewCell {
    
    var file: FileManager.FileInfo?
    
    //MARK: Subviews
    
    internal let iconImageView = UIImageView()
    internal let fileNameLable = UILabel()
    internal let describeLabel = UILabel()
    
    public func render(_ file: FileManager.FileInfo) {
        self.file = file
        iconImageView.image = file.fileIcon
        fileNameLable.text = file.name
    }
}

//MARK: Load View

extension LibraryTableViewCell {
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        
        setupIconImageView()
        setupLabel()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        
        iconImageView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(44)
            maker.leading.equalToSuperview().offset(18)
            maker.centerY.equalToSuperview()
        }
        
        fileNameLable.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView.snp.centerY).offset(3)
            maker.leading.equalTo(iconImageView.snp.trailing).offset(10)
            maker.trailing.equalToSuperview().inset(15)
        }
        
        describeLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(fileNameLable)
            maker.top.equalTo(fileNameLable.snp.bottom).offset(2)
        }
    }
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()
        jo.setSeparator(.bottom)
        jo.setSeparatorBottomlineCorner(JoViewSeparatorCorner(top: 0, leading: 44 + 20, bottom: 0, trailing: 0, thickness: UIScreen.main.jo.apixel), animated: true)
    }
    
    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFill
        contentView.addSubview(iconImageView)
    }
    
    private func setupLabel() {
        fileNameLable.textColor = .black
        fileNameLable.font = .systemFont(ofSize: 14)
        contentView.addSubview(fileNameLable)
        
        describeLabel.textColor = .lightGray
        describeLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(describeLabel)
    }
    
}

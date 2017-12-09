//
//  ArticleTableViewCell.swift
//  journal-ios
//
//  Created by riverciao on 2017/12/8.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.bounds = CGRect(x: 0, y: 0, width: 335, height: 140)
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupTitleLabel()
        setupPictureImageView()

        
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19.8).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 315).isActive = true
        titleLabel.heightAnchor.constraint(equalTo:(textLabel?.heightAnchor)!).isActive = true
    }
    
    private func setupPictureImageView() {
        addSubview(pictureImageView)
        
        pictureImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pictureImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        pictureImageView.widthAnchor.constraint(equalToConstant: 335).isActive = true
        pictureImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

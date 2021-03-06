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
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        // color slate
        label.textColor = UIColor(r: 67, g: 87, b: 97)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // add shadow in roundedView view instead of in pictureImageView
    let roundedView: UIView = {
        let view = UIView()
        // coolGrey
        view.layer.shadowColor = UIColor(r: 171, g: 179, b: 176).cgColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        addSubview(roundedView)
        roundedView.addSubview(pictureImageView)
        
        // layout
        roundedView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        roundedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        roundedView.widthAnchor.constraint(equalToConstant: 335).isActive = true
        roundedView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        
        pictureImageView.centerXAnchor.constraint(equalTo: roundedView.centerXAnchor).isActive = true
        pictureImageView.centerYAnchor.constraint(equalTo: roundedView.centerYAnchor).isActive = true
        pictureImageView.widthAnchor.constraint(equalTo: roundedView.widthAnchor).isActive = true
        pictureImageView.heightAnchor.constraint(equalTo: roundedView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

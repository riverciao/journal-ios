//
//  ArticleTableViewCell.swift
//  journal-ios
//
//  Created by riverciao on 2017/12/8.
//  Copyright © 2017年 riverciao. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    var publishDateLabel = UILabel()
    var authorLabel = UILabel()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        
        publishDateLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(publishDateLabel)
        contentView.addSubview(authorLabel)

        
        authorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
        authorLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        publishDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2).isActive = true
        publishDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        publishDateLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        publishDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

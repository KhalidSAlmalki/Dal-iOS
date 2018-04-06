//
//  SectionLayoutCell.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Parchment
import Kingfisher
class SectionPagingCell: PagingCell {
    private var options: PagingOptions?

    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.black
        label.textAlignment = .center

        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        // x,y , h, w
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func updateSelectedState(selected: Bool) {
        guard let options = options else { return }
        if selected {
            titleLabel.textColor = options.selectedTextColor
            imageView.tintColor = options.selectedTextColor
        } else {
            titleLabel.textColor = options.textColor
            imageView.tintColor = options.textColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        self.options = options

         let item = pagingItem as? sectionItem

 
            self.titleLabel.text = item?.title
//            let url = URL(string:(item?.logoURL)!)
//                self.imageView.kf.setImage(with: url)



    }

    
}

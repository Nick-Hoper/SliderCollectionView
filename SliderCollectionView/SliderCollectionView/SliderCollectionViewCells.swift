//
//  SliderCollectionViewCells.swift
//  SliderCollectionView
//
//  Created by Nick luo on 2018/12/17.
//  Copyright © 2018 Nick luo. All rights reserved.
//

import UIKit

class SliderCollectionViewCells: UICollectionViewCell {

    /// 文字
    var titleLable: UILabel
    
    override init(frame: CGRect) {
        
        titleLable = UILabel()
        super.init(frame: frame)
        
        self.titleLable.numberOfLines = 2
        self.titleLable.font = UIFont.systemFont(ofSize: 14)
        self.titleLable.textColor = UIColor.darkGray
        self.titleLable.textAlignment = .center
        contentView.addSubview(self.titleLable)
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLable.frame = CGRect(x: 0, y: 0,
                                  width: self.frame.width, height: 44)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//
//  GGirlCollectionViewCell.swift
//  Girls
//
//  Created by 张如泉 on 16/3/30.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit

class GGirlCollectionViewCell: UICollectionViewCell {

    var girlsImageView = UIImageView()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {

        addSubview(girlsImageView)
        girlsImageView.frame = bounds
        girlsImageView.contentMode = .scaleAspectFit
    }

}

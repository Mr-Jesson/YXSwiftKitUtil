//
//  YXKitLoggerMenuCollectionViewCell.swift
//  YXSwiftKitUtil_Example
//
//  Created by Mr_Jesson on 2022/3/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

struct YXKitLoggerMenuCollectionViewCellModel {
    var title = ""
    var image: UIImage?

}

class YXKitLoggerMenuCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self._createUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updateUI(model: YXKitLoggerMenuCollectionViewCellModel) {
        self.mTitleLabel.text = model.title
        self.mImageView.image = model.image
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textAlignment = NSTextAlignment.center
        tLabel.numberOfLines = 1
        tLabel.font = UIFont.systemFont(ofSize: 13)
        tLabel.textColor = UIColor.yx.color(hexValue: 0xffffff)
        return tLabel
    }()

    lazy var mImageView: UIImageView = {
        let tImageView = UIImageView()
        return tImageView
    }()

}

private extension YXKitLoggerMenuCollectionViewCell {
    func _createUI() {
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(36)
        }
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(mImageView.snp.bottom).offset(10)
        }
    }
}

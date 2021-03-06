//
//  YXKitLoggerMenuView.swift
//  YXSwiftKitUtil_Example
//
//  Created by Mr_Jesson on 2022/3/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class YXKitLoggerMenuView: UIView {
    var mCollectionList = [YXKitLoggerMenuCollectionViewCellModel]()
    var clickSubject: ((_ index: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self._createUI()
        self._loadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var mCollectionView: UICollectionView = {
        let tCollectionViewLayout = UICollectionViewFlowLayout()
        tCollectionViewLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        tCollectionViewLayout.itemSize = CGSize(width: 100, height: 100)
        tCollectionViewLayout.minimumLineSpacing = 0
        tCollectionViewLayout.minimumInteritemSpacing = 0
        tCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let tCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tCollectionViewLayout)
        tCollectionView.backgroundColor = UIColor.clear
        tCollectionView.dataSource = self
        tCollectionView.delegate = self
        tCollectionView.isPagingEnabled = false
        tCollectionView.showsHorizontalScrollIndicator = false
        tCollectionView.register(YXKitLoggerMenuCollectionViewCell.self, forCellWithReuseIdentifier: "YXKitLoggerMenuCollectionViewCell")
        return tCollectionView
    }()
}

private extension YXKitLoggerMenuView {
    func _createUI() {
        self.backgroundColor = UIColor.yx.color(hexValue: 0x000000, alpha: 0.6)
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }

    func _loadData() {
        mCollectionList.removeAll()
        var titleList = ["Back", "Decrypt", "Search", "Share", "Scroll", "Analyse"]
        var imageList = [UIImageHDBoundle(named: "icon_normal_back"), UIImageHDBoundle(named: "icon_decrypt"), UIImageHDBoundle(named: "icon_search"), UIImageHDBoundle(named: "icon_share"), UIImageHDBoundle(named: "icon_fixed"), UIImageHDBoundle(named: "icon_analyse")]

        if YXKitLogger.uploadComplete != nil {
            titleList.append("Upload")
            imageList.append(UIImageHDBoundle(named: "icon_upload"))
        }

        for i in 0..<titleList.count {
            let model = YXKitLoggerMenuCollectionViewCellModel(title: titleList[i], image: imageList[i])
            mCollectionList.append(model)
        }
        self.mCollectionView.reloadData()
    }
}

extension YXKitLoggerMenuView: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK:collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mCollectionList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.mCollectionList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXKitLoggerMenuCollectionViewCell", for: indexPath) as! YXKitLoggerMenuCollectionViewCell
        cell.updateUI(model: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let clickSubject = clickSubject {
            clickSubject(indexPath.item)
        }
    }
}

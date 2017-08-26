//
//  ceshiTab.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SDWebImage
class HomeTableCell: UITableViewCell {
  
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var HCollection: UICollectionView!
    /// 标识
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 称昵
    @IBOutlet weak var nameLabel: UILabel!
    /// vip图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    
    var thumbnail_pic = [NSURL]()
    
    var viewModel: StatusViewModel?{
        didSet{
            // 1.设置头像
            iconImageView.sd_setImage(with: viewModel?.icon_URL)
            
            // 2.设置认证图标
            verifiedImageView.image = viewModel?.verified_image
            
            // 3.设置昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            // 4.设置会员图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.black
            if let image = viewModel?.mbrankImage
            {
                vipImageView.image = image
                nameLabel.textColor = UIColor.orange
            }
            // 5.设置时间
            timeLabel.text = viewModel?.created_Time
            
            // 6.设置来源
            sourceLabel.text = viewModel?.source_Text
            
            // 7.设置正文
            contentLabel.text = viewModel?.status.text

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.preferredMaxLayoutWidth = kWidth - 20
        iconImageView.layer.cornerRadius = 30
        iconImageView.clipsToBounds = true
        
        HCollection.dataSource = self
        HCollection.backgroundColor = UIColor.black
        HCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "pictureCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (kWidth - 62)/3, height:65)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3)
        HCollection.collectionViewLayout = layout
//        flowLayout.scrollDirection = .vertical
//        flowLayout.itemSize = CGSize(width: (kWidth - 62)/3, height:65)
//        flowLayout.minimumLineSpacing = 3
//        flowLayout.minimumInteritemSpacing = 3
//        flowLayout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3)

    }
    /// 计算cell和collectionview的尺寸
    private func calculateSize() -> (CGSize, CGSize)
    {
        
        let count = thumbnail_pic.count ?? 0
        // 没有配图
        if count == 0
        {
            return (CGSize.zero, CGSize.zero)
        }
        
        // 一张配图
        if count == 1
        {
            let key = thumbnail_pic.first!.absoluteString
            // 从缓存中获取已经下载好的图片, 其中key就是图片的url
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: key)
            return (image!.size, image!.size)
        }
        
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        let imageMargin: CGFloat = 10
        // 四张配图
        if count == 4
        {
            let col = 2
            let row = col
            // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
            let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
            // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
            let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
            return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        }
        
        // 其他张配图
        let col = 3
        let row = (count - 1) / 3 + 1
        // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
    }
}
extension HomeTableCell: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}

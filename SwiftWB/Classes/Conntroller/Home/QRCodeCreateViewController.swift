//
//  QRCodeCreateViewController.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class QRCodeCreateViewController: UIViewController {

    @IBOutlet weak var customImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setDefaults()
        
        filter?.setValue("曾恩柏".data(using: String.Encoding.utf8), forKeyPath: "InputMessage")
        
        guard var ciImage = filter?.outputImage else {
            return
        }
        //设置高清二维码图片
        let transform = CGAffineTransform(scaleX: 20, y: 20)
        ciImage = ciImage.applying(transform)
        
        var resultImage = UIImage(ciImage: ciImage)
        
        customImageView.image = resultImage
        
        // Do any additional setup after loading the view.
    }
}

 //
//  QRCodeViewController.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import AVFoundation
 
class QRCodeViewController: UIViewController {
    //冲击波
    @IBOutlet weak var scanLineView: UIImageView!
    //容器高度
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    //冲击波顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    //底部工具条
    @IBOutlet weak var customTabbar: UITabBar!
    //显示二维码信息
    @IBOutlet weak var customLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //默认选中第一个按钮
        customTabbar.selectedItem = customTabbar.items?.first
        
        customTabbar.delegate = self
        //扫描二维码
        scanQRCode()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StartAnimation()
    }
    //MARK: - 扫描二维码
    fileprivate func scanQRCode(){
        //判断输入能否添加到会话中
        if !session.canAddInput(input){
            return
        }
        //判断输出能否添加到会话中
        if !session.canAddOutput(output){
            return
        }
        //将输出输入对象添加到会话
        session.addInput(input)
        session.addOutput(output)
        //设置输出能解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        
        session.startRunning()
        
    }
    /// 开始冲击波动画
    fileprivate func StartAnimation(){
        //设置冲击波顶部约束
        scanLineCons.constant = -containerHeight.constant
        //刷新
        view.layoutIfNeeded()
        //执行扫描动画
        UIView.animate(withDuration: 1.5) {
            //动画循环
            UIView.setAnimationRepeatCount(MAXFLOAT)
            
            self.scanLineCons.constant = self.containerHeight.constant
            
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func closeBtnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func photoBtnClick(_ sender: Any) {
        //打开相册
        //是否能打开相册
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            return
        }
        //创建相册控制器
        let  imagePickerVC = UIImagePickerController()
        
        imagePickerVC.delegate = self
        //弹出相册
        present(imagePickerVC, animated: true, completion: nil)
    }
    //MARK: - 懒加载
    //输入对象
    fileprivate lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    //会话
    fileprivate lazy var session: AVCaptureSession = AVCaptureSession()
    
    //输出对象
    fileprivate lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
 }

 
 
extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
        customLabel.text = metadataObjects.last.debugDescription
       
    }
}
extension QRCodeViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        containerHeight.constant = (item.tag == 1) ? 150 : 300
        view.layoutIfNeeded()
        //移除动画
        scanLineView.layer.removeAllAnimations()
        //重新加载动画
        StartAnimation()
    }
}
 extension QRCodeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            return
        }
        guard let ciImage = CIImage(image: image) else {
            return
        }
        //从图片中读取二维码
        //创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        //利用探测器探测数据
        let results = detector?.features(in: ciImage)
        //取出探测到的数据
        for result in results!{
            print((result as! CIQRCodeFeature).messageString ?? "无效二维码")
        }
        picker.dismiss(animated: true, completion: nil)
    }
 }

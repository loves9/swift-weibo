//
//  QRCodeViewController.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/9/9.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

import AVFoundation

class QRCodeViewController: UIViewController {

    @IBOutlet weak var customTabbar: UITabBar!
    
    @IBOutlet weak var scanCodeCons: NSLayoutConstraint!
    
    @IBOutlet weak var scanLineImageView: UIImageView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var customLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.默认选中
        customTabbar.selectedItem = customTabbar.items?.first
        
        // 2.tabbar代理
        customTabbar.delegate = self
        
        // 3.扫描二维码
        scanQRCode()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    func startAnimation(){
        // 1.
        scanCodeCons.constant = -containerHeight.constant
        
        view.layoutIfNeeded()
        
        // 2.执行动画
        UIView.animate(withDuration: 2.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanCodeCons.constant = self.containerHeight.constant
            
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func leftBtnClick(sender: AnyObject) {
        // 关闭
        dismiss(animated: true, completion: nil)
    }

    @IBAction func rightBtnClick(sender: AnyObject) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            return
        }
        
        // 创建相册控制器
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    // MARK: - 扫描二维码
    private func scanQRCode(){
        if !session.canAddInput(input) {
            return
        }
        if !session.canAddOutput(output) {
            return
        }
        
        // 添加输入输出到回话中
        session.addInput(input)
        session.addOutput(output)
        // 设置输出能够解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        // 设置监听解析到的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // 
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        
        // 开始扫描
        session.startRunning()
    }
    // MARK: - 懒加载
    // 1.输入对象
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    // 2.会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 3.输出对象
    private lazy var output: AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        
        // 设置扫瞄区域
        let viewRect = self.view.frame
        let containerRect = self.scanLineImageView.frame
        let x = containerRect.origin.y / (viewRect.height);
        let y = containerRect.origin.x / (viewRect.width);
        let width = containerRect.height / (viewRect.height);
        let height = containerRect.width / viewRect.width;
        out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        print("feng:", y)

        return out
    }()
    
    // 4.预览图层
    lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    // 5.描边图层
    lazy var containerLayer: CALayer = CALayer()
}

// MARK: - 代理方法
extension QRCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        guard let image = info[UIImagePickerControllerOriginalImage] else {
            return
        }
        
        // 读取二维码数据
        guard let ciImage = CIImage(image: image as! UIImage) else {
            return
        }
        // 创建一个探测器
        let imageDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        // 探测数据
        let results = imageDetector!.features(in: ciImage)
        
        for result in results {
            customLabel.text = (result as! CIQRCodeFeature).messageString
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension QRCodeViewController : UITabBarDelegate
{
    private func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        containerHeight.constant = (item.tag == 1) ? 150 : 300
        
        scanLineImageView.layer.removeAllAnimations()
        
        startAnimation()
        
        if item.tag == 1 {
            customLabel.text = "将条形码放入框内，即可扫描条形码"
        }else if item.tag == 0 {
            customLabel.text = "将二维码放入框内，即可扫描二维码"
        }
    }
    
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate
{
    // 扫描得到结果调用
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        customLabel.text = (metadataObjects.last as AnyObject).stringValue
        
        clearLayers()

        guard let metadataObjects = metadataObjects.last as? AVMetadataObject else {
            return
        }
        // 转换坐标数据
        let obj = previewLayer.transformedMetadataObject(for: metadataObjects)
        // 1.对扫描到的二维码描边
        guard ((obj as? AVMetadataMachineReadableCodeObject) != nil) else {
            return
        }
        drawLines(obj: (obj as? AVMetadataMachineReadableCodeObject)!)
    }
    
    private func drawLines(obj: AVMetadataMachineReadableCodeObject){
        
        guard let array = obj.corners else {
            return
        }
        
        // 1.创建图层 用于保存四边形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        // 2.创建UIBezierPath 绘制四边形
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        point = CGPoint.init(dictionaryRepresentation: (array[index] as! CFDictionary))!
        index += 1
        
        // - 2.1 将起点移动到某一点
        path.move(to: point)
        // - 2.2 连接其它线段
        while index < array.count {
            point = CGPoint.init(dictionaryRepresentation: (array[index] as! CFDictionary))!
            index += 1
            
            path.addLine(to: point)
        }
        path.close()
        
        layer.path = path.cgPath
        
        // 3.将用于保存四边形的图层添加到界面
        containerLayer.addSublayer(layer)
    }
    
    // 清空描边
    private func clearLayers(){
        guard let subLayers = containerLayer.sublayers else {
            return
        }
        
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
}

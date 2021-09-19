//
//  ViewController.swift
//  MKMagneticProgress
//
//  Created by malkouz on 09/05/2017.
//  Copyright (c) 2017 malkouz. All rights reserved.
//

import UIKit
import MKColorPicker
import MKMagneticProgress
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var magProgress:MKMagneticProgress!
    
    @IBOutlet weak var progressValueSlider:UISlider!
    @IBOutlet weak var lineWidthSlider:UISlider!
    @IBOutlet weak var insetsSlider:UISlider!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var progressColorBtn: UIButton!
    @IBOutlet weak var backgroundColorBtn: UIButton!
    @IBOutlet weak var titleColorBtn: UIButton!
    @IBOutlet weak var percentColorBtn: UIButton!
    
    
    let progressColorPicker = ColorPickerViewController()
    let backgroundColorPicker = ColorPickerViewController()
    let titleColorPicker = ColorPickerViewController()
    let percentColorPicker = ColorPickerViewController()
    
    // 그래디언트 레이어 만들기
    func gradientLayer(bounds : CGRect,
                       firstColor: CGColor,
                       secondColor: CGColor) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }

    // 그래디언트 레이어로 그래디언트 색 만들기
    func gradientColor(gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, 0.0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        magProgress.setProgress(progress: CGFloat(progressValueSlider.value), animated: false)
        
        
        progressColorPicker.selectedColor = { [weak self] color in
            
            guard let self = self else { return }
            
            // 위치 잡기
            let bounds = self.magProgress.bounds
            
            // 그래디언트 레이어 만들기 색 조합
            let gradientLayer = self.gradientLayer(bounds: bounds,
                                                   firstColor: UIColor.black.cgColor,
                                                   secondColor: UIColor.yellow.cgColor)
            
            
            if let gradientColor = self.gradientColor(gradientLayer: gradientLayer) {
                // 해당 색 적용하기 
                self.magProgress.progressShapeColor =  gradientColor
            } else {
                self.magProgress.progressShapeColor = color
            }
            
            self.updateButton(btn: self.progressColorBtn, with: color)
        }
        
        backgroundColorPicker.selectedColor = { [weak self] color in
            self?.magProgress.backgroundShapeColor = color
            self?.updateButton(btn: self?.backgroundColorBtn, with: color)
        }
        
        titleColorPicker.selectedColor = { [weak self] color in
            self?.magProgress.titleColor = color
            self?.updateButton(btn: self?.titleColorBtn, with: color)
        }
        
        percentColorPicker.selectedColor = { [weak self] color in
            self?.magProgress.percentColor = color
            self?.updateButton(btn: self?.percentColorBtn, with: color)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateButton(btn: UIButton?, with color: UIColor)
    {
        if let btn = btn{
            btn.backgroundColor = color
            btn.setTitleColor(color.inverted, for: .normal)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func progressValueChangedValue(sender: UISlider){
        magProgress.setProgress(progress: CGFloat(sender.value), animated: false)
    }
    
    @IBAction func lineWidthChangedValue(sender: UISlider){
        magProgress.lineWidth = CGFloat(sender.value)
        insetsSlider.maximumValue = sender.value - 1.0
    }
    
    @IBAction func insetsChangedValue(sender: UISlider){
        magProgress.inset = CGFloat(sender.value)
    }
    
    @IBAction func orientationChanged(sender: UISegmentedControl){
        if let orient = Orientation(rawValue: sender.selectedSegmentIndex) {
            magProgress.orientation = orient
        }
    }
    
    @IBAction func lineCapChanged(sender: UISegmentedControl){
        if let lineCap = LineCap(rawValue: sender.selectedSegmentIndex){
            magProgress.lineCap = lineCap
        }
    }
    
    @IBAction func SpaceChangedValue(sender: UISlider){
        magProgress.spaceDegree = CGFloat(sender.value)
    }
    
    
    @IBAction func titleTextChanged(sender: UITextField){
        magProgress.title = sender.text!
    }
    
    @IBAction func clockwiseChanged(sender: UISwitch){
        magProgress.clockwise = sender.isOn
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
    }
    
    
    //MARK: - text field delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        titleTextField.resignFirstResponder()
        return true
    }
    
    //MARK : - Color picker
    @IBAction func colorPressed(sender: UIButton){
        let pickerVC: UIViewController!
        
        switch sender {
        case titleColorBtn:
            pickerVC = titleColorPicker
            break
        case percentColorBtn:
            pickerVC = percentColorPicker
            break
        case progressColorBtn:
            pickerVC = progressColorPicker
            break
        case backgroundColorBtn:
            pickerVC = backgroundColorPicker
            break
        default:
            return
        }
        
        if let pickerVC = pickerVC{
            if let popoverController = pickerVC.popoverPresentationController{
                popoverController.delegate = backgroundColorPicker
                popoverController.permittedArrowDirections = .any
                //            popoverVC.delegate = self
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            
            self.present(pickerVC, animated: true, completion: nil)
        }
    }
}

//
//  NeumorphicView.swift
//  Neumorphic-View
//
//  Created by r_vihite on 2020/10/23.
//  Copyright © 2020 r_vihite. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class NeumorphicView: UIView {
    
    enum ShapeType: Int {
        case Flat    = 0
        case Concave = 1
        case Convex  = 2
        case Pressed = 3
    }
    
    enum DirectionType: Int {
        case TopLeft = 0
        case TopRight = 1
        case BottomLeft = 2
        case BottomRight = 3
    }
    
    var shadowPath0: UIBezierPath?
    var shadowPath1: UIBezierPath?
    var shadowLayer0: CALayer = CALayer()
    var shadowLayer1: CALayer = CALayer()
    var topLayer: CALayer = CALayer()
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    var shape: ShapeType = .Flat
    var direction: DirectionType = .TopLeft
    var shadowIntensity: CGFloat = 0
    var shadowColor0: UIColor?
    var shadowColor1: UIColor?
    var gradientColor0: UIColor?
    var gradientColor1: UIColor?
    
    @IBInspectable var shapeType: Int {
        get {
            return self.shape.rawValue
        }
        
        set(shapeIndex) {
            if shapeIndex < 0 || shapeIndex > 3 {
                self.shape = ShapeType.Flat
            }
            else {
                self.shape = ShapeType(rawValue: shapeIndex) ?? ShapeType.Flat
            }
        }
    }
    
    @IBInspectable var directionType: Int {
        get {
            return self.direction.rawValue
        }
        
        set(directionIndex) {
            if directionIndex < 0 || directionIndex > 3 {
                self.direction = DirectionType.TopLeft
            }
            else {
                self.direction = DirectionType(rawValue: directionIndex) ?? DirectionType.TopLeft
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            topLayer.cornerRadius = newValue
            gradientLayer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var opacity: Float {
        get {
            return shadowLayer0.shadowOpacity
        }
        set {
            shadowLayer0.shadowOpacity = newValue
            shadowLayer1.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return shadowLayer0.shadowRadius*2
        }
        set {
            shadowLayer0.shadowRadius = newValue/2
            shadowLayer1.shadowRadius = newValue/2
        }
    }
    
    @IBInspectable var offset: CGFloat {
        get {
            return shadowLayer0.shadowOffset.width
        }
        set {
            switch(shape) {
            case .Flat, .Concave, .Convex:
                switch(direction) {
                case .TopLeft:
                    shadowLayer0.shadowOffset = CGSize(width: newValue, height: newValue)
                    shadowLayer1.shadowOffset = CGSize(width: -newValue, height: -newValue)
                case .TopRight:
                    shadowLayer0.shadowOffset = CGSize(width: -newValue, height: newValue)
                    shadowLayer1.shadowOffset = CGSize(width: newValue, height: -newValue)
                case .BottomLeft:
                    shadowLayer0.shadowOffset = CGSize(width: newValue, height: -newValue)
                    shadowLayer1.shadowOffset = CGSize(width: -newValue, height: newValue)
                case .BottomRight:
                    shadowLayer0.shadowOffset = CGSize(width: -newValue, height: -newValue)
                    shadowLayer1.shadowOffset = CGSize(width: newValue, height: newValue)
                }
            case .Pressed:
                break
            }
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            topLayer.backgroundColor = self.backgroundColor?.cgColor
        }
    }
    
    @IBInspectable var intensity: CGFloat {
        get {
            return self.shadowIntensity
        }
        set {
            self.shadowIntensity = newValue
            
            let redValue = self.backgroundColor?.redComponent
            let greenValue = self.backgroundColor?.greenComponent
            let blueValue = self.backgroundColor?.blueComponent
            
            shadowColor0 = UIColor.init(
                red: redValue!-(newValue/255),
                green: greenValue!-(newValue/255),
                blue: blueValue!-(newValue/255), alpha: 1)
            
            shadowColor1 = UIColor.init(
                red: redValue!+(newValue/255),
                green: greenValue!+(newValue/255),
                blue: blueValue!+(newValue/255), alpha: 1)
            
            shadowLayer0.shadowColor = shadowColor0?.cgColor
            shadowLayer1.shadowColor = shadowColor1?.cgColor
            
            gradientColor0 = UIColor.init(
                red: redValue!-(25/255),
                green: greenValue!-(25/255),
                blue: blueValue!-(25/255), alpha: 1)
            
            gradientColor1 = UIColor.init(
                red: redValue!+(25/255),
                green: greenValue!+(25/255),
                blue: blueValue!+(25/255), alpha: 1)
        }
    }
    
    fileprivate func setup() {
        shadowPath0 = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        shadowLayer0.frame = self.bounds
        shadowLayer0.shadowPath = shadowPath0?.cgPath
        shadowLayer0.shadowColor = shadowColor0?.cgColor
        self.layer.insertSublayer(shadowLayer0, at: 0)
        
        shadowPath1 = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        shadowLayer1.frame = self.bounds
        shadowLayer1.shadowPath = shadowPath1?.cgPath
        shadowLayer1.shadowColor = shadowColor1?.cgColor
        self.layer.insertSublayer(shadowLayer1, at: 1)
        
        topLayer.frame = self.bounds
        self.layer.insertSublayer(topLayer, at: 2)
        
        self.layer.insertSublayer(gradientLayer, at: 3)
        
        switch(shape) {
        case .Flat:
            break
        case .Concave:
            gradientLayer.cornerRadius = self.cornerRadius
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [
                gradientColor0?.cgColor as Any, gradientColor1?.cgColor as Any
            ]
            gradientLayer.locations = [0, 1]
            self.layer.insertSublayer(gradientLayer, at: 3)
            
            switch(direction) {
            case .TopLeft:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            case .TopRight:
                gradientLayer.startPoint = CGPoint(x: 1, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            case .BottomLeft:
                gradientLayer.startPoint = CGPoint(x: 0, y: 1)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            case .BottomRight:
                gradientLayer.startPoint = CGPoint(x: 1, y: 1)
                gradientLayer.endPoint = CGPoint(x: 0, y: 0)
            }
        case .Convex:
            gradientLayer.cornerRadius = self.cornerRadius
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [
                gradientColor1?.cgColor as Any, gradientColor0?.cgColor as Any
            ]
            gradientLayer.locations = [0, 1]
            self.layer.insertSublayer(gradientLayer, at: 3)
            
            switch(direction) {
            case .TopLeft:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            case .TopRight:
                gradientLayer.startPoint = CGPoint(x: 1, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            case .BottomLeft:
                gradientLayer.startPoint = CGPoint(x: 0, y: 1)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            case .BottomRight:
                gradientLayer.startPoint = CGPoint(x: 1, y: 1)
                gradientLayer.endPoint = CGPoint(x: 0, y: 0)
            }
        case .Pressed:
            switch(direction) {
            case .TopLeft:
                self.addInnerShadow(onSide: .topAndLeft, shadowColor: shadowColor0!.cgColor, shadowSize: shadowRadius/2, cornerRadius: cornerRadius, shadowOpacity: opacity)
                self.addInnerShadow(onSide: .bottomAndRight, shadowColor: shadowColor1!.cgColor, shadowSize: shadowRadius/2, cornerRadius: cornerRadius, shadowOpacity: opacity)
            case .TopRight:
                self.addInnerShadow(onSide: .topAndRight, shadowColor: shadowColor0!.cgColor, shadowSize: shadowRadius/2, cornerRadius: cornerRadius, shadowOpacity: opacity)
                self.addInnerShadow(onSide: .bottomAndLeft, shadowColor: shadowColor1!.cgColor, shadowSize: shadowRadius/2, cornerRadius: cornerRadius, shadowOpacity: opacity)
            case .BottomLeft:
                self.addInnerShadow(onSide: .bottomAndLeft, shadowColor: shadowColor0!.cgColor, shadowSize: shadowRadius/2, cornerRadius: cornerRadius, shadowOpacity: opacity)
                self.addInnerShadow(onSide: .topAndRight, shadowColor: shadowColor1!.cgColor, shadowSize: shadowRadius/2, cornerRadius: cornerRadius, shadowOpacity: opacity)
            case .BottomRight:
                self.addInnerShadow(onSide: .bottomAndRight, shadowColor: shadowColor0!.cgColor, shadowSize: shadowRadius/2, cornerRadius: cornerRadius, shadowOpacity: opacity)
                self.addInnerShadow(onSide: .topAndLeft, shadowColor: shadowColor1!.cgColor, shadowSize: shadowRadius/2, cornerRadius: cornerRadius, shadowOpacity: opacity)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red: red, green: green, blue: blue, alpha: alpha)
    }

    var redComponent: CGFloat {
        var red: CGFloat = 0.0
        getRed(&red, green: nil, blue: nil, alpha: nil)

        return red
    }

    var greenComponent: CGFloat {
        var green: CGFloat = 0.0
        getRed(nil, green: &green, blue: nil, alpha: nil)

        return green
    }

    var blueComponent: CGFloat {
        var blue: CGFloat = 0.0
        getRed(nil, green: nil, blue: &blue, alpha: nil)

        return blue
    }

    var alphaComponent: CGFloat {
        var alpha: CGFloat = 0.0
        getRed(nil, green: nil, blue: nil, alpha: &alpha)

        return alpha
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static func contrastRatio(between color1: UIColor, and color2: UIColor) -> CGFloat {
        let luminance1 = color1.luminance()
        let luminance2 = color2.luminance()

        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)

        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }

    func contrastRatio(with color: UIColor) -> CGFloat {
        return UIColor.contrastRatio(between: self, and: color)
    }
    
    func luminance() -> CGFloat {
        let ciColor = CIColor(color: self)
        
        func adjust(colorComponent: CGFloat) -> CGFloat {
            return (colorComponent < 0.04045) ?
                (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
        }
        
        return 0.2126 * adjust(colorComponent: ciColor.red)
            + 0.7152 * adjust(colorComponent: ciColor.green)
            + 0.0722 * adjust(colorComponent: ciColor.blue)
    }
}

extension UIView
{
    public enum innerShadowSide
    {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
    
    public func addInnerShadow(onSide: innerShadowSide, shadowColor: CGColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float)
    {
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        let shadowPath = CGMutablePath()
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide
            {
                case .all:
                    return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
                case .left:
                    return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
                case .right:
                    return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
                case .top:
                    return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
                case.bottom:
                    return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
                case .topAndLeft:
                    return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
                case .topAndRight:
                    return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
                case .bottomAndLeft:
                    return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
                case .bottomAndRight:
                    return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
                case .exceptLeft:
                    return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
                case .exceptRight:
                    return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
                case .exceptTop:
                    return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
                case .exceptBottom:
                    return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        shadowLayer.path = shadowPath
        layer.addSublayer(shadowLayer)
        clipsToBounds = true
    }
}
extension UIView
{
    
    func setVerticalGradientBackground(colorTop:UIColor,colorBottom:UIColor) {
        
        //func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.black,UIColor.green]
        gradient.startPoint = CGPoint(x : 0.0, y : 0.5)
        gradient.endPoint = CGPoint(x :1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        //}
    }
    func setViewShadow(cRadius:CGFloat,shadowOpacity:Float) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        layer.shadowOpacity = shadowOpacity
        layer.cornerRadius = cRadius
    }
    
    func setShadowWithBorder() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: -0.2, height: 0.2)
        layer.shadowOpacity = 0.2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 0.05, green: 0.08, blue: 0.27, alpha: 1.00).cgColor
    }
    
    func setviewFreamborderview() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
    func setViewShadowOrderListBackGround() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        layer.shadowOpacity = 0.6
        layer.cornerRadius = 8
    }
    
    func setViewShadowForAddonPrepTab() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        layer.shadowOpacity = 0.6
        layer.cornerRadius = 20
    }
    
    func setViewShadowWithoutCornerRadius() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: -0.9, height: 0.9)
        layer.shadowOpacity = 0.6
        
    }
    
    func viewShadowHeader(view: UIView) {
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 1.0
        view.layer.shadowColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    }
    
    func setViewCornerRadiusWithoutShadow() {
        layer.cornerRadius = 10
    }
    
    func roundedViewFromUpperSide(cornerWidth:Double,cornerHeight:Double){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: cornerWidth, height: cornerHeight))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
        //        layer.shadowColor = UIColor.lightGray.cgColor
        //        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        //        layer.shadowOpacity = 0.6
        layer.borderWidth = 0
        layer.masksToBounds = true
    }
    
    func roundedViewFromBottomSide(cornerWidth:Double,cornerHeight:Double){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii: CGSize(width: cornerWidth, height: cornerHeight))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
        //        layer.shadowColor = UIColor.lightGray.cgColor
        //        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        //        layer.shadowOpacity = 0.6
        layer.borderWidth = 0
        layer.masksToBounds = true
    }
    
    func roundedViewPrepTab(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .bottomRight],
                                     cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        layer.shadowOpacity = 0.6
        //        layer.borderColor = #colorLiteral(red: 0.3622615337, green: 0.8218501806, blue: 0.8313922286, alpha: 1)
        //        layer.borderWidth = 1
        layer.masksToBounds = true
    }
    
    func roundedViewAddonTab(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        layer.shadowOpacity = 0.6
        layer.masksToBounds = true
    }
    
    func setViewShadowWithCornerRadius(cRadius:CGFloat,shadowOpacity:Float) {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        layer.shadowOpacity = shadowOpacity
        layer.cornerRadius = cRadius
        
        layer.masksToBounds = true
    }
    
    func setViewCircle() {
        layer.cornerRadius = layer.frame.size.height / 2
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
    }
    
   
    
    
    
    
}
//This is IBDesignable class used for different view to add the function from storyboard
@IBDesignable
class StylishUIView: UIView {

  @IBInspectable var  cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var circleView: Bool = false {
        didSet {
            if circleView{
            layer.cornerRadius = self.frame.width / 2
                cornerRadius = layer.cornerRadius
            } else {
                layer.cornerRadius = 0.0
                cornerRadius = layer.cornerRadius
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
   
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //layer.masksToBounds = false
    }

}
//MARK:- for Button
@IBDesignable
class StylishUIButton: UIButton{
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var circleView: Bool = false {
        didSet {
            if circleView{
                layer.cornerRadius = self.frame.width / 2
                cornerRadius = layer.cornerRadius
            } else {
                layer.cornerRadius = 0.0
                cornerRadius = layer.cornerRadius
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            
            //layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //layer.masksToBounds = false
    }
    
}
//MARK:- for Image
@IBDesignable
class StylishUIImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var circleView: Bool = false {
        didSet {
            if circleView{
                layer.cornerRadius = self.frame.width / 2
                cornerRadius = layer.cornerRadius
            } else {
                layer.cornerRadius = 0.0
                cornerRadius = layer.cornerRadius
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            
            //layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
  //      layer.masksToBounds = true
    }
    
}
//MARK:- for Label
@IBDesignable
class StylishUILabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var circleView: Bool = false {
        didSet {
            if circleView{
                layer.cornerRadius = self.frame.width / 2
                cornerRadius = layer.cornerRadius
            } else {
                layer.cornerRadius = 0.0
                cornerRadius = layer.cornerRadius
            }
        }
    }
    
    
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            
            //layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColorLabel: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColorLabel.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffsetLabel: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffsetLabel
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
 //       layer.masksToBounds = true
    }
    
}
//MARK:- for tableView
@IBDesignable
class StylishUITableView: UITableView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            
            //layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      //  layer.masksToBounds = true
    }
    
}
//MARK:- for collectionView
@IBDesignable
class StylishUICollectionView: UICollectionView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            
            //layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     //   layer.masksToBounds = true
    }
    
}
//MARK:- for textfield
@IBDesignable
class StylishUITextField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            
            //layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    //    layer.masksToBounds = true
    }
    
}
//MARK:- for TextView
@IBDesignable
class StylishUITextView: UITextView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            
            //layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     //   layer.masksToBounds = true
    }
    
}
//MARK:- for PickerView
@IBDesignable
class StylishUIPickerView: UIPickerView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            
            //layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     //   layer.masksToBounds = true
    }
    
}
//MARK:- for DatePicker
@IBDesignable
class StylishUIDatePicker: UIDatePicker {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = -1.0 {
        didSet {
            
            //layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet{
            //layer.masksToBounds = false
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            //layer.masksToBounds = false
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0) {
        didSet {
            //layer.masksToBounds = false
            layer.shadowOffset = shadowOffset
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //   layer.masksToBounds = true
    }
    
}

//MARK:- gradient
@IBDesignable
class StylishUIGradientView: UIView {
    
    // the gradient start colour
    @IBInspectable var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // the gradient end colour
    @IBInspectable var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // the gradient angle, in degrees anticlockwise from 0 (east/right)
    @IBInspectable var angle: CGFloat = 270 {
        didSet {
            updateGradient()
        }
    }
    
    // the gradient layer
    private var gradient: CAGradientLayer?
    
    // initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        installGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        installGradient()
    }
    
    // Create a gradient and install it on the layer
    private func installGradient() {
        // if there's already a gradient installed on the layer, remove it
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }
    
    // Update an existing gradient
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
        }
    }
    
    // create gradient layer
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
    
    // create vector pointing in direction of angle
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        //let start = pointForAngle(angle+180.0)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    // get a point corresponding to the angle
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (fabs(x) > fabs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }
    
    // transform point in unit space to gradient space
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }
    
    // return the opposite point in the signed unit square
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    // ensure the gradient gets initialized when the view is created in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        installGradient()
        updateGradient()
    }
}

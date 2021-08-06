
import UIKit

public class GradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    public var colors: [UIColor] = [#colorLiteral(red: 0.9926498532, green: 0.8366565108, blue: 0.2699221075, alpha: 1), #colorLiteral(red: 0.9664717317, green: 0.3388285041, blue: 0.52980721, alpha: 1)] {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var locations: [NSNumber] = [0, 1] {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var startPoint: CGPoint = .init(x: 0, y: 0.5) {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var endPoint: CGPoint = .init(x: 1, y: 0.5) {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public override func layoutSubviews() {
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = colors.map { $0.cgColor }
        self.gradientLayer.startPoint = startPoint
        self.gradientLayer.endPoint = endPoint
        self.gradientLayer.locations = locations
    }
    
    public func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey:"animateGradient")
    }
}

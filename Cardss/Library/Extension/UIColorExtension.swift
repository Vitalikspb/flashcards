
import UIKit

extension UIColor {
    
    // цвет бэкграунда для лаунчскрина
    static var brandLaunchBackGround: UIColor { brandLaunchBackGround }

    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                }
                return light
            }
        }
        else {
            self.init(cgColor: light.cgColor)
        }
    }
    
    convenience init(firstColor: (light: UIColor, dark: UIColor), secondColor: (light: UIColor, dark: UIColor) ) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init { traitCollection in
                if traitCollection.userInterfaceLevel == .base {
                    return .init(light: firstColor.light, dark: firstColor.dark)
                }
                else {
                    return .init(light: secondColor.light, dark: secondColor.dark)
                }
            }
        }
        else {
            self.init(cgColor: firstColor.light.cgColor)
        }
    }
    
    static func hex(_ hex:String, alpha: CGFloat = 1) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    func lighter (by amount: CGFloat = 0.25) -> UIColor {
        return mixWithColor(UIColor.white, amount: amount)
    }

    func darker (by amount: CGFloat = 0.25) -> UIColor {
        return mixWithColor(UIColor.black, amount: amount)
    }

    func mixWithColor(_ color: UIColor, amount: CGFloat = 0.25) -> UIColor {
        var r1     : CGFloat = 0
        var g1     : CGFloat = 0
        var b1     : CGFloat = 0
        var alpha1 : CGFloat = 0
        var r2     : CGFloat = 0
        var g2     : CGFloat = 0
        var b2     : CGFloat = 0
        var alpha2 : CGFloat = 0

        self.getRed (&r1, green: &g1, blue: &b1, alpha: &alpha1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &alpha2)
        return UIColor( red:r1*(1.0-amount)+r2*amount,
                        green:g1*(1.0-amount)+g2*amount,
                        blue:b1*(1.0-amount)+b2*amount,
                        alpha: alpha1 )
    }
}

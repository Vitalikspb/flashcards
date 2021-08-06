
import UIKit

public enum Animate {
    public static func spring(time: TimeInterval, delay: TimeInterval = 0, damping: CGFloat = 0.8, velocity: CGFloat = 0.3, animate: @escaping() -> Void, completion: @escaping () -> Void) {
        UIView.animate(withDuration: time,
                       delay: delay,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity,
                       options: .curveEaseInOut,
                       animations: {
                        animate()
        }, completion: { _ in
            completion()
        })
    }
    
    public static func spring(time: TimeInterval, delay: TimeInterval = 0, damping: CGFloat = 0.8, velocity: CGFloat = 0.3, animate: @escaping() -> Void) {
        UIView.animate(withDuration: time,
                       delay: delay,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity,
                       options: .curveEaseInOut,
                       animations: {
                        animate()
        }, completion: { _ in })
    }
    
    public static func base(time: TimeInterval, delay: TimeInterval = 0 , animate: @escaping() -> Void, completion: @escaping () -> Void) {
        UIView.animate(withDuration: time,
                       delay: delay,
                       animations: {
                        animate()
        }, completion: { _ in
            completion()
        })
    }
    
    public static func base(time: TimeInterval, delay: TimeInterval = 0 , animate: @escaping() -> Void) {
        UIView.animate(withDuration: time,
                       delay: delay,
                       animations: {
                        animate()
        }, completion: { _ in })
    }
    
    public static func transition(with view: UIView, time: TimeInterval, options: UIView.AnimationOptions = .transitionCrossDissolve, animate: @escaping() -> Void) {
        UIView.transition(with: view, duration: time, options: options) {
            animate()
        } completion: { _ in }
    }
    
    public static func transition(with view: UIView, time: TimeInterval, options: UIView.AnimationOptions = .transitionCrossDissolve, animate: @escaping() -> Void, completion: @escaping () -> Void) {
        UIView.transition(with: view, duration: time, options: options) {
            animate()
        } completion: { _ in  completion() }
    }
}


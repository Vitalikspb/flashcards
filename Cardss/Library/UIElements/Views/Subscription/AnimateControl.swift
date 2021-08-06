
import UIKit

open class AnimateControl: UIControl {
    
    // MARK: - Lifecycle
    
    public init() {
        super.init(frame: .zero)
        setupGestureRecognizer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(state: true)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(state: false)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(state: false)
    }
    
    // MARK: - Public Methods

    open func animate(state: Bool) {
        if state == true {
            Animate.spring(time: 0.3, animate: {
                self.transform = .init(scaleX: 0.97, y: 0.97)
            })
        } else {
            Animate.spring(time: 0.3, animate: {
                self.transform = .identity
            })
        }
    }
}

// MARK: - Handlers

private extension AnimateControl {
    @objc func tapped() {
        sendActions(for: .touchUpInside)
    }
}

// MARK: - Layout Setup
private extension AnimateControl {
    func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
}

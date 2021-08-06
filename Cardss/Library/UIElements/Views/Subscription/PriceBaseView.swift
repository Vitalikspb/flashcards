

import UIKit

open class PriceBaseView: AnimateControl {
    
    // MARK: - Open Proporties
    
    public var isChoosen: Bool = false {
        didSet {
            setupState()
        }
    }
    
    // MARK: - Private Proporties
    
    // MARK: - Life cycle
    public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupState() {
        fatalError("Method must be overridden")
    }
}


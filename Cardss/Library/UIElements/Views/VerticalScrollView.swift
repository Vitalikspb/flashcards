import UIKit

public class VerticalScrollView: UIScrollView {
    // MARK: UI Elements
    lazy var contentView = UIView()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        delaysContentTouches = false
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton { return true }
        return super.touchesShouldCancel(in: view)
    }
    
}

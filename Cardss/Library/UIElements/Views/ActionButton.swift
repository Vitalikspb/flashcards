

import UIKit

public class ActionButton: UIButton {
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    func setupView() {
        self.setTitleColor(AppSource.Color.blueTextColor, for: .highlighted)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
        self.backgroundColor = AppSource.Color.backgroundActionButton
    }
}

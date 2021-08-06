
import UIKit
import SnapKit

final public class FeatureHorizontalView: UIView {

    // MARK: - UI Elements

    public var imageView = UIImageView()
    public var titleLabel = UILabel()

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init(image: String, title: String, bgColor: UIColor?, contentColor: UIColor) {
        self.init()
        imageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = title
        backgroundColor = bgColor
        titleLabel.textColor = contentColor
        imageView.tintColor = contentColor
    }

}

// MARK: - Layout Setup

private extension FeatureHorizontalView {

    func setupView() {
        
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.do {
            $0.font = .systemFont(ofSize: 14, weight: .semibold)
        }
        
    }

    func setupConstraints() {
        addSubview(imageView)
        addSubview(titleLabel)

        self.snp.makeConstraints {
            $0.height.equalTo(55).priority(990)
        }

        imageView.snp.makeConstraints {
            $0.size.equalTo(24).priority(990)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
        }
    }

}

//
//  MenuButton.swift


import UIKit

final class ChooseButton: UIControl {
    // MARK: - UI Elements
    private lazy var themeArrowImage = UIImageView()
    private lazy var imageView = UIImageView()
    
    // MARK: - Open Proporties
    lazy var themeWrapperView = UIView()
    lazy var themeLabel = UILabel()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            layoutImageView()
        }
    }
    
    // MARK: - Life cycle
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrame()
    }
}

// MARK: - Layout Setup
private extension ChooseButton {
    func setupColors() {
        self.backgroundColor = AppSource.Color.backgroundWrapperView
        themeWrapperView.backgroundColor = AppSource.Color.backgroundWrapperView
    }
    func layoutImageView() {
        themeLabel.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            if image == nil {
                $0.leading.equalToSuperview().offset(20)
            } else {
                $0.leading.equalTo(imageView.snp.trailing).offset(15)
            }
            $0.trailing.equalTo(themeArrowImage.snp.leading)
        }
    }
    func setupFrame() {
        self.layer.cornerRadius = 10
    }
    func setupView() {
        setupColors()
        themeWrapperView.do {
            $0.addSubview(imageView)
            $0.addSubview(themeLabel)
            $0.addSubview(themeArrowImage)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        themeLabel.do {
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        themeArrowImage.do {
            $0.tintColor = AppSource.Color.chooseButtonImageTint
            $0.image = AppSource.Image.rightArrow
            $0.contentMode = .scaleAspectFit
        }
        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = AppSource.Color.chooseButtonImageTint
        }
    }
    
    func setupConstraints() {
        addSubview(themeWrapperView)
        self.snp.makeConstraints{
            $0.height.equalTo(45)
        }
        themeWrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(25)
        }
        layoutImageView()
        themeArrowImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(20)
            $0.width.equalTo(14)
        }
    }
}


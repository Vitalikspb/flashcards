

import UIKit

class NameOfViewController: UIView {
    
    private lazy var wrapperView = UIView()
    private lazy var mainView = UIView()
    private lazy var mainTitle = UILabel()
    private lazy var mainImage = UIImageView()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        setupView()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

extension NameOfViewController {
    public func showNameView(_ name: String, andImage image: UIImage) {
        mainTitle.text = name
        mainImage.image = image
    }
    public func animate() {
        UIView.animate(withDuration: 0.35,
                       delay: 0.15,
                       options: .curveEaseInOut) {
            self.mainView.center.y += 120
        } completion: { (finished) in
            if finished {
                UIView.animate(withDuration: 0.35,
                               delay: 0.75,
                               options: .curveEaseInOut) {
                    self.mainView.center.y -= 120
                }
            }
        }
    }
}

extension NameOfViewController {
    func setupLayout() {
        mainView.do {
            $0.layer.cornerRadius = 20
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowRadius = 7
            $0.layer.shadowOpacity = 0.35
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
    }
    
    func setupColor() {
        wrapperView.backgroundColor = .clear
    }
    
    func setupView() {
        setupColor()
        mainView.do {
            $0.backgroundColor = AppSource.Color.background
        }
        mainTitle.do {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textAlignment = .left
            $0.textColor = AppSource.Color.blueTextColor
        }
        mainImage.do {
            $0.contentMode = .scaleAspectFill
            $0.tintColor = AppSource.Color.blueTextColor
        }
    }
    
    func setupConstraints() {
        addSubview(wrapperView)
        
        wrapperView.addSubview(mainView)
        mainView.addSubview(mainImage)
        mainView.addSubview(mainTitle)
        
        wrapperView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        mainView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
        }
        mainImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.size.equalTo(25)
        }
        mainTitle.snp.makeConstraints {
            $0.leading.equalTo(mainImage.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.bottom.equalToSuperview()
        }
    }
}

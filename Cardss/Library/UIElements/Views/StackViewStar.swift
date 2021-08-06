

import UIKit

class StackViewStar: UIView {
    
    private lazy var wrapperView = UIView()
    private lazy var stackView = UIView()
    private lazy var image1 = UIImageView()
    private lazy var image2 = UIImageView()
    private lazy var image3 = UIImageView()
    private lazy var image4 = UIImageView()
    private lazy var image5 = UIImageView()
    
    public func show(with count: Int) {
        switch count {
        case 1:
            image2.isHidden = true
            image3.isHidden = true
            image4.isHidden = true
            image5.isHidden = true
        case 2:
            image3.isHidden = true
            image4.isHidden = true
            image5.isHidden = true
        case 3:
            image4.isHidden = true
            image5.isHidden = true
        case 4:
            image5.isHidden = true
        default:
            print("error")
        }
    }


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

extension StackViewStar {
    func setupLayout() {
        
    }
    func setupColor() {
        wrapperView.backgroundColor = .clear
        stackView.backgroundColor = .clear
    }
    func setupView() {
        setupColor()
        stackView.do {
            $0.addSubview(image1)
            $0.addSubview(image2)
            $0.addSubview(image3)
            $0.addSubview(image4)
            $0.addSubview(image5)
        }
        let arrayImage = [image1, image2, image3, image4, image5]
        arrayImage.forEach {
            $0.image = AppSource.Image.star
            $0.tintColor = AppSource.Color.selectedStrokeBottomButton
            $0.image?.withRenderingMode(.alwaysTemplate)
            $0.isHidden = false
        }
    }
    func setupConstraints() {
        addSubview(wrapperView)
        wrapperView.addSubview(stackView)
        
        wrapperView.snp.makeConstraints {
            $0.height.equalTo(25)
            $0.width.equalTo(150)
        }
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        image1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        image2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(image1.snp.trailing).offset(5)
            $0.size.equalTo(20)
        }
        image3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(image2.snp.trailing).offset(5)
            $0.size.equalTo(20)
        }
        image4.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(image3.snp.trailing).offset(5)
            $0.size.equalTo(20)
        }
        image5.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(image4.snp.trailing).offset(5)
            $0.size.equalTo(20)
        }
    }
}

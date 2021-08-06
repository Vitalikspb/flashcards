

import UIKit
import SnapKit
import Then

class BottomButtonView: UIView {
    
    private lazy var buttonStack = UIStackView()
    
     lazy var cardsButtom = UIView()
     lazy var cardsImage = UIImageView()
     lazy var statisticsButtom = UIView()
     lazy var statisticImage = UIImageView()
     lazy var settingButtom = UIView()
     lazy var settingsImage = UIImageView()
     lazy var learnButtom = UIView()
     lazy var educationImage = UIImageView()
     lazy var arrayOfButtons = [cardsButtom, statisticsButtom,
                                settingButtom, learnButtom]
    public var presentCardsVC: (() -> Void)?
    public var presentStatisticsVC: (() -> Void)?
    public var presentSettingVC: (() -> Void)?
    public var presentLearnVC: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomButtonView {

    @objc func cardsTapped() {
        presentCardsVC?()
    }
    @objc func statisticTapped() {
        presentStatisticsVC?()
    }
    @objc func settingsTapped() {
        presentSettingVC?()
    }
    @objc func educationTapped() {
        presentLearnVC?()
    }
    
}
private extension BottomButtonView {
    func setupColors() {
        buttonStack.backgroundColor = .clear
    }
    func setupView() {
        setupColors()
    
        arrayOfButtons.forEach {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue ? 15 : 20
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 2
            $0.layer.borderColor = AppSource.Color.unSelectedStrokeBottomButton.cgColor
            $0.tintColor = AppSource.Color.unSelectedStrokeBottomButton
        }
        
        buttonStack.do {
            $0.addArrangedSubview(cardsButtom)
            $0.addArrangedSubview(statisticsButtom)
            $0.addArrangedSubview(settingButtom)
            $0.addArrangedSubview(learnButtom)
            $0.alignment = .center
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.spacing = 15
        }
        cardsButtom.do {
            $0.addSubview(cardsImage)
            let tap = UITapGestureRecognizer(target: self, action: #selector(cardsTapped))
            $0.addGestureRecognizer(tap)
        }
        statisticsButtom.do {
            $0.addSubview(statisticImage)
            let tap = UITapGestureRecognizer(target: self, action: #selector(statisticTapped))
            $0.addGestureRecognizer(tap)
        }
        settingButtom.do {
            let tap = UITapGestureRecognizer(target: self, action: #selector(settingsTapped))
            $0.addGestureRecognizer(tap)
            $0.addSubview(settingsImage)
        }
        learnButtom.do {
            let tap = UITapGestureRecognizer(target: self, action: #selector(educationTapped))
            $0.addGestureRecognizer(tap)
            $0.addSubview(educationImage)
        }
        cardsImage.do {
            $0.image = AppSource.Image.bullet
        }
        statisticImage.do {
            $0.image = AppSource.Image.waveform
        }
        settingsImage.do {
            $0.image = AppSource.Image.slider
        }
        educationImage.do {
            $0.image = AppSource.Image.play
        }
    }
    
    func setupConstraints() {
        addSubview(buttonStack)
        buttonStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let sizeHeightButtons = UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue ? 55 : 68
        let sizeHeightImages = UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue ? 25 : 28
        [cardsButtom, statisticsButtom, settingButtom, learnButtom].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(sizeHeightButtons)
            }
        }
        [cardsImage, statisticImage, settingsImage, educationImage].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(sizeHeightImages)
                $0.center.equalToSuperview()
            }
        }
    }
}

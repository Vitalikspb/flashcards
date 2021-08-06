

import UIKit
import SnapKit
import Then

class EndEducationNotificationView: UIView {
    
    private lazy var wrapperView = UIView()
    private lazy var titleLabel = UILabel()
    
    private lazy var fiveStarLabel = UILabel()
    private lazy var fiveStarStack = StackViewStar()
    private lazy var threeStarLabel = UILabel()
    private lazy var threeStarStack = StackViewStar()
    private lazy var oneStarLabel = UILabel()
    private lazy var oneStarStack = StackViewStar()
    
    var fiveStar: Int {
        set { fiveStarLabel.text = "\(newValue) \(AppSource.Text.StatisticsVC.word)" }
        get { return fiveStar }
    }
    var threeStar: Int {
        set { threeStarLabel.text = "\(newValue) \(AppSource.Text.StatisticsVC.word)" }
        get { return threeStar }
    }
    var oneStar: Int {
        set { oneStarLabel.text = "\(newValue) \(AppSource.Text.StatisticsVC.word)" }
        get { return oneStar }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EndEducationNotificationView {
    func setupColors() {
        self.backgroundColor = .clear
    }
    
    func setupView() {
        setupColors()
        
        wrapperView.do {
            $0.backgroundColor = AppSource.Color.backgroundEndEducation
            $0.addSubview(titleLabel)
            $0.addSubview(fiveStarLabel)
            $0.addSubview(fiveStarStack)
            $0.addSubview(threeStarLabel)
            $0.addSubview(threeStarStack)
            $0.addSubview(oneStarLabel)
            $0.addSubview(oneStarStack)
        }
        titleLabel.do {
            $0.text = "Вы прошли обучение"
            $0.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            $0.textAlignment = .center
            $0.textColor = AppSource.Color.textColor
        }
        
        [fiveStarLabel, threeStarLabel, oneStarLabel].forEach {
           $0.do {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textAlignment = .left
            $0.textColor = AppSource.Color.textColor
        }
        }
        fiveStarStack.do {
            $0.show(with: 5)
        }
      
        threeStarStack.do {
            $0.show(with: 3)
        }
        oneStarStack.do {
            $0.show(with: 1)
        }
    }
    
    func setupConstraints() {
        self.addSubview(wrapperView)
        
        wrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        fiveStarStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.height.equalTo(20)
            $0.width.equalTo(90)
        }
        threeStarStack.snp.makeConstraints {
            $0.top.equalTo(fiveStarStack.snp.bottom).offset(15)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.height.equalTo(20)
            $0.width.equalTo(90)
        }
        oneStarStack.snp.makeConstraints {
            $0.top.equalTo(threeStarStack.snp.bottom).offset(15)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.height.equalTo(20)
            $0.width.equalTo(90)
        }
        fiveStarLabel.snp.makeConstraints {
            $0.centerY.equalTo(fiveStarStack.snp.centerY).offset(3)
            $0.leading.equalTo(fiveStarStack.snp.trailing).offset(45)
            $0.height.equalTo(70)
            $0.height.equalTo(20)
        }
        threeStarLabel.snp.makeConstraints {
            $0.centerY.equalTo(threeStarStack.snp.centerY).offset(3)
            $0.leading.equalTo(fiveStarStack.snp.trailing).offset(45)
            $0.height.equalTo(70)
            $0.height.equalTo(20)
        }
        oneStarLabel.snp.makeConstraints {
            $0.centerY.equalTo(oneStarStack.snp.centerY).offset(3)
            $0.leading.equalTo(fiveStarStack.snp.trailing).offset(45)
            $0.height.equalTo(70)
            $0.height.equalTo(20)
        }
    }
}

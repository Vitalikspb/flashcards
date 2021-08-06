//
//  CardsCollectionViewCell.swift
//  Cardss
//
//  Created by Macbook on 22.12.2020.
//

import UIKit
import SnapKit
import Then

class AddCardToLearnCollectionCell: UICollectionViewCell {
    
    static let reuseCellIdentifier = "AddCardToLearnCollectionCell"
    
    lazy var contentWrapper = UIView()
    lazy var progressLearningView = UIView()
    lazy var greenLearnedLabel = UILabel()
    lazy var redUnknownLabel = UILabel()
    
    lazy var langLabel = UILabel()
    lazy var nameOfPack = UILabel()
    lazy var dateOfPack = UILabel()
    
    private lazy var gradientView = GradientView()
    private lazy var progressLearningRightColor = UIColor()
    private lazy var progressLearningLeftColor = UIColor()
    private lazy var colorTheme = 0
    private lazy var color = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddCardToLearnCollectionCell {
    
    func setupCellText(color: UIColor,
                       langLabel: String,
                       learnedWords: String,
                       countWords: String,
                       nameOfPack: String,
                       dateOfPack: String){
        
        if self.traitCollection.userInterfaceStyle == .dark {
            colorTheme = 0 // dark
        } else {
            colorTheme = 1 // light
        }
        
        if colorTheme == 0 {
            self.color = color.lighter()
            contentWrapper.backgroundColor = color
            progressLearningLeftColor = color.darker()
            progressLearningRightColor = color
            
            self.color = color.darker()
            
        } else {
            self.color = color.darker()
            contentWrapper.backgroundColor = color
            progressLearningLeftColor = color.darker()
            progressLearningRightColor = color
            self.color = color.lighter()
        }
        self.langLabel.text = langLabel
        self.greenLearnedLabel.text = learnedWords
        self.redUnknownLabel.text = countWords
        self.nameOfPack.text = nameOfPack
        self.dateOfPack.text = dateOfPack
        setupLearnedViewColor(countOfLearnedWord: Int(learnedWords) ?? 0,
                              countOfUnknownWord: Int(countWords) ?? 100)
    }
    
    func setupLearnedViewColor(countOfLearnedWord leftColor: Int, countOfUnknownWord rightColor: Int) {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width - 30, height: self.frame.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        if leftColor == 0 {
            gradient.locations = [0.0, 0.05]
        } else if leftColor == rightColor {
            gradient.locations = [0.95, 1.0]
        } else {
            let endGreenframe = modf(Float(leftColor) / Float(rightColor))
            let endGreenframeNumber: NSNumber = NSNumber(value: endGreenframe.1 - 0.05)
            let endGreenframeNumber1: NSNumber = NSNumber(value: endGreenframe.1 + 0.05)
            gradient.locations = [endGreenframeNumber, endGreenframeNumber1]
        }
        gradient.colors = [progressLearningLeftColor.cgColor,
                           progressLearningRightColor.cgColor]
        progressLearningView.layer.addSublayer(gradient)
    }
}

extension AddCardToLearnCollectionCell {
    
    func setupColor() {
        backgroundColor = .clear
    }
    
    func setupView() {
        setupColor()
        
        let arrayOfLabels = [greenLearnedLabel, redUnknownLabel, langLabel, nameOfPack, dateOfPack]
        arrayOfLabels.forEach {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        
        greenLearnedLabel.do {
            $0.textAlignment = .left
        }
        redUnknownLabel.do {
            $0.textAlignment = .right
        }
        progressLearningView.do {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        langLabel.do {
            $0.text = ""
            $0.textAlignment = .left
            $0.numberOfLines = 2
        }
        nameOfPack.do {
            $0.textAlignment = .left
            $0.numberOfLines = 2
        }
        dateOfPack.do {
            $0.textAlignment = .left
        }
        contentWrapper.do {
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
        
        contentWrapper.insertSubview(gradientView, at: 0)
        gradientView.do {
            $0.colors = [AppSource.Color.gradientCellTop,
                         AppSource.Color.gradientCellBottom]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
    }
    
    func setupConstraints() {
        
        contentView.addSubview(contentWrapper)
        
        contentWrapper.addSubview(progressLearningView)
        contentWrapper.addSubview(greenLearnedLabel)
        contentWrapper.addSubview(redUnknownLabel)
        
        contentWrapper.addSubview(langLabel)
        contentWrapper.addSubview(nameOfPack)
        contentWrapper.addSubview(dateOfPack)

        contentWrapper.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            
        }
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nameOfPack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(34)
        }
        langLabel.snp.makeConstraints {
            $0.top.equalTo(nameOfPack.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(34)
        }
        
        dateOfPack.snp.makeConstraints {
            $0.top.equalTo(langLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        progressLearningView.snp.makeConstraints {
            $0.top.equalTo(dateOfPack.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(20)
        }

        greenLearnedLabel.snp.makeConstraints {
            $0.centerY.equalTo(progressLearningView.snp.centerY)
            $0.leading.equalToSuperview().offset(25)
        }
        redUnknownLabel.snp.makeConstraints {
            $0.centerY.equalTo(progressLearningView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-25)
        }
    }
    
}

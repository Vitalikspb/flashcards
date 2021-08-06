//
//  ChooseGroupCell.swift
//  Cardss
//
//  Created by Macbook on 22.12.2020.
//

import UIKit
import SnapKit
import Then

class ChooseGroupCell: UITableViewCell {
    
//    MARK: - UI Elements
    private lazy var contentWrapper = UIView()
    
//    MARK: - Public Properties
    static let reuseCellIdentifier = "ChooseGroupCell"
    lazy var name = UILabel()
     
    
//    MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        self.backgroundColor = .white
        self.layer.borderWidth = 0
        self.name.textColor = AppSource.Color.textColor
    }
}

//    MARK: - SetupCellText
extension ChooseGroupCell {
    func setupCellText(name: String) {
        self.name.text = name
    }
    
}

//    MARK: - Initial Setup Views
extension ChooseGroupCell {
    
    func setupColor() {
        backgroundColor = AppSource.Color.backgroundWrapperView
        contentWrapper.backgroundColor = AppSource.Color.backgroundWrapperView
    }
    
    func setupView() {
        setupColor()
        name.do {
            $0.text = ""
            $0.textAlignment = .left
            $0.textColor = AppSource.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(contentWrapper)
        contentWrapper.addSubview(name)
        contentWrapper.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        name.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
        }
    }
}



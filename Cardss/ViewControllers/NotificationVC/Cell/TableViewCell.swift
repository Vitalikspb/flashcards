//
//  ServerCell.swift


import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: - UIElements
    lazy var wrapper = UIView()
    lazy var nameLabel = UILabel()
    lazy var dayLabel = UILabel()
    lazy var separatorView = UIView()
    lazy var timeLabel = UILabel()
    
    // MARK: - Open Properties
    static let reuseId = "ServerCell"

    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Layout Setup
private extension TableViewCell {
    func setupColors() {
        backgroundColor = AppSource.Color.backgroundBottonView
        wrapper.backgroundColor = .clear
    }
    
    func setupView() {
        setupColors()
        selectionStyle = .none
        
        nameLabel.do {
            $0.textColor = AppSource.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            $0.textAlignment = .left
            $0.text = ""
        }
        dayLabel.do {
            $0.textColor = AppSource.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textAlignment = .left
            $0.text = ""
        }
        separatorView.do {
            $0.backgroundColor =  AppSource.Color.titleStick
        }
        timeLabel.do {
            $0.textColor = AppSource.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 22, weight: .regular)
            $0.textAlignment = .center
            $0.text = ""
        }
    }
    
    func setupConstraint(){
        
        addSubview(wrapper)
        wrapper.addSubview(nameLabel)
        wrapper.addSubview(dayLabel)
        wrapper.addSubview(separatorView)
        wrapper.addSubview(timeLabel)
        
        wrapper.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.leading.equalTo(7)
            $0.trailing.equalTo(-7)
            $0.height.equalTo(50)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalTo(separatorView.snp.leading).offset(5)
        }
        dayLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalTo(separatorView.snp.leading).offset(5)
        }
        separatorView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(2)
            $0.height.equalTo(40)
            $0.trailing.equalTo(timeLabel.snp.leading)
        }
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(90)
            $0.trailing.equalToSuperview().offset(-5)
        }
    }
}




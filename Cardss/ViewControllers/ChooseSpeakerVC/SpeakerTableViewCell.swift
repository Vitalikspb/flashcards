//
//  ServerCell.swift


import UIKit

class SpeakerTableViewCell: UITableViewCell {
    
    // MARK: - UIElements
    lazy var wrapper = UIView()
    lazy var nameLabel = UILabel()
    var updateSpeaker: ((_ speaker: String) -> Void)?
    // MARK: - Open Properties
    static let reuseId = "SpeakerTableViewCell"

    
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
private extension SpeakerTableViewCell {
    func setupColors() {
        backgroundColor = AppSource.Color.backgroundWrapperView
        wrapper.backgroundColor = .clear
    }
    
    func setupView() {
        setupColors()
        wrapper.do {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        }
        nameLabel.do {
            $0.textColor = AppSource.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.textAlignment = .left
            $0.text = ""
        }
    }
    
    func setupConstraint() {
        
        contentView.addSubview(wrapper)
        wrapper.addSubview(nameLabel)
        
        wrapper.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(45)
        }
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview()
        }
        
    }
}




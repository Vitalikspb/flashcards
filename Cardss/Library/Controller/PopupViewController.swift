//
//  PopupViewController.swift



import Foundation
import UIKit
    
class PopupViewController: UIViewController {
    
    private lazy var topImageStick = UIView()
    private lazy var contentView = UIView()
    
    // MARK: - Open Proporties
    var willDisappear: (() -> Void)?
    
    // MARK: - Private Proporties
    
    // MARK: - Life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .formSheet
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
}

// MARK: - Layout Setup
private extension PopupViewController {
    func setupColors() {
        view.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func setupView() {
        setupColors()
        
        contentView.do {
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
        
        topImageStick.do {
            $0.backgroundColor = AppSource.Color.titleStick
            $0.layer.cornerRadius = 2
            $0.layer.masksToBounds = true
        }
    }
    
    func setupConstraints() {
        view.addSubview(contentView)
        view.addSubview(topImageStick)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        topImageStick.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(75)
            $0.height.equalTo(4)
        }
    }
}

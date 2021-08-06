//
//  BuyButton.swift


import UIKit

final class BuyButton: AnimateControl {
    // MARK: - UI Elements
    lazy var titleLabel = UILabel()
    private lazy var indicatorView = UIActivityIndicatorView()
    
    // MARK: - Open Proporties
    var isLoading = false {
        didSet {
            loading()
        }
    }
    
    // MARK: - Private Proporties
    private var animateTimer: Timer?
    
    // MARK: - Life cycle
    override init() {
        super.init()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Handlers
private extension BuyButton {
    @objc func tappedView() {
        sendActions(for: .touchUpInside)
    }
}

// MARK: - Private Methods
private extension BuyButton {
    func loading() {
        if isLoading {
            isUserInteractionEnabled = false
            self.titleLabel.alpha = 0
            self.indicatorView.startAnimating()
        } else {
            isUserInteractionEnabled = true
            indicatorView.stopAnimating()
            self.titleLabel.alpha = 1
        }
    }
}

// MARK: - Layout Setup
private extension BuyButton {
    func setupColors() {
        backgroundColor = AppSource.Color.background
        indicatorView.color = .white
    }
    
    func setupView() {
        setupColors()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        addGestureRecognizer(tap)

        titleLabel.do {
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.adjustsFontSizeToFitWidth = true
            $0.textColor = .black
        }
        
        indicatorView.do {
            $0.hidesWhenStopped = true
            $0.stopAnimating()
        }
    }
    
    func setupConstraints() {
        addSubview(titleLabel)
        addSubview(indicatorView)
        
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(55)
        }
        
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}

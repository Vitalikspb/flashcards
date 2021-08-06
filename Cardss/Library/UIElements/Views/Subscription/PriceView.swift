
import UIKit
import SnapKit

final public class PriceView: PriceBaseView {
    
    // MARK: - UI Elements
    
    /// Период подписки
    public lazy var periodLabel = UILabel()
    
    /// Цена подписки
    public lazy var priceLabel = UILabel()
    
    private lazy var radioImageView = UIImageView()
    private lazy var titleStack = UIStackView()
    
    // MARK: - Public Properties
    
    /// Цвет акцентных элементов, когда элемент выбран
    public var selectedElementColor: UIColor? = .yellow {
        didSet {
            setupState()
        }
    }
    
    /// Цвет акцентных элементов, когда элемент НЕ выбран
    public var unselectedElementColor: UIColor? = .gray {
        didSet {
            setupState()
        }
    }
    
    /// Цвет бэкграунда, когда элемент выбран
    public var selectedBackgroundColor: UIColor? = .clear {
        didSet {
            setupState()
        }
    }
    
    /// Цвет бэкграунда, когда элемент НЕ выбран
    public var unselectedBackgroundColor: UIColor? = .clear {
        didSet {
            setupState()
        }
    }
    
    /// Цвет такста, когда элемент выбран
    public var selectedTextColor: UIColor? = .blue {
        didSet {
            setupState()
        }
    }
    
    /// Цвет такста, когда элемент НЕ выбран
    public var unselectedTextColor: UIColor? = .gray {
        didSet {
            setupState()
        }
    }
    
    // MARK: - Lifecycle
    
    public override init() {
        super.init()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupFrame()
    }
    
    public override func setupState() {
        if isChoosen {
            Animate.spring(time: 0.3) { [self] in
                radioImageView.tintColor = AppSource.Color.textColor
                layer.borderWidth = 0
                radioImageView.image = AppSource.Image.rightArrow
                priceLabel.textColor = AppSource.Color.textColor
                periodLabel.textColor = AppSource.Color.textColor
                backgroundColor = AppSource.Color.backgroundActionButton
            }
        } else {
            radioImageView.tintColor = unselectedElementColor
            layer.borderWidth = 2
            layer.borderColor = AppSource.Color.backgroundActionButton.cgColor
            radioImageView.image = UIImage()
            priceLabel.textColor = unselectedTextColor
            periodLabel.textColor = unselectedTextColor
            backgroundColor = unselectedBackgroundColor
        }
    }
    
    override public func animate(state: Bool) {
        Animate.spring(time: 0.3) { [self] in alpha = state ? 0.7 : 1 }
    }
}

// MARK: - Layout Setup

private extension PriceView {
    func setupColors() {
        
    }
    
    func setupView() {
        setupColors()
        
        radioImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        periodLabel.do {
            $0.font = .systemFont(ofSize: 14, weight: .regular)
        }
        
        priceLabel.do {
            $0.font = .systemFont(ofSize: 13, weight: .regular)
            $0.textAlignment = .right
        }
        
        titleStack.do {
            $0.axis = .horizontal
            $0.spacing = 2
        }
        
        setupState()
    }
    
    func setupFrame() {
        
    }
    
    
    func setupConstraints() {
        titleStack.addArrangedSubview(periodLabel)
        titleStack.addArrangedSubview(priceLabel)
        addSubview(radioImageView)
        addSubview(titleStack)
        
        self.snp.makeConstraints {
            $0.height.equalTo(55).priority(990)
        }
        
        radioImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
        }
        
        titleStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(radioImageView.snp.trailing).offset(11)
            $0.trailing.equalToSuperview().offset(-14)
        }
    }
}

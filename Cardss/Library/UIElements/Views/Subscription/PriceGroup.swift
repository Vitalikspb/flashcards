

import UIKit
import SnapKit

final public class PriceGroup: UIControl {
    
    private lazy var stackView = UIStackView()
    
    // MARK: - Public Properties
    
    /// Текущий индекс выбранного элемента, по умолчанию равен -1
    public var selectedIndex: Int = 0 {
        didSet {
            guard let selectedItem = item(at: selectedIndex) else { return }
            item(at: oldValue)?.isChoosen = false
            selectedItem.isChoosen = true
            stackView.bringSubviewToFront(selectedItem)
        }
    }
    
    /// Ось, по которой расположены элементы
    public var axis: NSLayoutConstraint.Axis = .vertical {
        didSet {
            stackView.axis = axis
        }
    }
    
    /// Расстояние между элементами
    public var spacing: CGFloat = 10 {
        didSet {
            stackView.spacing = spacing
        }
    }
    
    // MARK: - Private Properties
    
    private var items: [PriceBaseView] {
        return stackView.arrangedSubviews.compactMap { $0 as? PriceBaseView }
    }
    
    // MARK: - Lifecycle
    
    public init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Handlers

private extension PriceGroup {
    @objc func itemTapped(_ sender: PriceBaseView) {
        guard let index = items.firstIndex(of: sender), index != selectedIndex else { return }
        selectedIndex = index
        stackView.bringSubviewToFront(sender)
        sendActions(for: .valueChanged)
    }
}

// MARK: - Open Methods

public extension PriceGroup {
    func addItems(priceViews: [PriceBaseView]) {
        priceViews.forEach { addItem(priceView: $0) }
    }
    
    func addItem(priceView: PriceBaseView) {
        stackView.addArrangedSubview(priceView)
        priceView.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - Private Methods

private extension PriceGroup {
    func item(at index: Int) -> PriceBaseView? {
        guard index >= 0 && index < stackView.arrangedSubviews.count else { return nil }
        return stackView.arrangedSubviews[index] as? PriceBaseView
    }
}

// MARK: - Layout Setup

private extension PriceGroup {
    
    func setupView() {
        
        stackView.do {
            $0.axis = axis
            $0.distribution = .fillEqually
            $0.spacing = spacing
        }
    }
    
    func setupConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}


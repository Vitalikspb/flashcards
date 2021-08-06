

import UIKit
import SnapKit
import Then

class LanguagePickerView: UIView {
    
    private lazy var languageWrapperView = UIView()
    private lazy var languageLabel = UILabel()
    private lazy var languageRightImage = UIImageView()
    private lazy var setLanguageView = UIView()
    private lazy var setLanguageViewWrapper = UIView()
    private lazy var languagePickerView = UIPickerView()
    
    private var pickerLanguageData: [String] = [String]()
    
    public var sendLanguageName: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LanguagePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerLanguageData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerLanguageData[row]
    }
}

private extension LanguagePickerView {
    func setupColors() {
        self.backgroundColor = .clear
    }
    
    func setupProperties() {
        pickerLanguageData = ["Ru", "Eng", "Ger", "Jap", "Chi", "Ita"]
    }
    func setupView() {
        setupColors()
        setupProperties()
    
    }
    
    func setupConstraints() {
        
    }
}

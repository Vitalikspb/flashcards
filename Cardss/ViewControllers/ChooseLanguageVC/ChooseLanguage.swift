//
//  ChooseLanguage.swift
//  Cardss
//
//  Created by VITALIY SVIRIDOV on 10.08.2021.
//

import UIKit
import SnapKit
import Then
import FlagKit

class ChooseLanguage: PopupViewController {
    
//    MARK: - UI Elements

    private lazy var setLanguageView = UIView()
    private lazy var setLanguageViewWrapper = UIView()
    private lazy var languagePickerView = UIPickerView()
    
    private lazy var helloLabel = UILabel()
    private lazy var logoImageView = UIImageView()
    private lazy var nativeLanguageLabel = UILabel()
    private lazy var nativeWrapperView = ChooseButton()
    private lazy var foreignLanguageLabel = UILabel()
    private lazy var foreignWrapperView = ChooseButton()
    private lazy var saveButtonLabel = ActionButton()
    
    
//    MARK: - Private Properties
    
    private lazy var pickerData: [String] = [String]()
    private lazy var selectedNativeLang = ""
    private lazy var selectedForeignLang = ""
    private lazy var selectedLanguage: Bool = true
    private var currentCardsCollection: [CardsModel]!
    private var moduleFactory = FactoryPresent()
    
    
//    MARK: - life cycle
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: UserDefaults.firstLaunchApp) {
            DispatchQueue.main.async { [weak self] in
                self?.moduleFactory.switchToSecond(toModule: .cards)
            }
        } else {
            setupView()
            setupConstraints()
        }
    }
}


//    MARK: - Selectors
extension ChooseLanguage {
    @objc func saveButtonTapped() {
        setupUserDefaultSettings()
    }
    
    @objc func showNativeLanguageViewTapped() {
        selectedLanguage = true
        setLanguageView.isHidden = false
    }
    
    @objc func showFofeignLanguageViewTapped() {
        selectedLanguage = false
        setLanguageView.isHidden = false
    }
    
    @objc func hideLanguageViewTapped() {
        setLanguageView.isHidden = true
    }
}

//MARK: - Helpers function

extension ChooseLanguage {
    
    func setupUserDefaultSettings() {
        let userDefault = UserDefaults.standard
        
        userDefault.synchronize()
        if !userDefault.bool(forKey: UserDefaults.firstLaunchApp) {
            userDefault.set(false, forKey: UserDefaults.premium)
            userDefault.set(true, forKey: UserDefaults.firstLaunchApp)
            userDefault.set(true, forKey: UserDefaults.showHints)

            // при первом запуске задаем пустые значения всей базе
            currentCardsCollection = [
                CardsModel(
                    uid: "CardsCollection",
                    educationTime: 0,
                    countAllWords: 0,
                    countFiveStar: 0,
                    countThreeStar: 0,
                    countOneStar: 0,
                    repeatsCount: 0,
                    currentNativeLang: nativeWrapperView.themeLabel.text ?? "Русский",
                    currentForeignLang: foreignWrapperView.themeLabel.text ?? "Английский",
                    countLeaningWordsSevenDays: [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                 WeekDayCounter.returnDateOfDate()[1]: 0,
                                                 WeekDayCounter.returnDateOfDate()[2]: 0,
                                                 WeekDayCounter.returnDateOfDate()[3]: 0,
                                                 WeekDayCounter.returnDateOfDate()[4]: 0,
                                                 WeekDayCounter.returnDateOfDate()[5]: 0,
                                                 WeekDayCounter.returnDateOfDate()[6]: 0
                    ],
                    educationTimeSevenDays: [WeekDayCounter.returnDateOfDate()[0]: 0,
                                             WeekDayCounter.returnDateOfDate()[1]: 0,
                                             WeekDayCounter.returnDateOfDate()[2]: 0,
                                             WeekDayCounter.returnDateOfDate()[3]: 0,
                                             WeekDayCounter.returnDateOfDate()[4]: 0,
                                             WeekDayCounter.returnDateOfDate()[5]: 0,
                                             WeekDayCounter.returnDateOfDate()[6]: 0
                    ],
                    repeatsCountSevenDays: [WeekDayCounter.returnDateOfDate()[0]: 0,
                                            WeekDayCounter.returnDateOfDate()[1]: 0,
                                            WeekDayCounter.returnDateOfDate()[2]: 0,
                                            WeekDayCounter.returnDateOfDate()[3]: 0,
                                            WeekDayCounter.returnDateOfDate()[4]: 0,
                                            WeekDayCounter.returnDateOfDate()[5]: 0,
                                            WeekDayCounter.returnDateOfDate()[6]: 0
                    ],
                    cardsCollection: [])
            ]
            UserDefaults.saveToUD(currentCardsCollection)
        }
        moduleFactory.switchToSecond(toModule: .cards)
    }
}

//    MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ChooseLanguage: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 60))
        let langImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let langName  = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 50))

        langImage.image = setImage(with: pickerData[row])
        langName.text = pickerData[row]
        myView.addSubview(langImage)
        myView.addSubview(langName)
        langImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(75)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(30)
        }
        langName.snp.makeConstraints {
            $0.leading.equalTo(langImage.snp.trailing).offset(15)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        return myView
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedLanguage  {
        case true:
            nativeWrapperView.themeLabel.text = pickerData[row]
            nativeWrapperView.image = setImage(with: pickerData[row])
            selectedNativeLang = selectThemeLang(is: pickerData[row])
            
        case false:
            foreignWrapperView.themeLabel.text = pickerData[row]
            foreignWrapperView.image = setImage(with: pickerData[row])
            selectedForeignLang = selectThemeLang(is: pickerData[row])
        }
        if selectedForeignLang != "" && selectedNativeLang != "" {
            saveButtonLabel.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
        } else {
            saveButtonLabel.setTitleColor(.lightGray, for: .normal)
        }
    }
}


//    MARK: - initial setup
extension ChooseLanguage {
    
    func selectThemeLang(is name: String) -> String {
        // возвращаем на русском чтобы открыть файл с русским названием
        switch name {
        case AppSource.Text.languages.russian: return "Русский"
        case AppSource.Text.languages.english: return "Английский"
        case AppSource.Text.languages.german: return "Немецкий"
        case AppSource.Text.languages.french: return "Французский"
        case AppSource.Text.languages.spanish: return "Испанский"
        case AppSource.Text.languages.italy: return "Итальянский"
        case AppSource.Text.languages.turkish: return "Турецкий"
        case AppSource.Text.languages.chine: return "Китайский"
        default:
            return "Error"
        }
    }
    
    func setImage(with name: String) -> UIImage {
        var countryCode = ""
        switch name {
        case AppSource.Text.languages.russian: countryCode = "RU"
        case AppSource.Text.languages.english: countryCode = "US"
        case AppSource.Text.languages.german:  countryCode = "DE"
        case AppSource.Text.languages.french:  countryCode = "FR"
        case AppSource.Text.languages.spanish: countryCode = "ES"
        case AppSource.Text.languages.italy:   countryCode = "IT"
        case AppSource.Text.languages.turkish: countryCode = "TR"
        case AppSource.Text.languages.chine:   countryCode = "CN"
        default: print("error")
        }
        let flag = Flag(countryCode: countryCode)!
        let styledImage = flag.image(style: .circle)
        return styledImage
    }
    
    func setupColors() {
        guard #available(iOS 13.0, *) else { return }
        switch UserDefaults.standard.integer(forKey: UserDefaults.settingNightMode) {
        case 0:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified }
        case 1:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light }
        case 2:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark }
        default:
            UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .unspecified }
        }
        view.backgroundColor = AppSource.Color.background
    }
    
    func setupProperties() {
        pickerData = Flags.flagArrayForChooseGroup
        selectedNativeLang = "Русский"
        selectedForeignLang = "Английский"
    }
    
    //    MARK: - setupView
    func setupView() {
        setupColors()
        setupProperties()

        helloLabel.do {
            $0.text = AppSource.Text.ChooseLanguageVC.helloLabel
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        }
        logoImageView.do {
            $0.image = AppSource.Image.logo
            $0.contentMode = .scaleAspectFill
        }
        nativeLanguageLabel.do {
            $0.text = AppSource.Text.ChooseLanguageVC.nativeLanguage
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        foreignLanguageLabel.do {
            $0.text = AppSource.Text.ChooseLanguageVC.foreignLanguage
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        nativeWrapperView.do {
            languagePickerView.selectRow(0, inComponent: 0, animated: true)
            $0.themeLabel.text = AppSource.Text.languages.russian
            $0.image = setImage(with: AppSource.Text.languages.russian)
            let tap = UITapGestureRecognizer(target: self, action: #selector(showNativeLanguageViewTapped))
            $0.addGestureRecognizer(tap)
        }
        foreignWrapperView.do {
            languagePickerView.selectRow(1, inComponent: 0, animated: true)
            $0.themeLabel.text = AppSource.Text.languages.english
            $0.image = setImage(with: AppSource.Text.languages.english)
            let tap = UITapGestureRecognizer(target: self, action: #selector(showFofeignLanguageViewTapped))
            $0.addGestureRecognizer(tap)
        }

        setLanguageView.do {
            $0.backgroundColor = AppSource.Color.backgroundWithAlpha
            $0.isHidden = true
            $0.addSubview(setLanguageViewWrapper)
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideLanguageViewTapped))
            $0.addGestureRecognizer(tap)
        }
        
        setLanguageViewWrapper.do {
            $0.backgroundColor = AppSource.Color.background
            $0.layer.cornerRadius = 30
            $0.clipsToBounds = true
            $0.addSubview(languagePickerView)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = AppSource.Color.background.cgColor
        }
        
        languagePickerView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        
        saveButtonLabel.do {
            $0.setTitle(AppSource.Text.Shared.save, for: .normal)
            $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            $0.transform = .init(translationX: 0, y: 15)
            $0.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
        }
        
    }
//        MARK: - setupConstraints
    func setupConstraints() {
        
        view.addSubview(helloLabel)
        view.addSubview(logoImageView)
        view.addSubview(nativeLanguageLabel)
        view.addSubview(nativeWrapperView)
        view.addSubview(foreignLanguageLabel)
        view.addSubview(foreignWrapperView)
        view.addSubview(saveButtonLabel)
        view.addSubview(setLanguageView)
        
        helloLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(80)
        }
        logoImageView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(helloLabel.snp.bottom).offset(10)
            $0.top.lessThanOrEqualTo(helloLabel.snp.bottom).offset(150)
            $0.size.greaterThanOrEqualTo(50)
            $0.size.lessThanOrEqualTo(120)
            $0.centerX.equalToSuperview()
        }
        nativeLanguageLabel.snp.makeConstraints {
            $0.bottom.equalTo(nativeWrapperView.snp.top).offset(-5)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(50)
        }
        nativeWrapperView.snp.makeConstraints {
            $0.bottom.equalTo(foreignLanguageLabel.snp.top).offset(-50)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(120)
        }
        foreignLanguageLabel.snp.makeConstraints {
            $0.bottom.equalTo(foreignWrapperView.snp.top).offset(-5)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(50)
        }
        foreignWrapperView.snp.makeConstraints {
            $0.bottom.equalTo(saveButtonLabel.snp.top).offset(-25)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(120)
        }
        saveButtonLabel.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-25)
        }
        setLanguageView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
        setLanguageViewWrapper.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(280)
        }
        languagePickerView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
}

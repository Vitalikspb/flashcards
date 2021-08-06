

import UIKit
import SnapKit
import Then
import FlagKit

enum ShowTextView {
    case top
    case bottom
}

class AddTextViewController: UIViewController {
    
    //    MARK: - UI Elements
    private lazy var headerTitleWrapper = UIView()
    private lazy var headerTitleStick = UIView()
    private lazy var headerTitleLabel = UILabel()
    private lazy var doneLabel = UILabel()
    
    private lazy var setLanguageView = UIView()
    private lazy var setLanguageViewWrapper = UIView()
    private lazy var languagePickerView = UIPickerView()
    private lazy var nativeWrapperView = ChooseButton()
    private lazy var mainTextView = UITextView()
    
    //    MARK: - Properties
    var inputText: String!
    var setupTextFromNewTextView: ((_ curLang: String, _ curView: ShowTextView, _ curText: String) -> Void)?
    var fromVC: ShowTextView = .top
    var selectedNativeLang = ""
    private var keyboardShow = false
    private var selectedLanguage = false
    private var firstSelectedLanguage = 0
    private lazy var pickerData: [String] = [String]()
    
    //    MARK: - Life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        registerKeyboardNotification()
        registerToolBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViewLayout()
    }
    deinit {
        removeKeyboardNotification()
    }
    
    //    MARK: - Setup Keyboard
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func willShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let frame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 2.5) {
            var heightSize = 65
            if UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue {
                heightSize = 205
            } else if UIScreen.main.bounds.height <= DeviceHeight.iphone6s.rawValue {
                heightSize = 120
            } else if UIScreen.main.bounds.height <= DeviceHeight.iphoneX.rawValue {
                heightSize = 125
            } else if UIScreen.main.bounds.height <= DeviceHeight.iphone11.rawValue {
                heightSize = 65
            }
            self.mainTextView.snp.remakeConstraints {
                $0.top.equalTo(self.nativeWrapperView.snp.bottom).offset(15)
                $0.leading.equalToSuperview().offset(15)
                $0.trailing.equalToSuperview().offset(-15)
                $0.height.equalTo(frame.height - CGFloat(heightSize))
                
            }
        }
        keyboardShow = true
    }
    
    @objc func willHide() {
        mainTextView.snp.remakeConstraints {
            $0.top.equalTo(nativeWrapperView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        keyboardShow = false
    }
}

private extension AddTextViewController {
    
    
    func registerToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let doneButton = UIBarButtonItem(title: AppSource.Text.Shared.done,
                                         style: .done,
                                         target: self,
                                         action: #selector(dismissKeyboard))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        mainTextView.inputAccessoryView = toolBar
    }
    
    @objc func doneLabelTapped() {
        if keyboardShow {
            dismissKeyboard()
            mainTextView.resignFirstResponder()
            doneLabel.text = AppSource.Text.Shared.close
        } else {
            if mainTextView.text.filter({ $0 == "\n" }).count < 4 {
                // выводим ошибку что количество изучаемых слов должно быть больше 5 или больше слов
                errorAlertWithCancel(with: AppSource.Text.Shared.errorCountOfNewWords)
            } else {
                setupTextFromNewTextView?(selectedNativeLang, fromVC, mainTextView.text)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func errorAlertWithCancel(with text: String) {
        let alertController = CreateAlerts.errorAlertWithCancel(with: AppSource.Text.Shared.error,
                                                                and: text) { [weak self] in
            guard let self = self else { return }
            self.setupTextFromNewTextView?(self.selectedNativeLang, self.fromVC, "")
            self.dismiss(animated: true, completion: nil)
        }
        
        present(alertController, animated: true)
    }
    func errorAlert(with text: String) {
        let alertController = CreateAlerts.errorAlert(with: AppSource.Text.Shared.error,
                                                      and: text)
        present(alertController, animated: true)
    }
    
}

//    MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddTextViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 60))
        let langImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let langName  = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 50))
        
        langImage.image = Flags.setImage(with: pickerData[row])
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
        nativeWrapperView.themeLabel.text = pickerData[row]
        nativeWrapperView.image = Flags.setImage(with: pickerData[row])
        selectedNativeLang = pickerData[row]
        
        if selectedNativeLang != "" {
            doneLabel.textColor = AppSource.Color.blueTextColor
        } else {
            doneLabel.textColor = .lightGray
        }
    }
}

//    MARK: - UITextViewDelegate
extension AddTextViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        doneLabel.text = AppSource.Text.Shared.done
        doneLabel.textColor = AppSource.Color.blueTextColor
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        doneLabel.text = AppSource.Text.Shared.close
    }
}

//    MARK: - Private Methods
private extension AddTextViewController {
    func setupViewLayout() {
        mainTextView.layer.cornerRadius = 20
        mainTextView.layer.masksToBounds = true
    }
    
    func setupColors() {
        view.backgroundColor = AppSource.Color.background
        mainTextView.backgroundColor = AppSource.Color.backgroundWrapperView
    }
    @objc func showNativeLanguageViewTapped() {
        dismissKeyboard()
        mainTextView.resignFirstResponder()
        selectedLanguage = true
        setLanguageView.isHidden = false
    }
    @objc func hideLanguageViewTapped() {
        setLanguageView.isHidden = true
    }
    func setupProperties() {
        pickerData = Flags.flagArrayForAddNewWord
        for (index, element) in pickerData.enumerated() {
            if element == selectedNativeLang {
                firstSelectedLanguage = index
            }
        }
    }
    //    MARK: - Setup View
    func setupView() {
        setupColors()
        setupProperties()
        view.do {_ in
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        doneLabel.do {
            $0.text = AppSource.Text.Shared.close
            $0.textColor = AppSource.Color.selectedStrokeBottomButton
            $0.textAlignment = .right
            $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(doneLabelTapped))
            $0.addGestureRecognizer(tap)
        }
        headerTitleWrapper.do {
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.addSubview(headerTitleLabel)
            $0.addSubview(headerTitleStick)
        }
        headerTitleStick.do {
            $0.backgroundColor = AppSource.Color.titleStick
        }
        
        headerTitleLabel.do {
            $0.text = AppSource.Text.AddNewWordsVC.add
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        nativeWrapperView.do {
            if selectedNativeLang != "" {
                $0.themeLabel.text = pickerData[firstSelectedLanguage]
                $0.image = Flags.setImage(with: pickerData[firstSelectedLanguage])
            } else {
                $0.themeLabel.text = AppSource.Text.languages.russian
                $0.image = Flags.setImage(with: AppSource.Text.languages.russian)
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(showNativeLanguageViewTapped))
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
            if selectedNativeLang == "" {
                selectedNativeLang = "Русский"
            } else {
                languagePickerView.selectRow(firstSelectedLanguage, inComponent: 0, animated: true)
            }
        }
        mainTextView.do {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.text = inputText
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.delegate = self
            $0.tag = 0
        }
        
    }
    //    MARK: - Setup Constraints
    func setupConstraints() {
        view.addSubview(headerTitleWrapper)
        view.addSubview(doneLabel)
        view.addSubview(nativeWrapperView)
        view.addSubview(mainTextView)
        view.addSubview(setLanguageView)
        
        headerTitleWrapper.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(90)
            $0.leading.trailing.equalToSuperview()
        }
        headerTitleStick.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        headerTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        
        doneLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(35)
            $0.centerY.equalTo(headerTitleLabel.snp.centerY)
        }
        nativeWrapperView.snp.makeConstraints {
            $0.top.equalTo(headerTitleStick.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        mainTextView.snp.makeConstraints {
            $0.top.equalTo(nativeWrapperView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            if UIScreen.main.bounds.height < DeviceHeight.iphoneX.rawValue {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            } else {
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
            }
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

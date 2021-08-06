

import UIKit
import SnapKit
import Then

//    MARK: - Public Enum - ShowFromVC
public enum ShowFromVC {
    case AddCards
    case CollectionCell
}

class AddWordController: PopupViewController {
    //    MARK: - UI Elements
    private lazy var scrollWrapper = VerticalScrollView()
    private lazy var headerTitleWrapper = UIView()
    private lazy var headerTitleStick = UIView()
    private lazy var headerTitleLabel = UILabel()
    private lazy var doneLabel = UILabel()
    
    private lazy var topContent = UIView()
    private lazy var theme = UITextField()
    private lazy var name = UITextField()
    private lazy var chooseButton = ChooseButton()
    
    private lazy var stackViewText = UIStackView()
    private lazy var textViewTopView = UITextView()
    private lazy var upperTextViewTopView = UIView()
    private lazy var upperlabelTopView = UILabel()
    private lazy var upperFlagTopImageView = UIImageView()
    private lazy var upperWordsCountTopView = UILabel()
    
    private lazy var textViewBottomView = UITextView()
    private lazy var upperTextViewBottomView = UIView()
    private lazy var upperlabelBottomView = UILabel()
    private lazy var upperFlagBottomImageView = UIImageView()
    private lazy var upperWordsCountBottomView = UILabel()
    
    private lazy var saveButtonLabel = ActionButton()
    private lazy var deleteButtonLabel = ActionButton()
    
    private var currentCardsCollection: [CardsModel]!
    
    
    //    MARK: - Public Properties
    var fromVC: ShowFromVC!
    var indexPath: IndexPath?
    var updateCollectionView: (() -> ())?
    
    //    MARK: - Private Properties
    private lazy var leftString: String = ""
    private lazy var rightString: String = ""
    private lazy var saveButtonBoolean = false
    private lazy var selectedTextView = false
    private lazy var selectedTextField = false
    private lazy var selectedTheme = ""
    private lazy var selectedName = ""
    private lazy var selectedNativeLang: String = ""
    private lazy var selectedForeignLang: String = ""
    private lazy var countOfWords: Int = 0
    private lazy var fromLibrary = false
    
    
    //    MARK: - life cycle
    override init() {
        super.init()
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
        let screensize: CGRect = UIScreen.main.bounds
        scrollWrapper.contentSize = CGSize(width: screensize.width, height: screensize.height-350)
    }
    deinit {
        removeKeyboardNotification()
    }
}



//    MARK: - Show/hide keyboard 
private extension AddWordController {
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
        if self.selectedTextField == false {
            if self.selectedTextView {
                self.scrollWrapper.contentOffset = CGPoint(x: 0, y: (frame.height))
            } else {
                self.scrollWrapper.contentOffset = CGPoint(x: 0, y: (frame.height - self.textViewBottomView.frame.height))
            }
        }
    }
    
    @objc func willHide() {
        scrollWrapper.contentOffset = CGPoint.zero
    }
}

private extension AddWordController {
    func registerToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let doneButton = UIBarButtonItem(title: AppSource.Text.Shared.done,
                                         style: .done,
                                         target: self,
                                         action: #selector(doneButtonTapped))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        name.inputAccessoryView = toolBar
        theme.inputAccessoryView = toolBar
    }
    @objc func doneButtonTapped() {
        name.resignFirstResponder()
        theme.resignFirstResponder()
        setupDoneButton()
    }
    func setupDoneButton() {
        if name.text == "" && theme.text == "" &&
            !upperlabelTopView.isHidden && !upperlabelBottomView.isHidden {
            // если все пусто и ничего не менялось
            doneLabel.isHidden = true
        } else {
            // если чтото поменялось
            switch fromVC {
            case .AddCards: doneLabel.isHidden = false
            case .CollectionCell: doneLabel.isHidden = true
            case .none:
                print("error")
            }
            doneLabel.text = AppSource.Text.Shared.anew
        }
        
    }
    func selectedLang(is name: String) -> String {
        // возвращаем на русском чтобы открыть файл с русским названием
        switch name {
        case "Русский": return AppSource.Text.languages.russian
        case "Английский": return AppSource.Text.languages.english
        case "Немецкий": return AppSource.Text.languages.german
        case "Французский": return AppSource.Text.languages.french
        case "Испанский": return AppSource.Text.languages.spanish
        case "Итальянский": return AppSource.Text.languages.italy
        case "Турецкий": return AppSource.Text.languages.turkish
        case "Китайский": return AppSource.Text.languages.chine
        default:
            return AppSource.Text.languages.russian
        }
    }
    @objc func showthemeViewTapped() {
        let vc = ChooseGroupOfCards()
        
        
        vc.choosenDataFile = { [weak self] (nameLang, selectedThemeTopic, selectedThemeName, level, native, foreign) in
            guard let self = self else { return }
            self.textViewTopView.text = self.setupChoosenTheme(theme: nameLang, with: native)
            self.textViewBottomView.text = self.setupChoosenTheme(theme: nameLang, with: foreign)
            self.name.text = selectedThemeTopic
            self.selectedNativeLang = self.selectedLang(is: native)
            self.selectedForeignLang = self.selectedLang(is: foreign)
            self.upperFlagTopImageView.image = Flags.setImage(with: self.selectedNativeLang)
            self.upperFlagBottomImageView.image = Flags.setImage(with: self.selectedForeignLang)
            self.theme.text = selectedThemeName
            self.selectedTheme = selectedThemeName
            self.fromLibrary = true
            self.saveButtonLabel.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
            self.saveButtonBoolean = true
            self.upperTextViewTopView.backgroundColor = .clear
            self.upperlabelTopView.isHidden = true
            self.upperTextViewBottomView.backgroundColor = .clear
            self.upperlabelBottomView.isHidden = true
            self.doneLabel.isHidden = false
            self.doneLabel.text = AppSource.Text.Shared.anew
        }
        present(vc, animated: true, completion: nil)
    }
    func correctLocalizeThemeName(is level: Int) -> String {
        switch level {
        case 0: return ""
        case 1: return AppSource.Text.AddNewWordsVC.beginer
        case 2: return AppSource.Text.AddNewWordsVC.middle
        case 3: return AppSource.Text.AddNewWordsVC.middlePlus
        case 4: return AppSource.Text.AddNewWordsVC.advanced
        case 5: return AppSource.Text.AddNewWordsVC.advancedPlus
        default:
            return ""
        }
    }
    func setupChoosenTheme(theme name: String, with lang: String) -> String {
        let file = name + lang
        var text = ""
        if let path = Bundle.main.path(forResource: file, ofType: ".txt") {
            if let textOfFile = try? String(contentsOfFile: path) {
                text = textOfFile
            }
        }
        return text
    }
    
    
    @objc func doneLabelTapped() {
        if doneLabel.text == AppSource.Text.Shared.anew {
            fromLibrary = false
            name.text = ""
            name.isUserInteractionEnabled = true
            theme.text = ""
            theme.isUserInteractionEnabled = true
            selectedNativeLang = AppSource.Text.languages.russian
            selectedForeignLang =  AppSource.Text.languages.english
            textViewTopView.text = ""
            upperTextViewTopView.backgroundColor = AppSource.Color.backgroundWrapperView
            upperlabelTopView.isHidden = false
            textViewBottomView.text = ""
            upperTextViewBottomView.backgroundColor = AppSource.Color.backgroundWrapperView
            upperlabelBottomView.isHidden = false
            doneLabel.isHidden = true
            switchSetToOn()
        } else {
            dismissKeyboard()
            setupDoneButton()
        }
    }
    
    @objc func addButtonTapped() {
        if saveButtonBoolean {
            if name.text == "" {
                errorAlert(with: AppSource.Text.AddNewWordsVC.setName)
            } else if textViewTopView.text == "" {
                errorAlert(with: AppSource.Text.AddNewWordsVC.setNativeWords)
            } else if textViewBottomView.text == "" {
                errorAlert(with: AppSource.Text.AddNewWordsVC.setForeignWords)
            } else if countOfLines(with: textViewBottomView) != countOfLines(with: textViewTopView) {
                errorAlert(with: AppSource.Text.AddNewWordsVC.countOfLinesError)
                upperWordsCountTopView.text = "\(countOfLines(with: textViewTopView))"
                upperWordsCountBottomView.text = "\(countOfLines(with: textViewBottomView))"
                // показывать лэйблы с количеством текста
            } else if saveButtonBoolean {
                addNewPackOfCard()
                doneLabel.isHidden = true
            }
            
        }
    }
    
    
    
    func countOfLines(with text: UITextView) -> Int {
        guard let text = text.text else  {
            return 0
        }
        let newlineCount = text.filter {$0 == "\n"}.count
        return newlineCount + 1
    }
    
    
    func errorAlert(with text: String) {
        let alertController = CreateAlerts.errorAlert(with: AppSource.Text.Shared.error,
                                                               and: text)
        present(alertController, animated: true)
    }
    
    func endOfActionButton() {
        UserDefaults.saveToUD(currentCardsCollection)
        updateCollectionView!()
        dismiss(animated: true)
    }
    
    @objc func deleteButtonTapped() {
        guard let currentIndexPath = indexPath else { return }
        // сначала сравнить откуда удаляем из уникальных тем или тем где есть другие коллекции
        // удалить из общих слов слова из коллекции ( количество )
        // удалить из общие колва звезд 1-3-5 звезды из коллекции
        // удалить саму коллекцию
        let tempWordCount = currentCardsCollection[0].cardsCollection![currentIndexPath.section].info[currentIndexPath.row].countWords
        let tempFiveStarCount = currentCardsCollection[0].cardsCollection![currentIndexPath.section].info[currentIndexPath.row].fiveStarWords
        let tempThreeStarCount = currentCardsCollection[0].cardsCollection![currentIndexPath.section].info[currentIndexPath.row].threeStarWords
        let tempOneStarCount = currentCardsCollection[0].cardsCollection![currentIndexPath.section].info[currentIndexPath.row].oneStarWords
        
        currentCardsCollection[0].countAllWords -= tempWordCount
        currentCardsCollection[0].countFiveStar -= tempFiveStarCount
        currentCardsCollection[0].countThreeStar -= tempThreeStarCount
        currentCardsCollection[0].countOneStar -= tempOneStarCount
        
        
        if currentCardsCollection[0].cardsCollection![currentIndexPath.section].info.count > 1 {
            // если в теме есть другме коллекции то удаляем выбранную коллекцию
            currentCardsCollection[0].cardsCollection![currentIndexPath.section].info.remove(at: currentIndexPath.row)
        } else {
            // если в теме только 1 коллекция то удаляем всю тему
            currentCardsCollection[0].cardsCollection!.remove(at: currentIndexPath.section)
        }
        endOfActionButton()
    }
    
    func addNewPackOfCard() {
        // задаем данные в модель из заполненных свойств
        selectedTheme = theme.text ?? AppSource.Text.Shared.defaultTheme
        selectedName = name.text ?? AppSource.Text.Shared.noThemeName
        
        var currentIndexPath = IndexPath()
        if fromVC == .CollectionCell {
            guard let indexPath = indexPath else { return }
            currentIndexPath = indexPath
        }
        
        var tempArrayNativeWords: [Int: String] = [:]
        var tempArrayNativeWordsValue = textViewTopView.text.components(separatedBy: "\n")
        tempArrayNativeWordsValue.removeLast()
        
        var tempArrayForeignWords: [Int: String] = [:]
        var tempArrayForeignWordsValue = textViewBottomView.text.components(separatedBy: "\n")
        tempArrayForeignWordsValue.removeLast()
        
        countOfWords = tempArrayNativeWordsValue.count
        
        for index in 0..<countOfWords {
            tempArrayNativeWords[index] = tempArrayNativeWordsValue[index]
            tempArrayForeignWords[index] = tempArrayForeignWordsValue[index]
        }
        
        currentCardsCollection[0].countAllWords += countOfWords
        
        guard let cards = currentCardsCollection[0].cardsCollection else { return }
        
        var matchedNewTheme = -1
        for (index, _) in cards.enumerated() {
            if selectedTheme == cards[index].theme {
                matchedNewTheme = index
            }
        }

        if matchedNewTheme >= 0 {
            // если у нас уже есть в базе тема с текущим названием тогда добавляем коллекцию в имеющуюся тему
            switch fromVC {
            case .AddCards:
                currentCardsCollection[0].cardsCollection![matchedNewTheme].theme = selectedTheme
                currentCardsCollection[0].cardsCollection![matchedNewTheme].info.append(contentsOf: [CollectionInfo(name: selectedName,
                                                                                              nativeLanguage: selectedNativeLang,
                                                                                              foreignLanguage: selectedForeignLang,
                                                                                              dateAdded: Date(),
                                                                                              countWords: countOfWords,
                                                                                              fiveStarWords: 0,
                                                                                              threeStarWords: 0,
                                                                                              oneStarWords: 0,
                                                                                              arrayNativeWords: tempArrayNativeWords,
                                                                                              arrayForeignWords: tempArrayForeignWords)])
            case .CollectionCell:
                currentCardsCollection[0].cardsCollection![matchedNewTheme].theme = selectedTheme
                currentCardsCollection[0].cardsCollection![matchedNewTheme].info[currentIndexPath.row] =
                    CollectionInfo(name: selectedName,
                                    nativeLanguage: selectedNativeLang,
                                    foreignLanguage: selectedForeignLang,
                                    dateAdded: Date(),
                                    countWords: countOfWords,
                                    fiveStarWords: 0,
                                    threeStarWords: 0,
                                    oneStarWords: 0,
                                    arrayNativeWords: tempArrayNativeWords,
                                    arrayForeignWords: tempArrayForeignWords)
            case .none:
                print("Error save new collection in theme")
            }
            
        } else {
            // если у нас в базе тема с текущим названием отсутствует, тогда в базу добавляем новую тему с коллекцией
            currentCardsCollection[0].cardsCollection!.append(CardsCollection(theme: selectedTheme,
                                                                              info: [CollectionInfo(name: selectedName,
                                                                                                    nativeLanguage: selectedNativeLang,
                                                                                                    foreignLanguage: selectedForeignLang,
                                                                                                    dateAdded: Date(),
                                                                                                    countWords: countOfWords,
                                                                                                    fiveStarWords: 0,
                                                                                                    threeStarWords: 0,
                                                                                                    oneStarWords: 0,
                                                                                                    arrayNativeWords: tempArrayNativeWords,
                                                                                                    arrayForeignWords: tempArrayForeignWords)]))
        }
        endOfActionButton()
    }
    @objc func fromOneListSwitchTapped() {
        changeListView()
    }
    
    func changeListView() {
        leftString = textViewTopView.text
        rightString = textViewBottomView.text
    }
    func switchSetToOn() {
        if name.text == "" || textViewTopView.text == "" || textViewBottomView.text == "" {
            saveButtonLabel.setTitleColor(.lightGray, for: .normal)
            saveButtonBoolean = false
        } else {
            saveButtonLabel.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
            saveButtonBoolean = true
        }
    }
    @objc func showTextViewLeftTapped() {
        presentAddNewText(0) // 0 top textView
    }
    @objc func showTextViewRightTapped() {
        presentAddNewText(1) // 1 bottom textView
    }
    
    func presentAddNewText(_ textViewTag: Int) {
        let vc = AddTextViewController()
        upperWordsCountTopView.text = ""
        upperWordsCountBottomView.text = ""
        if textViewTag == 0 {                              // 0 top textView
            vc.inputText = textViewTopView.text
            vc.fromVC = ShowTextView.top
            vc.selectedNativeLang = selectedNativeLang
            upperTextViewTopView.backgroundColor = .clear
            upperlabelTopView.isHidden = true
        } else if textViewTag == 1 {                       // 1 bottom textView
            vc.inputText = textViewBottomView.text
            vc.fromVC = ShowTextView.bottom
            vc.selectedNativeLang = selectedForeignLang
            upperTextViewBottomView.backgroundColor = .clear
            upperlabelBottomView.isHidden = true
        }
        
        vc.setupTextFromNewTextView = { [weak self] (curLang, textView, curText) in
            guard let self = self else { return }
            if curText == "" {
                self.upperTextViewTopView.backgroundColor = AppSource.Color.backgroundWrapperView
                self.upperlabelTopView.isHidden = false
                self.upperTextViewBottomView.backgroundColor = AppSource.Color.backgroundWrapperView
                self.upperlabelBottomView.isHidden = false
            } else {
                if textView == ShowTextView.top {
                    self.textViewTopView.text = curText
                    self.selectedNativeLang = curLang
                    self.upperFlagTopImageView.image = Flags.setImage(with: self.selectedNativeLang)
                } else {
                    self.textViewBottomView.text = curText
                    self.selectedForeignLang = curLang
                    self.upperFlagBottomImageView.image = Flags.setImage(with: self.selectedForeignLang)
                }
            }
            self.setupDoneButton()
            self.switchSetToOn()
        }
        present(vc, animated: true, completion: nil)
    }
}

extension AddWordController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneLabel.isHidden = false
        doneLabel.text = AppSource.Text.Shared.done
        selectedTextField = true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switchSetToOn()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneLabel.isHidden = false
        doneLabel.text = AppSource.Text.Shared.done
        textField.resignFirstResponder()
        return true
    }
    @objc func dismissKeyboard() {
        doneLabel.isHidden = false
        doneLabel.text = AppSource.Text.Shared.done
        view.endEditing(true)
    }
}

private extension AddWordController {

    func setupColors() {
        view.backgroundColor = AppSource.Color.background
        topContent.backgroundColor = AppSource.Color.backgroundBottonView
    }
    
    func setupProperties() {
        currentCardsCollection = UserDefaults.loadFromUD()
        guard let indexPathStrong = indexPath else { return }
        guard let currentCards = currentCardsCollection[0].cardsCollection?[indexPathStrong.section] else { return }
        theme.text = currentCards.theme
        name.text = currentCards.info[indexPathStrong.row].name
        upperTextViewBottomView.backgroundColor = .clear
        upperTextViewTopView.backgroundColor = .clear
        var nativeText = ""
        currentCards.info[indexPathStrong.row].arrayNativeWords.sorted { $0 < $1 }.forEach {
            nativeText = "\($0.value)\n\(nativeText)"
        }
        nativeText.removeLast()
        var foreignText = ""
        currentCards.info[indexPathStrong.row].arrayForeignWords.sorted { $0 < $1 }.forEach {
            foreignText = "\($0.value)\n\(foreignText)"
        }
        foreignText.removeLast()
        textViewTopView.text = nativeText
        textViewBottomView.text = foreignText
        selectedNativeLang = currentCards.info[indexPathStrong.row].nativeLanguage
        selectedForeignLang = currentCards.info[indexPathStrong.row].foreignLanguage
        self.upperFlagTopImageView.image = Flags.setImage(with: selectedNativeLang)
        self.upperFlagBottomImageView.image = Flags.setImage(with: selectedForeignLang)
    }
    
    func setupView() {
        setupColors()
        setupProperties()
        
        
        //.text = "
        selectedTheme = "Без темы"
        scrollWrapper.do {
            $0.backgroundColor = AppSource.Color.background
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
        }
        
        view.do {_ in
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        doneLabel.do {
            $0.text = AppSource.Text.Shared.done
            $0.textColor = AppSource.Color.selectedStrokeBottomButton
            $0.textAlignment = .right
            $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(doneLabelTapped))
            $0.addGestureRecognizer(tap)
            $0.isHidden = true
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
            switch fromVC {
            case .AddCards: $0.text = AppSource.Text.AddNewWordsVC.add
            case .CollectionCell: $0.text = AppSource.Text.AddNewWordsVC.change
            case .none:
                print("error")
            }
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        topContent.do {
            $0.addSubview(stackViewText)
            $0.addSubview(deleteButtonLabel)
        }
        
        name.do {
            $0.placeholder = AppSource.Text.AddNewWordsVC.name
            $0.delegate = self
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: $0.frame.height))
            $0.leftViewMode = .always
            $0.borderStyle = .none
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.textColor = AppSource.Color.textColor
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        theme.do {
            $0.placeholder = AppSource.Text.AddNewWordsVC.enterTheme
            $0.delegate = self
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: $0.frame.height))
            $0.leftViewMode = .always
            $0.borderStyle = .none
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.textColor = AppSource.Color.textColor
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        chooseButton.do {
            $0.themeLabel.text = AppSource.Text.AddNewWordsVC.library
            $0.image = AppSource.Image.book
            let tap = UITapGestureRecognizer(target: self, action: #selector(showthemeViewTapped))
            $0.addGestureRecognizer(tap)
            switch fromVC {
            case .AddCards: $0.isHidden = false
            case .CollectionCell: $0.isHidden = true
            case .none:
                print("error")
            }
        }
        stackViewText.do {
            $0.addArrangedSubview(textViewTopView)
            $0.addArrangedSubview(textViewBottomView)
            $0.alignment = .fill
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        textViewTopView.do {
            $0.isUserInteractionEnabled = true
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.tag = 0
        }
        upperTextViewTopView.do {
            switch fromVC {
            case .AddCards: $0.backgroundColor = AppSource.Color.backgroundWrapperView
            case .CollectionCell: $0.backgroundColor = .clear
            case .none:
                print("error")
            }
            
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(showTextViewLeftTapped))
            $0.addGestureRecognizer(tap)
            $0.addSubview(upperlabelTopView)
            $0.addSubview(upperFlagTopImageView)
            $0.addSubview(upperWordsCountTopView)
        }
        upperTextViewBottomView.do {
            switch fromVC {
            case .AddCards: $0.backgroundColor = AppSource.Color.backgroundWrapperView
            case .CollectionCell: $0.backgroundColor = .clear
            case .none:
                print("error")
            }
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(showTextViewRightTapped))
            $0.addGestureRecognizer(tap)
            $0.addSubview(upperlabelBottomView)
            $0.addSubview(upperFlagBottomImageView)
            $0.addSubview(upperWordsCountBottomView)
        }
        upperlabelTopView.do {
            switch fromVC {
            case .AddCards: $0.isHidden = false
            case .CollectionCell: $0.isHidden = true
            case .none:
                print("error")
            }
            $0.text = AppSource.Text.AddNewWordsVC.nativeLanguage
            $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            $0.textAlignment = .center
            $0.textColor = .lightGray
            $0.backgroundColor = .clear
        }
        [upperWordsCountTopView, upperWordsCountBottomView].forEach {
            $0.do {
                $0.text = ""
                $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                $0.textAlignment = .right
                $0.textColor = AppSource.Color.textColor
            }
        }
        [upperFlagTopImageView, upperFlagBottomImageView].forEach {
            $0.do {
                $0.contentMode = .scaleAspectFit
                $0.tintColor = AppSource.Color.chooseButtonImageTint
                $0.backgroundColor = .clear
            }
        }
        upperlabelBottomView.do {
            switch fromVC {
            case .AddCards: $0.isHidden = false
            case .CollectionCell: $0.isHidden = true
            case .none:
                print("error")
            }
            $0.text = AppSource.Text.AddNewWordsVC.foreignLanguage
            $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            $0.textAlignment = .center
            $0.textColor = .lightGray
            $0.backgroundColor = .clear
        }
        textViewBottomView.do {
            $0.isUserInteractionEnabled = true
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.tag = 1
        }
        saveButtonLabel.do {
            switch fromVC {
            case .AddCards: $0.setTitle(AppSource.Text.AddNewWordsVC.add, for: .normal)
            case .CollectionCell: $0.setTitle(AppSource.Text.Shared.save, for: .normal)
            case .none:
                print("error")
            }
            $0.setTitleColor(.lightGray, for: .normal)
            $0.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
            $0.transform = .init(translationX: 0, y: 15)
        }
        deleteButtonLabel.do {
            switch fromVC {
            case .AddCards: $0.isHidden = true
            case .CollectionCell: $0.isHidden = false
            case .none:
                print("error")
            }
            $0.setTitle(AppSource.Text.Shared.delete, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .red
            $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            $0.transform = .init(translationX: 0, y: 15)
        }
    }
    
    func setupConstraints() {
        view.addSubview(scrollWrapper)
        scrollWrapper.addSubview(topContent)
        scrollWrapper.addSubview(headerTitleWrapper)
        scrollWrapper.addSubview(doneLabel)
        scrollWrapper.addSubview(theme)
        scrollWrapper.addSubview(name)
        scrollWrapper.addSubview(chooseButton)
        scrollWrapper.addSubview(saveButtonLabel)
        scrollWrapper.addSubview(upperTextViewTopView)
        scrollWrapper.addSubview(upperTextViewBottomView)
        
        headerTitleWrapper.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview()
        }
        headerTitleStick.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        headerTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        
        upperTextViewTopView.snp.makeConstraints {
            $0.edges.equalTo(textViewTopView.snp.edges)
        }
        upperTextViewBottomView.snp.makeConstraints {
            $0.edges.equalTo(textViewBottomView.snp.edges)
        }
        
        upperFlagTopImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.size.equalTo(25)
        }
        upperFlagBottomImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.size.equalTo(25)
        }
        upperWordsCountTopView.snp.makeConstraints {
            $0.top.equalTo(upperFlagTopImageView.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(35)
        }
        upperWordsCountBottomView.snp.makeConstraints {
            $0.top.equalTo(upperFlagBottomImageView.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(35)
        }
        scrollWrapper.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        doneLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(35)
            $0.centerY.equalTo(headerTitleLabel.snp.centerY)
        }
        topContent.snp.makeConstraints {
            $0.top.equalTo(saveButtonLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            switch fromVC {
            case .AddCards:
                let screensize: CGRect = UIScreen.main.bounds
                $0.height.equalTo(screensize.height-330)
            case .CollectionCell:
                let screensize: CGRect = UIScreen.main.bounds
                $0.height.equalTo(screensize.height-265)
            case .none:
                print("error")
            }
            
        }
        theme.snp.makeConstraints {
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        name.snp.makeConstraints {
            $0.top.equalTo(theme.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        chooseButton.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        saveButtonLabel.snp.makeConstraints {
            $0.height.equalTo(45)
            switch fromVC {
            case .AddCards:       $0.top.equalTo(chooseButton.snp.bottom)
            case .CollectionCell: $0.top.equalTo(name.snp.bottom)
            case .none:
                print("error")
            }
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        upperlabelTopView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        upperlabelBottomView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        stackViewText.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            switch fromVC {
            case .AddCards: $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            case .CollectionCell: $0.bottom.equalTo(deleteButtonLabel.snp.top)
            case .none:
                print("error")
            }
        }
        deleteButtonLabel.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
}



import UIKit
import SnapKit
import Then
//import FlagKit

class ChooseGroupOfCards: PopupViewController {
    
//    MARK: - UI Elements
    private lazy var headerTitleWrapper = UIView()
    private lazy var headerTitleStick = UIView()
    private lazy var headerTitleLabel = UILabel()
    private lazy var tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private lazy var saveButtonLabel = ActionButton()
    
//    MARK: - Public Properties
    var choosenDataFile: ((_ file: String,
                           _ selectedThemeTopic: String,
                           _ choosenDataFile: String,
                          _ level: Int,
                          _ native: String,
                          _ foreign: String) -> Void)?
    
//    MARK: - Private Properties
    private lazy var oldIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    private lazy var selectedTheme: Bool = false
    private lazy var selectedLanguage: Bool = false
    
    private lazy var selectedFile = ""
    private lazy var selectedThemeTopic = ""
    private lazy var selectedThemeName = ""
    private lazy var selectedLevel = 0
    private lazy var selectedNativeLang = ""
    private lazy var selectedForeignLang = ""
    private lazy var firstSelecterNativePicker = true
    private lazy var firstSelecterForeignPicker = true
    private lazy var selectedIndex = IndexPath()
     
    
    private let themesFamily = [AppSource.Text.ChooseGroupOfCards.family]          //0
    private let themesWheather = [AppSource.Text.ChooseGroupOfCards.wheather]
    private let themesAppearance = [AppSource.Text.ChooseGroupOfCards.appearance1, //2-2
                                    AppSource.Text.ChooseGroupOfCards.appearance2]
    private let themesCharacter = [AppSource.Text.ChooseGroupOfCards.character]
    private let themesMood = [AppSource.Text.ChooseGroupOfCards.mood]
    private let themesMyDay = [AppSource.Text.ChooseGroupOfCards.myDay]
    private let themesSchool = [AppSource.Text.ChooseGroupOfCards.school]
    private let themesHobby = [AppSource.Text.ChooseGroupOfCards.hobby]
    private let themesBooks = [AppSource.Text.ChooseGroupOfCards.books1,           // 8-3
                               AppSource.Text.ChooseGroupOfCards.books2,
                               AppSource.Text.ChooseGroupOfCards.books3]
    private let themesFood = [AppSource.Text.ChooseGroupOfCards.food1,             // 9-5
                              AppSource.Text.ChooseGroupOfCards.food2,
                              AppSource.Text.ChooseGroupOfCards.food3,
                              AppSource.Text.ChooseGroupOfCards.food4,
                              AppSource.Text.ChooseGroupOfCards.food5]
    private let themesClother = [AppSource.Text.ChooseGroupOfCards.clother1,       // 10-2
                                 AppSource.Text.ChooseGroupOfCards.clother2]
    private let themesNature = [AppSource.Text.ChooseGroupOfCards.nature1,         // 11-2
                                AppSource.Text.ChooseGroupOfCards.nature2]
    private let themesTravel = [AppSource.Text.ChooseGroupOfCards.travel]
    private let themesHome = [AppSource.Text.ChooseGroupOfCards.home1,             // 13-2
                              AppSource.Text.ChooseGroupOfCards.home2]
    private let themesParty = [AppSource.Text.ChooseGroupOfCards.party]
    private let themesSport = [AppSource.Text.ChooseGroupOfCards.sport]
    private let themesJob = [AppSource.Text.ChooseGroupOfCards.job1,               // 16-3
                                AppSource.Text.ChooseGroupOfCards.job2,
                                AppSource.Text.ChooseGroupOfCards.job3]
    private let themeCity = [AppSource.Text.ChooseGroupOfCards.city1,               // 17-3
                                AppSource.Text.ChooseGroupOfCards.city2,
                                AppSource.Text.ChooseGroupOfCards.city3]
    private let themeVerb = [AppSource.Text.ChooseGroupOfCards.verb1,               // 18-4
                                AppSource.Text.ChooseGroupOfCards.verb2,
                                AppSource.Text.ChooseGroupOfCards.verb3,
                                AppSource.Text.ChooseGroupOfCards.verb4]
    private let themeOther = [AppSource.Text.ChooseGroupOfCards.other1,               // 19-5
                                AppSource.Text.ChooseGroupOfCards.other2,
                                AppSource.Text.ChooseGroupOfCards.other3,
                                AppSource.Text.ChooseGroupOfCards.other4,
                                AppSource.Text.ChooseGroupOfCards.other5]
    private let themeAdjective = [AppSource.Text.ChooseGroupOfCards.adjective1,               // 20-5
                                AppSource.Text.ChooseGroupOfCards.adjective2,
                                AppSource.Text.ChooseGroupOfCards.adjective3,
                                AppSource.Text.ChooseGroupOfCards.adjective4,
                                AppSource.Text.ChooseGroupOfCards.adjective5]
    private let themeColor = [AppSource.Text.ChooseGroupOfCards.color]
    private let themeEvent = [AppSource.Text.ChooseGroupOfCards.event]
    private let themeNumber = [AppSource.Text.ChooseGroupOfCards.number1,                 // 23-2
                               AppSource.Text.ChooseGroupOfCards.number2]
    private let themePreposition = [AppSource.Text.ChooseGroupOfCards.preposition]
    private let themePronomen = [AppSource.Text.ChooseGroupOfCards.pronomen]
    private let themeQuestion = [AppSource.Text.ChooseGroupOfCards.question]
    private let themeFeeling  = [AppSource.Text.ChooseGroupOfCards.feeling]
    private let themeMeasure  = [AppSource.Text.ChooseGroupOfCards.measure]
    private let themePurchase = [AppSource.Text.ChooseGroupOfCards.purchase]
    private let themeArt      = [AppSource.Text.ChooseGroupOfCards.art]
    private let themeThing = [AppSource.Text.ChooseGroupOfCards.thing1,               // 31-3
                                AppSource.Text.ChooseGroupOfCards.thing2,
                                AppSource.Text.ChooseGroupOfCards.thing3]
    private let themeHealth = [AppSource.Text.ChooseGroupOfCards.health]
    private let themeDishes = [AppSource.Text.ChooseGroupOfCards.dishes]
    private let themeBlank = [AppSource.Text.ChooseGroupOfCards.blank]
    private let themeTime = [AppSource.Text.ChooseGroupOfCards.time1,               // 35-3
                                AppSource.Text.ChooseGroupOfCards.time2,
                                AppSource.Text.ChooseGroupOfCards.time3]
    private let themeTransport = [AppSource.Text.ChooseGroupOfCards.transport]
    private let themePeople = [AppSource.Text.ChooseGroupOfCards.people]
    private let themeAnimal = [AppSource.Text.ChooseGroupOfCards.animal]
    
    private lazy var themeArray = [
        themesFamily, themesWheather, themesAppearance, themesCharacter, themesMood, themesMyDay, themesSchool,
        themesHobby, themesBooks, themesFood, themesClother, themesNature, themesTravel, themesHome, themesParty,
        themesSport, themesJob, themeCity, themeVerb, themeOther, themeAdjective, themeColor, themeEvent,
        themeNumber, themePreposition, themePronomen, themeQuestion, themeFeeling, themeMeasure, themePurchase,
        themeArt, themeThing, themeHealth, themeDishes, themeBlank, themeTime, themeTransport, themePeople, themeAnimal
    ]
    
    
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
        
    }
}


//    MARK: - UITableViewDelegate, UITableViewDataSource
extension ChooseGroupOfCards: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return themeArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { return 2 } else  // themesAppearance
        if section == 8 { return 3 } else  // themesBooks
        if section == 9 { return 5 } else  // themesFood
        if section == 10 { return 2 } else // themesClother
        if section == 11 { return 2 } else // themesNature
        if section == 13 { return 2 } else // themesHome
        if section == 16 { return 3 } else // themesJob
        if section == 17 { return 3 } else // themesCity
        if section == 18 { return 4 } else // themesVerb
        if section == 19 { return 5 } else // themesOther
        if section == 20 { return 5 } else // themesAdjective
        if section == 23 { return 2 } else // themesNumber
        if section == 31 { return 3 } else // themesThing
        if section == 35 { return 3 } else // themesTime
        { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseGroupCell.reuseCellIdentifier, for: indexPath) as! ChooseGroupCell
        var name = ""
        name = themeArray[indexPath.section][indexPath.row]
        if selectedIndex == indexPath {
            cell.accessoryType = .checkmark
            cell.selectedBackgroundView?.backgroundColor = AppSource.Color.backgroundWrapperView
            cell.name.textColor = AppSource.Color.selectedStrokeBottomButton
            cell.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
        } else {
            cell.accessoryType = .none
            cell.name.textColor = AppSource.Color.textColor
            cell.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
            cell.layer.borderWidth = 0
        }
        cell.selectedBackgroundView?.backgroundColor = AppSource.Color.backgroundWrapperView
        cell.setupCellText(name: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: oldIndexPath) as? ChooseGroupCell {
            cell.accessoryType = .none
            cell.name.textColor = AppSource.Color.textColor
            cell.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
            cell.layer.borderWidth = 0
        }
        oldIndexPath = indexPath
        if let cell = tableView.cellForRow(at: indexPath) as? ChooseGroupCell {
            cell.accessoryType = .checkmark
            cell.selectedBackgroundView?.backgroundColor = AppSource.Color.backgroundWrapperView
            cell.name.textColor = AppSource.Color.selectedStrokeBottomButton
            cell.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            selectedTheme = true
            selectedIndex = indexPath
            selectedFile = selectRusNameTheme(is: cell.name.text ?? AppSource.Text.Shared.defaultTheme)
            selectedThemeTopic = cell.name.text ?? "Error"
            selectedThemeName = CardsTheme.init(rawValue: indexPath.section)?.title() ?? AppSource.Text.Shared.noThemeName
            selectedLevel = indexPath.row
        }
        if selectedForeignLang != "" && selectedNativeLang != "" && selectedTheme {
            saveButtonLabel.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
        } else {
            saveButtonLabel.setTitleColor(.lightGray, for: .normal)
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = .clear
        let nameLabel = UILabel()
        nameLabel.do {
            $0.text = CardsTheme.init(rawValue: section)?.title()
            $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            $0.textColor = AppSource.Color.textColor
        }
        headerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-2)
        }
        return headerView

    }
}
//    MARK: - private method
extension ChooseGroupOfCards {
    @objc func saveButtonTapped() {
        if selectedTheme && selectedNativeLang != "" && selectedForeignLang != "" {
            choosenDataFile?(selectedFile, selectedThemeTopic, selectedThemeName, selectedLevel, selectedNativeLang, selectedForeignLang)
            dismiss(animated: true, completion: nil)
        } else if selectedNativeLang == "" {
            let alertController = CreateAlerts.errorAlert(with: AppSource.Text.Shared.error, and: AppSource.Text.ChooseGroupOfCards.chooseNativeLang)
            present(alertController, animated: true)
        } else if selectedForeignLang == "" {
            let alertController = CreateAlerts.errorAlert(with: AppSource.Text.Shared.error, and: AppSource.Text.ChooseGroupOfCards.chooseForeignLang)
            present(alertController, animated: true)
            
        } else if !selectedTheme {
            let alertController = CreateAlerts.errorAlert(with: AppSource.Text.Shared.error, and: AppSource.Text.ChooseGroupOfCards.needChooseTheme)
            present(alertController, animated: true)
        }
    }
    func selectRusNameTheme(is name: String) -> String {
        // возвращаем на русском чтобы открыть файл с русским названием
        switch name {
        case AppSource.Text.ChooseGroupOfCards.family: return "Родственники1"
        case AppSource.Text.ChooseGroupOfCards.wheather: return "Погода1"
            
        case AppSource.Text.ChooseGroupOfCards.appearance1: return "Внешность1"
        case AppSource.Text.ChooseGroupOfCards.appearance2: return "Внешность2"
            
        case AppSource.Text.ChooseGroupOfCards.character: return "Характер1"
        case AppSource.Text.ChooseGroupOfCards.mood: return "Настроение1"
        case AppSource.Text.ChooseGroupOfCards.myDay: return "Мой День1"
        case AppSource.Text.ChooseGroupOfCards.school: return "Школа1"
        case AppSource.Text.ChooseGroupOfCards.hobby: return "Хобби1"
            
        case AppSource.Text.ChooseGroupOfCards.books1: return "Книги1"
        case AppSource.Text.ChooseGroupOfCards.books2: return "Книги2"
        case AppSource.Text.ChooseGroupOfCards.books3: return "Книги3"
            
        case AppSource.Text.ChooseGroupOfCards.food1: return "Еда1"
        case AppSource.Text.ChooseGroupOfCards.food2: return "Еда2"
        case AppSource.Text.ChooseGroupOfCards.food3: return "Еда3"
        case AppSource.Text.ChooseGroupOfCards.food4: return "Еда4"
        case AppSource.Text.ChooseGroupOfCards.food5: return "Еда5"
            
        case AppSource.Text.ChooseGroupOfCards.clother1: return "Одежда1"
        case AppSource.Text.ChooseGroupOfCards.clother2: return "Одежда2"
            
        case AppSource.Text.ChooseGroupOfCards.nature1: return "Природа1"
        case AppSource.Text.ChooseGroupOfCards.nature2: return "Природа2"
            
        case AppSource.Text.ChooseGroupOfCards.travel: return "Путешествие1"
        case AppSource.Text.ChooseGroupOfCards.party: return "Вечеринка1"
            
        case AppSource.Text.ChooseGroupOfCards.job1: return "Род занятий1"
        case AppSource.Text.ChooseGroupOfCards.job2: return "Род занятий2"
        case AppSource.Text.ChooseGroupOfCards.job3: return "Род занятий3"
            
        case AppSource.Text.ChooseGroupOfCards.home1: return "Дом1"
        case AppSource.Text.ChooseGroupOfCards.home2: return "Мебель1"
            
        case AppSource.Text.ChooseGroupOfCards.sport: return "Спорт1"
            
        case AppSource.Text.ChooseGroupOfCards.city1: return "Города1"
        case AppSource.Text.ChooseGroupOfCards.city2: return "Города2"
        case AppSource.Text.ChooseGroupOfCards.city3: return "Города3"

            
        case AppSource.Text.ChooseGroupOfCards.verb1: return "Глаголы1"
        case AppSource.Text.ChooseGroupOfCards.verb2: return "Глаголы2"
        case AppSource.Text.ChooseGroupOfCards.verb3: return "Глаголы3"
        case AppSource.Text.ChooseGroupOfCards.verb4: return "Глаголы4"
            
        case AppSource.Text.ChooseGroupOfCards.other1: return "Другие1"
        case AppSource.Text.ChooseGroupOfCards.other2: return "Другие2"
        case AppSource.Text.ChooseGroupOfCards.other3: return "Другие3"
        case AppSource.Text.ChooseGroupOfCards.other4: return "Другие4"
        case AppSource.Text.ChooseGroupOfCards.other5: return "Другие5"
            
        case AppSource.Text.ChooseGroupOfCards.adjective1: return "Прилагательное1"
        case AppSource.Text.ChooseGroupOfCards.adjective2: return "Прилагательное2"
        case AppSource.Text.ChooseGroupOfCards.adjective3: return "Прилагательное3"
        case AppSource.Text.ChooseGroupOfCards.adjective4: return "Прилагательное4"
        case AppSource.Text.ChooseGroupOfCards.adjective5: return "Прилагательное5"
        
        case AppSource.Text.ChooseGroupOfCards.color: return "Цвет1"
        case AppSource.Text.ChooseGroupOfCards.event: return "События1"
            
        case AppSource.Text.ChooseGroupOfCards.number1: return "Числа1"
        case AppSource.Text.ChooseGroupOfCards.number2: return "Числа2"
            
        case AppSource.Text.ChooseGroupOfCards.preposition: return "Предлоги1"
        case AppSource.Text.ChooseGroupOfCards.pronomen: return "Местоимения1"
        case AppSource.Text.ChooseGroupOfCards.question: return "Вопрос1"
        case AppSource.Text.ChooseGroupOfCards.feeling: return "Чувства1"
        case AppSource.Text.ChooseGroupOfCards.measure: return "Измерения1"
        case AppSource.Text.ChooseGroupOfCards.purchase: return "Покупки1"
        case AppSource.Text.ChooseGroupOfCards.art: return "Искусство1"
            
        case AppSource.Text.ChooseGroupOfCards.thing1: return "Вещь1"
        case AppSource.Text.ChooseGroupOfCards.thing2: return "Вещь2"
        case AppSource.Text.ChooseGroupOfCards.thing3: return "Вещь3"
            
        case AppSource.Text.ChooseGroupOfCards.health: return "Здоровье1"
        case AppSource.Text.ChooseGroupOfCards.dishes: return "Посуда1"
        case AppSource.Text.ChooseGroupOfCards.blank: return "Бланк1"
            
        case AppSource.Text.ChooseGroupOfCards.time1: return "Время1"
        case AppSource.Text.ChooseGroupOfCards.time2: return "ДниНедели1"
        case AppSource.Text.ChooseGroupOfCards.time3: return "Месяца1"
            
        case AppSource.Text.ChooseGroupOfCards.transport: return "Транспорт1"
        case AppSource.Text.ChooseGroupOfCards.people: return "Люди1"
        case AppSource.Text.ChooseGroupOfCards.animal: return "Животные1"
        default: return "error"
        }
    }
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
}

//    MARK: - initial setup
private extension ChooseGroupOfCards {
    
    func setupProperties() {
        let currentCardsCollection: [CardsModel]!
        currentCardsCollection = UserDefaults.loadFromUD()
        selectedNativeLang = selectThemeLang(is: currentCardsCollection[0].currentNativeLang)
        selectedForeignLang = selectThemeLang(is: currentCardsCollection[0].currentForeignLang)
    }
    func setupColors() {
        view.backgroundColor = AppSource.Color.background
        tableView.backgroundColor = AppSource.Color.background
    }
    
    //    MARK: - setupView
    func setupView() {
        setupProperties()
        setupColors()
        headerTitleWrapper.do {
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.addSubview(headerTitleLabel)
            $0.addSubview(headerTitleStick)
        }
        headerTitleStick.do {
            $0.backgroundColor = AppSource.Color.titleStick
        }
        headerTitleLabel.do {
            $0.text = AppSource.Text.AddNewWordsVC.library
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        tableView.do {
            $0.register(ChooseGroupCell.self,
                        forCellReuseIdentifier: ChooseGroupCell.reuseCellIdentifier)
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.separatorColor = AppSource.Color.titleStick
            $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.reloadData()
            $0.tintColor = AppSource.Color.selectedStrokeBottomButton
            
        }
        saveButtonLabel.do {
            $0.setTitle(AppSource.Text.ChooseGroupOfCards.Add, for: .normal)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            $0.transform = .init(translationX: 0, y: 15)
        }
    }
//        MARK: - setupConstraints
    func setupConstraints() {
        
        view.addSubview(headerTitleWrapper)
        view.addSubview(tableView)
        view.addSubview(saveButtonLabel)
        
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
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerTitleWrapper.snp.bottom).offset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(saveButtonLabel.snp.top)
        }
        saveButtonLabel.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(15)
            $0.height.equalTo(45)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-25)
        }
    }
}



import UIKit
import SnapKit
import Then
import AVFoundation
import GoogleMobileAds

class EducationViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    private lazy var topNameView = NameOfViewController()
    private lazy var chooseCardLearnButton = ActionButton()
    
    private lazy var hintsView = UIView()
    private lazy var longPressWrapperView = UIView()
    private lazy var longPressPicImage = UIImageView()
    private lazy var longPressActImage = UIImageView()
    
    private lazy var pressWrapperView = UIView()
    private lazy var pressPicImage = UIImageView()
    private lazy var pressActImage = UIImageView()
    
    private lazy var leftSwipeWrapperView = UIView()
    private lazy var leftSwipePicImage = UIImageView()
    private lazy var leftSwipeActImage = StackViewStar()
    
    private lazy var rightSwipeWrapperView = UIView()
    private lazy var rightSwipePicImage = UIImageView()
    private lazy var rightSwipeActImage = StackViewStar()
    
    private lazy var downSwipeWrapperView = UIView()
    private lazy var downSwipePicImage = UIImageView()
    private lazy var downSwipeActImage = StackViewStar()
    
    private lazy var topView = UIView()
    private lazy var topCardTextLabel = UILabel()
    private lazy var topVoiceImage = UIImageView()
    
    private lazy var bottomView = UIView()
    private lazy var bottomCardTextLabel = UILabel()
    private lazy var bottomVoiceImage = UIImageView()
    
    private lazy var bottomTestView1 = UIView()
    private lazy var bottomTestViewLabel1 = UILabel()
    private lazy var bottomTestView2 = UIView()
    private lazy var bottomTestViewLabel2 = UILabel()
    private lazy var bottomTestView3 = UIView()
    private lazy var bottomTestViewLabel3 = UILabel()
    private lazy var bottomTestView4 = UIView()
    private lazy var bottomTestViewLabel4 = UILabel()
    
    private lazy var buttonWrapper = UIView()
    private lazy var buttonsView = BottomButtonView()
    
    private lazy var endEducationView = EndEducationNotificationView()
    
    private lazy var showTranslateCard = false
    private lazy var showTestView = false // обучаемся тестом или карточками
    private lazy var firstLaunch = true
    private lazy var startVoice = true
    private lazy var randomOfCardsSwitch = false // случайный выбор след слова или обучение по порядку
    private lazy var randomCurrentIndex: [Int] = [] // при случайном выборе след слова используем массив куда записываем уже использованные индексы
    private let synth = AVSpeechSynthesizer()
    private lazy var myUtterance = AVSpeechUtterance(string: "")
    private lazy var selectedSpeaker = ""
    private lazy var tapToButtonCount = 0 // количество нажатий на кнопки при тестировании - с первого раза угадываем - 5 звезд, если 1 раз не правильно нажал - 3 звезды, в других случаях 1 звезда
    private lazy var repeatCount = 0 // количество повторов обучения
    
    private lazy var whichSideCardToLearn = 0 // какую сторону карточки учим
    private lazy var currentLearningIndex = 0 // текущий индекс для выбора слов из словарей со словами
    private lazy var nativeWordsArray: [Int: String] = [:] // словарь с родными словами
    private lazy var foreignWordsArray: [Int: String] = [:] // словарь с иностранными словами
    private var currentCardsCollection: [CardsModel]!
    private lazy var tempCountFiveStar: Int = 0  // временное количество для стравнения с результатом
    private lazy var tempCountThreeStar: Int = 0 // временное количество для стравнения с результатом
    private lazy var tempCountOneStar: Int = 0   // временное количество для стравнения с результатом
    private lazy var fiveStarCount = 0   // слова с 5 звезднами
    private lazy var threeStarCount = 0  // слова с тремя звездами
    private lazy var oneStarCount = 0    // слова с одной звездой
    private lazy var timer = Timer()
    private lazy var educationTime = 0
    private lazy var premiumAccount: Bool = false
    var indexPathOfCollection: IndexPath? // для сохранения по текущему индексу колекции всех обновленных параметров
    
    private var interstitial: GADInterstitialAd?
    private var moduleFactory = FactoryPresent()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserDefaultSettings()
        setupGoogleAds()
        buttonsView.learnButtom.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
        buttonsView.learnButtom.tintColor = AppSource.Color.selectedStrokeBottomButton
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topNameView.isHidden = false
        topNameView.animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.topNameView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstLaunch {
            hintsView.isHidden = false
            return
        } else {
            hintsView.isHidden = true
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaults.showHints) {
            UserDefaults.standard.set(true, forKey: UserDefaults.showHints)
            hintsView.isHidden = showTestView ? true : false // если выбрана опция показывать подсказки и выбран тестовый режим обучения то подсказки не покажутся. Подсказки показываються только в режиме карточек
        } else {
            hintsView.isHidden = true
        }
    }
}

extension EducationViewController: GADFullScreenContentDelegate {
    func setupGoogleAds() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AppSource.Constants.googleBanerId,
                                        request: request,
                              completionHandler: { [self] ad, error in
                                if let error = error {
                                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                  return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                              }
            )
    }
    func showAds() {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: self)
          } else {
            print("Ad wasn't ready")
          }
    }
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad presented full screen content.
      func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }
}


private extension EducationViewController {
    
    func setupUserDefaultSettings() {
        let userDefault = UserDefaults.standard
        premiumAccount = userDefault.bool(forKey: UserDefaults.premium)  ? true : false
        selectedSpeaker = userDefault.string(forKey: UserDefaults.selectedSpeaker) ?? "Milena"
        randomOfCardsSwitch = userDefault.bool(forKey: UserDefaults.settingRandomListCard) ? true : false
        showTestView = userDefault.bool(forKey: UserDefaults.changeLearningView) ? true : false
        
        if !userDefault.bool(forKey: UserDefaults.firstLaunchApp) {
            userDefault.set(true, forKey: UserDefaults.firstLaunchApp)
            firstLaunch = true
        } else {
            firstLaunch = false
        }
        
        switch userDefault.integer(forKey: UserDefaults.settingCardView) {
        case 0: whichSideCardToLearn = 0
        case 1: whichSideCardToLearn = 1
        case 2: whichSideCardToLearn = 2
        default: print("error")
        }
        
        switch userDefault.integer(forKey: UserDefaults.settingNightMode) {
        case 0:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified }
        case 1:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light }
        case 2:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark }
        default: print("error")
        }
    }
    
    
}

extension EducationViewController {
    
    func saveCurrentResult() {
        
        
        
        // сохранить в локальную базу
        
        // для этого надо узнать текущий индекс коллекции для записи к нее след информации
        guard let indexPathStrong = indexPathOfCollection else { return }

        currentCardsCollection[0].countFiveStar = tempCountFiveStar + fiveStarCount
        currentCardsCollection[0].cardsCollection?[indexPathStrong.section].info[indexPathStrong.row].fiveStarWords = fiveStarCount
        
        currentCardsCollection[0].countThreeStar = tempCountThreeStar + threeStarCount
        currentCardsCollection[0].cardsCollection?[indexPathStrong.section].info[indexPathStrong.row].threeStarWords = threeStarCount

        currentCardsCollection[0].countOneStar = tempCountOneStar + oneStarCount
        currentCardsCollection[0].cardsCollection?[indexPathStrong.section].info[indexPathStrong.row].oneStarWords = oneStarCount

        
        let oneMinutesInSecond = 60

        if educationTime < 30 {
            // если текущее обучение меньше 30 секунд тогда время обучения = 0
            educationTime = 0
        } else if educationTime < oneMinutesInSecond {
            // если текущее обучение от 30 до 60 секунд тогда ставим 60 для правильного отображения в статистике
            educationTime = oneMinutesInSecond
        } else {
            // если время обучения больше минуты тогда вычисляем секунды -
            // если меньше 30 то удаляем лишние секунды до ровного количества минут
            // если больше 30 то добавляем до ровного количества минут (след минуты обучения)
            let tempTime = educationTime % oneMinutesInSecond
            if tempTime < 30 {
                educationTime = educationTime - tempTime
            } else if tempTime < oneMinutesInSecond {
                educationTime = educationTime + (oneMinutesInSecond - tempTime)
            }
        }
        
        //общее время обучения в секундах, в статистике делим на 60 чтобы получить в часах и минутах
        currentCardsCollection[0].educationTime += educationTime
        
        //общее количество повторений
        currentCardsCollection[0].repeatsCount += repeatCount
        
        // надо сохранить количество выученных слов по днях (7дней)
        let dataCards = currentCardsCollection[0]
        let todayDay = WeekDayCounter.returnDateOfDate()[0]
        
        let newData = dataCards.countLeaningWordsSevenDays.sorted { $0 > $1 }
        var dateDiff: Int
        
        for (_, value) in newData.enumerated() {
            dateDiff = Calendar.current.dateComponents([.day],
                                                       from: value.key,
                                                       to: todayDay).day ?? 0
            switch dateDiff {
            case 0:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: newData[0].value + fiveStarCount,
                    WeekDayCounter.returnDateOfDate()[1]: newData[1].value,
                    WeekDayCounter.returnDateOfDate()[2]: newData[2].value,
                    WeekDayCounter.returnDateOfDate()[3]: newData[3].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData[4].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData[5].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData[6].value]
            case 1:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: fiveStarCount,
                    WeekDayCounter.returnDateOfDate()[1]: newData[0].value,
                    WeekDayCounter.returnDateOfDate()[2]: newData[1].value,
                    WeekDayCounter.returnDateOfDate()[3]: newData[2].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData[3].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData[4].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData[5].value]
            case 2:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: fiveStarCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: newData[0].value,
                    WeekDayCounter.returnDateOfDate()[3]: newData[1].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData[2].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData[3].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData[4].value]
            case 3:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: fiveStarCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: newData[0].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData[1].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData[2].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData[3].value]
            case 4:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: fiveStarCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: newData[0].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData[1].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData[2].value]
                
            case 5:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: fiveStarCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: 0,
                    WeekDayCounter.returnDateOfDate()[5]: newData[0].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData[1].value]
                
            case 6:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: fiveStarCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: 0,
                    WeekDayCounter.returnDateOfDate()[5]: 0,
                    WeekDayCounter.returnDateOfDate()[6]: newData[0].value]
                
            default:
                // сдвиг по дням составить больше 7 дней и значит выставляем везде 0
                currentCardsCollection[0].countLeaningWordsSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: fiveStarCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: 0,
                    WeekDayCounter.returnDateOfDate()[5]: 0,
                    WeekDayCounter.returnDateOfDate()[6]: 0]
            }
            
            // после первого прохода останавливаем цикл
            break
        }

        // надо сохранить время обучения по днях (7дней)
        let newData1 = dataCards.educationTimeSevenDays.sorted { $0 > $1 }
        var dateDiff1: Int
        
        for (_, value) in newData1.enumerated() {
            dateDiff1 = Calendar.current.dateComponents([.day],
                                                        from: value.key,
                                                        to: todayDay).day ?? 0
            switch dateDiff1 {
            case 0:
                currentCardsCollection[0].educationTimeSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: newData1[0].value + educationTime,
                    WeekDayCounter.returnDateOfDate()[1]: newData1[1].value,
                    WeekDayCounter.returnDateOfDate()[2]: newData1[2].value,
                    WeekDayCounter.returnDateOfDate()[3]: newData1[3].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData1[4].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData1[5].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData1[6].value]
            case 1:
                currentCardsCollection[0].educationTimeSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: educationTime,
                    WeekDayCounter.returnDateOfDate()[1]: newData1[0].value,
                    WeekDayCounter.returnDateOfDate()[2]: newData1[1].value,
                    WeekDayCounter.returnDateOfDate()[3]: newData1[2].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData1[3].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData1[4].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData1[5].value]
                
            case 2:
                currentCardsCollection[0].educationTimeSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: educationTime,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: newData1[0].value,
                    WeekDayCounter.returnDateOfDate()[3]: newData1[1].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData1[2].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData1[3].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData1[4].value]
            case 3:
                currentCardsCollection[0].educationTimeSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: educationTime,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: newData1[0].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData1[1].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData1[2].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData1[3].value]
            case 4:
                currentCardsCollection[0].educationTimeSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: educationTime,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: newData1[0].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData1[1].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData1[2].value]
            case 5:
                currentCardsCollection[0].educationTimeSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: educationTime,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: 0,
                    WeekDayCounter.returnDateOfDate()[5]: newData1[0].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData1[1].value]
            case 6:
                currentCardsCollection[0].educationTimeSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: educationTime,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: 0,
                    WeekDayCounter.returnDateOfDate()[5]: 0,
                    WeekDayCounter.returnDateOfDate()[6]: newData1[0].value]
            default:
                // сдвиг по дням составить больше 7 дней и значит выставляем везде 0
                currentCardsCollection[0].educationTimeSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: educationTime,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: 0,
                    WeekDayCounter.returnDateOfDate()[5]: 0,
                    WeekDayCounter.returnDateOfDate()[6]: 0]
            }
            
            // после первого прохода останавливаем цикл
            break
        }
        
        
        // количетво повторений для текущего дня из 7 дней
        let newData2 = dataCards.repeatsCountSevenDays.sorted { $0 > $1 }
        var dateDiff2: Int
        
        for (_, value) in newData2.enumerated() {
            dateDiff2 = Calendar.current.dateComponents([.day],
                                                        from: value.key,
                                                        to: todayDay).day ?? 0
            switch dateDiff2 {
            case 0:
                currentCardsCollection[0].repeatsCountSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: newData2[0].value + repeatCount,
                    WeekDayCounter.returnDateOfDate()[1]: newData2[1].value,
                    WeekDayCounter.returnDateOfDate()[2]: newData2[2].value,
                    WeekDayCounter.returnDateOfDate()[3]: newData2[3].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData2[4].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData2[5].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData2[6].value]
            case 1:
                currentCardsCollection[0].repeatsCountSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: repeatCount,
                    WeekDayCounter.returnDateOfDate()[1]: newData2[0].value,
                    WeekDayCounter.returnDateOfDate()[2]: newData2[1].value,
                    WeekDayCounter.returnDateOfDate()[3]: newData2[2].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData2[3].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData2[4].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData2[5].value]
            case 2:
                currentCardsCollection[0].repeatsCountSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: repeatCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: newData2[0].value,
                    WeekDayCounter.returnDateOfDate()[3]: newData2[1].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData2[2].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData2[3].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData2[4].value]
            case 3:
                currentCardsCollection[0].repeatsCountSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: repeatCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: newData2[0].value,
                    WeekDayCounter.returnDateOfDate()[4]: newData2[1].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData2[2].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData2[3].value]
            case 4:
                currentCardsCollection[0].repeatsCountSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: repeatCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: newData2[0].value,
                    WeekDayCounter.returnDateOfDate()[5]: newData2[1].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData2[2].value]
            case 5:
                currentCardsCollection[0].repeatsCountSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: repeatCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: 0,
                    WeekDayCounter.returnDateOfDate()[5]: newData2[0].value,
                    WeekDayCounter.returnDateOfDate()[6]: newData2[1].value]
            case 6:
                currentCardsCollection[0].repeatsCountSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: repeatCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: 0,
                    WeekDayCounter.returnDateOfDate()[5]: 0,
                    WeekDayCounter.returnDateOfDate()[6]: newData2[0].value]
            default:
                // сдвиг по дням составить больше 7 дней и значит выставляем везде 0
                currentCardsCollection[0].repeatsCountSevenDays =  [
                    WeekDayCounter.returnDateOfDate()[0]: repeatCount,
                    WeekDayCounter.returnDateOfDate()[1]: 0,
                    WeekDayCounter.returnDateOfDate()[2]: 0,
                    WeekDayCounter.returnDateOfDate()[3]: 0,
                    WeekDayCounter.returnDateOfDate()[4]: 0,
                    WeekDayCounter.returnDateOfDate()[5]: 0,
                    WeekDayCounter.returnDateOfDate()[6]: 0]
            }
            
            // после первого прохода останавливаем цикл
            break
        }
        // сохраняем в локальную базу
        UserDefaults.saveToUD(currentCardsCollection)
        
        // сохранить в firebase
        
        
        // сбрасываем все параметры в начально
        randomCurrentIndex.removeAll()
        repeatCount = 0
        fiveStarCount = 0
        threeStarCount = 0
        oneStarCount = 0
        currentLearningIndex = 0
        topCardTextLabel.text = ""
        bottomCardTextLabel.text = ""
        bottomCardTextLabel.isHidden = true
        bottomVoiceImage.isHidden = showTestView ? true : false
        topVoiceImage.isHidden = true
        showTranslateCard = false
        bottomTestViewLabel1.text = ""
        bottomTestViewLabel2.text = ""
        bottomTestViewLabel3.text = ""
        bottomTestViewLabel4.text = ""
        timer.invalidate()
    }
    
    private func setupColors() {
        view.backgroundColor = AppSource.Color.background
        buttonWrapper.backgroundColor = AppSource.Color.backgroundBottonView
        topView.backgroundColor = AppSource.Color.backgroundWrapperView
        hintsView.backgroundColor = AppSource.Color.backgroundWithAlpha
    }
    
    @objc func tapBottomViewTapped() {
        if showTranslateCard {
            bottomCardTextLabel.isHidden = true
            showTranslateCard = false
        } else {
            bottomCardTextLabel.isHidden = false
            showTranslateCard = true
        }
    }
    
    @objc func swipeBottomViewTapped(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.down: oneStarCount += 1
        case UISwipeGestureRecognizer.Direction.left: fiveStarCount += 1
        case UISwipeGestureRecognizer.Direction.right: threeStarCount += 1
        default : print("Error swipe direction")
        }
        bottomCardTextLabel.isHidden = true
        showTranslateCard = false
        setupEducation()
    }
    
    @objc func chooseCardTapped() {
        let vc = AddPackOfCardToLearnViewController()
        vc.choosenCardsToLearn = { [weak self] (indexPath, nativeArray, foreignArray) in
            guard let self = self else { return }
            // инициализация начальный значений при загрузке коллекции в режим обучения
            
            // проверка на то, какую сторону учим у коллекции карточек переднюю / заднюю / случайную
            self.indexPathOfCollection = indexPath
            switch self.whichSideCardToLearn {
            case 0:
                self.nativeWordsArray = nativeArray
                self.foreignWordsArray = foreignArray
            case 1:
                self.nativeWordsArray = foreignArray
                self.foreignWordsArray = nativeArray
            case 2:
                let randomBool = Bool.random()
                self.nativeWordsArray = randomBool ? nativeArray : foreignArray
                self.foreignWordsArray = randomBool ? foreignArray : nativeArray
            default:
                print("Error whichSideCardToLearn")
            }
            // если обучение последовательное то задаем текущий индекс 0
            if !self.randomOfCardsSwitch {
                self.currentLearningIndex = 0
            }
            self.repeatCount = 0
            self.fiveStarCount = 0
            self.threeStarCount = 0
            self.oneStarCount = 0
            self.educationTime = 0
            self.bottomCardTextLabel.isHidden = true
            self.bottomVoiceImage.isHidden = self.showTestView ? true : false
            self.topVoiceImage.isHidden = false
            
            
            guard let indexPathStrong = self.indexPathOfCollection else { return }
            
            // количество выученных слов для данной колекции карточек
            
            
            
            self.tempCountFiveStar = self.currentCardsCollection[0].countFiveStar - (self.currentCardsCollection[0].cardsCollection?[indexPathStrong.section].info[indexPathStrong.row].fiveStarWords)!
            self.tempCountThreeStar = self.currentCardsCollection[0].countThreeStar - (self.currentCardsCollection[0].cardsCollection?[indexPathStrong.section].info[indexPathStrong.row].threeStarWords)!
            self.tempCountOneStar = self.currentCardsCollection[0].countOneStar - (self.currentCardsCollection[0].cardsCollection?[indexPathStrong.section].info[indexPathStrong.row].oneStarWords)!
            self.bottomView.isUserInteractionEnabled = true
            self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(self.onTimer),
                                              userInfo: nil,
                                              repeats: true)
            self.setupEducation()
        }
        timer.invalidate()
        present(vc, animated: true, completion: nil)
    }
    @objc func VoiceTapTapped(gesture: UILongPressGestureRecognizer) {
        if topCardTextLabel.text != "" {
            if gesture.state == .ended {
                startVoice = true
            } else if gesture.state == .began {
                guard startVoice else { return }
                switch gesture.name {
                case "topVoiceImage":
                    myUtterance = AVSpeechUtterance(string: topCardTextLabel.text ?? "" )
                case "bottomVoiceImage":
                    myUtterance = AVSpeechUtterance(string: bottomCardTextLabel.text ?? "" )
                default:
                    print("Error name Voice")
                }
                myUtterance.voice = AVSpeechSynthesisVoice(language: selectedSpeaker)
                myUtterance.rate = 0.4
                myUtterance.postUtteranceDelay = 1.5
                synth.speak(myUtterance)
                startVoice = false
            }
        }
    }
    @objc func bottomVoiceTapTapped(gesture: UILongPressGestureRecognizer) {
        if bottomCardTextLabel.text != "" {
            if gesture.state == .ended {
                startVoice = true
            } else if gesture.state == .began {
                guard startVoice else { return }
                
            }
        }
    }
    
    @objc func bottomTestViewTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, let text = label.text else { return }
        guard let rightNameButton = foreignWordsArray[currentLearningIndex-1] else { return}
        tapToButtonCount += 1
        if text == rightNameButton {
            label.backgroundColor = AppSource.Color.selectedStrokeBottomButton
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                label.backgroundColor = .clear
                switch self.tapToButtonCount {
                case 1: self.fiveStarCount += 1
                case 2: self.threeStarCount += 1
                default: self.oneStarCount += 1
                }
                self.setupEducation()
            }
            
        } else {
            label.backgroundColor = .red
            label.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                label.backgroundColor = .clear
            }
        }
    }
    
    @objc func tipTapped() {
        hintsView.isHidden = true
    }
    @objc func hideEndEducationViewTapped() {
        endEducationView.isHidden = true
        if !premiumAccount {
            showAds()
        }
    }
    @objc func onTimer() {
        educationTime += 1
    }
    func setupEducation() {
        // обучение началось или в процессе
        if repeatCount <= nativeWordsArray.count-1 {
            
            // текущий индекс случайный если выбран случайный выбор слов при обучении
            if randomOfCardsSwitch {
                currentLearningIndex = Int.random(in: 0..<foreignWordsArray.count)
                while randomCurrentIndex.contains(currentLearningIndex) {
                    currentLearningIndex = Int.random(in: 0..<foreignWordsArray.count)
                    // если индекс не совпал и является уникальным тогда добавляем его в массив для сдел сравнения
                }
                randomCurrentIndex.append(currentLearningIndex)
            }
            topCardTextLabel.text = nativeWordsArray[currentLearningIndex]?.capitalized
            if showTestView {
                // обучение тестом
                tapToButtonCount = 0
                let randomIndexForRightWord = Int.random(in: 0..<3)
                var arrayOfUsedIndex: [Int] = []
                let arrayOfButtons = [bottomTestViewLabel1, bottomTestViewLabel2,
                                      bottomTestViewLabel3, bottomTestViewLabel4]
                
                for i in 0..<4 {
                    //если случайный индекс совпадает с тагом кнопки тогда присваем туда правильный перевод
                    if randomIndexForRightWord == arrayOfButtons[i].tag {
                        arrayOfButtons[i].text = foreignWordsArray[currentLearningIndex]
                        // записываем индекс чтобы дальше не повтортся
                        arrayOfUsedIndex.append(currentLearningIndex)
                    }
                }
                for i in 0..<4 {
                    //если случайный индекс совпадает с тагом кнопки тогда присваем туда правильный перевод
                    if randomIndexForRightWord != arrayOfButtons[i].tag {
                        var randomIndexForWrongWord = Int.random(in: 0..<foreignWordsArray.count)
                        while arrayOfUsedIndex.contains(randomIndexForWrongWord) {
                            randomIndexForWrongWord = Int.random(in: 0..<foreignWordsArray.count)
                            // если индекс не совпал и является уникальным тогда добавляем его в массив для сдел сравнения
                        }
                        arrayOfUsedIndex.append(randomIndexForWrongWord)
                        arrayOfButtons[i].text = foreignWordsArray[randomIndexForWrongWord]
                    }
                }
            } else {
                // обучение карточками
                bottomCardTextLabel.text = foreignWordsArray[currentLearningIndex]?.capitalized
            }
            // текущий индекс +1 если выбран последоавтельный выбор слов при обучении
            if !randomOfCardsSwitch {
                currentLearningIndex += 1
            }
            
            repeatCount += 1
            
        } else {
            // окончание обучения - сбрасывание на 0 всех значений и сохранение
            endEducationView.fiveStar = fiveStarCount
            endEducationView.threeStar = threeStarCount
            endEducationView.oneStar = oneStarCount
            endEducationView.isHidden = false
            bottomView.isUserInteractionEnabled = false
            saveCurrentResult()
        }
    }
    func setupProperties() {
        currentCardsCollection = UserDefaults.loadFromUD()
        repeatCount = 0
        fiveStarCount = 0
        threeStarCount = 0
        oneStarCount = 0
        
        topCardTextLabel.text = ""
        bottomCardTextLabel.text = ""
        bottomCardTextLabel.isHidden = true
        bottomView.isUserInteractionEnabled = false
        showTranslateCard = false
        bottomTestViewLabel1.text = ""
        bottomTestViewLabel2.text = ""
        bottomTestViewLabel3.text = ""
        bottomTestViewLabel4.text = ""
    }
    
    private func setupView() {
        setupColors()
        setupProperties()
        
        synth.delegate = self
        
        buttonsView.presentCardsVC = { [weak self] in
            guard let self = self else { return }
            self.timer.invalidate()
            self.moduleFactory.switchToSecond(toModule: .cards)
        }
        buttonsView.presentStatisticsVC = { [weak self] in
            guard let self = self else { return }
            self.timer.invalidate()
            self.moduleFactory.switchToSecond(toModule: .statistics)
        }
        buttonsView.presentSettingVC = { [weak self] in
            guard let self = self else { return }
            self.timer.invalidate()
            self.moduleFactory.switchToSecond(toModule: .settings)
        }
        buttonsView.presentLearnVC = { [weak self] in
            guard let self = self else { return }
            self.timer.invalidate()
            self.moduleFactory.switchToSecond(toModule: .education)
        }
        
        topNameView.do {
            $0.isHidden = true
            $0.showNameView(AppSource.Text.EducationVC.education, andImage: AppSource.Image.play!)
        }
        
        chooseCardLearnButton.do {
            $0.setTitleColor(AppSource.Color.blueTextColor, for: .highlighted)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            $0.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
            $0.backgroundColor = AppSource.Color.backgroundActionButton
            
            $0.setTitle(AppSource.Text.EducationVC.start, for: .normal)
            $0.addTarget(self, action: #selector(chooseCardTapped), for: .touchUpInside)
            $0.transform = .init(translationX: 0, y: 15)
        }
        
        topView.do {
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
            $0.addSubview(topCardTextLabel)
            $0.addSubview(topVoiceImage)
            $0.insertSubview(topVoiceImage, aboveSubview: topCardTextLabel)
        }
        topVoiceImage.do {
            $0.image = AppSource.Image.speakWord
            $0.contentMode = .scaleAspectFill
            let voiceTap = UILongPressGestureRecognizer(target: self, action: #selector(VoiceTapTapped))
            voiceTap.name = "topVoiceImage"
            voiceTap.minimumPressDuration = 0.2
            startVoice = true
            $0.addGestureRecognizer(voiceTap)
            $0.isHidden = true
            $0.isUserInteractionEnabled = true
        }
        topCardTextLabel.do {
            $0.textColor = AppSource.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 28, weight: .regular)
            $0.backgroundColor = .clear
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        [bottomTestView1, bottomTestView2, bottomTestView3, bottomTestView4].forEach {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
        }
        
        bottomTestView1.do {
            $0.addSubview(bottomTestViewLabel1)
        }
        bottomTestView2.do {
            $0.addSubview(bottomTestViewLabel2)
        }
        bottomTestView3.do {
            $0.addSubview(bottomTestViewLabel3)
        }
        bottomTestView4.do {
            $0.addSubview(bottomTestViewLabel4)
        }
        [bottomTestViewLabel1, bottomTestViewLabel2, bottomTestViewLabel3, bottomTestViewLabel4].forEach {
            $0.textColor = AppSource.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.backgroundColor = .clear
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.isUserInteractionEnabled = true
        }
        bottomTestViewLabel1.do {
            $0.tag = 0
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(bottomTestViewTapped(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        bottomTestViewLabel2.do {
            $0.tag = 1
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(bottomTestViewTapped(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        bottomTestViewLabel3.do {
            $0.tag = 2
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(bottomTestViewTapped(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        bottomTestViewLabel4.do {
            $0.tag = 3
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(bottomTestViewTapped(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        bottomView.do {
            $0.isUserInteractionEnabled = false
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
            $0.addSubview(bottomTestView1)
            $0.addSubview(bottomTestView2)
            $0.addSubview(bottomTestView3)
            $0.addSubview(bottomTestView4)
            $0.addSubview(bottomCardTextLabel)
            $0.addSubview(bottomVoiceImage)
            if !showTestView {
                let swipeGestureLeft = UISwipeGestureRecognizer(target: self,
                                                                action: #selector(swipeBottomViewTapped(_:)))
                swipeGestureLeft.direction = UISwipeGestureRecognizer.Direction.left
                $0.addGestureRecognizer(swipeGestureLeft)
                
                let swipeGestureRight = UISwipeGestureRecognizer(target: self,
                                                                 action: #selector(swipeBottomViewTapped(_:)))
                swipeGestureRight.direction = UISwipeGestureRecognizer.Direction.right
                $0.addGestureRecognizer(swipeGestureRight)
                
                let swipeGestureDown = UISwipeGestureRecognizer(target: self,
                                                                action: #selector(swipeBottomViewTapped(_:)))
                swipeGestureDown.direction = UISwipeGestureRecognizer.Direction.down
                $0.addGestureRecognizer(swipeGestureDown)
            }
            
            if showTestView {
                bottomCardTextLabel.isHidden = true
                bottomVoiceImage.isHidden = true
                bottomTestView1.isHidden = false
                bottomTestView2.isHidden = false
                bottomTestView3.isHidden = false
                bottomTestView4.isHidden = false
                bottomView.backgroundColor = .clear
            } else {
                let tapGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(tapBottomViewTapped))
                $0.addGestureRecognizer(tapGesture)
                bottomCardTextLabel.isHidden = false
                bottomVoiceImage.isHidden = false
                bottomTestView1.isHidden = true
                bottomTestView2.isHidden = true
                bottomTestView3.isHidden = true
                bottomTestView4.isHidden = true
                bottomView.backgroundColor = AppSource.Color.backgroundWrapperView
            }
        }
        bottomVoiceImage.do {
            $0.image = AppSource.Image.speakWord
            $0.contentMode = .scaleAspectFill
            let voiceTap = UILongPressGestureRecognizer(target: self, action: #selector(VoiceTapTapped))
            voiceTap.name = "bottomVoiceImage"
            voiceTap.minimumPressDuration = 0.2
            startVoice = true
            $0.isHidden = true
            $0.addGestureRecognizer(voiceTap)
            $0.isUserInteractionEnabled = true
        }
        
        
        
        
        bottomCardTextLabel.do {
            $0.text = ""
            $0.textColor = AppSource.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 28, weight: .regular)
            $0.backgroundColor = .clear
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        buttonWrapper.do {
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
        }
        
        
        hintsView.do {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tipTapped))
            $0.isHidden = true
            $0.addGestureRecognizer(tap)
            $0.addSubview(longPressWrapperView)
            $0.addSubview(pressWrapperView)
            $0.addSubview(leftSwipeWrapperView)
            $0.addSubview(rightSwipeWrapperView)
            $0.addSubview(downSwipeWrapperView)
        }
        longPressWrapperView.do {
            $0.addSubview(longPressPicImage)
            $0.addSubview(longPressActImage)
        }
        pressWrapperView.do {
            $0.addSubview(pressPicImage)
            $0.addSubview(pressActImage)
        }
        leftSwipeWrapperView.do {
            $0.addSubview(leftSwipePicImage)
            $0.addSubview(leftSwipeActImage)
        }
        rightSwipeWrapperView.do {
            $0.addSubview(rightSwipePicImage)
            $0.addSubview(rightSwipeActImage)
        }
        downSwipeWrapperView.do {
            $0.addSubview(downSwipePicImage)
            $0.addSubview(downSwipeActImage)
        }
        [longPressWrapperView, pressWrapperView,
         leftSwipeWrapperView, rightSwipeWrapperView, downSwipeWrapperView].forEach {
            $0.do {
                $0.backgroundColor = .lightGray
                $0.layer.cornerRadius = 20
            }
         }
        [longPressPicImage, longPressActImage, pressPicImage, pressActImage,
         leftSwipePicImage, rightSwipePicImage,downSwipePicImage].forEach {
            $0.do {
                $0.tintColor = AppSource.Color.selectedStrokeBottomButton
                $0.image?.withRenderingMode(.alwaysTemplate)
                $0.contentMode = .scaleAspectFit
            }
         }
        longPressPicImage.do {
            $0.image = AppSource.Image.longPressVoicePic
        }
        longPressActImage.do {
            $0.image = AppSource.Image.speakWord
        }
        pressPicImage.do {
            $0.image = AppSource.Image.showWordPic
        }
        pressActImage.do {
            $0.image = AppSource.Image.showWordAct
        }
        leftSwipePicImage.do {
            $0.image = AppSource.Image.leftSwipePic
        }
        leftSwipeActImage.do {
            $0.show(with: 5)
        }
        rightSwipePicImage.do {
            $0.image = AppSource.Image.rightSwipePic
        }
        rightSwipeActImage.do {
            $0.show(with: 3)
        }
        downSwipePicImage.do {
            $0.image = AppSource.Image.downSwipePic
        }
        downSwipeActImage.do {
            $0.show(with: 1)
        }
        endEducationView.do {
            $0.isHidden = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideEndEducationViewTapped))
            $0.isHidden = true
            $0.addGestureRecognizer(tap)
        }
    }
    private func setupConstraints() {
        view.addSubview(chooseCardLearnButton)
        view.addSubview(buttonWrapper)
        view.addSubview(bottomView)
        buttonWrapper.addSubview(buttonsView)
        view.addSubview(topView)
        view.addSubview(endEducationView)
        view.addSubview(topNameView)
        view.addSubview(hintsView)
        
        topNameView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        chooseCardLearnButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(45)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        topView.snp.makeConstraints {
            $0.top.equalTo(chooseCardLearnButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(bottomView.snp.top).offset(-15)
            $0.height.equalTo(bottomView.snp.height)
        }
        topCardTextLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(80)
        }
        topVoiceImage.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.size.equalTo(30)
        }
        bottomView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(buttonWrapper.snp.top).offset(-15)
            $0.leading.equalToSuperview().offset(15)
            $0.height.equalTo(topView.snp.height)
        }
        
        bottomTestView1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        bottomTestView2.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(bottomTestView1.snp.bottom).offset(15)
            $0.top.lessThanOrEqualTo(bottomTestView1.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(bottomTestView1)
        }
        bottomTestView3.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(bottomTestView2.snp.bottom).offset(15)
            $0.top.lessThanOrEqualTo(bottomTestView2.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(bottomTestView1)
        }
        bottomTestView4.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(bottomTestView3.snp.bottom).offset(15)
            $0.top.lessThanOrEqualTo(bottomTestView3.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(bottomTestView1)
            $0.bottom.equalToSuperview().offset(-15)
        }
        bottomVoiceImage.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.size.equalTo(30)
        }
        bottomTestViewLabel1.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        bottomTestViewLabel2.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        bottomTestViewLabel3.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        bottomTestViewLabel4.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        bottomCardTextLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(80)
        }
        buttonWrapper.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            let sizeHeight = UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue ? 80 : 100
            $0.height.equalTo(sizeHeight)
        }
        buttonsView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-15)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        hintsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let trailingSize = UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue ? 15 : 50
        let topSize = UIScreen.main.bounds.height >= DeviceHeight.iphoneX.rawValue ? 150 : 50 
        let actTrailingSize = 50 // между левыми и правыми картинками
        let topPicSize = 10 // между левыми картинками
        longPressWrapperView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topSize)
            $0.leading.trailing.equalToSuperview().inset(trailingSize)
            $0.height.equalTo(80)
        }
        longPressPicImage.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        longPressActImage.snp.makeConstraints {
            $0.centerY.equalTo(longPressPicImage.snp.centerY)
            $0.size.equalTo(50)
            $0.leading.equalTo(longPressPicImage.snp.trailing).offset(actTrailingSize)
        }
        
        
        
        
        pressWrapperView.snp.makeConstraints {
            $0.top.equalTo(longPressWrapperView.snp.bottom).offset(topPicSize)
            $0.leading.trailing.equalToSuperview().inset(trailingSize)
            $0.height.equalTo(80)
        }
        pressPicImage.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        pressActImage.snp.makeConstraints {
            $0.centerY.equalTo(pressPicImage.snp.centerY)
            $0.size.equalTo(50)
            $0.leading.equalTo(pressPicImage.snp.trailing).offset(actTrailingSize)
        }
        
        
        
        
        
        leftSwipeWrapperView.snp.makeConstraints {
            $0.top.equalTo(pressWrapperView.snp.bottom).offset(topPicSize)
            $0.leading.trailing.equalToSuperview().inset(trailingSize)
            $0.height.equalTo(80)
        }
        leftSwipePicImage.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        leftSwipeActImage.snp.makeConstraints {
            $0.centerY.equalTo(leftSwipePicImage.snp.centerY)
            $0.height.equalTo(35)
            $0.leading.equalTo(leftSwipePicImage.snp.trailing).offset(actTrailingSize)
        }
        
        
        
        
        
        rightSwipeWrapperView.snp.makeConstraints {
            $0.top.equalTo(leftSwipeWrapperView.snp.bottom).offset(topPicSize)
            $0.leading.trailing.equalToSuperview().inset(trailingSize)
            $0.height.equalTo(80)
        }
        rightSwipePicImage.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        rightSwipeActImage.snp.makeConstraints {
            $0.centerY.equalTo(rightSwipePicImage.snp.centerY)
            $0.height.equalTo(35)
            $0.leading.equalTo(rightSwipePicImage.snp.trailing).offset(actTrailingSize)
        }
        
        
        
        
        
        
        downSwipeWrapperView.snp.makeConstraints {
            $0.top.equalTo(rightSwipeWrapperView.snp.bottom).offset(topPicSize)
            $0.leading.trailing.equalToSuperview().inset(trailingSize)
            $0.height.equalTo(80)
        }
        downSwipePicImage.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        downSwipeActImage.snp.makeConstraints {
            $0.centerY.equalTo(downSwipePicImage.snp.centerY)
            $0.height.equalTo(35)
            $0.leading.equalTo(downSwipePicImage.snp.trailing).offset(actTrailingSize)
        }
        
        
        
        
        
        
        endEducationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}


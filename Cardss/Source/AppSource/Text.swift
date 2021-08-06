
import Foundation

extension AppSource.Text {
    // - MARK: Shared
    enum Shared {
        private static var domain = "Shared."
        // Заново
        static var anew: String { (Shared.domain + "anew").localized() }
        // Готово
        static var done: String { (Shared.domain + "done").localized()  }
        // Закрыть
        static var  close: String { (Shared.domain + "close").localized()  }
        // ок
        static var  ok: String { (Shared.domain + "ok").localized()  }
        // ошибка
        static var  error: String { (Shared.domain + "error").localized()  }
        // Сохранить
        static var  save: String { (Shared.domain + "save").localized()  }
        // Удалить
        static var  delete: String { (Shared.domain + "delete").localized()  }
        
        // Terms of Use
        static var  termsOfUse: String { (Shared.domain + "termsOfUse").localized()  }
        // Privacy Policy
        static var  privacyPolicy: String { (Shared.domain + "privacyPolicy").localized()  }
        // Warning
        static var  warning: String { (Shared.domain + "warning").localized()  }
        // Error with purchase
        static var  errorWithPurchase: String { (Shared.domain + "errorWithPurchase").localized()  }
        // Warning
        static var  tryAgainLater: String { (Shared.domain + "tryAgainLater").localized()  }
        // Warning
        static var  continueBuyButton: String { (Shared.domain + "continueBuyButton").localized()  }
        // restore
        static var  restore: String { (Shared.domain + "restore").localized()  }
        // No ads
        static var  noAds: String { (Shared.domain + "noAds").localized()  }
        // use Library
        static var  useLibrary: String { (Shared.domain + "useLibrary").localized()  }
        // Work with all function
        static var  workWithAllFunction: String { (Shared.domain + "workWithAllFunction").localized()  }
        // default
        static var  defaultTheme: String { (Shared.domain + "defaultTheme").localized()  }
        // No Theme Name
        static var  noThemeName: String { (Shared.domain + "noThemeName").localized()  }
        // error Count Of New Words
        static var  errorCountOfNewWords: String { (Shared.domain + "errorCountOfNewWords").localized()  }
        // Education time
        static var  educationTime: String { (Shared.domain + "educationTime").localized()  }
        // hour
        static var  hour: String { (Shared.domain + "hour").localized()  }
        // minute
        static var  minute: String { (Shared.domain + "minute").localized()  }
        // repeatsCount
        static var  repeatsCount: String { (Shared.domain + "repeatsCount").localized()  }
        // All words
        static var  allWords: String { (Shared.domain + "allWords").localized()  }
        // learned words
        static var  learnedWords: String { (Shared.domain + "learnedWords").localized()  }
        // minutes -> m.
        static var  minuteShort: String { (Shared.domain + "minuteShort").localized()  }
        // hour -> h
        static var  hourShort: String { (Shared.domain + "hourShort").localized()  }
        // all Time
        static var  allTimeEducation: String { (Shared.domain + "allTimeEducation").localized()  }
        // 7 days education
        static var  sevenDayEducation: String { (Shared.domain + "sevenDayEducation").localized()  }
        // get Premium
        static var  getPremium: String { (Shared.domain + "getPremium").localized()  }
 
    }
    // - MARK: Languages
    enum languages {
        private static var domain = "Languages."
        // Русский
        static var russian: String { (languages.domain + "russian").localized()  }
        // Английский
        static var english: String { (languages.domain + "english").localized()  }
        // Немецкий
        static var german: String { (languages.domain + "german").localized()  }
        // Итальянский
        static var italy: String { (languages.domain + "italy").localized()  }
        // Испанский
        static var spanish: String { (languages.domain + "spanish").localized()  }
        // Китайский
        static var chine: String { (languages.domain + "chine").localized()  }
        // Арабский
        static var arabic: String { (languages.domain + "arabic").localized()  }
        // Португальский
        static var portugal: String { (languages.domain + "portugal").localized()  }
        // Индонезийский
        static var indonezian: String { (languages.domain + "indonezian").localized()  }
        // Французский
        static var french: String { (languages.domain + "french").localized()  }
        // Японский
        static var japan: String { (languages.domain + "japan").localized()  }
        // Шведский
        static var swedish: String { (languages.domain + "swedish").localized()  }
        // Турецкий
        static var turkish: String { (languages.domain + "turkish").localized()  }
        // Корейский
        static var korean: String { (languages.domain + "korean").localized()  }
        // Вьетнамский
        static var vietman: String { (languages.domain + "vietman").localized()  }
        // Тайский
        static var thai: String { (languages.domain + "thai").localized()  }
    }
    // - MARK: AddNewWordsVC
    enum AddNewWordsVC {
        private static var domain = "AddNewWordsVC."
        // Введите тему
        static var enterTheme: String { (AddNewWordsVC.domain + "enterTheme").localized()  }
        // библиотека
        static var library: String { (AddNewWordsVC.domain + "library").localized()  }
        // иностранный язык
        static var foreignLanguage: String { (AddNewWordsVC.domain + "foreignLanguage").localized()  }
        // родной язык
        static var nativeLanguage: String { (AddNewWordsVC.domain + "nativeLanguage").localized()  }
        // Разное количество строк
        static var countOfLinesError: String { (AddNewWordsVC.domain + "countOfLinesError").localized()  }
        // Новые
        static var newCards: String { (AddNewWordsVC.domain + "new").localized()  }
        // Название
        static var name: String { (AddNewWordsVC.domain + "name").localized()  }
        // Добавить
        static var add: String { (AddNewWordsVC.domain + "add").localized()  }
        // Изменить
        static var change: String { (AddNewWordsVC.domain + "change").localized()  }
        // Введите название
        static var setName: String { (AddNewWordsVC.domain + "setName").localized()  }
        // Введите в верхнее поле
        static var setNativeWords: String { (AddNewWordsVC.domain + "setYourWords").localized()  }
        // Введите иностранные слова в нижнее поле
        static var setForeignWords: String { (AddNewWordsVC.domain + "setUnknownWords").localized()  }
        // "часть 1"
        static var beginer: String { (AddNewWordsVC.domain + "beginer").localized()  }
        // "часть 2"
        static var middle: String { (AddNewWordsVC.domain + "middle").localized()  }
        // "часть 3"
        static var middlePlus: String { (AddNewWordsVC.domain + "middlePlus").localized()  }
        // "часть 4"
        static var advanced: String { (AddNewWordsVC.domain + "advanced").localized()  }
        // "часть 5"
        static var advancedPlus: String { (AddNewWordsVC.domain + "advancedPlus").localized()  }
    }
    // - MARK: CardsVC
    enum CardsVC {
        private static var domain = "CardsVC."
        // Редактирование
        static var addNewCards: String { (CardsVC.domain + "addNewCards").localized()  }
        // Редактирование
        static var edit: String { (CardsVC.domain + "edit").localized()  }
        // Название
        static var name: String { (CardsVC.domain + "name").localized()  }
        // Невыученные
        // static var unknown: String { (CardsVC.domain + "unknown").localized()  }
        // Дата
        static var date: String { (CardsVC.domain + "date").localized()  }
    }
    // - MARK: StatisticsVC
    enum StatisticsVC {
        private static var domain = "StatisticsVC."
        // Статистика
        static var statistic: String { (StatisticsVC.domain + "statistic").localized()  }
        // Выученные слова
        static var learnedWords: String { (StatisticsVC.domain + "learnedWords").localized()  }
        // Время обучения
        static var educationTime: String { (StatisticsVC.domain + "educationTime").localized()  }
        // Повторения
        static var repeats: String { (StatisticsVC.domain + "repeats").localized()  }
        // слов
        static var word: String { (StatisticsVC.domain + "word").localized()  }
    }
    // - MARK: SettingVC
    enum SettingVC {
        private static var domain = "SettingVC."
        // "Показывать подсказки"
        static var showHints: String { (SettingVC.domain + "showHints").localized()  }
        // "Цвет темы"
        static var themeColor: String { (SettingVC.domain + "themeColor").localized()  }
        // аккаунт
        static var account: String { (SettingVC.domain + "account").localized()  }
        // голос
        static var voice: String { (SettingVC.domain + "voice").localized()  }
        // Оценить
        static var estimate: String { (SettingVC.domain + "estimate").localized()  }
        // Поделиться
        static var share: String { (SettingVC.domain + "share").localized()  }
        // Написать
        static var support: String { (SettingVC.domain + "support").localized()  }
        // Автоматически
        static var unspecified: String { (SettingVC.domain + "unspecified").localized()  }
        // Темная
        static var dark: String { (SettingVC.domain + "dark").localized()  }
        // Светлая
        static var light: String { (SettingVC.domain + "light").localized()  }
        // Настройки
        static var settings: String { (SettingVC.domain + "settings").localized()  }
        // Повтор не выученных карточек
        static var repeatOfUnknownWord: String { (SettingVC.domain + "repeatOfUnknownWord").localized()  }
        // Случайный порядок карточек
        static var randomList: String { (SettingVC.domain + "randomList").localized()  }
        // Учить тестом или карточкой
        static var testOrCards: String { (SettingVC.domain + "testOrCards").localized()  }
        // Учить карточки
        static var leanrOfCards: String { (SettingVC.domain + "leanrOfCards").localized()  }
        // неизвестные
        static var bad: String { (SettingVC.domain + "bad").localized()  }
        // средние (Удовлетворительные)
        static var middle: String { (SettingVC.domain + "middle").localized()  }
        // известные
        static var good: String { (SettingVC.domain + "good").localized()  }
        // Какую сторону учим
        static var whichCardDoYouLearn: String { (SettingVC.domain + "whichCardDoYouLearn").localized()  }
        // Левую
        static var left: String { (SettingVC.domain + "left").localized()  }
        // Правую
        static var right: String { (SettingVC.domain + "right").localized()  }
        // Случайную
        static var random: String { (SettingVC.domain + "random").localized()  }
        // Ночной режим
        static var nightMode: String { (SettingVC.domain + "nightMode").localized()  }
        // Уведомления
        static var notifications: String { (SettingVC.domain + "notifications").localized()  }
    }
    // - MARK: NotificationVC
    enum NotificationVC {
        private static var domain = "NotificationVC."
        // "Укажите день недели"
        static var errorDay: String { (NotificationVC.domain + "errorDay").localized()  }
        // Уведомления
        static var notification: String { (NotificationVC.domain + "notification").localized()  }
        // Название уведомления
        static var name: String { (NotificationVC.domain + "name").localized()  }
        // Введите название уведомления
        static var nameError: String { (NotificationVC.domain + "nameError").localized()  }
        // Понедельник
        static var monday: String { (NotificationVC.domain + "monday").localized()  }
        // Вторник
        static var tuesday: String { (NotificationVC.domain + "tuesday").localized()  }
        // Среда
        static var wednesday: String { (NotificationVC.domain + "wednesday").localized()  }
        // Четверг
        static var thursday: String { (NotificationVC.domain + "thursday").localized()  }
        // Пятница
        static var friday: String { (NotificationVC.domain + "friday").localized()  }
        // Суббота
        static var saturday: String { (NotificationVC.domain + "saturday").localized()  }
        // Воскресенье
        static var sunday: String { (NotificationVC.domain + "sunday").localized()  }
        // пн
        static var mondayShort: String { (NotificationVC.domain + "mondayShort").localized()  }
        // вт
        static var tuesdayShort: String { (NotificationVC.domain + "tuesdayShort").localized()  }
        // ср
        static var wednesdayShort: String { (NotificationVC.domain + "wednesdayShort").localized()  }
        // чт
        static var thursdayShort: String { (NotificationVC.domain + "thursdayShort").localized()  }
        // пт
        static var fridayShort: String { (NotificationVC.domain + "fridayShort").localized()  }
        // сб
        static var saturdayShort: String { (NotificationVC.domain + "saturdayShort").localized()  }
        // Вс
        static var sundayShort: String { (NotificationVC.domain + "sundayShort").localized()  }
        // Пора учить карточки
        static var notificationString1: String { (NotificationVC.domain + "notificationString1").localized()  }
        // Давно тебя не видели
        static var notificationString2: String { (NotificationVC.domain + "notificationString2").localized()  }
        // Учить карточки
        static var notificationString3: String { (NotificationVC.domain + "notificationString3").localized()  }
        // Сейчас начнется обучение
        static var notificationString4: String { (NotificationVC.domain + "notificationString4").localized()  }
        // Есть пару минут для обучения
        static var notificationString5: String { (NotificationVC.domain + "notificationString5").localized()  }
        // Давай учиться
        static var notificationString6: String { (NotificationVC.domain + "notificationString6").localized()  }
        // Новые слова ждут тебя
        static var notificationString7: String { (NotificationVC.domain + "notificationString7").localized()  }
    }
    // - MARK: EducationVC
    enum EducationVC {
        private static var domain = "EducationVC."
        // обучение
        static var education: String { (EducationVC.domain + "education").localized()  }
        // начать
        static var start: String { (EducationVC.domain + "start").localized()  }
    }
    // - MARK: AddPackOfCardToLearnVC
    enum AddPackOfCardToLearnVC {
        private static var domain = "AddPackOfCardToLearnVC."
        // Выбрать карточки
        static var chooseForLearning: String { (AddPackOfCardToLearnVC.domain + "chooseForLearning").localized()  }
    }
    // - MARK: ChooseGroupOfCards
    enum ChooseGroupOfCards {
        private static var domain = "ChooseGroupOfCards."
        // Родственники
        static var family: String { (ChooseGroupOfCards.domain + "family").localized()  }
        // погода
        static var wheather: String { (ChooseGroupOfCards.domain + "wheather").localized()  }
        // внешность 1
        static var appearance1: String { (ChooseGroupOfCards.domain + "appearance1").localized()  }
        // внешность 2
        static var appearance2: String { (ChooseGroupOfCards.domain + "appearance2").localized()  }
        // характер
        static var character: String { (ChooseGroupOfCards.domain + "character").localized()  }
        // настроение
        static var mood: String { (ChooseGroupOfCards.domain + "mood").localized()  }
        // мой день
        static var myDay: String { (ChooseGroupOfCards.domain + "myDay").localized()  }
        // школа
        static var school: String { (ChooseGroupOfCards.domain + "school").localized()  }
        // хобби
        static var hobby: String { (ChooseGroupOfCards.domain + "hobby").localized()  }
        // книги 1
        static var books1: String { (ChooseGroupOfCards.domain + "books1").localized()  }
        // книги 2
        static var books2: String { (ChooseGroupOfCards.domain + "books2").localized()  }
        // книги 3
        static var books3: String { (ChooseGroupOfCards.domain + "books3").localized()  }
        // еда 1
        static var food1: String { (ChooseGroupOfCards.domain + "food1").localized()  }
        // еда 2
        static var food2: String { (ChooseGroupOfCards.domain + "food2").localized()  }
        // еда 3
        static var food3: String { (ChooseGroupOfCards.domain + "food3").localized()  }
        // еда 4
        static var food4: String { (ChooseGroupOfCards.domain + "food4").localized()  }
        // еда 5
        static var food5: String { (ChooseGroupOfCards.domain + "food5").localized()  }
        // одежда 1
        static var clother1: String { (ChooseGroupOfCards.domain + "clother1").localized()  }
        // одежда 2
        static var clother2: String { (ChooseGroupOfCards.domain + "clother2").localized()  }
        // природа 1
        static var nature1: String { (ChooseGroupOfCards.domain + "nature1").localized()  }
        // природа 2
        static var nature2: String { (ChooseGroupOfCards.domain + "nature2").localized()  }
        // путешествие
        static var travel: String { (ChooseGroupOfCards.domain + "travel").localized()  }
        // вечеринки
        static var party: String { (ChooseGroupOfCards.domain + "party").localized()  }
        // Род занятий
        static var job1: String { (ChooseGroupOfCards.domain + "job1").localized()  }
        // Род занятий
        static var job2: String { (ChooseGroupOfCards.domain + "job2").localized()  }
        // Род занятий
        static var job3: String { (ChooseGroupOfCards.domain + "job3").localized()  }
        // Спорт
        static var sport: String { (ChooseGroupOfCards.domain + "sport").localized()  }
        // Дом 1
        static var home1: String { (ChooseGroupOfCards.domain + "home1").localized()  }
        // Мебель 1
        static var home2: String { (ChooseGroupOfCards.domain + "home2").localized()  }
        // города 1
        static var city1: String { (ChooseGroupOfCards.domain + "city1").localized()  }
        // города 2
        static var city2: String { (ChooseGroupOfCards.domain + "city2").localized()  }
        // города 3
        static var city3: String { (ChooseGroupOfCards.domain + "city3").localized()  }
        
        // глаголы 1
        static var verb1: String { (ChooseGroupOfCards.domain + "verb1").localized()  }
        // глаголы 2
        static var verb2: String { (ChooseGroupOfCards.domain + "verb2").localized()  }
        // глаголы 3
        static var verb3: String { (ChooseGroupOfCards.domain + "verb3").localized()  }
        // глаголы 3
        static var verb4: String { (ChooseGroupOfCards.domain + "verb4").localized()  }
        
        // другие 1
        static var other1: String { (ChooseGroupOfCards.domain + "other1").localized()  }
        // другие 2
        static var other2: String { (ChooseGroupOfCards.domain + "other2").localized()  }
        // другие 3
        static var other3: String { (ChooseGroupOfCards.domain + "other3").localized()  }
        // другие 4
        static var other4: String { (ChooseGroupOfCards.domain + "other4").localized()  }
        // другие 5
        static var other5: String { (ChooseGroupOfCards.domain + "other5").localized()  }
        
        // прилагательные 1
        static var adjective1: String { (ChooseGroupOfCards.domain + "adjective1").localized()  }
        // прилагательные 2
        static var adjective2: String { (ChooseGroupOfCards.domain + "adjective2").localized()  }
        // прилагательные 3
        static var adjective3: String { (ChooseGroupOfCards.domain + "adjective3").localized()  }
        // прилагательные 4
        static var adjective4: String { (ChooseGroupOfCards.domain + "adjective4").localized()  }
        // прилагательные 5
        static var adjective5: String { (ChooseGroupOfCards.domain + "adjective5").localized()  }
        
        // Цвет
        static var color: String { (ChooseGroupOfCards.domain + "color").localized()  }
        // События
        static var event: String { (ChooseGroupOfCards.domain + "event").localized()  }
        
        // Цифры 1
        static var number1: String { (ChooseGroupOfCards.domain + "number1").localized()  }
        // Цифры 2
        static var number2: String { (ChooseGroupOfCards.domain + "number2").localized()  }
        
        // предлоги
        static var preposition: String { (ChooseGroupOfCards.domain + "preposition").localized()  }
        // местоимения
        static var pronomen: String { (ChooseGroupOfCards.domain + "pronomen").localized()  }
        
        // вопросы
        static var question: String { (ChooseGroupOfCards.domain + "question").localized()  }
        // чувства
        static var feeling: String { (ChooseGroupOfCards.domain + "feeling").localized()  }
        // измерения
        static var measure: String { (ChooseGroupOfCards.domain + "measure").localized()  }
        // покупки
        static var purchase: String { (ChooseGroupOfCards.domain + "purchase").localized()  }
        // искусство
        static var art: String { (ChooseGroupOfCards.domain + "art").localized()  }
        
        // вещи 1
        static var thing1: String { (ChooseGroupOfCards.domain + "thing1").localized()  }
        // вещи 2
        static var thing2: String { (ChooseGroupOfCards.domain + "thing2").localized()  }
        // вещи 3
        static var thing3: String { (ChooseGroupOfCards.domain + "thing3").localized()  }
        
        // здоровье
        static var health: String { (ChooseGroupOfCards.domain + "health").localized()  }
        // посуда
        static var dishes: String { (ChooseGroupOfCards.domain + "dishes").localized()  }
        // Бланк
        static var blank: String { (ChooseGroupOfCards.domain + "blank").localized()  }
        
        // время 1
        static var time1: String { (ChooseGroupOfCards.domain + "time1").localized()  }
        // Дни недели 2
        static var time2: String { (ChooseGroupOfCards.domain + "time2").localized()  }
        // месяца 3
        static var time3: String { (ChooseGroupOfCards.domain + "time3").localized()  }
        
        // транспорт
        static var transport: String { (ChooseGroupOfCards.domain + "transport").localized()  }
        // люди
        static var people: String { (ChooseGroupOfCards.domain + "people").localized()  }
        // животные
        static var animal: String { (ChooseGroupOfCards.domain + "animal").localized()  }
        
        //"Выбрать родной язык"
        static var chooseNativeLang: String { (ChooseGroupOfCards.domain + "chooseNativeLang").localized()  }
        //"Выбрать иностранный язык"
        static var chooseForeignLang: String { (ChooseGroupOfCards.domain + "chooseForeignLang").localized()  }
        // Добавить
        static var Add: String { (ChooseGroupOfCards.domain + "Add").localized()  }
        // Выбрать тему
        static var needChooseTheme: String { (ChooseGroupOfCards.domain + "needChooseTheme").localized()  }
        // иностранный язык
        static var foreignLang: String { (ChooseGroupOfCards.domain + "foreignLang").localized()  }
        // родной язык
        static var nativeLang: String { (ChooseGroupOfCards.domain + "nativeLang").localized()  }
    }
    
    // - MARK: TypeOfCardsTheme
    enum TypeOfCardsTheme {
        private static var domain = "TypeOfCardsTheme."
        // семья
        static var familyTheme: String { (TypeOfCardsTheme.domain + "familyTheme").localized()  }
        // погода
        static var wheatherTheme: String { (TypeOfCardsTheme.domain + "wheatherTheme").localized()  }
        // внешность
        static var appearanceTheme: String { (TypeOfCardsTheme.domain + "appearanceTheme").localized()  }
        // характер
        static var characterTheme: String { (TypeOfCardsTheme.domain + "characterTheme").localized()  }
        // настроение
        static var moodTheme: String { (TypeOfCardsTheme.domain + "moodTheme").localized()  }
        // мой день
        static var myDayTheme: String { (TypeOfCardsTheme.domain + "myDayTheme").localized()  }
        // школа
        static var schoolTheme: String { (TypeOfCardsTheme.domain + "schoolTheme").localized()  }
        // хобби
        static var hobbyTheme: String { (TypeOfCardsTheme.domain + "hobbyTheme").localized()  }
        // книги
        static var booksTheme: String { (TypeOfCardsTheme.domain + "booksTheme").localized()  }
        // еда
        static var foodTheme: String { (TypeOfCardsTheme.domain + "foodTheme").localized()  }
        // одежда
        static var clotherTheme: String { (TypeOfCardsTheme.domain + "clotherTheme").localized()  }
        // природа
        static var natureTheme: String { (TypeOfCardsTheme.domain + "natureTheme").localized()  }
        // путешествие
        static var travelTheme: String { (TypeOfCardsTheme.domain + "travelTheme").localized()  }
        // дом
        static var homeTheme: String { (TypeOfCardsTheme.domain + "homeTheme").localized()  }
        // вечеринки
        static var partyTheme: String { (TypeOfCardsTheme.domain + "partyTheme").localized()  }
        // работа
        static var jobTheme: String { (TypeOfCardsTheme.domain + "jobTheme").localized()  }
        // спорт
        static var sportTheme: String { (TypeOfCardsTheme.domain + "sportTheme").localized()  }
        // город
        static var cityTheme: String { (TypeOfCardsTheme.domain + "cityTheme").localized()  }
        // глаголы
        static var verbTheme: String { (TypeOfCardsTheme.domain + "verbTheme").localized()  }
        // другие
        static var otherTheme: String { (TypeOfCardsTheme.domain + "otherTheme").localized()  }
        // прилагательные
        static var adjectiveTheme: String { (TypeOfCardsTheme.domain + "adjectiveTheme").localized()  }
        // цвет
        static var colorTheme: String { (TypeOfCardsTheme.domain + "colorTheme").localized()  }
        // события
        static var eventTheme: String { (TypeOfCardsTheme.domain + "eventTheme").localized()  }
        // цифры
        static var numberTheme: String { (TypeOfCardsTheme.domain + "numberTheme").localized()  }
        // предлоги
        static var prepositionTheme: String { (TypeOfCardsTheme.domain + "prepositionTheme").localized()  }
        // местоимения
        static var pronomenTheme: String { (TypeOfCardsTheme.domain + "pronomenTheme").localized()  }
        // вопросы
        static var questionTheme: String { (TypeOfCardsTheme.domain + "questionTheme").localized()  }
        // чувства
        static var feelingTheme: String { (TypeOfCardsTheme.domain + "feelingTheme").localized()  }
        // измерения
        static var measureTheme: String { (TypeOfCardsTheme.domain + "measureTheme").localized()  }
        // покупки
        static var purchaseTheme: String { (TypeOfCardsTheme.domain + "purchaseTheme").localized()  }
        // искусство
        static var artTheme: String { (TypeOfCardsTheme.domain + "artTheme").localized()  }
        // вещи
        static var thingTheme: String { (TypeOfCardsTheme.domain + "thingTheme").localized()  }
        // здоровье
        static var healthTheme: String { (TypeOfCardsTheme.domain + "healthTheme").localized()  }
        // посуда
        static var dishesTheme: String { (TypeOfCardsTheme.domain + "dishesTheme").localized()  }
        // мебель
        static var furnitureTheme: String { (TypeOfCardsTheme.domain + "furnitureTheme").localized()  }
        // время
        static var timeTheme: String { (TypeOfCardsTheme.domain + "timeTheme").localized()  }
        // транспорт
        static var transportTheme: String { (TypeOfCardsTheme.domain + "transportTheme").localized()  }
        // люди
        static var peopleTheme: String { (TypeOfCardsTheme.domain + "peopleTheme").localized()  }
        // животные
        static var animalTheme: String { (TypeOfCardsTheme.domain + "animalTheme").localized()  }
    }
    
    
    
    
    
    
    
    // - MARK: AccountVC
    enum AccountVC {
        private static var domain = "AccountVC."
        // Сбросить пароль?
        static var resetPassword: String { (AccountVC.domain + "resetPassword").localized()  }
        // Да, на почту
        static var yesToMail: String { (AccountVC.domain + "yesToMail").localized()  }
        // Зарегистрироватся
        static var register: String { (AccountVC.domain + "register").localized()  }
        // Войти
        static var signIn: String { (AccountVC.domain + "signIn").localized()  }
        // Придумайте пароль
        static var createPassword: String { (AccountVC.domain + "createPassword").localized()  }
        // Введите пароль
        static var enterPassword: String { (AccountVC.domain + "enterPassword").localized()  }
        // Введите имя
        static var enterName: String { (AccountVC.domain + "enterName").localized()  }
        // Выйти
        static var logout: String { (AccountVC.domain + "logout").localized()  }
        // Вошли под логином:
        static var youSignInWithLogin: String { (AccountVC.domain + "youSignInWithLogin").localized()  }
        // Введите почту
        static var enterMail: String { (AccountVC.domain + "enterMail").localized()  }
        // Вошли в систему!
        static var loginSuccess: String { (AccountVC.domain + "loginSuccess").localized()  }
        // Успешно зарегистрировались!
        static var registerSuccess: String { (AccountVC.domain + "registerSuccess").localized()  }
        // successMessage
        static var messageSuccess: String { (AccountVC.domain + "messageSuccess").localized()  }
    }
}

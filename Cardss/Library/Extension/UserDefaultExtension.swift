//
//  UserDefaultsExtension.swift


import Foundation


extension UserDefaults {
    
    // первый запуск для показа подсказок
    static var firstLaunchPrompt: String { "firstLaunchPrompt" }
    
    // первый запуск приложения
    static var firstLaunchApp: String { "firstLaunchApp" }
    
    // структура карточек 
    static var cardsCollectionUserDefault: String { "cardsCollectionUserDefault" }
    
    // Попытка залогиниться в Firebase при запуске
    static var tryLoginFirst: String { "tryLoginFirst" }
    
    // отмена автоматического входа в систему если была нажата кнопка Logout
    static var tryAutomaticLogin: String { "tryAutomaticLogin" }
    
    // есть ли премиум
    static var premium: String { "premium" }

    // узнать за что отвечачет и написать название
    static var statistic: String { "statistic" }
    
    // случайный порядок карточек в коллекции
    static var settingRandomListCard: String { "RandomListCard" }
    
    // обучение тестом или карточками
    static var changeLearningView: String { "changeLearningView" }
    
    // показ подсказок
    static var showHints: String { "showHints" }
    
    // выбор языка диктора
    static var selectedSpeaker: String { "selectedSpeaker" }
    
    // какую сторону учим
    static var settingCardView: String { "settingLeft" }
    
    // ночной режим
    static var settingNightMode: String { "nightMode" }
    
    // Сохранение
    static func saveToUD(_ books: [CardsModel]) {
        let data = books.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: UserDefaults.cardsCollectionUserDefault)
    }
    
    // Считывание
    static func loadFromUD() -> [CardsModel] {
        guard let encodedData = UserDefaults.standard.array(forKey: UserDefaults.cardsCollectionUserDefault) as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(CardsModel.self, from: $0) }
    }
}

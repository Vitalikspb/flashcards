


import UIKit

struct CardsModel: Codable {
    
    static let shared = CardsModel(uid: "firstLaunch",
                                   educationTime: 0,
                                   countAllWords: 0,
                                   countFiveStar: 0,
                                   countThreeStar: 0,
                                   countOneStar: 0,
                                   repeatsCount: 0,
                                   countLeaningWordsSevenDays: [WeekDayCounter.returnDateOfDate()[0]:0,
                                                                WeekDayCounter.returnDateOfDate()[1]:0,
                                                                WeekDayCounter.returnDateOfDate()[2]:0,
                                                                WeekDayCounter.returnDateOfDate()[3]:0,
                                                                WeekDayCounter.returnDateOfDate()[4]:0,
                                                                WeekDayCounter.returnDateOfDate()[5]:0,
                                                                WeekDayCounter.returnDateOfDate()[6]:0],
                                   educationTimeSevenDays: [WeekDayCounter.returnDateOfDate()[0]:0,
                                                            WeekDayCounter.returnDateOfDate()[1]:0,
                                                            WeekDayCounter.returnDateOfDate()[2]:0,
                                                            WeekDayCounter.returnDateOfDate()[3]:0,
                                                            WeekDayCounter.returnDateOfDate()[4]:0,
                                                            WeekDayCounter.returnDateOfDate()[5]:0,
                                                            WeekDayCounter.returnDateOfDate()[6]:0],
                                   repeatsCountSevenDays: [WeekDayCounter.returnDateOfDate()[0]:0,
                                                           WeekDayCounter.returnDateOfDate()[1]:0,
                                                           WeekDayCounter.returnDateOfDate()[2]:0,
                                                           WeekDayCounter.returnDateOfDate()[3]:0,
                                                           WeekDayCounter.returnDateOfDate()[4]:0,
                                                           WeekDayCounter.returnDateOfDate()[5]:0,
                                                           WeekDayCounter.returnDateOfDate()[6]:0],
                                   cardsCollection: nil)
    var uid: String
    var educationTime: Int
    var countAllWords: Int
    var countFiveStar: Int
    var countThreeStar: Int
    var countOneStar: Int
    var repeatsCount: Int
    var countLeaningWordsSevenDays: [Date: Int]
    var educationTimeSevenDays: [Date: Int]
    var repeatsCountSevenDays: [Date: Int]
    var cardsCollection: [CardsCollection]?
}

struct CardsCollection: Codable {
    var theme: String
    var info: [CollectionInfo]
}

struct CollectionInfo: Codable {
    var name: String
    var nativeLanguage: String
    var foreignLanguage: String
    var dateAdded: Date
    var countWords: Int
    var fiveStarWords: Int
    var threeStarWords: Int
    var oneStarWords: Int
    var arrayNativeWords: [Int: String]
    var arrayForeignWords: [Int: String]
}

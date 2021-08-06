


enum CardsTheme: Int {
    
    case family      = 0
    case wheather    = 1
    case appearance  = 2
    case character   = 3
    case mood        = 4
    case myDay       = 5
    case school      = 6
    case hobby       = 7
    case books       = 8
    case food        = 9
    case clother     = 10
    case nature      = 11
    case travel      = 12
    case home        = 13
    case party       = 14
    case sport       = 15
    case job         = 16
    case city        = 17
    case verb        = 18
    case other       = 19
    case adjective   = 20
    case color       = 21
    case event       = 22
    case number      = 23
    case preposition = 24
    case pronomen    = 25
    case question    = 26
    case feeling     = 27
    case measure     = 28
    case purchase    = 29
    case art         = 30
    case thing       = 31
    case health      = 32
    case dishes      = 33
    case furniture   = 34
    case time        = 35
    case transport   = 36
    case people      = 37
    case animal      = 38
    
    func title() -> String {
        switch self {
        case .family      : return AppSource.Text.TypeOfCardsTheme.familyTheme
        case .wheather    : return AppSource.Text.TypeOfCardsTheme.wheatherTheme
        case .appearance  : return AppSource.Text.TypeOfCardsTheme.appearanceTheme
        case .character   : return AppSource.Text.TypeOfCardsTheme.characterTheme
        case .mood        : return AppSource.Text.TypeOfCardsTheme.moodTheme
        case .myDay       : return AppSource.Text.TypeOfCardsTheme.myDayTheme
        case .school      : return AppSource.Text.TypeOfCardsTheme.schoolTheme
        case .hobby       : return AppSource.Text.TypeOfCardsTheme.hobbyTheme
        case .books       : return AppSource.Text.TypeOfCardsTheme.booksTheme
        case .food        : return AppSource.Text.TypeOfCardsTheme.foodTheme
        case .clother     : return AppSource.Text.TypeOfCardsTheme.clotherTheme
        case .nature      : return AppSource.Text.TypeOfCardsTheme.natureTheme
        case .travel      : return AppSource.Text.TypeOfCardsTheme.travelTheme
        case .home        : return AppSource.Text.TypeOfCardsTheme.homeTheme
        case .party       : return AppSource.Text.TypeOfCardsTheme.partyTheme
        case .sport       : return AppSource.Text.TypeOfCardsTheme.sportTheme
        case .job         : return AppSource.Text.TypeOfCardsTheme.jobTheme
        case .city        : return AppSource.Text.TypeOfCardsTheme.cityTheme
        case .verb        : return AppSource.Text.TypeOfCardsTheme.verbTheme
        case .other       : return AppSource.Text.TypeOfCardsTheme.otherTheme
        case .adjective   : return AppSource.Text.TypeOfCardsTheme.adjectiveTheme
        case .color       : return AppSource.Text.TypeOfCardsTheme.colorTheme
        case .event       : return AppSource.Text.TypeOfCardsTheme.eventTheme
        case .number      : return AppSource.Text.TypeOfCardsTheme.numberTheme
        case .preposition : return AppSource.Text.TypeOfCardsTheme.prepositionTheme
        case .pronomen    : return AppSource.Text.TypeOfCardsTheme.pronomenTheme
        case .question    : return AppSource.Text.TypeOfCardsTheme.questionTheme
        case .feeling     : return AppSource.Text.TypeOfCardsTheme.feelingTheme
        case .measure     : return AppSource.Text.TypeOfCardsTheme.measureTheme
        case .purchase    : return AppSource.Text.TypeOfCardsTheme.purchaseTheme
        case .art         : return AppSource.Text.TypeOfCardsTheme.artTheme
        case .thing       : return AppSource.Text.TypeOfCardsTheme.thingTheme
        case .health      : return AppSource.Text.TypeOfCardsTheme.healthTheme
        case .dishes      : return AppSource.Text.TypeOfCardsTheme.dishesTheme
        case .furniture   : return AppSource.Text.TypeOfCardsTheme.furnitureTheme
        case .time        : return AppSource.Text.TypeOfCardsTheme.timeTheme
        case .transport   : return AppSource.Text.TypeOfCardsTheme.transportTheme
        case .people      : return AppSource.Text.TypeOfCardsTheme.peopleTheme
        case .animal      : return AppSource.Text.TypeOfCardsTheme.animalTheme
        }
    }
}

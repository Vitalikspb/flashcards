

enum Speaker: String, CaseIterable {
    case Karen = "en-AU"
    case Daniel = "en-GB"
    case Samantha = "en-US"
    case Milena = "ru-RU"
    
    static func selectName(by name: String) -> String {
        switch name {
        case "Karen" : return "en-AU"
        case "Daniel" : return "en-GB"
        case "Samantha" : return "en-US"
        case "Milena" : return "ru-RU"
        default:
            return "ru-RU"
        }
    }
}

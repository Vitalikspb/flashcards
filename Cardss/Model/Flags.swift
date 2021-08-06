import UIKit
import FlagKit

struct Flags {

    static let flagArrayForChooseGroup = [
        AppSource.Text.languages.russian,
        AppSource.Text.languages.english,
        AppSource.Text.languages.german,
        AppSource.Text.languages.french,
        AppSource.Text.languages.spanish,
        AppSource.Text.languages.italy,
        AppSource.Text.languages.turkish,
        AppSource.Text.languages.chine
    ]
    
    static let flagArrayForAddNewWord = [
        AppSource.Text.languages.russian,
        AppSource.Text.languages.english,
        AppSource.Text.languages.german,
        AppSource.Text.languages.italy,
        AppSource.Text.languages.spanish,
        AppSource.Text.languages.chine,
        AppSource.Text.languages.arabic,
        AppSource.Text.languages.portugal,
        AppSource.Text.languages.indonezian,
        AppSource.Text.languages.french,
        AppSource.Text.languages.japan,
        AppSource.Text.languages.swedish,
        AppSource.Text.languages.turkish,
        AppSource.Text.languages.korean,
        AppSource.Text.languages.vietman,
        AppSource.Text.languages.thai
    ]
    
    static func setImage(with name: String) -> UIImage {
        var countryCode = ""
        switch name {
        case AppSource.Text.languages.russian: countryCode = "RU"
        case AppSource.Text.languages.english: countryCode = "US"
        case AppSource.Text.languages.german: countryCode = "DE"            
        case AppSource.Text.languages.italy: countryCode = "IT"
        case AppSource.Text.languages.spanish: countryCode = "ES"
        case AppSource.Text.languages.chine: countryCode = "CN"
        case AppSource.Text.languages.arabic: countryCode = "AE"
        case AppSource.Text.languages.portugal: countryCode = "PT"
        case AppSource.Text.languages.indonezian: countryCode = "ID"
        case AppSource.Text.languages.french: countryCode = "FR"
        case AppSource.Text.languages.japan: countryCode = "JP"
        case AppSource.Text.languages.swedish: countryCode = "SE"
        case AppSource.Text.languages.turkish: countryCode = "TR"
        case AppSource.Text.languages.korean: countryCode = "KR"
        case AppSource.Text.languages.vietman: countryCode = "VN"
        case AppSource.Text.languages.thai: countryCode = "TH"
        default: print("error")
        }
        if countryCode == "" { countryCode = "RU" }
        let flag = Flag(countryCode: countryCode)
        let styledImage = flag!.image(style: .circle)
        return styledImage
    }
}


import UIKit

extension AppSource.Constants {

    // ID Приложения
    static var appID = "1566540685"
    // ID bundle Приложения
    static var appBundleID = "ru.vitaliySviridov.Cards"
    static var verifySharedKey = "b21219a7fbf84451be0f347ddb599b1d"
    
    // Ссылка на отзыв о приложении
    static var appURL:
        URL { URL(string: "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review")! }
    // Поделиться
    static var review:
        URL { URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review")! }

    // Написать письмо
    static var support:
        URL { URL(string: "https://forms.gle/VdEqUx6z7bLUW8gC8")! }
    
    // privacy policy
    static var privacyPolicyURL:
        URL { URL(string: "http://cardsapp.ru/privacy-policy/")! }
    
    // terms of use
    static var termsOfUseURL:
        URL { URL(string: "http://cardsapp.ru/terms-of-user/")! }
    
    // google ads banner id
    static var googleBanerId = "ca-app-pub-4754654270322771/7178524316" // рабочий
    
}

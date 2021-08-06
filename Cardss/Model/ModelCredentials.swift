
import Foundation
import RealmSwift
import Realm

@objcMembers

class ModelCredential: Object {
    @objc dynamic var loginMail = ""
    @objc dynamic var password = ""
}

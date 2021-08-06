
import Foundation
import RealmSwift
import Realm

@objcMembers
class StructNotification: Object {
    @objc dynamic var name = ""
    @objc dynamic var time = ""
    let days = List<String>()
}


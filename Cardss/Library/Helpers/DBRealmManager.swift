

import RealmSwift
import Realm

let realm = try! Realm()
// для обработки локальных уведомлений
class StorageManager {
    func saveNotificationObject(_ place: StructNotification) {
        try! realm.write {
            realm.add(place)
        }
    }
    func deleteNotificationObject(_ place: StructNotification) {
        try! realm.write {
            realm.delete(place)
        }
    }
    func obtainNotificationObject() -> [StructNotification] {
        let models = realm.objects(StructNotification.self)
        return Array(models)
    }
}

// для обработки учетных данных пользователя для входа
class CredentialManager {
    func saveCredentialObject(_ credential: ModelCredential) {
        try! realm.write {
            realm.add(credential)
        }
    }
    func obtainCredentialObject() -> [ModelCredential] {
        let owner = realm.objects(ModelCredential.self)
        return Array(owner)
    }
    func deleteCredentialObject(_ place: ModelCredential) {
        try! realm.write {
            realm.delete(place)
        }
    }
}

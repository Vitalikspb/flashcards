


import Foundation
import UserNotifications

//        dayNumberComponents
//        1 // Вс
//        2 // Пн
//        3 // Вт
//        4 // Ср
//        5 // Чт
//        6 // Пт
//        7 // Сб

struct customNotification {
    var id: String
    var title: String
    var body: String
    var minuteComponents: Int
    var hourComponents: Int
    var dayNumberComponents: Int
}

class LocalNotificationManager {
    var notifications = [customNotification]()
    
    func startScheduledNotification() {
        requestAuthorization()
        deleteRegisteredNotifications()
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notification) in
            print("local notification: \(notification)")
        }
    }
    private func deleteRegisteredNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (granted, error) in
            if granted == true && error == nil {
                self.scheduleNotification()
            }
        }
    }
    
    private func scheduleNotification() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = .default
            
            //change image name
            content.launchImageName = "star"
            var dateComponents = DateComponents()
            dateComponents.hour = notification.hourComponents
            dateComponents.minute = notification.minuteComponents
            dateComponents.weekday = notification.dayNumberComponents
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                        repeats: true)
            let request = UNNotificationRequest(identifier: notification.id,
                                                content: content,
                                                trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
            }
        }
    }
}

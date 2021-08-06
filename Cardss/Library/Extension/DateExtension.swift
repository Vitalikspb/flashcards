

import Foundation

extension Date {
    func daysCompare(to secondDate: Date) -> Int {
        let calendar: Calendar = Calendar.current
        guard let dateDiff = calendar.dateComponents([.day], from: self, to: secondDate).day else { return 9999 }
        return dateDiff
        // Здесь force unwrap, так как в компонентах указали .day и берем day
    }
}

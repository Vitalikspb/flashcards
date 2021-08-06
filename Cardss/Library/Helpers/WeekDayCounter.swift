//
//  WeekDayCounter.swift
//  Cardss
//
//  Created by Macbook on 29.04.2021.
//

import Foundation

class WeekDayCounter {
    
    static func returnStringOfDate() -> [String] {
        let now = Date() // сегодня
        let formatterToString = DateFormatter()
        formatterToString.timeStyle = .none
        formatterToString.dateStyle = .short
        formatterToString.timeZone = TimeZone.current
        
        // преобразовали дату в нужный формат и получили строку
        let dateNow = Calendar.current.startOfDay(for: now)
        let date0 = formatterToString.string(from: dateNow)                 // сегодня
        let date1 = formatterToString.string(from: dateNow - (60*60*24*1))  // вчера / 1 день назад
        let date2 = formatterToString.string(from: dateNow - (60*60*24*2))  // позавчера / 2 дня назад
        let date3 = formatterToString.string(from: dateNow - (60*60*24*3))  // 3 дня назад
        let date4 = formatterToString.string(from: dateNow - (60*60*24*4))  // 4 дня назад
        let date5 = formatterToString.string(from: dateNow - (60*60*24*5))  // 5 дней назад
        let date6 = formatterToString.string(from: dateNow - (60*60*24*6))  // 6 дней назад

        return [date0, date1, date2, date3, date4, date5, date6]
    }
    
    static func returnDateOfDate() -> [Date] {
        let now = Date() // сегодня
        
        // преобразовали дату в нужный формат и получили строку
        let dateNow = Calendar.current.startOfDay(for: now)

        // преобразовали строку в дату в нужном формате
        let dd0 = dateNow + (60*60*24*1)
        let dd1 = dateNow
        let dd2 = dateNow - (60*60*24*1)
        let dd3 = dateNow - (60*60*24*2)
        let dd4 = dateNow - (60*60*24*3)
        let dd5 = dateNow - (60*60*24*4)
        let dd6 = dateNow - (60*60*24*5)

        return [dd0, dd1, dd2, dd3, dd4, dd5, dd6]
    }

}

//
//  LogBook.swift
//  App_Pressure-Calculator
//
//  Created by Anastasia Kantor on 2020-11-06.
//

import Foundation

class LogBook {
    
    var data: [String:[Result]]
    
    init() {
        self.data = [:]
    }

    // добавляем новую запись в журнал
    func add(sampleName: String, dateTime: String, pressure: String) {
        if self.data.index(forKey: sampleName) == nil {
            self.data[sampleName] = []
        }
        self.data[sampleName]!.append(Result(dateTime: dateTime, pressure: pressure))
        
    }
    
    // сохраняем данные в UserDefaults
    func save() {
        
        var dictToSave: [String: Data] = [:]
        
        for (key, value) in self.data {
            let data = try? PropertyListEncoder().encode(value)
            dictToSave[key] = data
        }
        UserDefaults.standard.set(dictToSave, forKey: "SavedData")
    }
    
    // читаем данные из UserDefaults
    func restore() {
        self.data.removeAll()
        
        if let dictWithData = UserDefaults.standard.object(forKey: "SavedData") as? [String: Data] {

            for (key, value) in dictWithData {
                if let array  = try? PropertyListDecoder().decode([Result].self, from: value) {
                    array.forEach { element in
                        self.add(sampleName: key, dateTime: element.dateTime, pressure: element.pressure)
                    }
                } else {
                    print("Error while deconding data from UserDefaults.")
                }
            }
        } else {
            print("Error: UsedDefaults's data has wrong format.")
        }
        
    }
    // исключительно для тестирования
    func printData() {
        if self.data.count == 0 {
            print("There is no data at all")
            return
        }
        
        for (key, value) in self.data {
            value.forEach { record in
                print("sample = \(key) time_stamp = \(record.dateTime) pressure = \(record.pressure)")
            }
        }
    }
    
}

// из интернета. Необходимо, чтобы можно было сохранять сложные типы данных.
extension UserDefaults {
    
    func set<Element: Codable>(value: Element, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        UserDefaults.standard.setValue(data, forKey: key)
    }
    
    func codable<Element: Codable>(forKey key: String) -> Element? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }
}

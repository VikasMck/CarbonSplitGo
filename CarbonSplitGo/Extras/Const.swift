import Foundation

struct Const {
    static let API_KEY = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    static let DB_HOST = Bundle.main.object(forInfoDictionaryKey: "DB_HOST") as? String ?? ""
    static let DB_DATABASE = Bundle.main.object(forInfoDictionaryKey: "DB_DATABASE") as? String ?? ""
    static let DB_USER = Bundle.main.object(forInfoDictionaryKey: "DB_USER") as? String ?? ""
    static let DB_PASSWORD = Bundle.main.object(forInfoDictionaryKey: "DB_PASSWORD") as? String ?? ""


}

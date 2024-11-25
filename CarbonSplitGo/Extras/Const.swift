import Foundation

struct Const {
    static let API_KEY = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
}

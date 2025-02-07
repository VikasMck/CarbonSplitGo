import PostgresClientKit

struct PostgresConnect {
    static let configuration: PostgresClientKit.ConnectionConfiguration = {
        var config = PostgresClientKit.ConnectionConfiguration()
        config.host = Const.DB_HOST
        config.database = Const.DB_DATABASE
        config.user = Const.DB_USER
        config.credential = .scramSHA256(password: Const.DB_PASSWORD)
        return config
    }()

    static func getConnection() throws -> Connection {
        return try Connection(configuration: configuration)
    }
}

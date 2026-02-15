import os

enum AppLogger {
    static let main = Logger()
}

enum LogLevel {
    case info, debug, error
}

func Log(_ level: LogLevel, _ message: String, category: Logger = AppLogger.main) {
    switch level {
    case .info:
        category.info("\(message)")
    case .debug:
        category.debug("\(message)")
    case .error:
        category.error("\(message)")
    }
}

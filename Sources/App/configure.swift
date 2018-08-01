import Fluent
import FluentSQLite
import Vapor
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Middleware configuration
    var middlewareConfig = MiddlewareConfig.default()
    middlewareConfig.use(SessionsMiddleware.self)
    services.register(middlewareConfig)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)

    // Directory Configuration
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    // Database configuration
    var databaseConfig = DatabasesConfig()
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)forums.db"))
    databaseConfig.add(database: db, as: .sqlite)
    services.register(databaseConfig)
    
    // Migration Configuration for the Forum class to the previously created database
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Forum.self, database: .sqlite)
    migrationConfig.add(model: Message.self, database: .sqlite)
    migrationConfig.add(model: User.self, database: .sqlite)
    services.register(migrationConfig)
    
    // Leaf configuration
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

}

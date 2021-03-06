import FluentPostgreSQL
import Vapor
import Leaf





/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    
    
//    let postgresqlConfig = PostgreSQLDatabaseConfig(hostname: "127.0.0.1", port: 5432, username: "premnalluri", database: "helloworld1", password: nil)
//    services.register(postgresqlConfig)
//    let postgresdatabase = PostgreSQLDatabase(config: postgresqlConfig)
//
    
    let postgresqlConfig : PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL"){
        postgresqlConfig = PostgreSQLDatabaseConfig(url: url, transport: .unverifiedTLS)!
    }else{
        postgresqlConfig = PostgreSQLDatabaseConfig(url: "")!
    }
    let postgresdatabase = PostgreSQLDatabase(config: postgresqlConfig)
    var databases = DatabasesConfig()
    databases.add(database: postgresdatabase, as: .psql)
    services.register(databases)
    
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    
    
    
    
    //Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .psql)
    services.register(migrations)
    
    


//    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

//    // Configure a SQLite database
//    let sqlite = try SQLiteDatabase(storage: .memory)
//
//    // Register the configured SQLite database to the database config.
//    var databases = DatabasesConfig()
//    databases.add(database: sqlite, as: .sqlite)
//    services.register(databases)
//
//    // Configure migrations
//    var migrations = MigrationConfig()
//    migrations.add(model: Todo.self, database: .sqlite)
//    services.register(migrations)
}

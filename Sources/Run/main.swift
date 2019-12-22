import Vapor
import FluentPostgreSQL

//let drop = Droplet()
//drop.addProvider(FluentPostgreSQLProvider)
//
//drop.get("/"){ request in
//    return "HelloWorld"
//}
//drop.run()
import App

try app(.detect()).run()


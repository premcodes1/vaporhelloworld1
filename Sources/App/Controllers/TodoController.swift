import Vapor
import FluentPostgreSQL
import PostgreSQL
/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        let title = try req.query.get(String.self, at: "title")
//
//        return Todo.query(on: req).filter(\.id, .equal, 6)
        return Todo.query(on: req).group(.or){ query in
            query.filter(\.title == title)
            
        }.all()
    }
//filter(\.id == 6)
    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        
        return try req.content.decode(Todo.self).flatMap { todo in
            print(todo.id) 
            print(todo.title)
            return todo.create(on: req)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
    
    func update(_ req : Request) throws -> Future<Response> {
        return try req.parameters.next(Todo.self).flatMap{ Todo in
            return try req.content.decode(Todo1.self).flatMap{
                Todo1 in
                Todo.id = Todo1.id
                Todo.title = Todo1.title
                return Todo.save(on: req).map { _ in
                    return req.redirect(to: "/todos")
                    
                }
                
            }
        }
    }
    struct Todo1 : Content{
        var id : Int
        var title : String
    }
}

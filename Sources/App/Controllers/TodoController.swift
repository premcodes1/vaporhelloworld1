import Vapor
import FluentPostgreSQL
import PostgreSQL
/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    var todoCopy : Todo?
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
//        let id = try req.query.get(String.self, at: "id")
//
      // return Todo.query(on: req).filter(\.id, .equal, 6)
        let id = try req.parameters.next(Int.self)
        return Todo.query(on: req).group(.or){ query in
            query.filter(\.id == id)

        }.all()
        //return Todo.query(on: req).all()
//        if Todo.query(on: req).filter(\.id == id).first() == nil {
//            return Todo.query(on: req).filter(\.id == id).first()
//        }
//        else{
//            return Todo.query(on: req).filter(\.id == id).first()
//        }
        
        //return Todo.query(on: req).filter(\.id == id).first()
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
//    func delete(_ req: Request) throws -> Future<HTTPStatus> {
//        return try req.parameters.next(Int.self).flatMap { todo in
//            return todo.delete(on: req)
//        }.transform(to: .ok)
//    }
    
    
    func json(_ req : Request) throws -> String{
//         try req.content.decode(Todo.self).flatMap { todo in
//            self.todoCopy = todo
//
//              todo.create(on: req)
//            }
        try req.content.decode(Todo.self).map{ todo in
            
           
                self.todoCopy = todo

                try todo.create(on: req)
            let todoCopy1 = todo.create(on: req)
            print(todo.create(on: req))
            
        }
        var finalTodo  =  finalToDo(body: todoCopy!, success: true, message: "created successfully")
        do{
            let jsonData = try JSONEncoder().encode(finalTodo)
            let jsonString = String(data : jsonData ,encoding: .utf8)!
           return jsonString
        }catch{
           return ""
        }
            
        
    }

    
//    router.delete("posts", Post.parameter) { req -> Future<String> in
//    guard let futurePost = try? req.parameters.next(Post.self) else {
//        throw Abort(.badRequest)
//    }
//
//    return futurePost.flatMap { post in
//        return post.delete(on: req).map {
//            return "deleted post: \(post.id!)"
//        }
//    }
    
//    func delete1(_ req: Request) throws -> Future<String>{
//        return try req.parameters.next(Todo.self).flatMap{ todo in
//            guard let user = try Todo.find(req.parameters.next(Int.self))else{
//                throw abort()
//            }
//        }
//
//    }

    
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
    struct finalToDo : Codable{
        var body : Todo?
        var success : Bool?
        var message : String?
        init(body : Todo,success : Bool,message:String) {
            self.body = body
            self.success = success
            self.message = message
        }
    }
}

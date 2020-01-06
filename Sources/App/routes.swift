import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get("hello"){req in
        
        return "hello world"
    }
    router.get("hello1"){req in
        return "hello1"
    }
    let todoController = TodoController()
    router.get("todos",use: todoController.index)

    router.post("todos", use: todoController.create)
    router.post("todos", Todo.parameter , "update", use: todoController.update)
    router.get("helloleaf"){ req -> Future<View> in
        return try req.view().render("home",["name":"Leaf"])
        
    }
  
    
}

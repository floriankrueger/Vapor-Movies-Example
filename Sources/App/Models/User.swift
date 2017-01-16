
import Vapor
import Fluent

final class User: Model {
    
    var name: String
    
    // MARK: Model
    
    var id: Node?
    var exists: Bool = false
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
            ])
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.name = try node.extract("name")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("name")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
    
}

extension User {
    func ratedMovies() throws -> Siblings<Movie> {
        return try siblings()
    }
}

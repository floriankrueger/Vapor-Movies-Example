
import Vapor
import Fluent

final class Movie: Model {
    
    var title: String
    
    // MARK: Model
    
    var id: Node?
    var exists: Bool = false
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title
            ])
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.title = try node.extract("title")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("movies") { movies in
            movies.id()
            movies.string("title")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("movies")
    }
    
}

extension Movie {
    func raters() throws -> Siblings<User> {
        return try siblings()
    }
}


import Vapor

final class Rating: Model {
    
    static var entity = "movie_user"
    
    var movieId: Node
    var userId: Node
    var stars: Int
    
    // MARK: Model
    
    var id: Node?
    var exists: Bool = false
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "movie_id": movieId,
            "user_id": userId,
            "stars": stars,
            ])
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.movieId = try node.extract("movie_id")
        self.userId = try node.extract("user_id")
        self.stars = try node.extract("stars")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("movie_user") { movie_user in
            movie_user.id()
            movie_user.int("movie_id")
            movie_user.int("user_id")
            movie_user.int("stars")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("movie_user")
    }
    
}

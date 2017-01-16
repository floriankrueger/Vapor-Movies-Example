
import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)

drop.preparations += Movie.self
drop.preparations += User.self
drop.preparations += Rating.self

drop.group("movies") { movies in
    
    movies.get(Int.self) { request, movieId in
        guard let movie = try Movie.find(movieId) else { throw Abort.notFound }
        return movie
    }
    
    movies.post() { request in
        var movie = try Movie(node: request.json)
        try movie.save()
        return movie
    }
    
    movies.get(Int.self, "ratings") { request, movieId in
        guard let movie = try Movie.find(movieId) else { throw Abort.notFound }
        
        let ratings = try Rating.query().filter("movie_id", movieId).all()
        return try JSON(node: ratings)
    }
    
    movies.get(Int.self, "raters") { request, movieId in
        guard let movie = try Movie.find(movieId) else { throw Abort.notFound }
        
        let raters = try movie.raters().all()
        return try JSON(node: raters)
    }
    
}

drop.group("users") { users in
    
    users.get(Int.self) { request, userId in
        guard let user = try User.find(userId) else { throw Abort.notFound }
        return user
    }
    
    users.post() { request in
        var user = try User(node: request.json)
        try user.save()
        return user
    }
    
}

drop.group("ratings") { ratings in

    ratings.post() { request in
        var rating = try Rating(node: request.json)
        try rating.save()
        return rating
    }
    
}

drop.run()

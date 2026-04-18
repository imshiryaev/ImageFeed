enum API {
    enum Key {
        static let accessKey = "J40xwnkorlfopGUjttlAJf21zmxjQY-1w-rMlnjpToQ"
        static let secretKey = "H-mUZylu6pXnKjTOQmzVoXD8_K90z5ep7ED2hUN5xWA"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
    }
    enum Endpoint {
        static let defaultBaseURLString = "https://api.unsplash.com"
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let unsplashOauthTokenURLString = "https://unsplash.com/oauth/token"
    }
    enum Path {
        static let me = "/me"
        static let photos = "/photos"
        static func users(_ username: String) -> String { "/users/\(username)" }
        static func like(_ photoId: String) -> String { "/photos/\(photoId)/like" }
    }
}

struct ApiConfiguration {
    static let standart: ApiConfiguration = ApiConfiguration(
        accessKey: API.Key.accessKey,
        secretKey: API.Key.secretKey,
        redirectURI: API.Key.redirectURI,
        accessScope: API.Key.accessScope,
        defaultBaseURLString: API.Endpoint.defaultBaseURLString,
        unsplashAuthorizeURLString: API.Endpoint.unsplashAuthorizeURLString,
        unsplashOauthTokenURLString: API.Endpoint.unsplashOauthTokenURLString
    )
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let unsplashAuthorizeURLString: String
    let unsplashOauthTokenURLString: String

    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseURLString: String,
        unsplashAuthorizeURLString: String,
        unsplashOauthTokenURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.unsplashOauthTokenURLString = unsplashOauthTokenURLString
    }
}

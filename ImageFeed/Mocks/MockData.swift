import Foundation

enum MockData {
    static let photos: [Photo] = [
        Photo(
            id: "LBI7cgq3pbM",
            size: CGSize(width: 5245, height: 3497),
            createdAt: Date(),
            welcomeDescription: "A man drinking a coffee.",
            thumbImageURL: "https://images.unsplash.com/photo-1?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-1?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-1?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-1?q=75&fm=jpg&w=1080&fit=max",
            isLiked: false
        ),
        Photo(
            id: "ABC1234defG",
            size: CGSize(width: 4000, height: 3000),
            createdAt: Date(),
            welcomeDescription: "A sunset over the ocean.",
            thumbImageURL: "https://images.unsplash.com/photo-2?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-2?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-2?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-2?q=75&fm=jpg&w=1080&fit=max",
            isLiked: true
        ),
        Photo(
            id: "XYZ9876abcD",
            size: CGSize(width: 6000, height: 4000),
            createdAt: Date(),
            welcomeDescription: "Mountains covered in snow.",
            thumbImageURL: "https://images.unsplash.com/photo-3?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-3?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-3?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-3?q=75&fm=jpg&w=1080&fit=max",
            isLiked: false
        ),
        Photo(
            id: "MNO1122ppqR",
            size: CGSize(width: 3500, height: 2500),
            createdAt: Date(),
            welcomeDescription: "A forest in autumn.",
            thumbImageURL: "https://images.unsplash.com/photo-4?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-4?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-4?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-4?q=75&fm=jpg&w=1080&fit=max",
            isLiked: true
        ),
        Photo(
            id: "QRS4455ttuV",
            size: CGSize(width: 4800, height: 3200),
            createdAt: Date(),
            welcomeDescription: "City lights at night.",
            thumbImageURL: "https://images.unsplash.com/photo-5?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-5?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-5?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-5?q=75&fm=jpg&w=1080&fit=max",
            isLiked: false
        ),
        Photo(
            id: "WXY7788vvwX",
            size: CGSize(width: 5500, height: 3700),
            createdAt: Date(),
            welcomeDescription: "A beach with crystal clear water.",
            thumbImageURL: "https://images.unsplash.com/photo-6?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-6?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-6?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-6?q=75&fm=jpg&w=1080&fit=max",
            isLiked: true
        ),
        Photo(
            id: "ZAB0011ccde",
            size: CGSize(width: 4200, height: 2800),
            createdAt: Date(),
            welcomeDescription: "Flowers blooming in spring.",
            thumbImageURL: "https://images.unsplash.com/photo-7?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-7?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-7?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-7?q=75&fm=jpg&w=1080&fit=max",
            isLiked: false
        ),
        Photo(
            id: "CDE2233ffgh",
            size: CGSize(width: 3800, height: 2600),
            createdAt: Date(),
            welcomeDescription: "A desert landscape.",
            thumbImageURL: "https://images.unsplash.com/photo-8?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-8?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-8?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-8?q=75&fm=jpg&w=1080&fit=max",
            isLiked: true
        ),
        Photo(
            id: "GHI4455iijk",
            size: CGSize(width: 5000, height: 3300),
            createdAt: Date(),
            welcomeDescription: "A waterfall in a jungle.",
            thumbImageURL: "https://images.unsplash.com/photo-9?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-9?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-9?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-9?q=75&fm=jpg&w=1080&fit=max",
            isLiked: false
        ),
        Photo(
            id: "JKL6677llmn",
            size: CGSize(width: 4600, height: 3100),
            createdAt: Date(),
            welcomeDescription: "A snowy village at Christmas.",
            thumbImageURL: "https://images.unsplash.com/photo-10?q=75&fm=jpg&w=200&fit=max",
            largeImageURL: "https://images.unsplash.com/photo-10?q=75&fm=jpg",
            smallImageURL: "https://images.unsplash.com/photo-10?q=75&fm=jpg&w=400&fit=max",
            regularImageURL: "https://images.unsplash.com/photo-10?q=75&fm=jpg&w=1080&fit=max",
            isLiked: true
        )
    ]
}

//
//  ProjectModel.swift
//  importfolio
//
//  Created by Marwan Osama on 28/09/2021.
//

import Foundation

struct ProjectModel: Codable {
    var id: String
    var name: String
    var appImage: String
    var category: String
    var description: String
    var technologies: String
    var github: String
}

struct ImageModel: Codable {
    var id: String
    var imageURL: String
}

extension ProjectModel {
    static let mockQuadrant = ProjectModel(id: "1",
                                           name: "Quadrant",
                                           appImage: "https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/74/6c/dc/746cdc86-7895-c7d8-6d45-06310d598b43/AppIcon-0-0-1x_U007emarketing-0-0-0-5-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1024x1024bb.png",
                                           category: "Travel",
                                           description: "Well it's quite easy, You Begin with the signing up You can sign up as a Passenger or a Driver/nPassenger Side/nYou can Search for places and locations in your local area. Pick a place and you will see the directions and some route information like distance and estimated time and average price. Request and wait for a Driver near you to accept your trip request. If there is a Driver accepted, You will see the driver's live location. Wait him till he arrive at your pickup location and begin the trip./nDriver Side/nYou can search for trips requested near you. If there is a trip request you will see Passenger pickup location and a timer to accept or reject. Accept the trip and you will have the directions to the passenger location. When you Arrive pick up the passenger and begin the trip.",
                                           technologies: "Firebase and Realtime Database. Reachability. RxSwift, RxCocoa. Push Notifications, Firebase Messaging. MVVM architectural pattern.",
                                           github: "https://github.com/marwansultan97/Quadrant")
    
    static let mockFoodie = ProjectModel(id: "2",
                                         name: "Foodie",
                                         appImage: "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/a3/b4/07/a3b4070a-963b-e369-7d00-770aad0e1937/AppIcon-0-0-1x_U007emarketing-0-0-0-5-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1024x1024bb.png",
                                         category: "Food/Drink",
                                         description: "Simple User Interface and easy to use. It provides you free recipes with nutritions and steps to prepare it. You can search recipes with name or with some filters(e.g., Cuisine, Diet, Dish types). You can find some famous restaurants and their Menu items and it's nutritions. You can generate Day or Week Meal Plan with Targeted Calories.",
                                         technologies: "RxSwift, RxCocoa. MVVM architectural pattern. Networking.",
                                         github: "https://github.com/marwansultan97/Foodie")
}


extension ImageModel {
    static let mockQuadrand = [
        ImageModel(id: "11", imageURL: "https://user-images.githubusercontent.com/52767660/114253068-c2ff5180-99a8-11eb-90c8-657f4956f7f9.png"),
        ImageModel(id: "22", imageURL: "https://is2-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/7e/73/93/7e7393af-b697-ef26-7921-d77f1750f95f/cf40c836-b5b5-453c-b7d1-1dc2d292948e_IMG_0007.PNG/1242x2688bb.png"),
        ImageModel(id: "33", imageURL: "https://is2-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/7e/73/93/7e7393af-b697-ef26-7921-d77f1750f95f/cf40c836-b5b5-453c-b7d1-1dc2d292948e_IMG_0007.PNG/1242x2688bb.png"),
        ImageModel(id: "44", imageURL: "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/e1/9a/af/e19aafe5-9d6e-1262-e6e4-99cbb55d457a/e672c903-f1b2-4baf-8a11-a5286893c0c6_IMG_0008.PNG/1242x2688bb.png"),
        ImageModel(id: "55", imageURL: "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/f9/7f/b5/f97fb586-a7f1-8489-4556-2ecd747208b9/7db2ecb2-808e-447f-bc1a-4a25b8837805_IMG_0012.PNG/1242x2688bb.png"),
        ImageModel(id: "66", imageURL: "https://is3-ssl.mzstatic.com/image/thumb/PurpleSource124/v4/7e/1f/26/7e1f266a-41e1-7501-6d7e-aef2218cd126/b0b4086a-e12d-429c-b29c-16f2f4528c5f_IMG_0015.PNG/1242x2688bb.png"),
        ImageModel(id: "77", imageURL: "https://is3-ssl.mzstatic.com/image/thumb/PurpleSource124/v4/b2/96/aa/b296aada-8274-bcad-4042-2d195e4f39e3/7624df62-1c82-4e4b-98e1-c63d64474b83_IMG_0017.PNG/1242x2688bb.png")]
    
    
    
    static let mockFoodie = [
        ImageModel(id: "11", imageURL: "https://user-images.githubusercontent.com/52767660/114253068-c2ff5180-99a8-11eb-90c8-657f4956f7f9.png"),
        ImageModel(id: "22", imageURL: "https://is2-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/7e/73/93/7e7393af-b697-ef26-7921-d77f1750f95f/cf40c836-b5b5-453c-b7d1-1dc2d292948e_IMG_0007.PNG/1242x2688bb.png"),
        ImageModel(id: "33", imageURL: "https://is2-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/7e/73/93/7e7393af-b697-ef26-7921-d77f1750f95f/cf40c836-b5b5-453c-b7d1-1dc2d292948e_IMG_0007.PNG/1242x2688bb.png"),
        ImageModel(id: "44", imageURL: "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/e1/9a/af/e19aafe5-9d6e-1262-e6e4-99cbb55d457a/e672c903-f1b2-4baf-8a11-a5286893c0c6_IMG_0008.PNG/1242x2688bb.png"),
        ImageModel(id: "55", imageURL: "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource114/v4/f9/7f/b5/f97fb586-a7f1-8489-4556-2ecd747208b9/7db2ecb2-808e-447f-bc1a-4a25b8837805_IMG_0012.PNG/1242x2688bb.png"),
        ImageModel(id: "66", imageURL: "https://is3-ssl.mzstatic.com/image/thumb/PurpleSource124/v4/7e/1f/26/7e1f266a-41e1-7501-6d7e-aef2218cd126/b0b4086a-e12d-429c-b29c-16f2f4528c5f_IMG_0015.PNG/1242x2688bb.png"),
        ImageModel(id: "77", imageURL: "https://is3-ssl.mzstatic.com/image/thumb/PurpleSource124/v4/b2/96/aa/b296aada-8274-bcad-4042-2d195e4f39e3/7624df62-1c82-4e4b-98e1-c63d64474b83_IMG_0017.PNG/1242x2688bb.png")]
}

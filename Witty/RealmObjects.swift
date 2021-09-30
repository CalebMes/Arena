//
//  RealmObjects.swift
//  NewsTestApp
//
//  Created by Caleb Mesfien on 12/5/20.
//

import UIKit
import RealmSwift


class userObject: Object {
    @objc dynamic var name = ""
    @objc dynamic var username = ""
    @objc dynamic var isPrivate = true
    @objc dynamic var bio = "🤷 No Bio"
    @objc dynamic var instagramHandle = ""
    @objc dynamic var tiktokHandle = ""
    @objc dynamic var image: NSData?
    @objc dynamic var joinedDate =  ""
    @objc dynamic var iconItem = 0
    @objc dynamic var FID = ""
}

class BlockedUsers: Object{
    @objc dynamic var username: String?
    @objc dynamic var userId: String?
}


class DarkMode: Object{
    @objc dynamic var isDarkMode = false
}
class AutoReaderMode: Object{
    @objc dynamic var isOn = false
}


class usedVote: Object{
    @objc dynamic var eventID: String?
    @objc dynamic var date: String?
}

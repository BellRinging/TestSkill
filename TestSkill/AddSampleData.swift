//
//  AddSampleData.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 8/11/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Promises

class AddSampleData: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        view.addSubview(addUserButton)
        view.addSubview(addPostButton)
        view.addSubview(addGroupButton)
        view.addSubview(addGameButton)
        view.addSubview(addGameDetailButton)
        addUserButton.Anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
        addPostButton.Anchor(top: addUserButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 0, height: 50)
        addGroupButton.Anchor(top: addPostButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 0, height: 50)
        addGameButton.Anchor(top: addGroupButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 0, height: 50)
        addGameDetailButton.Anchor(top: addGameButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 0, bottomPadding: 8, width: 0, height: 50)
    }
    
    let addUserButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Reset Data", for: .normal)
        bn.addTarget(self, action: #selector(handleAddUser), for: .touchUpInside)
        return bn
    }()
    
    let addPostButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Add Post", for: .normal)
        bn.addTarget(self, action: #selector(handleAddPost), for: .touchUpInside)
        return bn
    }()
    
    let addGroupButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Add Group", for: .normal)
        bn.addTarget(self, action: #selector(handleAddGroup), for: .touchUpInside)
        return bn
    }()

    let addGameButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Add Sample Data", for: .normal)
        bn.addTarget(self, action: #selector(handleAddGame), for: .touchUpInside)
        return bn
    }()
    
    let addGameDetailButton : UIButton = {
        let bn = UIButton()
        bn.setTitle("Add Game Detail", for: .normal)
        bn.addTarget(self, action: #selector(handleAddGameDetail), for: .touchUpInside)
        return bn
    }()
    
    
    func getAllUser() -> [User]{
        //get all users
        
    
        let users = try! await(User.getAllItem().catch{ err in
            Utility.showError(self, message: err.localizedDescription)
            print(err.localizedDescription)
            }
        )
        return users
    }
    
    func getGroupByID(groupId : String) -> Group{
        //get group
        let group = try! await(Group.getById(id: "749C7B4D-21ED-40B1-8F28-ACC42E364B7A").catch{ err in
            Utility.showError(self, message: err.localizedDescription)
            print(err.localizedDescription)
            }
        )
        return group
    }
    
    func createRandomGame(users : [User] , group : Group) -> Game{
        let someDateTime = self.generateRandomDate(daysBack:365)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: someDateTime!)
        dateFormatter.dateFormat = "yyyyMM"
        let period = dateFormatter.string(from: someDateTime!)
        let modify = [1,-1]
//        let number1 = Int.random(in: 0 ... 300) * modify.randomElement()!
//        let number2 = Int.random(in: 0 ... 300) * modify.randomElement()!
//        let number3 = Int.random(in: 0 ... 300) * modify.randomElement()!
//        let number4 = (number1 + number2 + number3) * -1
//        let numList = [number1,number2,number3,number4]
        let numList = [0,0,0,0]
        let location = ["CP Home", "Ricky Home"]
        let area = location.randomElement()!
        var result : [String:Int] = [:]
        let randomPickList = self.randomPick(array: users, number: 4) as! [User]
        var players : [String:String] = [:]
        for user in randomPickList {
            players[user.id] = user.name
        }
        var count = 0
        for num in randomPickList{
            result[num.id] = numList[count]
            count = count+1
        }
        let groupId = group.group_id
        let uuid = UUID().uuidString
        let game = Game(game_id: uuid, group_id: groupId, location: area, date: date, period : period, result: result ,players : players)
        return game
    }
    
    func createGameDetailObject(game : Game, groupRule : [Int:Int]) ->GameDetail{
        
        let whoWin = game.result.randomElement()!
        let randomWinType = ["self","other"].randomElement()!
        var value = 0
        var credit = 0
        let remark = Int.random(in: 3...10)
        var whoLoseList:[String] = []

        
        if (randomWinType == "other"){
            value = groupRule[remark]!
            credit = value
            var whoLose = whoWin
            while ( whoWin.key == whoLose.key ){
                whoLose = game.result.randomElement()!
            }
            whoLoseList = [whoLose.key]
        }else{
            value = groupRule[remark * 10]!
            credit = value * 3
            for (key,value) in game.result {
                if (key != whoWin.key){
                    whoLoseList.append(key)
                }
            }
        }
        let uuid = UUID().uuidString
        let gameDetail = GameDetail(id: uuid, game_id: game.game_id, remark: "\(remark) fan", value: value, whoLose: whoLoseList, whoWin: [whoWin.key], winType: randomWinType)
        return gameDetail
    }
    
    func saveGroup(group : Group ,users : [User]) {
        try! await(group.save().then({ (group) in
            for user in users {
                let userGroup = UserGroup(group_id: group.group_id, group_name: "VietNam")
                try! userGroup.save(userId: user.id)
            }
        }).catch{ err in
            Utility.showError(self, message: err.localizedDescription)
            print(err.localizedDescription)
            }
        )
    }
    
    func saveGameDetail(gameDetail :GameDetail ,game : Game ,users:[User]){
        try gameDetail.save().then({ detail in
            let value = detail.value
            var credit : Int
            if (detail.winType == "other"){
                credit = detail.value
            }else{
                credit = detail.value * 3
            }
            
        })
        
    }
    
    func saveIndivualRecord(detail : GameDetail ,game : Game ,users: [User] ,credit : Int ,value: Int){
        for whoWin in detail.whoWin {
            let gameRecord = GameRecord(record_id: detail.id, game_id: game.game_id, value: credit)
            try gameRecord.save(userId: whoWin)
            try game.updateResult(playerId : whoWin , value : credit )
            let winUser = users.filter ({$0.id == whoWin})[0]
            try winUser.updateBalance(userId : winUser.id , value : credit )
        }
        for whoLose in detail.whoLose {
            let gameRecord = GameRecord(record_id: detail.id, game_id: game.game_id, value: value * -1 )
            try gameRecord.save(userId: whoLose)
            try game.updateResult(playerId : whoLose, value : detail.value * -1 )
            let loseUser = users.filter ({$0.id == whoLose})[0]
            try loseUser.updateBalance(userId : loseUser.id , value : credit * -1)
        }
    }
    
    
    @objc func handleAddGame(){
        
        
        self.background.async {
            Utility.showProgress()
            let users = self.getAllUser()
            print("get all user : \(users.count)")
            let group = self.createGroupObject(users: users)
            self.saveGroup(group: group, users: users)
            let groupRule = group.rule
            for round in 0...1{
                let game = self.createRandomGame(users: users, group: group)
                try! await(game.save().then({ game in
                    print("Save Game \(round)")
                    for nextRound in 0...16{
                        let gameDetail = self.createGameDetailObject(game: game, groupRule: groupRule)
                        self.saveGameDetail(gameDetail: gameDetail, game: game, users: users)
                    }
                }))
                
            }
           Utility.hideProgress()
        }
    }
            
    
    
   @objc func handleAddGameDetail(){
    self.background.async {

        
        
        
        //Radon select a game 
        let games = try! await(Game.getAllItem().catch{err in
            Utility.showError(self, message: err.localizedDescription)
        })
        guard let selectedGame = games.randomElement() else { return}
        print("Selected Game id : \(selectedGame.game_id)")
        
        //Get the game rule
        let groupRule = try! await(Group.getById(id: selectedGame.group_id).catch{err in
            Utility.showError(self, message: err.localizedDescription)
        }).rule
        print("Rule : \(groupRule)")
        
        
        
    }
    }
    
    lazy var background: DispatchQueue = {
          return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
      }()
    
    
    func createGroupObject(users: [User]) -> Group{
        //Create group
        let uuid = UUID().uuidString
        let rule = [3:60,4:130,5:190,6:260,7:380,8:510,9:770,10:1020
                            ,30:30,40:60,50:100,60:130,70:190,80:260,90:380,100:510]
        
        let players = Dictionary(uniqueKeysWithValues: users.map { ($0.id , $0.name) })
        let group = Group(group_id: uuid, players: players, rule: rule, group_name: "VietNam")
        return group
    
    }
    
    @objc func handleAddGroup(){
        
    }

        
        
    
    
    func randomPick(array:[Any],number : Int)-> [Any]{
        var count = Int(array.count) - 1
        var result : [Any] = []
        var used : [Int] = []
        var random = Int.random(in: 0...count)
//        print("random num :\(random)")
        for num in 1...number{
            result.append(array[random])
            used.append(random)
            random = Int.random(in: 0...count)
            while  true {
                if let temp = used.firstIndex(of: random){
                    random = Int.random(in: 0...count)
//                    print("regen random num :\(random)")
                }else {
                    break
                }
            }
        }
        return result
    }
    
    
    func generateRandomDate(daysBack: Int)-> Date?{
                    let day = arc4random_uniform(UInt32(daysBack))+1
                    let hour = arc4random_uniform(23)
                    let minute = arc4random_uniform(59)
                    
                    let today = Date(timeIntervalSinceNow: 0)
                    let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
                    var offsetComponents = DateComponents()
                    offsetComponents.day = -1 * Int(day - 1)
                    offsetComponents.hour = -1 * Int(hour)
                    offsetComponents.minute = -1 * Int(minute)
                    
                    let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        
                 
                    return randomDate
    }

    
    
    
    @objc func handleAddUser(){
        print("handleAddUser")
        self.background.async {
            
            if let groups = try? await(Group.getAllItem()){
                for group in groups {
                    try! Group.delete(id: group.group_id).then({
                        for (player,_) in group.players {
                            try! UserGroup.delete(userId: player, docId: group.group_id)
                        }
                    }).catch({ (err) in
                        print(err.localizedDescription)
                    })
                    
                    
                }
            }
            
            
            print("handleAddUser backgrouptask")
            if let games = try? await(Game.getAllItem()){
                for game in games {
                    try! Game.delete(id: game.game_id).catch({ (err) in
                        print(err.localizedDescription)
                    })
                }
            }
            
            if let gameDetails = try? await(GameDetail.getAllItem()){
                for gameDetail in gameDetails {
                    try! GameDetail.delete(id: gameDetail.id).catch({ (err) in
                        print(err.localizedDescription)
                    })
                }
            }
            
            if let users = try? await(User.getAllItem()){
                for user in users {
                    if let gameRecords = try? await (GameRecord.getAllItem(userId: user.id)){
                        for gameRecord in gameRecords {
                            try! gameRecord.deleteGameRecord(userId: user.id, docId: gameRecord.record_id).catch({ (err) in
                                print(err.localizedDescription)
                            })
                        }
                    }
                }
            }
        }
        
        /*
        print("Add User")
        if let path = Bundle.main.path(forResource: "user", ofType: "txt"){
            do {
                let data  = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                var count = 1
                
                DispatchQueue.main.async {
                    
                    lines.map({ (text)  in
                        if text != "" {
                            print("create dummy \(count) \(text)")
                            self.loginUser(num: count ,name:  text)
                            count = count + 1
                        }
                    })
                
                }
            
            }catch{
                print(error)
            }
            
        }
        
        
        */
    }
    
    func fetchAllUser(){
        var users = [User]()
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {return }
            dict.forEach({ (key,value) in
               
                guard let userProfileDict = value as? [String: Any] else {return}
                let data = try! JSONSerialization.data(withJSONObject: userProfileDict, options: .prettyPrinted)
                var user = try! JSONDecoder.init().decode(User.self, from: data)
//                let user = User(dict: userProfileDict as [String : AnyObject])
                users.append(user)
            })
            self.addPost(users: users)
            
        })
    }
    
    func addPost(users: [User]){
        
        print(users.count)
        
        if let path = Bundle.main.path(forResource: "item", ofType: "txt"){
            do {
                let data  = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                var count = 1000
                
                for i in 2001...8000 {
                    let line = lines[i]
                    if (line != "") {
                        print(line)
                        let items = line.components(separatedBy: "\t")
                        let rand : UInt32 = arc4random_uniform(UInt32(users.count))
//                        print(items[0])
//                        print(items[1])
//                        print(rand)
                        self.saveToDatabaseWithImageUrl(imageUrl: items[0], uid: users[Int(rand)].id, caption: items[1])
                    }
                }
                
//                DispatchQueue.main.async {
//
//                    lines.map({ (text)  in
//                        if text != "" {
////                            print("create dummy \(count) \(text)")
////                            self.loginUser(num: count ,name:  text)
//                            let items = text.split(separator: "\t")
//                            print(items[0])
//                            print(items[1])
//
////                            let rand : UInt32 = arc4random_uniform(UInt32(users.count))
////                            if let user = users[Int(rand)] as? User {
////                                print(user.id)
////                            }
//
//                            count = count + 1
//                        }
//                    })
                
//                }
//
            }catch{
                print(error)
            }
            
        }
        
    }
    
    @objc func handleAddPost(){
        fetchAllUser()
    }
    
    
    func createUser(num : Int ,name : String){
        
        let email = "dummy\(num)@gmail.com"
        let password = "123456"
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            guard let user = result?.user else {return}
//            self.updateDisplayName(user, name: name )
            print("User created")
        }
    }
    
    func loginUser(num : Int ,name:String ){
        
        let email = "dummy\(num)@gmail.com"
        let password = "123456"
        
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {return}
            print("User login")
//            self.createProfitObject(num: num, uid: user.uid, name: name)
        }
    }
//
//    func updateDisplayName(_ user: Any , name:String ){
//        let changeRequest = user.createProfileChangeRequest()
//        changeRequest.displayName = name
//        changeRequest.commitChanges(completion: { (error) in
//            if let err = error {
//                print(err.localizedDescription)
//                return
//            }
//            print("Updated Display Name")
//            do {
//            try Auth.auth().signOut()
//                print("signout")
//            }catch{
//                print(error)
//            }
//        })
//    }
    
    func createProfitObject(num : Int ,uid : String ,name : String){
        let ref = Storage.storage().reference().child("profile_images").child(uid).child("profilePic.jpg")
        if let profileImage = UIImage(named: "\(num).jpg"), let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
            ref.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if (error != nil){
                    print("some bad happend in put image to server")
                    return
                }
                print("upload image")
                ref.downloadURL { (url, error) in
                    if let profileImageURL = url?.absoluteString{
                                        let values = [ "last_name": "Dummy", "first_name": "\(num)" ,"email" : "dummy\(num)@gmail.com" , "img_url" : profileImageURL , "name" : name ,"id" : uid]
                                        print(values)
                                        self.registerUserIntoDatabaseWithUID(uid ,values: values as [String : AnyObject])
                                    }
                }
                
                
            })
        }
    }
    
    
                
    func registerUserIntoDatabaseWithUID( _ uid : String ,values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            do {
                try Auth.auth().signOut()
                print("signout")
            }catch{
                print(error)
            }
    })
    }
    
 
    
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String , uid : String ,caption : String ) {
        
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": 100, "imageHeight": 100, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
//                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
//            self.dismiss(animated: true, completion: nil)
            
//            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
}

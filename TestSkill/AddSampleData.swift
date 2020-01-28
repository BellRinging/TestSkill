////
////  AddSampleData.swift
////  TestSkill
////
////  Created by Kwok Wai Yeung on 8/11/2017.
////  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
////
//
//import Foundation
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//import FirebaseStorage
//import Promises
//
//class AddSampleData: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupView()
//    }
//    
//    func setupView(){
//        view.addSubview(addUserButton)
////        view.addSubview(addPostButton)
//        view.addSubview(addGroupButton)
//        view.addSubview(addGameButton)
//        view.addSubview(addGameDetailButton)
//        let guide = view.safeAreaLayoutGuide
//        addUserButton.Anchor(top: guide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 0, width: 0, height: 50)
////        addPostButton.Anchor(top: addUserButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 8, width: 0, height: 50)
////        addGroupButton.Anchor(top: addUserButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 8, width: 0, height: 50)
//        addGameButton.Anchor(top: addUserButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 8, width: 0, height: 50)
//        addGameDetailButton.Anchor(top: addGameButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topPadding: 8, leftPadding: 8, rightPadding: 8, bottomPadding: 8, width: 0, height: 50)
//        print("Setup")
//    }
//    
//    let addUserButton : UIButton = {
//        let bn = UIButton()
//        bn.backgroundColor = .red
//        bn.setTitle("Reset Data", for: .normal)
////        bn.addTarget(self, action: #selector(handleResetData), for: .touchUpInside)
//        return bn
//    }()
//    
////    let addPostButton : UIButton = {
////        let bn = UIButton()
////        bn.backgroundColor = .green
////        bn.setTitle("Add Post", for: .normal)
////        bn.addTarget(self, action: #selector(handleAddPost), for: .touchUpInside)
////        return bn
////    }()
//    
//    let addGroupButton : UIButton = {
//        let bn = UIButton()
//        bn.backgroundColor = .black
//        bn.setTitle("Add Group", for: .normal)
////        bn.addTarget(self, action: #selector(handleAddGroup), for: .touchUpInside)
//        return bn
//    }()
//
//    let addGameButton : UIButton = {
//        let bn = UIButton()
//        bn.backgroundColor = .yellow
//        bn.setTitle("Add Sample Data", for: .normal)
////        bn.addTarget(self, action: #selector(handleAddGame), for: .touchUpInside)
//        return bn
//    }()
//    
//    let addGameDetailButton : UIButton = {
//        let bn = UIButton()
//              bn.backgroundColor = .blue
//        bn.setTitle("Add Game Detail", for: .normal)
////        bn.addTarget(self, action: #selector(handleAddGameDetail), for: .touchUpInside)
//        return bn
//    }()
//    
//    
//    func getAllUser() -> [User]{
//        //get all users
////        let users = try! await(User.getAllItem().catch{ err in
////            Utility.showError(self, message: err.localizedDescription)
////            print(err.localizedDescription)
////            }
////        )
////        return users
////    }
//    
////    func getGroupByID(groupId : String) -> PlayGroup{
////        //get group
////        let group = try! await(PlayGroup.getById(id: "749C7B4D-21ED-40B1-8F28-ACC42E364B7A").catch{ err in
////            Utility.showError(self, message: err.localizedDescription)
////            print(err.localizedDescription)
////            }
////        )
////        return group
////    }
//    
//    func createRandomGame(users : [User] , group : PlayGroup) -> Game{
////        print("Create random Game")
//        let someDateTime = self.generateRandomDate(daysBack:365)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd"
//        let date = dateFormatter.string(from: someDateTime!)
//        dateFormatter.dateFormat = "yyyyMM"
//        let period = dateFormatter.string(from: someDateTime!)
//        let numList = [0,0,0,0]
//        let location = ["CP Home", "Ricky Home"]
//        let area = location.randomElement()!
//        let randomPickList = self.randomPick(array: users, number: 4) as! [User]
//        let userIdList: [String] = randomPickList.map{ $0.id}
//        let userNameList : [String] = randomPickList.map{$0.userName}
//        let players = Dictionary(uniqueKeysWithValues: zip(userIdList,userNameList))
//        let result : [String:Int] = Dictionary(uniqueKeysWithValues: zip(userIdList,numList))
//        let groupId = group.id
//        let uuid = UUID().uuidString
//        let today = Date(timeIntervalSinceNow: 0)
//        dateFormatter.dateFormat = "yyyyMMddhhmmss"
//        let currentDateTime = dateFormatter.string(from: today)
//        
////        print("Game"
//        let game = Game(gameId: uuid, groupId: groupId, location: area, date: date, period : period, result: result ,playersMap : players,playersId :userIdList,createDateTime : currentDateTime)
////        print("created")
//        return game
//    }
//    
//    func createGameDetailObject(game : Game, groupRule : [Int:Int]) ->GameDetail{
//        
//        let whoWin = game.result.randomElement()!
//        let randomWinType = ["self","other"].randomElement()!
//        var value = 0
//        let fanNo = Int.random(in: 3...10)
//        var whoLoseList:[String] = []
//        
//        if (randomWinType == "other"){
//            value = groupRule[fanNo]!
//            var whoLose = whoWin
//            while ( whoWin.key == whoLose.key ){
//                whoLose = game.result.randomElement()!
//            }
//            whoLoseList = [whoLose.key]
//        }else{
//            value = groupRule[fanNo * 10]!
//            whoLoseList = game.result.keys.filter{ $0 != whoWin.key}
//        }
//        let uuid = UUID().uuidString
//        let gameDetail = GameDetail(gameDetailId: uuid, gameId: game.gameId, remark: "\(fanNo) fan", value: value, whoLose: whoLoseList, whoWin: [whoWin.key], winType: randomWinType)
//        return gameDetail
//    }
//    
//    func saveGroup(group : PlayGroup ,users : [User]) {
////        let _ = try group.save().then{ (group) in
//////            for user in users {
//////                let userGroup = UserGroup(group_id: group.group_id, group_name: "VietNam")
//////                let _ = userGroup.save(userId: user.id)
//////            }
////        }.catch{ err in
////            Utility.showError(self, message: err.localizedDescription)
////            print(err.localizedDescription)
////        }
//    }
//    
//    func saveGameDetail(gameDetail :GameDetail ,game : Game ,users:[User]){
//        let _ =  gameDetail.save().then{ detail in
//            self.saveIndivualRecord(detail: detail, game: game, users: users)
//        }.catch{ err in
//            Utility.showError(self, message: err.localizedDescription)
//            print(err.localizedDescription)
//        }
//    }
//    
//    func saveIndivualRecord(detail : GameDetail ,game : Game ,users: [User] ){
//        let value = detail.value
//        var credit : Int
//        if (detail.winType == "other"){
//            credit = detail.value
//        }else{
//            credit = detail.value * 3
//        }
//        for whoWin in detail.whoWin {
//            let gameRecord = GameRecord(record_id: detail.gameDetailId, game_id: game.gameId, value: credit)
//            gameRecord.save(userId: whoWin).then { _ in
//                return game.updateResult(playerId : whoWin , value : credit )
//            }.then{ _ in
//                let winUser = users.filter ({$0.id == whoWin})[0]
////                let _ = winUser.updateBalance(userId : winUser.id , value : credit )
//            }.catch{err in
//                Utility.showError(self, message: err.localizedDescription)
//                print(err.localizedDescription)
//            }
//        }
//        for whoLose in detail.whoLose {
//            let gameRecord = GameRecord(record_id: detail.gameDetailId, game_id: game.gameId, value: value * -1 )
//            gameRecord.save(userId: whoLose).then{ _ in
//                return game.updateResult(playerId : whoLose, value : detail.value * -1 )
//            }.then{ _ in
//                let loseUser = users.filter ({$0.id == whoLose})[0]
////                let _ = loseUser.updateBalance(userId : loseUser.id , value : credit * -1)
//            }.catch { (err) in
//                Utility.showError(self, message: err.localizedDescription)
//                print(err.localizedDescription)
//            }
//        
//            
//        }
//    }
//    
//    
//    @objc func handleAddGame(){
//        
//            Utility.showProgress()
//        
//        
//        self.background.async {
//        
//            let users = self.getAllUser()
//            print("get all user : \(users.count)")
//            
////            let group = self.createGroupObject(users: users)
////            self.saveGroup(group: group, users: users)
////            let groupRule = group.rule
////            for round in 0...16{
//////                print("round : \(round)")
////                let game = self.createRandomGame(users: users, group: group)
////                print(game)
////                let _ =  game.save().then{ game in
////                    print("Save Game \(round)")
////                    for _ in 0...10{
////                        let gameDetail = self.createGameDetailObject(game: game, groupRule: groupRule)
////                        self.saveGameDetail(gameDetail: gameDetail, game: game, users: users)
////                    }
////                }
////            }
//              Utility.hideProgress()
//        }
//        
//      
//    }
//            
//    
//    
//   @objc func handleAddGameDetail(){
//    self.background.async {
//
//        
//        
//        
//        //Radon select a game
//        let games = try! await(Game.getAllItem().catch{err in
//            Utility.showError(self, message: err.localizedDescription)
//        })
//        guard let selectedGame = games.randomElement() else { return}
//        print("Selected Game id : \(selectedGame.gameId)")
//        
//        //Get the game rule
////        let groupRule = try! await(PlayGroup.getById(id: selectedGame.groupId).catch{err in
////            Utility.showError(self, message: err.localizedDescription)
////        }).rule
////        print("Rule : \(groupRule)")
//        
//        
//        
//    }
//    }
//    
//    lazy var background: DispatchQueue = {
//          return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
//      }()
//    
//    
////    func createGroupObject(users: [User]) -> PlayGroup{
////        //Create group
////        let uuid = UUID().uuidString
////        let rule = [3:60,4:130,5:190,6:260,7:380,8:510,9:770,10:1020
////                            ,30:30,40:60,50:100,60:130,70:190,80:260,90:380,100:510]
////
////        let players = Dictionary(uniqueKeysWithValues: users.map { ($0.id , $0.name) })
////        let group = PlayGroup(id: uuid, players: players, rule: rule, groupName: "VietNam")
////        return group
////
////    }
//    
//    @objc func handleAddGroup(){
//        
//    }
//
//        
//        
//    
//    
//    func randomPick(array:[Any],number : Int)-> [Any]{
////        print("random pick : \(number)")
//        let count = Int(array.count) - 1
//        var result : [Any] = []
//        var used : [Int] = []
//        var random : Int = 0
//        for _ in 1...number{
//            random = Int.random(in: 0...count)
//            while  used.firstIndex(of: random) != nil {
//                random = Int.random(in: 0...count)
////                print("regen random num :\(random)")
////                print("used : \(used)")
//            }
//            result.append(array[random])
//            used.append(random)
////            print("\(number) number is :\(random)")
//        }
//        return result
//    }
//    
//    
//    func generateRandomDate(daysBack: Int)-> Date?{
//        let day = arc4random_uniform(UInt32(daysBack))+1
//        let hour = arc4random_uniform(23)
//        let minute = arc4random_uniform(59)
//        let today = Date(timeIntervalSinceNow: 0)
//        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
//        var offsetComponents = DateComponents()
//        offsetComponents.day = -1 * Int(day - 1)
//        offsetComponents.hour = -1 * Int(hour)
//        offsetComponents.minute = -1 * Int(minute)
//        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
//        print("end of create random date")
//        return randomDate
//    }
//
//    
//    
//    
//    @objc func handleResetData(){
//        print("Reset")
//        self.background.async {
//            
////            Group.getAllItem().then{ groups in
////                for group in groups {
////                    Group.delete(id: group.group_id).then{
////                        for (player,_) in group.players {
////                            let _ =  UserGroup.delete(userId: player, docId: group.group_id)
////                        }
////                    }.catch{ (err) in
////                        print(err.localizedDescription)
////                    }
////                }
////            }.catch{ (err) in
////                print(err.localizedDescription)
////            }
////
//            print("Delete Game")
//            Game.getAllItem().then{ games in
//                print("After get game")
//                for game in games {
//                    let _ = Game.delete(id: game.gameId).catch{ (err) in
//                        print(err.localizedDescription)
//                    }
//                }
//            }.catch{err in
//                print(err.localizedDescription)
//            }
////
//            GameDetail.getAllItem().then{ gameDetails in
//                for gameDetail in gameDetails {
//                    GameDetail.delete(id: gameDetail.gameDetailId).catch({ (err) in
//                        print(err.localizedDescription)
//                    })
//                }
//            }.catch{err in
//                print(err.localizedDescription)
//            }
//
////
////            User.getAllItem().then{ users in
////                for user in users {
////                    GameRecord.getAllItem(userId: user.id).then { gameRecords in
////                        for gameRecord in gameRecords {
////                            let _ = gameRecord.deleteGameRecord(userId: user.id, docId: gameRecord.record_id).catch{ (err) in
////                                print(err.localizedDescription)
////                            }
////                        }
////                    }
////                }
////            }
//        }
//    }
//    
// 
//    
//    
//    func createUser(num : Int ,name : String){
//        
//        let email = "dummy\(num)@gmail.com"
//        let password = "123456"
//        
//        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
//            guard let _ = result?.user else {return}
////            self.updateDisplayName(user, name: name )
//            print("User created")
//        }
//    }
//    
//    func loginUser(num : Int ,name:String ){
//        
//        let email = "dummy\(num)@gmail.com"
//        let password = "123456"
//        
//        
//        
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//            guard let _ = result?.user else {return}
//            print("User login")
//        }
//    }
//    
//    func createProfitObject(num : Int ,uid : String ,name : String){
//        let ref = Storage.storage().reference().child("profile_images").child(uid).child("profilePic.jpg")
//        if let profileImage = UIImage(named: "\(num).jpg"), let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
//            ref.putData(uploadData, metadata: nil, completion: { (metaData, error) in
//                if (error != nil){
//                    print("some bad happend in put image to server")
//                    return
//                }
//                print("upload image")
//                ref.downloadURL { (url, error) in
//                    if let profileImageURL = url?.absoluteString{
//                                        let values = [ "last_name": "Dummy", "first_name": "\(num)" ,"email" : "dummy\(num)@gmail.com" , "img_url" : profileImageURL , "name" : name ,"id" : uid]
//                                        print(values)
//                                        self.registerUserIntoDatabaseWithUID(uid ,values: values as [String : AnyObject])
//                                    }
//                }
//                
//                
//            })
//        }
//    }
//    
//    
//                
//    func registerUserIntoDatabaseWithUID( _ uid : String ,values: [String: AnyObject]) {
//        let ref = Database.database().reference()
//        let usersReference = ref.child("users").child(uid)
//        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//            
//            if err != nil {
//                print(err!)
//                return
//            }
//            do {
//                try Auth.auth().signOut()
//                print("signout")
//            }catch{
//                print(error)
//            }
//    })
//    }
//    
// 
//    
//    
//    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String , uid : String ,caption : String ) {
//        
//        
//        let userPostRef = Database.database().reference().child("posts").child(uid)
//        let ref = userPostRef.childByAutoId()
//        
//        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": 100, "imageHeight": 100, "creationDate": Date().timeIntervalSince1970] as [String : Any]
//        
//        ref.updateChildValues(values) { (err, ref) in
//            if let err = err {
////                self.navigationItem.rightBarButtonItem?.isEnabled = true
//                print("Failed to save post to DB", err)
//                return
//            }
//            
//            print("Successfully saved post to DB")
////            self.dismiss(animated: true, completion: nil)
//            
////            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
//        }
//    }
//}

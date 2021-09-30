//
//  ViewController.swift
//  Witty
//
//  Created by Caleb Mesfien on 4/4/21.
//

import UIKit
import Lottie
import AVFoundation
import RealmSwift
import FirebaseFirestore
import GiphyUISDK

let db = Firestore.firestore()

protocol nameSet {
    func setName()
    func NewMessageCreated(message: String)
    func NewMessage()
}


struct Message {
    var text: String
    var name: String
    var username: String
    var bio: String
    var iconNum: Int
    var gifId: String
    var id: String
    var joined: String
    var instaHandle: String
    var tiktokHandle: String
    var isPrivate: Bool
}

let giphyView = GiphyViewController()


class ViewController: UIViewController, blackViewProtocol, presentGifProtocol, UITextViewDelegate {
    var chatText = [Message]()
    var event: eventItem?{
        didSet{
            constraintContainer()
            updateNews(id: event!.id)

            if realmObjc.objects(usedVote.self).filter("eventID = %@", event!.id).isEmpty{
                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                    generator.impactOccurred()
                            if let window = UIApplication.shared.keyWindow{
                                self.blackWindow.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                                self.blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
                                self.blackWindow.alpha = 0
                                self.view.addSubview(self.blackWindow)

                                UIView.animate(withDuration: 0.5) {
                                    self.blackWindow.alpha = 1
                                }
                    }
                    let vc = SideSelectionView()
                    vc.delegate = self
                    vc.first = self.event?.first
                    vc.second = self.event?.second
                    vc.eventID = self.event?.id
                    vc.modalPresentationStyle = .overCurrentContext
                    self.navigationController?.present(vc, animated: true)
                })
            }
        }
    }
    func presentGit(id: String) {
        let vc = blackViewComt()
        vc.hasGif = id
        present(vc, animated: true)
    }
    

    
    func changeBlackView() {
        self.blackWindow.removeFromSuperview()
    }

    
    let blackWindow = UIView()
    let realmObjc = try! Realm()

    
    
    
    var postNavigationViewHeight: NSLayoutConstraint?
    var collectionViewHeightCon: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().backgroundColor = UIColor.white

        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]


        giphyView.mediaTypeConfig = [.gifs]
        giphyView.delegate = self
        GiphyViewController.trayHeightMultiplier = 0.5
        Giphy.configure(apiKey: "5dEjPANRshiVh80S13ES9M0JDL1c6lb7")
    }
    
    var itemCount : Int?
    var updateOn = true

    func updateNews(id: String){
        db.collection("message").document(id).collection("messages").order(by: "timestamp")
                 .addSnapshotListener { documentSnapshot, error in
                guard self.itemCount == nil || self.itemCount != documentSnapshot?.count else{
                    return
                }
                self.itemCount = documentSnapshot?.count
                guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }

                    
                let data = document.documentChanges.last
                let gifId = data?.document.get("gifId") as? String
                let text = data?.document.get("text") as? String
                let name = data?.document.get("name") as? String
                let username = data?.document.get("username") as? String
                let bio = data?.document.get("bio") as? String
                let iconNum = data?.document.get("iconNum") as? Int
                let id = data?.document.get("id") as? String
                let joined = data?.document.get("joined") as? String
                let instaHandle = data?.document.get("instaHandle") as? String
                let tiktokHandle = data?.document.get("tiktokHandle") as? String
                let isPrivate = data?.document.get("isPrivate") as? Bool


//                let object = myObjectsList.filter("id = %@", objectID ?? NSNull()).first
                guard self.realmObjc.objects(BlockedUsers.self).filter("userId = %@", (String(describing: id)) ).count == 0 else{
                    return
                }

                    let message = Message(text: text ?? "", name: name ?? "", username: username ?? "", bio: bio ?? "🤷 No Bio", iconNum:iconNum ?? 0, gifId: gifId ?? "", id: id ?? "", joined: joined ?? "", instaHandle: instaHandle ?? "", tiktokHandle: tiktokHandle ?? "", isPrivate: isPrivate ?? false)
                self.chatText.append(message)

                if self.chatText.count == 1{
                    DispatchQueue.main.async {
                        self.chatCollectionView.reloadSections(IndexSet(integer: 0))
                    }
                    return
                }

                let item = self.chatText.count-1
                    let lastItemIndex = IndexPath(item: item, section: 0)//
                    self.chatCollectionView.performBatchUpdates({ () -> Void in
                        self.chatCollectionView.insertItems(at:[lastItemIndex])
                    }, completion: nil)


                    if self.updateOn{
                        let item = self.chatCollectionView.numberOfItems(inSection: 0)-1
                        let lastItemIndex = IndexPath(item: item, section: 0)
                        self.chatCollectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: false)
                    }
//            }
            }
    }
    @objc func handleKeyboardNotification(notification: NSNotification){
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        if let userInfo = notification.userInfo{
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            if keyboardFrame!.height > 0 {
                self.chatCollectionView.addGestureRecognizer(tapGesture)
                if self.textView.text == "Say something..."{
                    self.textView.text = ""
                    self.textView.textColor = .black

                }
            }
                UIView.animate(withDuration: 1) {
                    self.postNavigationViewHeight?.constant = -keyboardFrame!.height-8+bottomPadding!
                    self.view.layoutIfNeeded()
                }
        }
    }
    @objc func removeKeyboard(notification: NSNotification){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        if let userInfo = notification.userInfo{
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            if keyboardFrame!.height > 0 {
                self.chatCollectionView.addGestureRecognizer(tapGesture)
                if self.textView.text == ""{
                    self.textView.text = "Say something..."
                    self.textView.textColor = UIColor.lightGray
                    self.textView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                    self.sendBtn.isEnabled = false
                    self.sendBtn.titleLabel?.textColor = .lightGray
                }
            }
                UIView.animate(withDuration: 1) {
                    self.postNavigationViewHeight?.constant = -8
                    self.view.layoutIfNeeded()
                }
        }
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.chatCollectionView.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
        textView.resignFirstResponder()
    }

    
//    CHAT VIEWS
    

    lazy var fadeView: UIView = {
        let imageView = UIView()
  //       var blurEffect = UIBlurEffect()
        imageView.backgroundColor = .white


         let gradient = CAGradientLayer()
          gradient.frame = view.bounds
        gradient.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
  //        gradient.startPoint = CGPoint(x: 0, y: 0.0)
  //        gradient.endPoint = CGPoint(x: 0, y: 0.2)
        gradient.locations = [0,0.03]


         imageView.layer.mask = gradient
  //        imageView.layer.addSublayer(gradient)
          imageView.isUserInteractionEnabled = false
         imageView.clipsToBounds = true
//         imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
    }()

    lazy var fadeViewBottom: UIView = {
        let imageView = UIView()
  //       var blurEffect = UIBlurEffect()
        imageView.backgroundColor = .white
        

         let gradient = CAGradientLayer()
          gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]

  //        gradient.startPoint = CGPoint(x: 0, y: 0.0)
  //        gradient.endPoint = CGPoint(x: 0, y: 0.2)
        gradient.locations = [0,0.03]


         imageView.layer.mask = gradient
  //        imageView.layer.addSublayer(gradient)
          imageView.isUserInteractionEnabled = false
         imageView.clipsToBounds = true
//         imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
    }()
    let chatTitle: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Chatroom", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let chatNavView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var chatCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
//        collectionView.layer.cornerRadius = 28
//        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(chatCell2.self, forCellWithReuseIdentifier: "chatCellID2")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.keyboardAppearance = .light
        textView.returnKeyType = .send
        textView.delegate = self
        
        textView.contentInset = UIEdgeInsets(top: -6, left: 0, bottom: 0, right: 0)
//        textView.textColor = UIColor.black
//        textView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        textView.text = "Say something..."
        textView.attributedText = NSAttributedString(string: "Say something...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    lazy var postNavigationView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
//        view.backgroundColor = UIColor.white
//        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentKeyboard)))
        view.layer.cornerRadius = 38/2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    @objc func presentKeyboard(){textView.becomeFirstResponder()}
    
    
    fileprivate let GifBtn: UIButton = {
       let button = UIButton()
        button.isUserInteractionEnabled = true
        button.backgroundColor = .clear
        button.setAttributedTitle(NSAttributedString(string: "GIF", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        button.addTarget(self, action: #selector(giphSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sendBtn: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.textAlignment = .center
        btn.setAttributedTitle(NSAttributedString(string: "Send", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(sendSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
//    PREDICITON VIEW
    
    let predictionView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let predictionTitle: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Win Predictions", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let movePredictionArrow: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "remove"), for: .normal)
        btn.addTarget(self , action: #selector(predictionMove), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let firstVoteView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let secondVoteView: UIView = {
       let view = UIView()
        view.backgroundColor = TealConstantColor.withAlphaComponent(0.4)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstVoteViewTop: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let secondVoteViewTop: UIView = {
       let view = UIView()
        view.backgroundColor = TealConstantColor.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var firstTitle: UILabel = {
       let lbl = UILabel()
        lbl.text = event?.first
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    lazy var secondTitle: UILabel = {
       let lbl = UILabel()
        lbl.text = event?.second
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    lazy var firstPercentage: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        guard let secondTeamItem = event?.secondTeamVotes else{return lbl}
        guard let firstTeamItem = event?.firstTeamVotes else{return lbl}
        let num = round(100.0 * (Double(firstTeamItem)/Double(firstTeamItem+secondTeamItem)*100)) / 100.0
        lbl.text = "\(num)%"
        return lbl
    }()
    lazy var secondPercentage: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        guard let secondTeamItem = event?.secondTeamVotes else{return lbl}
        guard let firstTeamItem = event?.firstTeamVotes else{return lbl}
        let num = round(100.0 * (Double(secondTeamItem)/Double(firstTeamItem+secondTeamItem)*100)) / 100.0
        lbl.text = "\(num)%"


        return lbl
    }()
    let explanationLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "This is a representation of the favored\nteam within this chat room."
        lbl.font = .systemFont(ofSize: 12, weight: .regular)
        lbl.textColor = .gray
        lbl.numberOfLines = 0
//        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    
    
    lazy var emojiCollection: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.layer.cornerRadius = 28
//        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    let lineView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func constraintContainer(){
        view.addSubview(chatCollectionView)
        view.addSubview(fadeView)
//        view.addSubview(fadeViewBottom)
        
        predictionView.addSubview(predictionTitle)
        predictionView.addSubview(movePredictionArrow)
        view.addSubview(predictionView)
        predictionView.addSubview(explanationLbl)

        predictionView.addSubview(firstVoteView)
        firstVoteView.addSubview(firstVoteViewTop)
        firstVoteView.addSubview(firstTitle)
        firstVoteView.addSubview(firstPercentage)
        
        predictionView.addSubview(secondVoteView)
        secondVoteView.addSubview(secondVoteViewTop)
        secondVoteView.addSubview(secondPercentage)
        secondVoteView.addSubview(secondTitle)

        view.addSubview(chatNavView)
        chatNavView.addSubview(chatTitle)

        view.addSubview(postNavigationView)
        postNavigationView.addSubview(textView)
        postNavigationView.addSubview(sendBtn)
        view.addSubview(GifBtn)

        view.addSubview(lineView)
        view.addSubview(emojiCollection)
        
        postNavigationViewHeight = emojiCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        collectionViewHeightCon = chatCollectionView.topAnchor.constraint(equalTo: chatNavView.bottomAnchor, constant: -8)
        guard let secondTeamItem = event?.secondTeamVotes else{return}
        guard let firstTeamItem = event?.firstTeamVotes else{return}

        let sum = Double(firstTeamItem+secondTeamItem)
        print( CGFloat(Double(secondTeamItem)/sum))
        NSLayoutConstraint.activate([

            
            predictionTitle.topAnchor.constraint(equalTo: predictionView.topAnchor, constant: 8),
            predictionTitle.leadingAnchor.constraint(equalTo: predictionView.leadingAnchor, constant: 12),
            
            movePredictionArrow.heightAnchor.constraint(equalToConstant: 18),
            movePredictionArrow.widthAnchor.constraint(equalToConstant: 18),
            movePredictionArrow.trailingAnchor.constraint(equalTo: predictionView.trailingAnchor, constant: -12),
            movePredictionArrow.centerYAnchor.constraint(equalTo: predictionTitle.centerYAnchor),
            
            predictionView.heightAnchor.constraint(equalToConstant: 160),
            predictionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            predictionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            predictionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            firstVoteView.heightAnchor.constraint(equalToConstant: 34),
            firstVoteView.leadingAnchor.constraint(equalTo: predictionView.leadingAnchor, constant: 12),
            firstVoteView.trailingAnchor.constraint(equalTo: predictionView.trailingAnchor, constant: -12),
            firstVoteView.topAnchor.constraint(equalTo: predictionTitle.bottomAnchor, constant: 8),
            
            secondVoteView.heightAnchor.constraint(equalToConstant: 34),
            secondVoteView.leadingAnchor.constraint(equalTo: predictionView.leadingAnchor, constant: 12),
            secondVoteView.trailingAnchor.constraint(equalTo: predictionView.trailingAnchor, constant: -12),
            secondVoteView.topAnchor.constraint(equalTo: firstVoteView.bottomAnchor, constant: 8),
            
            firstVoteViewTop.topAnchor.constraint(equalTo:firstVoteView.topAnchor),
            firstVoteViewTop.leadingAnchor.constraint(equalTo: firstVoteView.leadingAnchor),
            firstVoteViewTop.widthAnchor.constraint(equalTo: firstVoteView.widthAnchor, multiplier: CGFloat(Double(firstTeamItem)/sum)),
            firstVoteViewTop.bottomAnchor.constraint(equalTo: firstVoteView.bottomAnchor),
            
            secondVoteViewTop.topAnchor.constraint(equalTo:secondVoteView.topAnchor),
            secondVoteViewTop.leadingAnchor.constraint(equalTo: secondVoteView.leadingAnchor),
            secondVoteViewTop.widthAnchor.constraint(equalTo: secondVoteView.widthAnchor, multiplier: CGFloat(Double(secondTeamItem)/sum)),
            secondVoteViewTop.bottomAnchor.constraint(equalTo: secondVoteView.bottomAnchor),
            
            firstTitle.centerYAnchor.constraint(equalTo: firstVoteView.centerYAnchor),
            firstTitle.leadingAnchor.constraint(equalTo: firstVoteView.leadingAnchor, constant: 12),
            firstPercentage.centerYAnchor.constraint(equalTo: firstVoteView.centerYAnchor),
            firstPercentage.trailingAnchor.constraint(equalTo: firstVoteView.trailingAnchor, constant: -12),
            
            secondTitle.centerYAnchor.constraint(equalTo: secondVoteView.centerYAnchor),
            secondTitle.leadingAnchor.constraint(equalTo: secondVoteView.leadingAnchor, constant: 12),
            secondPercentage.centerYAnchor.constraint(equalTo: secondVoteView.centerYAnchor),
            secondPercentage.trailingAnchor.constraint(equalTo: secondVoteView.trailingAnchor, constant: -12),
            
            explanationLbl.bottomAnchor.constraint(equalTo: predictionView.bottomAnchor, constant: -8),
            explanationLbl.leadingAnchor.constraint(equalTo:predictionView.leadingAnchor, constant: 12),
            
            
            
            
            chatNavView.heightAnchor.constraint(equalToConstant: 34),
            chatNavView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            chatNavView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            chatNavView.topAnchor.constraint(equalTo: predictionView.bottomAnchor, constant: 12),
            
            chatTitle.centerYAnchor.constraint(equalTo: chatNavView.centerYAnchor),
            chatTitle.leadingAnchor.constraint(equalTo: chatNavView.leadingAnchor, constant: 12),
            
//            chatCollectionView.topAnchor.constraint(equalTo: chatNavView.bottomAnchor, constant: 0),
            collectionViewHeightCon!,
            chatCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            chatCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            chatCollectionView.bottomAnchor.constraint(equalTo: lineView.topAnchor),
            
            fadeView.topAnchor.constraint(equalTo: chatNavView.bottomAnchor, constant: 0),
            fadeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            fadeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            fadeView.heightAnchor.constraint(equalToConstant: 35),
            
//            fadeViewBottom.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: 0),
//            fadeViewBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
//            fadeViewBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
//            fadeViewBottom.heightAnchor.constraint(equalToConstant: 38),
            
            postNavigationViewHeight!,
            postNavigationView.leadingAnchor.constraint(equalTo: GifBtn.trailingAnchor, constant: 8),
            postNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            postNavigationView.heightAnchor.constraint(equalToConstant: 38),
            postNavigationView.bottomAnchor.constraint(equalTo: emojiCollection.topAnchor, constant: -4),

            lineView.bottomAnchor.constraint(equalTo: postNavigationView.topAnchor,constant: -8),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emojiCollection.heightAnchor.constraint(equalToConstant: 34),
            emojiCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: postNavigationView.topAnchor, constant: 8),
//            textView.centerYAnchor.constraint(equalTo: postNavigationView.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: postNavigationView.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: postNavigationView.bottomAnchor, constant: -6),
            
            sendBtn.bottomAnchor.constraint(equalTo: postNavigationView.bottomAnchor, constant: 0),
            sendBtn.trailingAnchor.constraint(equalTo: postNavigationView.trailingAnchor, constant: -12),
            sendBtn.widthAnchor.constraint(equalToConstant: sendBtn.intrinsicContentSize.width),
            sendBtn.heightAnchor.constraint(equalToConstant: 38),

            GifBtn.centerYAnchor.constraint(equalTo: postNavigationView.centerYAnchor),
            GifBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            GifBtn.widthAnchor.constraint(equalToConstant: 38),
            GifBtn.heightAnchor.constraint(equalToConstant: 38),
        ])
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)

        if(text == "\n") {
            if textView.text.count > 0{
                db.collection("message").document(event!.id).collection("messages").addDocument(data: [
                "text":textView.text!,
                "gifId":"",
                "iconNum":realmObjc.objects(userObject.self)[0].iconItem,
                "name":realmObjc.objects(userObject.self)[0].name,
                "username":realmObjc.objects(userObject.self)[0].username,
                "timestamp":Date(),
                "id":realmObjc.objects(userObject.self)[0].FID,
                "joined":realmObjc.objects(userObject.self)[0].joinedDate,
                "instaHandle":realmObjc.objects(userObject.self)[0].instagramHandle,
                "tiktokHandle":realmObjc.objects(userObject.self)[0].tiktokHandle,
                "isPrivate": realmObjc.objects(userObject.self)[0].isPrivate,
                "bio": realmObjc.objects(userObject.self)[0].bio
                ])
                
                
                textView.attributedText = NSAttributedString(string: "Say something...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
                sendBtn.isEnabled = false
                UIView.animate(withDuration: 0.18) {
                    self.chatCollectionView.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
                    self.view.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.postNavigationView.constraints.forEach { (constraint) in
                        if constraint.firstAttribute == .height{
                            constraint.constant = 38
                        }
                    }
                    self.view.layoutIfNeeded()
                }

            }
            self.chatCollectionView.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
            UIView.animate(withDuration: 0.18) {
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
                if self.textView.text == ""{
                    self.textView.textColor = .lightGray
                    self.textView.text = "Say something..."
                }
                self.view.layoutIfNeeded()
            }
            textView.resignFirstResponder()
            return false
        }
        let numberOfChars = newText.count
        if numberOfChars >= 224{
            return false
        }
        
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        if textView.text.count != 0{
            sendBtn.isEnabled = true
            sendBtn.titleLabel?.textColor = .systemBlue
        }else{
            sendBtn.isEnabled = true
            sendBtn.titleLabel?.textColor = .lightGray
        }

        postNavigationView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height{
                constraint.constant = estimatedSize.height + 6
                print(estimatedSize.height)
            }
        }
    }
    func translateMainView(){
        UIView.animate(withDuration: 1.5) {

//            COMING FROM RIGHT
            self.chatNavView.transform = CGAffineTransform(translationX: -self.view.frame.width*0.975, y: 0)
            self.chatCollectionView.transform = CGAffineTransform(translationX: -self.view.frame.width*0.975, y: 0)
            self.fadeView.transform = CGAffineTransform(translationX: -self.view.frame.width*0.975, y: 0)
            self.fadeViewBottom.transform = CGAffineTransform(translationX: -self.view.frame.width*0.975, y: 0)

            self.GifBtn.alpha = 1
            self.postNavigationView.alpha = 1
            print("RIGHT HERE", self.view.safeAreaLayoutGuide.layoutFrame.height, self.view.frame.height)
        }
    }
    @objc func giphSelected(){
        UIView.animate(withDuration: 0.4) {
            self.chatCollectionView.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
            self.postNavigationViewHeight?.constant = -4
            self.postNavigationView.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height{
                    constraint.constant = 38
                }
            }
            self.view.layoutIfNeeded()
        }

        giphyView.theme = GPHTheme(type: .light)
        navigationController?.present(giphyView, animated: true, completion: {
        })
        
    }
    @objc func sendSelected(){
        if textView.text.count > 0{
            db.collection("message").document(event!.id).collection("messages").addDocument(data: [
            "text":textView.text!,
            "gifId":"",
            "iconNum":realmObjc.objects(userObject.self)[0].iconItem,
            "name":realmObjc.objects(userObject.self)[0].name,
            "username":realmObjc.objects(userObject.self)[0].username,
            "timestamp":Date(),
            "id":realmObjc.objects(userObject.self)[0].FID,
            "joined":realmObjc.objects(userObject.self)[0].joinedDate,
            "instaHandle":realmObjc.objects(userObject.self)[0].instagramHandle,
            "tiktokHandle":realmObjc.objects(userObject.self)[0].tiktokHandle,
            "isPrivate": realmObjc.objects(userObject.self)[0].isPrivate,
            "bio": realmObjc.objects(userObject.self)[0].bio
            ])
            textView.attributedText = NSAttributedString(string: "Say something...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
            sendBtn.isEnabled = false

            UIView.animate(withDuration: 0.3) {
                self.chatCollectionView.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
                self.postNavigationView.constraints.forEach { (constraint) in
                    if constraint.firstAttribute == .height{
                        constraint.constant = 38
                    }
                }
                self.view.layoutIfNeeded()
            }
            
        }
        self.chatCollectionView.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
        UIView.animate(withDuration: 0.18) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            if self.textView.text == ""{
                self.textView.attributedText = NSAttributedString(string: "Say something...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
            }
            self.view.layoutIfNeeded()
        }
        textView.resignFirstResponder()
    }
 
    @objc func predictionMove(){
        UIView.animate(withDuration: 1, delay: 0.25,options: UIView.AnimationOptions.curveEaseOut,animations: {
//            self.predictionView.alpha = 0
            self.predictionView.transform = CGAffineTransform(translationX: -1000, y: 0)
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            UIView.animate(withDuration: 1, delay: 0.25,options: UIView.AnimationOptions.curveEaseOut,animations: {
                self.chatNavView.transform = CGAffineTransform(translationX: 0, y: -168)
                
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
            UIView.animate(withDuration: 1, delay: 0.25,options: UIView.AnimationOptions.curveEaseOut,animations: {
                self.collectionViewHeightCon?.constant = -168
                self.fadeView.transform = CGAffineTransform(translationX: 0, y: -168)
                self.view.layoutIfNeeded()
            })
        }

    }
    
  
}




extension ViewController: GiphyDelegate {
   func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia)   {
    
    db.collection("message").document(event!.id).collection("messages").addDocument(data: [
        "text":"",
        "gifId":media.id,
        "iconNum":realmObjc.objects(userObject.self)[0].iconItem,
        "name":realmObjc.objects(userObject.self)[0].name,
        "username":realmObjc.objects(userObject.self)[0].username,
        "timestamp":Date(),
        "id":realmObjc.objects(userObject.self)[0].FID,
        "joined":realmObjc.objects(userObject.self)[0].joinedDate,
        "instaHandle":realmObjc.objects(userObject.self)[0].instagramHandle,
        "tiktokHandle":realmObjc.objects(userObject.self)[0].tiktokHandle,
        "isPrivate": realmObjc.objects(userObject.self)[0].isPrivate,
        "bio": realmObjc.objects(userObject.self)[0].bio
    ])
    
    giphyViewController.dismiss(animated: true) {}
   }
   
   func didDismiss(controller: GiphyViewController?) {}
}




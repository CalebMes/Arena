//
//  FirstViews.swift
//  Huge Fan
//
//  Created by Caleb Mesfien on 3/19/21.
//

import UIKit
import Realm
import WebKit
import Firebase
import RealmSwift
import GoogleSignIn
import FirebaseFirestore
import AuthenticationServices

class WelcomeView: UIViewController, blackViewProtocol, SelectedLoginOption, GIDSignInDelegate {
    var timer =  Timer()
    let realmObjc = try! Realm()
    let appleProvider = AppleSignInClient()
    let item = 3
    

    func loginOptions(OptionNum: Int) {
        if OptionNum == 0{
            appleProvider.handleAppleIdRequest { (fullName, email, userID)  in
                guard let id = userID else{return}
                let dbItem = db.collection("users")
                    
                    dbItem.whereField("userId", isEqualTo: id).getDocuments { (QuerySnapshot, error) in
                    if let error = error{
                        print(error)
                    }else{

                        self.showSpinner(onView: self.view)
                        if QuerySnapshot!.isEmpty{
                            if email == nil{
                                let alert = UIAlertController(title: "Settings > Apple ID > Password & Security > Apps Using Apple ID > Witty", message:"Due to deleting a past account, you will have to remove Witty from 'Apps Using Apple ID'\n\nOnce you arrive, select 'Stop Using Apple Id' and continue to sign up and create an account" , preferredStyle: .alert)

                                alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))

                                self.present(alert, animated: true)
                            }else{
                                let vc = usernameView()
                                vc.fetchedId = id
                                vc.fetchedEmail = email
                                vc.fetchedName = fullName
                                vc.textField.text = fullName!.replacingOccurrences(of: " ", with: "")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }else{
                            guard let DocID = QuerySnapshot?.documents[0] else{return}
                            let item = userObject()
                            item.FID = String(describing: DocID.documentID)
                            item.username = DocID.data()["username"] as! String
                            item.name = DocID.data()["name"] as! String
                            item.joinedDate =  DocID.data()["joined"] as! String
                            item.iconItem = DocID.data()["iconNum"] as! Int
                            item.bio = DocID.data()["bio"] as! String
                            item.instagramHandle = DocID.data()["instagramHandle"] as! String
                            item.tiktokHandle = DocID.data()["tiktokHandle"] as! String
                            item.image = nil


//                            if DocID.data()["hasProfileImage"] as! Bool{
//                                storage.reference().child(DocID.documentID + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
//                                    if error == nil {
//                                        try! self.realmObjc.write(){
//                                            item.image = (data! as NSData)
//                                        }
//                                    }else{
//                                        try! self.realmObjc.write(){
//                                            item.image = nil
//                                        }
//                                    }
//                                }
//                            }else{
//                                try! self.realmObjc.write(){
//                                    item.image = nil
//                                }
//                            }
//
                                try! self.realmObjc.write(){
                                    self.realmObjc.add(item)
                            }
//
                            
//                            BLOCKED
//                            dbItem.document(DocID.documentID).collection("blocked").getDocuments { (snapshot, error) in
//                                snapshot?.documents.forEach({ (snap) in
//                                    let answerItem = answeredQuestions()
//                                    answerItem.username = snap.data()["username"] as! String

//
//                                if snap.data()["hasImage"] as! Bool{
//                                    storage.reference().child(snap.data()["id"] as! String + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
//                                            if error == nil {
//                                                try! self.realmObjc.write(){
//                                                    answerItem.userImage = (data! as NSData)
//                                                }
//                                            }else{
//                                                try! self.realmObjc.write(){
//                                                    answerItem.userImage = nil
//                                                }
//                                            }
//                                        }
//                                    }else{
//                                        try! self.realmObjc.write(){
//                                            answerItem.userImage = nil
//                                        }
//                                    }
//
//                                    try! self.realmObjc.write{
//                                        self.realmObjc.add(answerItem)
//                                    }
//                                })
//                            }
                            
                            

                            
                        
                                let vc = MainViewController()
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    self.removeSpinner()
                                    self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }

                    }
                }

            }


        }else if OptionNum == 1{
//            GOOGLE SIGN IN
            GIDSignIn.sharedInstance()?.signIn()

        }else if OptionNum == 2{
            let alert = UIAlertController(title: "If you meet the requirment, you will be contacted within the hour.", message:.none , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        }else if OptionNum == 3{
            generator.impactOccurred()
                    if let window = UIApplication.shared.keyWindow{
                        blackWindow.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                        blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
                        blackWindow.alpha = 0
                        view.addSubview(blackWindow)

                        UIView.animate(withDuration: 0.5) {
                            self.blackWindow.alpha = 1
                        }
            }

        let vc = SignupOptions()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.selectedOptions = self
        navigationController?.present(vc, animated: true)
            print("PRESENTING")
        }
    }
    func presentCreateViewController() {
        navigationController?.pushViewController(MainViewController(), animated: true)
    }

    func changeBlackView() {
            self.blackWindow.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self

        let index = NSIndexPath(item: 1, section: 0)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.introCollectionView.scrollToItem(at: index as IndexPath, at: .init(), animated: true)
        }
        constraintContainer()
    }
    func fireTimer(_ int: Int){
        var itemInt = int
        var scroll = false
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in

            if scroll{
                self.introCollectionView.scrollToItem(at: NSIndexPath(row: itemInt, section: 0) as IndexPath, at: .init(), animated: true)
                if itemInt != self.item {
                    itemInt += 1
                }else{
                    itemInt = 0
                }
            }else{
                scroll = true
            }
        }
        timer.fire()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    
    
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let user = user else{
            dismiss(animated: true)
            return
        }

        let dbItem = db.collection("users")
            
        dbItem.whereField("userId", isEqualTo: user.userID!).getDocuments { (QuerySnapshot, error) in
            if let error = error{
                print(error)
            }else{


                self.showSpinner(onView: self.view)
                if QuerySnapshot!.isEmpty{
                            let vc = usernameView()
                            let name = user.profile.name.replacingOccurrences(of: " ", with: "")
                            vc.textField.text = name
                            vc.fetchedEmail = user.profile.email
                            vc.fetchedId = user.userID
                            vc.fetchedName = user.profile.name
                            self.navigationController?.pushViewController(vc, animated: true)

                }else{

                    guard let DocID = QuerySnapshot?.documents[0] else{return}
                    let item = userObject()
                    item.FID = String(describing: DocID.documentID)
                    item.username = DocID.data()["username"] as! String
                    item.name = DocID.data()["name"] as! String
                    item.joinedDate =  DocID.data()["joined"] as! String
                    item.iconItem = DocID.data()["iconNum"] as! Int
                    item.bio = DocID.data()["bio"] as! String
                    item.instagramHandle = DocID.data()["instagramHandle"] as! String
                    item.tiktokHandle = DocID.data()["tiktokHandle"] as! String
                    item.image = nil


//                    if DocID.data()["hasProfileImage"] as! Bool{
//                        storage.reference().child(DocID.documentID + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
//                            if error == nil {
//                                try! self.realmObjc.write(){
//                                    item.image = (data! as NSData)
//                                }
//                            }else{
//                                try! self.realmObjc.write(){
//                                    item.image = nil
//                                }
//                            }
//                        }
//                    }else{
//                        try! self.realmObjc.write(){
//                            item.image = nil
//                        }
//                    }

                        try! self.realmObjc.write(){
                            self.realmObjc.add(item)
                    }
                    
                    
                    
//                            ANSWERES
//                            dbItem.document(DocID.documentID).collection("answered").getDocuments { (snapshot, error) in
//                                snapshot?.documents.forEach({ (snap) in
//                                    let answerItem = answeredQuestions()
//                                    answerItem.username = snap.data()["username"] as! String
//                                    answerItem.answer = snap.data()["answer"] as! String
//                                    answerItem.question = snap.data()["question"] as! String
//                                    answerItem.points = snap.data()["points"] as! Int
//                                    answerItem.date = snap.data()["date"] as! String
//
//                                if snap.data()["hasImage"] as! Bool{
//                                    storage.reference().child(snap.data()["id"] as! String + "img.png").getData(maxSize: 1*1024*1024) { (data, error) in
//                                            if error == nil {
//                                                try! self.realmObjc.write(){
//                                                    answerItem.userImage = (data! as NSData)
//                                                }
//                                            }else{
//                                                try! self.realmObjc.write(){
//                                                    answerItem.userImage = nil
//                                                }
//                                            }
//                                        }
//                                    }else{
//                                        try! self.realmObjc.write(){
//                                            answerItem.userImage = nil
//                                        }
//                                    }
//
//                                    try! self.realmObjc.write{
//                                        self.realmObjc.add(answerItem)
//                                    }
//                                })
//                            }
                                                
                    
                    
                    
                    

                        let vc = MainViewController()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            self.removeSpinner()
                            self.navigationController?.pushViewController(vc, animated: true)
                    }

                }
            }
        }
    }
    
    
    
    
    
    
    
    fileprivate let startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        button.setAttributedTitle(NSAttributedString(string: "Get started",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
        button.addTarget(self, action: #selector(continueSelected), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let iconImg: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        img.image = UIImage(named: "ParticleIcon")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let phraseLbl: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 2
        label.text = "Welcome to Witty\nJoin Discussions"
//        label.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        label.textColor = UIColor.black
        label.textAlignment = .center

        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let aboutBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setAttributedTitle(NSAttributedString(string: "By signing up, you agree with\n the Terms & Conditions and Privacy Policy", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)]), for: .normal)
        button.addTarget(self, action: #selector(AboutViewSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var introCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(FirstViewCells.self, forCellWithReuseIdentifier: "FirstViewCells")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    
    fileprivate func constraintContainer(){
        view.addSubview(iconImg)
        view.addSubview(phraseLbl)
        view.addSubview(introCollectionView)
        view.addSubview(startButton)
        view.addSubview(aboutBtn)

        NSLayoutConstraint.activate([

            iconImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height*0.09),
            iconImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            iconImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),

            phraseLbl.topAnchor.constraint(equalTo: iconImg.bottomAnchor, constant: 8),
            phraseLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            introCollectionView.topAnchor.constraint(equalTo: phraseLbl.bottomAnchor, constant: 12),
            introCollectionView.bottomAnchor.constraint(equalTo: startButton.topAnchor,constant: -12),
            introCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            introCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: aboutBtn.topAnchor, constant: -8),
            startButton.heightAnchor.constraint(equalToConstant: 54),
            
            
            aboutBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            aboutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            aboutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
    }
    let blackWindow = UIView()

    @objc func continueSelected(){
        let alert = UIAlertController(title: "By using Witty you agree with the terms of service (EULA) and privacy policy. Witty has no tolerance for objectionable content or abusive users. You'll be banned for any inappropriate usage.", message:.none , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Leave", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in

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

            let vc = TermsAndConditionsView()
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            vc.selectedOptions = self
            self.navigationController?.present(vc, animated: true)
        }))
        present(alert, animated: true)
    }
    
    @objc func AboutViewSelected(){
        let alert = UIAlertController(title: .none, message:.none , preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Terms & Conditions", style: .default, handler: { (UIAlertAction) in
            let vc = AboutView()
            vc.urlItem = "https://witty.flycricket.io/terms.html"
            self.present(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Privacy Policy", style: .default, handler: { (UIAlertAction) in
            let vc = AboutView()
            vc.urlItem = "https://witty.flycricket.io/privacy.html"
            self.present(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}


extension WelcomeView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let topics = ["Stay Private", "Be Creative", "Be Respectful"]
        let infoText = ["Other users will only see the username and profile image you provide, you can keep your data, it's not needed.", "With text, gifs, and voice coming soon, the user can express themselves clearly.", "Witty is a platform, therefore abusive content is not tolerated, respect other users."]
        let images = ["privacyImg", "creativeImg", "respectImg"]
//        let topicImg = ["TechnologyIntro", "SportsIntro", "EntertainmentIntro", "PoliticsIntro", "BuisnessIntro", "MoreIntro"]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstViewCells", for: indexPath) as! FirstViewCells
        cell.tag = indexPath.row
        if cell.tag == indexPath.row{
            timer.invalidate()
            fireTimer(indexPath.row)
            cell.topicTitle.text = infoText[indexPath.row]
            cell.introTitle.text = topics[indexPath.row]
            cell.imgIcons.image = UIImage(named: images[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}




protocol SelectedLoginOption{
    func loginOptions(OptionNum: Int)
}










class SignupOptions: UIViewController {
    var delegate: blackViewProtocol?
    var selectedOptions: SelectedLoginOption?
    var accountType: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))

        constraintContainer()
    }
    var viewTranslation = CGPoint(x: 0, y: 0)
    @objc func PanGestureFunc(sender: UIPanGestureRecognizer){
        if sender.translation(in: view).y >= 0{
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            } completion: { (_) in

            }
        case .ended:
            if viewTranslation.y < 200{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                    self.view.transform = .identity
                } completion: { (_) in
                }

            }else {
                delegate?.changeBlackView()
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
        }
    }

    
    fileprivate let whiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewBar: CustomView = {
        let view = CustomView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3.5
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewTitle: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Welcome", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    fileprivate let viewDescription: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "Before we start, continue \nwith one of these options.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    
    fileprivate let appleButton: UIButton = {
        let button  = UIButton()
        
        
        
        
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.backgroundColor = .black

        button.setAttributedTitle(NSAttributedString(string: "Continue with Apple", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)
        button.addTarget(self, action: #selector(AppleLoginSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let appleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appleIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()

    
    fileprivate let emailButton: UIButton = {
        let button  = UIButton()
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setAttributedTitle(NSAttributedString(string: "Continue with Google", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)

        button.addTarget(self, action: #selector(GoogleLoginSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "googleLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()

    private func constraintContainer(){
        
        view.addSubview(whiteView)
            whiteView.addSubview(viewBar)
            whiteView.addSubview(viewTitle)
            whiteView.addSubview(viewDescription)
        
        whiteView.addSubview(appleButton)
            appleButton.addSubview(appleImageView)
        whiteView.addSubview(emailButton)
            emailButton.addSubview(emailImageView)

        NSLayoutConstraint.activate([
            viewBar.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 8),
            viewBar.widthAnchor.constraint(equalToConstant: 30),
            viewBar.heightAnchor.constraint(equalToConstant: 7),
            viewBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 284),
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewTitle.topAnchor.constraint(equalTo: viewBar.topAnchor, constant: 8),
            viewTitle.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            viewTitle.heightAnchor.constraint(equalToConstant: viewTitle.intrinsicContentSize.height),
            
            viewDescription.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 8),
            viewDescription.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            viewDescription.widthAnchor.constraint(equalTo: whiteView.widthAnchor),
            
            appleButton.topAnchor.constraint(equalTo: viewDescription.bottomAnchor, constant: 16),
            appleButton.leadingAnchor.constraint(equalTo:whiteView.leadingAnchor, constant: 16),
            appleButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            appleButton.heightAnchor.constraint(equalToConstant: 54),

        
            emailButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 16),
            emailButton.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            emailButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            emailButton.heightAnchor.constraint(equalToConstant:54),

            emailImageView.centerYAnchor.constraint(equalTo: emailButton.centerYAnchor),
            emailImageView.heightAnchor.constraint(equalToConstant: 22),
            emailImageView.widthAnchor.constraint(equalToConstant: 22),
            emailImageView.leadingAnchor.constraint(equalTo: emailButton.leadingAnchor, constant: 16),

            appleImageView.centerYAnchor.constraint(equalTo: appleButton.centerYAnchor),
            appleImageView.heightAnchor.constraint(equalToConstant: 22),
            appleImageView.widthAnchor.constraint(equalToConstant: 23),
            appleImageView.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 16),
        ])
        
    }

    @objc func AppleLoginSelected(){
        self.delegate?.changeBlackView()
        dismiss(animated: true){
            self.selectedOptions?.loginOptions(OptionNum: 0)
        }
    }
    @objc func GoogleLoginSelected(){
        self.delegate?.changeBlackView()
        dismiss(animated: true){
            self.selectedOptions?.loginOptions(OptionNum: 1)
        }
    }

    @objc func TermsOfUseSelected(){
        let vc = AboutView()
        present(vc, animated: true)
    }
        

}


































class usernameView: UIViewController, UITextFieldDelegate, blackViewProtocol{
   
    
    var fetchedName: String?
    var fetchedId: String?
    var fetchedEmail: String?
    
    var providedName = String()
    var listOfInterests: [String]?
    var selectedItem: Int?


    func SetUpComplete() {
        showSpinner(onView: view)
        let dateJoined = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let date = dateFormatter.string(from: dateJoined)


        guard let usernameText = textField.text?.lowercased() else{return}
        let realmObjc = try! Realm()

        db.collection("users").whereField("username", isEqualTo:usernameText).getDocuments { [self] (QuerySnapshot, error) in
            if let error = error{
                print(error)
            }else{
                if QuerySnapshot!.isEmpty{
                    print("Not Found!")
                    let doc = db.collection("users").document()

                    doc.setData(["userId" : fetchedId!,
                                 "name":fetchedName!,
                                 "e-mail": fetchedEmail!,
                                 "username":usernameText,
                                 "joined":date,
                                 "hasProfileImage":false,
                                 "iconNum":selectedItem!,
                                 "bio":"🤷 No Bio",
                                 "instagramHandle":"",
                                 "tiktokHandle":""
                    ])
        
                    let item = userObject()

//                    if hasImage{
//                        let storageRef = storage.reference().child(doc.documentID + "img.png")
//                        if let uploadData = self.profileImage.image!.jpegData(compressionQuality: 0.1){
//                            storageRef.putData(uploadData, metadata: nil) { (StorageMetadata, error) in
//                                if error != nil{
//                                    return
//                                }
//                            }
//                        }
//                        item.image = profileImage.image?.pngData() as NSData?
//                    }else{
//                        item.image = nil
//                    }

                    
                    
                    try! realmObjc.write(){
                        item.FID = String(describing: doc.documentID)
                        item.image = nil
                        item.joinedDate = date
                        item.iconItem = selectedItem!
                        item.name = fetchedName!
                        item.username = usernameText
                            realmObjc.add(item)
                        }
//                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {

                        self.navigationController?.pushViewController(MainViewController(), animated: true)
                        self.removeSpinner()
                    }
//
                }else{
                    let alert = UIAlertController(title: "The username you select is already occupied. Please select another username.", message:.none , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    
    
    func changeBlackView() {
        self.blackWindow.alpha = 0
        self.blackWindow.removeFromSuperview()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        title = ""
        view.backgroundColor = .white
        textField.delegate = self
        textFieldApearing()
        constraintContainer()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
                self.collectionView.selectItem(at: NSIndexPath(item: 23, section: 0) as IndexPath, animated:true, scrollPosition: .right)
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    let usernameText: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 1
        label.text = "Username:"
        label.textColor = .black

        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let textFieldView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .lightGray

       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    fileprivate lazy var textField: UITextField = {
       let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.keyboardAppearance = .light
        field.textColor = .black
        field.tintColor = .lightGray
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    
//    fileprivate lazy var profileImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named:"placeholderProfileImage")
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = (view.frame.height*0.12)/2
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//       return imageView
//    }()
    
//    fileprivate let changeProfileImage: UIButton = {
//       let btn = UIButton()
//        btn.setAttributedTitle(NSAttributedString(string: "Change Profile Image", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
//        btn.titleLabel?.tintColor = .systemBlue
//        btn.titleLabel?.textAlignment = .center
//        btn.addTarget(self, action: #selector(ChangeImageSelected), for: .touchUpInside)
//        btn.titleLabel!.font = .systemFont(ofSize: 10, weight: .semibold)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    
//    fileprivate let welcomeLabel: UILabel = {
//       let label = UILabel()
//        label.textAlignment = .center
//        label.numberOfLines = 2
//        label.attributedText = NSAttributedString(string: "We only need\na username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()

    
//    fileprivate let reasonForName: CustomLabel = {
//        let label = CustomLabel()
//        label.attributedText = NSAttributedString(string: "Witty only requires a username. So what would you like yours to be?", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()


    
    fileprivate let continueButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.isEnabled = false
        button.setAttributedTitle(NSAttributedString(string: "Done",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]), for: .normal)
        button.backgroundColor = UIColor(red: 52/255, green: 54/255, blue: 66/255, alpha: 1)
        button.addTarget(self, action: #selector(continueSelected), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(iconCell.self, forCellWithReuseIdentifier: "iconCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    lazy var fadeView: UIView = {
        let imageView = UIView()
  //       var blurEffect = UIBlurEffect()
        imageView.backgroundColor = .white
        

         let gradient = CAGradientLayer()
          gradient.frame = view.bounds
        gradient.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
          gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0.07, y: 0)
//        gradient.locations = [0,0.03]


         imageView.layer.mask = gradient
  //        imageView.layer.addSublayer(gradient)
          imageView.isUserInteractionEnabled = false
         imageView.clipsToBounds = true
//         imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
    }()
    
    lazy var fadeViewRight: UIView = {
        let imageView = UIView()
  //       var blurEffect = UIBlurEffect()
        imageView.backgroundColor = .white
        

         let gradient = CAGradientLayer()
          gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
      gradient.endPoint = CGPoint(x: 0.07, y: 0)
//        gradient.locations = [0,0.03]


         imageView.layer.mask = gradient
  //        imageView.layer.addSublayer(gradient)
          imageView.isUserInteractionEnabled = false
         imageView.clipsToBounds = true
//         imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
    }()
    fileprivate let ProfileIconLbl: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "Select a Profile Icon", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let reasonForName: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Choose a screen name to be displayed when you contribute to the chatroom.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let welcomeLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "What would you\nlike your username to be?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func constraintContainer(){
//        view.addSubview(profileImage)
//        view.addSubview(changeProfileImage)
        view.addSubview(welcomeLabel)
        
        
        view.addSubview(collectionView)
        view.addSubview(ProfileIconLbl)

        view.addSubview(fadeViewRight)
        view.addSubview(fadeView)
        
        view.addSubview(usernameText)
        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        
        view.addSubview(reasonForName)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([

            reasonForName.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 4),
            reasonForName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            reasonForName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameText.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 12),
            usernameText.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor),
            usernameText.widthAnchor.constraint(equalToConstant: usernameText.intrinsicContentSize.width),
            usernameText.heightAnchor.constraint(equalToConstant:36),
            
            textField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: usernameText.trailingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -4),
            textField.heightAnchor.constraint(equalToConstant:36),
            
            textFieldView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            textFieldView.heightAnchor.constraint(equalToConstant:0.8),
            
            
//            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            profileImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
//            profileImage.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),

//            changeProfileImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
//            changeProfileImage.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: ProfileIconLbl.bottomAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 62),
            
            ProfileIconLbl.topAnchor.constraint(equalTo: reasonForName.bottomAnchor, constant: 38),
            ProfileIconLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ProfileIconLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ProfileIconLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            
//            reasonForName.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
//            reasonForName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
//            reasonForName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            continueButton.widthAnchor.constraint(equalToConstant: 150),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 54),

            fadeViewRight.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fadeViewRight.widthAnchor.constraint(equalToConstant: 40),
            fadeViewRight.topAnchor.constraint(equalTo: collectionView.topAnchor),
            fadeViewRight.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            
            fadeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fadeView.widthAnchor.constraint(equalToConstant: 40),
            fadeView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            fadeView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)

        ])
    }
    
    
    @objc func ChangeImageSelected(){
        showSpinner(onView: view.self)
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
//        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion:{
            self.removeSpinner()
        })
    }
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        for letter in string{
            for i in "/:;()$&@\",?!'[]{}#%^*+=\\|~<>€£¥•,?!' "{
                if letter == i{
                    return false
                }
            }
        }
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if count >= 3 && selectedItem != nil{
                continueButton.backgroundColor = TealConstantColor
                continueButton.isEnabled = true
            }else{
                continueButton.backgroundColor = UIColor(red: 52/255, green: 54/255, blue: 66/255, alpha: 1)
                continueButton.isEnabled = false
        }
        return count <= 30
    }
    
    func textFieldApearing(){
            self.textField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 1) {
            self.continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardRect.height-12).isActive = true
        }

    }
    let blackWindow = UIView()
    let realmObjc = try! Realm()
    @objc func continueSelected(){
        if realmObjc.objects(userObject.self).isEmpty{
            SetUpComplete()
        }else{
            updateProfile()
        }
        continueButton.isEnabled = false
    }
    
    
    
    func updateProfile(){
//        if hasImage{
            
//            let storageRef = Storage.reference().child(realmObjc.objects(userObject.self)[0].FID + "img.png")
//            if let uploadData = self.profileImage.image!.jpegData(compressionQuality: 0.1){
//                storageRef.putData(uploadData, metadata: nil) { (StorageMetadata, error) in
//                    if error != nil{
//                        return
//                    }
//                }
//            }
//            try! realmObjc.write{
//                realmObjc.objects(userObject.self)[0].username = textField.text!
//                realmObjc.objects(userObject.self)[0].image = profileImage.image!.pngData()! as NSData
//            }
//        }else{
//            try! realmObjc.write{
//                realmObjc.objects(userObject.self)[0].username = textField.text!
//            }
//        }
        navigationController?.popViewController(animated: true)
    }

}
//extension usernameView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.editedImage] as? UIImage {
//            self.profileImage.image = image
//            hasImage = true
//            if textField.text!.count >= 3{
//                continueButton.backgroundColor = TealConstantColor
//                continueButton.isEnabled = true
//            }
//            dismiss(animated: true, completion: nil)
//        }
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
extension usernameView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! iconCell
        cell.tag = indexPath.row
        if cell.tag == indexPath.row{
            cell.image.image = UIImage(named: "\(indexPath.row+1)")
            if selectedItem == indexPath.row+1{
                cell.image.layer.borderColor = UIColor.systemBlue.cgColor
            }else{
                cell.image.layer.borderColor = UIColor.white.cgColor
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.row+1
        collectionView.reloadData()
        
        if textField.text!.count >= 3{
                continueButton.backgroundColor = TealConstantColor
                continueButton.isEnabled = true
    }
    }
    
}


class TermsAndConditionsView: UIViewController{
    var delegate: blackViewProtocol?
    var selectedOptions: SelectedLoginOption?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))
        constraintContainer()
    }
    var viewTranslation = CGPoint(x: 0, y: 0)
    @objc func PanGestureFunc(sender: UIPanGestureRecognizer){
        if sender.translation(in: view).y >= 0{
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            } completion: { (_) in

            }
        case .ended:
            if viewTranslation.y < 200{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                    self.view.transform = .identity
                } completion: { (_) in
                }

            }else {
                delegate?.changeBlackView()
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
        }
    }
    
    fileprivate let whiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewBar: CustomView = {
        let view = CustomView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Terms of Use & Privacy Policy"
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let termsBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.borderWidth = 2
        btn.layer.borderColor =  UIColor.black.cgColor
        btn.addTarget(self, action: #selector(selectedTerms), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let privacyBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.borderWidth = 2
        btn.layer.borderColor =  UIColor.black.cgColor
        btn.addTarget(self, action: #selector(selectedPrivacy), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let acceptBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setAttributedTitle(NSAttributedString(string: "Agree To Terms",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold),NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
        btn.alpha = 0.5
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(continueSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    
    let privacy: UIButton = {
        let btn = UIButton()
        let att = NSMutableAttributedString(string: "Yes, I have read the ",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.gray])
        att.append(NSAttributedString(string: "Privacy Policy",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
        btn.setAttributedTitle(att, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(privacyView), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let terms: UIButton = {
        let btn = UIButton()
        let att = NSMutableAttributedString(string: "Yes, I have read the ",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.gray])
        att.append(NSAttributedString(string: "Terms & Conditions",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
        btn.setAttributedTitle(att, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(termsView), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let byLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "By selecting \"Agree to Terms\", you agree to\nWitty's Terms & Conditions and Privacy Policy"
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .lightGray
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    func constraintContainer(){
        view.addSubview(whiteView)
        whiteView.addSubview(viewBar)
        whiteView.addSubview(titleLbl)
        whiteView.addSubview(privacyBtn)
        whiteView.addSubview(termsBtn)
        whiteView.addSubview(terms)
        whiteView.addSubview(privacy)
        whiteView.addSubview(acceptBtn)
        whiteView.addSubview(byLbl)
        NSLayoutConstraint.activate([
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 272),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            viewBar.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 8),
            viewBar.widthAnchor.constraint(equalToConstant: 30),
            viewBar.heightAnchor.constraint(equalToConstant: 7),
            viewBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLbl.topAnchor.constraint(equalTo: viewBar.bottomAnchor, constant: 8),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            termsBtn.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 24),
            termsBtn.heightAnchor.constraint(equalToConstant: 20),
            termsBtn.widthAnchor.constraint(equalToConstant: 20),
            termsBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            terms.leadingAnchor.constraint(equalTo: termsBtn.trailingAnchor, constant: 8),
            terms.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            terms.centerYAnchor.constraint(equalTo: termsBtn.centerYAnchor),
            
            privacyBtn.topAnchor.constraint(equalTo: termsBtn.bottomAnchor, constant: 12),
            privacyBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            privacyBtn.heightAnchor.constraint(equalToConstant: 20),
            privacyBtn.widthAnchor.constraint(equalToConstant: 20),
            
            privacy.leadingAnchor.constraint(equalTo: privacyBtn.trailingAnchor, constant: 8),
            privacy.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            privacy.centerYAnchor.constraint(equalTo: privacyBtn.centerYAnchor),

            acceptBtn.bottomAnchor.constraint(equalTo: byLbl.topAnchor, constant: -8),
            acceptBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            acceptBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            acceptBtn.heightAnchor.constraint(equalToConstant: 42),
            
            byLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            byLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            byLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
//            byLbl.heightAnchor.constraint(equalToConstant: byLbl.intrinsicContentSize.height*2),
        ])
    }
    
    @objc func continueSelected(){
        dismiss(animated: true) {
            self.selectedOptions?.loginOptions(OptionNum: 3)

        }
    }
    
    @objc func selectedPrivacy(){
        if privacyBtn.backgroundColor == .white{
            privacyBtn.backgroundColor = .black
            if termsBtn.backgroundColor == .black{
                acceptBtn.alpha = 1
                acceptBtn.isEnabled = true
            }
        }else{
            acceptBtn.alpha = 0.5
            acceptBtn.isEnabled = false
            privacyBtn.backgroundColor = .white
        }
    }
    @objc func selectedTerms(){
        if termsBtn.backgroundColor == .white{
            termsBtn.backgroundColor = .black
            if privacyBtn.backgroundColor == .black{
                acceptBtn.alpha = 1
                acceptBtn.isEnabled = true
            }
        }else{
            acceptBtn.alpha = 0.5
            acceptBtn.isEnabled = false
            termsBtn.backgroundColor = .white
        }
    }
    @objc func privacyView(){
        let vc = AboutView()
        vc.urlItem = "https://witty.flycricket.io/privacy.html"
        self.present(vc, animated: true)
    }
    @objc func termsView(){
        let vc = AboutView()
        vc.urlItem = "https://witty.flycricket.io/terms.html"
        self.present(vc, animated: true)
    }
}

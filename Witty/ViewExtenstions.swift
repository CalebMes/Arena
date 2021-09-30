//
//  ViewExtenstions.swift
//  Witty
//
//  Created by Caleb Mesfien on 4/15/21.
//

import UIKit
import RealmSwift


class BlockedUsersView: UIViewController,UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let realmObjc = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Blocked Users"
        view.backgroundColor = .white
        constraintContainer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage(named: "")
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    let textFieldView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var textField: UITextField = {
       let field = UITextField()
        field.delegate = self
        field.keyboardAppearance = .light
        field.returnKeyType = .search
        field.tintColor = .white
        field.attributedPlaceholder = NSAttributedString(string: "Search Blocked Users", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let searchIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "searchIconWhite")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 0)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BlockedUserCell.self, forCellWithReuseIdentifier: "BlockedUserCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func constraintContainer(){
        view.addSubview(textFieldView)
        textFieldView.addSubview(searchIcon)
        textFieldView.addSubview(textField)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            textFieldView.heightAnchor.constraint(equalToConstant: 44),

//            returnBtn.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor),
//            returnBtn.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            
            searchIcon.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 12),
            searchIcon.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -12),
            searchIcon.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 12),
            searchIcon.widthAnchor.constraint(equalTo: searchIcon.heightAnchor),

            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant:4),
            textField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -4),
            
            collectionView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if searchList.count == 1{
//            searchList.removeAll()
//
//            events.forEach { (item) in
//                self.searchList.append(searchItem(eventName: item.name, id: item.id))
//            }
//                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//                    self.searchCollectionView.reloadData()
//                    self.view.layoutSubviews()
//                }
//
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realmObjc.objects(BlockedUsers.self).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlockedUserCell", for: indexPath) as! BlockedUserCell
        cell.usernameLbl.text = realmObjc.objects(BlockedUsers.self)[indexPath.row].username
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 40)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Do you want to unblock \(String(describing: realmObjc.objects(BlockedUsers.self)[indexPath.row].username!))?", message:.none , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            try! self.realmObjc.write{
                self.realmObjc.delete(self.realmObjc.objects(BlockedUsers.self)[indexPath.row])
            }
            DispatchQueue.main.async{self.collectionView.reloadData()
                
                collectionView.layoutSubviews()
            }
        }))
        present(alert, animated: true)
    }
}





//      MARK:VIEW CONTROLLER DELEGATES

let emojiList = ["🤯", "😂", "😱","🥶","🤑", "🤫 ","🤬","🤕", "😈","🧐","💀","🤔","💩","😴"]
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollection{
            return emojiList.count
        }
        return chatText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
            cell.emoji.text = emojiList[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCellID2", for: indexPath) as! chatCell2
            cell.tag = indexPath.row
            
            if cell.tag == indexPath.row{
                cell.userComment.text = chatText[indexPath.row].text
                cell.userImage.image = UIImage(named: "\(chatText[indexPath.row].iconNum)")
                cell.userName.text = chatText[indexPath.row].username

                if  indexPath.row <= chatText.count-6{
                    updateOn = false
                }else{
                    updateOn = true
                }
                if chatText[indexPath.row].gifId.count != 0 {
                    cell.hasGif = chatText[indexPath.row].gifId
                }else{
                    cell.hasGif = ""
                }
                
    //            cell.isp
                cell.presentGif = self
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == emojiCollection{
            return CGSize(width:collectionView.frame.height, height: collectionView.frame.height)
        }else{
            let sizeOfItem = CGSize(width: (view.frame.width*0.95)-55, height: 1000)

                let item = NSString(string: chatText[indexPath.row].text).boundingRect(with:sizeOfItem , options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)], context: nil)
                
                let size = CGSize(width:collectionView.frame.width-12, height: item.height + 32)
                if chatText[indexPath.row].gifId != ""{

                    return CGSize(width:collectionView.frame.width-12, height: 24 + (UIScreen.main.bounds.height*0.18))
                }
                return size
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = profileInfo()
//        print(chatText[indexPath.row].id, realmObjc.objects(userObject.self)[0].FID)
//        if chatText[indexPath.row].id != realmObjc.objects(userObject.self)[0].FID{
//            let alert = UIAlertController(title: "Do you want to block "+ chatText[indexPath.row].name+"?", message:"Blocking this user will block any message sent into any chatroom. We will also review the users account." , preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: nil))
//                alert.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { (UIAlertAction) in
//                let blocked = BlockedUsers()
//                blocked.userId = self.chatText[indexPath.row].id
//                blocked.username = self.chatText[indexPath.row].name
//                try! self.realmObjc.write{
//                    self.realmObjc.add(blocked)
//                }
//            }))
//            self.present(alert, animated: true)
//        }
        if collectionView == emojiCollection{
            if textView.text.count <= 124{
                print(textView.text.count)
                textView.becomeFirstResponder()
                textView.text += emojiList[indexPath.row]
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

        }else{
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
            let vc = userInfoController()
            if chatText[indexPath.row].isPrivate{
                vc.profileImage.image = UIImage(named: "\(chatText[indexPath.row].iconNum)")
                
                vc.userInfo = chatText[indexPath.row]
                vc.name.text = chatText[indexPath.row].username
                vc.isPrivate = false
            }else{
                vc.profileImage.image = UIImage(named: "\(chatText[indexPath.row].iconNum)")
                vc.userInfo = chatText[indexPath.row]
                vc.name.text = chatText[indexPath.row].name
                vc.username.text = chatText[indexPath.row].username
                let sizeOfItem = CGSize(width: (view.frame.width*0.7)-12, height: 1000)
                let item = NSString(string: chatText[indexPath.row].bio).boundingRect(with:sizeOfItem , options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)], context: nil)
                vc.bio.text = chatText[indexPath.row].bio
                vc.joinedResponse.text = chatText[indexPath.row].joined
                vc.bioText = item.height
            }
            print(chatText[indexPath.row])
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        }
    }
    
}


extension TopicCells: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! articleCell
        cell.topicTitle.text = articles[indexPath.row].title
        let url = URL(string: articles[indexPath.row].image)
        cell.sourceName.text = articles[indexPath.row].source_name
        guard let data = try? Data(contentsOf: url!) else {cell.topicImg.image = UIImage(); return cell}
        cell.topicImg.image = UIImage(data: data)
//        cell.backgroundColor = .white
//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        cell.layer.shadowRadius = 8.0
//        cell.layer.shadowOpacity = 0.45
//        cell.layer.cornerRadius = 12
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDelegate?.selectedAccount(item: 0,id: nil, name: nil, url: articles[indexPath.row].url,eventItem: nil)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
//    }
}

//
//  MainView.swift
//  Witty
//
//  Created by Caleb Mesfien on 4/4/21.
//

import UIKit
import StoreKit
import RealmSwift
import SWXMLHash
import OpenGraph
import ShimmerSwift
import FirebaseFirestore
import FirebaseStorage
import SafariServices
import UPCarouselFlowLayout

protocol itemSelected {
    func selectedAccount(item: Int, id: String?, name: String?, url: String?,eventItem: eventItem?)
}


struct eventItem {
    var day: String
    var month: String
    var time: String
    var imageURL: String
    var name: String
    var first: String?
    var second: String?
    var type: String
    var id: String
    var isSport: Bool
    var firstTeamVotes: Int
    var secondTeamVotes: Int
}

struct searchItem {
    var eventName: String
    var id: String
}
struct ArticleItem{
    var url: String
    var title: String
    var desc: String
    var date: String
    var source_name: String
    var image: String
  }

class MainViewController: UIViewController, itemSelected, blackViewProtocol, UITextFieldDelegate{
    func changeBlackView() {
        UIView.animate(withDuration: 0.5) {
            self.blackWindow.alpha = 0
        }
    }
    func selectedAccount(item: Int, id: String?, name: String?, url: String?,eventItem: eventItem?) {
        if item == 0{
            let safariVC = SFSafariViewController(url: URL(string: url!)!, entersReaderIfAvailable: true)
            safariVC.preferredBarTintColor = .black
            safariVC.preferredControlTintColor = .white
            present(safariVC, animated: true, completion: nil)
        }else{
            let vc = ViewController()
            vc.event = eventItem!
            vc.title = name
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    var events = [eventItem](){
        didSet{
            let item = events.last!.first
//            removeShimmerViews()
//            view.addSubview(TopicCollection)
//            NSLayoutConstraint.activate([
//                TopicCollection.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 12),
//                TopicCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                TopicCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//                TopicCollection.bottomAnchor.constraint(equalTo: upcomingBtn.topAnchor, constant: -12),
//            ])
            fetchArticle((item?.replacingOccurrences(of: " ", with: "%20"))!, false,events.count-1, events.count-1)
        }
    }
    var Articles = [[ArticleItem]](){
        didSet{
            if Articles.count == events.count{
                removeShimmerViews()
                view.addSubview(TopicCollection)

                view.addSubview(fadeViewBottom)
                view.addSubview(upcomingBtn)

//                view.addSubview(lineView)
                NSLayoutConstraint.activate([

                    
                    TopicCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    TopicCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    TopicCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    TopicCollection.bottomAnchor.constraint(equalTo: fadeViewBottom.bottomAnchor),
                    
                    upcomingBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                    upcomingBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    upcomingBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    upcomingBtn.heightAnchor.constraint(equalToConstant: 42),
                    
                    fadeViewBottom.bottomAnchor.constraint(equalTo: upcomingBtn.centerYAnchor),
                    fadeViewBottom.leadingAnchor.constraint(equalTo: TopicCollection.leadingAnchor),
                    fadeViewBottom.trailingAnchor.constraint(equalTo: TopicCollection.trailingAnchor),
                    fadeViewBottom.heightAnchor.constraint(equalTo: TopicCollection.heightAnchor, multiplier: 0.1),


                ])
            }
            
        }
    }
    func fetchFeaturedData(){
        db.collection("message").getDocuments { (snap, error) in
            snap?.documents.forEach({ (snapshot) in
//                let isSport = snapshot.data()["isSport"] as! Bool
//                let day = snapshot.data()["day"] as! String
//                let month = snapshot.data()["month"] as! String
                let time = snapshot.data()["time"] as! String
//                let imageURL = snapshot.data()["imageURL"] as! String
                let name = snapshot.data()["name"] as! String
                let type = snapshot.data()["type"] as! String
                let firstTeamVotes = snapshot.data()["firstTeamVotes"] as! Int
                let secondTeamVotes = snapshot.data()["secondTeamVotes"] as! Int
                let first = snapshot.data()["first"] as! String
                let second = snapshot.data()["second"] as! String

//                if isSport{
//                    let user = eventItem(day: day, month:month, time: time, imageURL: imageURL,name:name, first: first, second: second, type: type, id: snapshot.documentID, isSport: isSport, firstTeamVotes: firstTeamVotes, secondTeamVotes: secondTeamVotes)
//                    self.events.append(user)
//                }else{
                    let user = eventItem(day: "day", month:"month", time: time, imageURL: "imageURL", name:name,first: first,second: second, type: type, id: snapshot.documentID, isSport: true, firstTeamVotes: firstTeamVotes, secondTeamVotes: secondTeamVotes)
                    self.events.append(user)
//                }
//
                self.searchList.append(searchItem(eventName: name, id: snapshot.documentID))
//                }
            })
        }
    
    }
    let realmObjc = try! Realm()
    let blackWindow = UIView()
    var searchList = [searchItem]()



    @objc func searchViewSelected(){
//        textField.resignFirstResponder()
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
        constraintContainer()
        fetchFeaturedData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonTitle = ""
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
//        if let userInfo = notification.userInfo{
            UIView.animate(withDuration: 0.8) {
//                    self.searchView.alpha = 1
//                    self.searchView.isUserInteractionEnabled = true
                
                self.returnBtn.transform = CGAffineTransform(translationX: 58, y: 0)
                self.profileImage.transform = CGAffineTransform(translationX: 58, y: 0)
                    self.view.layoutIfNeeded()
                }
//        }
    }
    @objc func menuSelected(){
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    let simmerView: shimmerViewClass = {
       let view = shimmerViewClass()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let simmerView2: shimmerViewClass = {
       let view = shimmerViewClass()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateShimmer:ShimmeringView = {
       let view = ShimmeringView()
        view.shimmerSpeed = 10
        view.shimmerPauseDuration = 1.5
        let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        blackView.clipsToBounds = true
        blackView.layer.cornerRadius = 5
        view.contentView = blackView
        view.isShimmering = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleShimmer:ShimmeringView = {
       let view = ShimmeringView()
        view.shimmerSpeed = 10
        view.shimmerPauseDuration = 1.5
        let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        blackView.clipsToBounds = true
        blackView.layer.cornerRadius = 5
        view.contentView = blackView
        view.isShimmering = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImageShimmer:ShimmeringView = {
       let view = ShimmeringView()
        view.shimmerSpeed = 10
        view.shimmerPauseDuration = 1.5
        let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        blackView.clipsToBounds = true
        blackView.layer.cornerRadius = 44/2.5
        view.contentView = blackView
        view.isShimmering = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func removeShimmerViews(){
        simmerView.removeFromSuperview()
        simmerView2.removeFromSuperview()
        profileImageShimmer.removeFromSuperview()
        titleShimmer.removeFromSuperview()
        dateShimmer.removeFromSuperview()
    }
    let lineView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let backView: UIView = {
       let view = UIView()
//        view.alpha = 0.8
        view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
//        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
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
        gradient.locations = [0,0.08]


         imageView.layer.mask = gradient
  //        imageView.layer.addSublayer(gradient)
          imageView.isUserInteractionEnabled = false
         imageView.clipsToBounds = true
//         imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
    }()

    fileprivate lazy var profileImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.layer.borderWidth = 2
        imageView.image = UIImage(named: "\(realmObjc.objects(userObject.self)[0].iconItem)")
        imageView.layer.borderColor = TealConstantColor.cgColor
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    
//    SEARCH VIEW
    lazy var searchView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    lazy var searchCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
        collectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchHeader")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    fileprivate let returnBtn: UIButton = {
       let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        btn.addTarget(self, action: #selector(returnBtnSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    fileprivate lazy var TopicCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 1.0
//        let layout = UPCarouselFlowLayout()
//        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 60, right: 0)

//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 400)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TopicCells.self, forCellWithReuseIdentifier: "TopicCells")
        collectionView.backgroundColor = .clear
//        collectionView.bounces = true
//        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let upcomingBtn: UIButton = {
       let view = UIButton()
        view.layer.masksToBounds = false
//        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        view.backgroundColor = TealConstantColor
        view.layer.cornerRadius = 11.5
        view.setAttributedTitle(NSAttributedString(string: "Upcoming Events", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
//        view.addTarget(self, action: #selector(editProfileSelected), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Open Chatrooms"
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 32)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    func constraintContainer(){
//        view.addSubview(returnBtn)
//        view.addSubview(textFieldView)
//        textFieldView.addSubview(searchIcon)
//        textFieldView.addSubview(textField)
//        view.addSubview(titleLbl)
        view.addSubview(simmerView)
        view.addSubview(simmerView2)
//        view.addSubview(shimmerNewsView)
//        view.addSubview(profileImage)
//        view.addSubview(lineView)
        view.addSubview(profileImageShimmer)
        view.addSubview(dateShimmer)
        view.addSubview(titleShimmer)
//        view.addConstraintsWithFormat(format: "H:|-18-[v0]-[v1(44)]-18-|", views: titleShimmer,profileImageShimmer)
//        view.addConstraintsWithFormat(format: "V:|-[v0][v1]", views: dateShimmer,titleShimmer)
//        view.addConstraintsWithFormat(format: "H:|-18-[v0]-[v1(44)]-18-|", views: dateShimmer,profileImageShimmer)
        NSLayoutConstraint.activate([
            titleShimmer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            titleShimmer.topAnchor.constraint(equalTo: dateShimmer.bottomAnchor, constant: 4),
            titleShimmer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            titleShimmer.heightAnchor.constraint(equalToConstant: 22),
            
            dateShimmer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            dateShimmer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dateShimmer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.16),
            dateShimmer.heightAnchor.constraint(equalToConstant: 18),
        
            profileImageShimmer.bottomAnchor.constraint(equalTo: titleShimmer.bottomAnchor),
            profileImageShimmer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            profileImageShimmer.heightAnchor.constraint(equalToConstant: 44),
            profileImageShimmer.widthAnchor.constraint(equalToConstant: 44),
            
            
//            titleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            

//            shimmerImage.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 18),
//            shimmerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
//            shimmerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
//            shimmerImage.heightAnchor.constraint(equalToConstant: 196),
            
            simmerView.topAnchor.constraint(equalTo: titleShimmer.bottomAnchor, constant: 22),
            simmerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            simmerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            simmerView.heightAnchor.constraint(equalToConstant: 396),
            
            simmerView2.topAnchor.constraint(equalTo: simmerView.bottomAnchor, constant: 8),
            simmerView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            simmerView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            simmerView2.heightAnchor.constraint(equalToConstant: 396),


//            textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            textFieldView.trailingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: -12),
//            textFieldView.heightAnchor.constraint(equalToConstant: 44),
//
//            returnBtn.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor),
//            returnBtn.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
//
//            searchIcon.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 12),
//            searchIcon.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -12),
//            searchIcon.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 12),
//            searchIcon.widthAnchor.constraint(equalTo: searchIcon.heightAnchor),
//
//            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant:4),
//            textField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
//            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
//            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -4),

//            profileImage.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor),
//            profileImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
//            profileImage.widthAnchor.constraint(equalToConstant: 44),
//            profileImage.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func fetchArticle(_ q: String, _ isSection: Bool, _ itemNum: Int, _ insertAt: Int){
//        var url: URL?
//        if isSection{
//            url = URL(string: "https://news.google.com/news/rss/headlines/section/topic/\(q.uppercased())")
//        }else{
        let url = URL(string: "https://news.google.com/rss/search?q=\(q)")
//        }
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in

            guard let data = data else{return}
            guard let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else{return}

                let xml = SWXMLHash.parse(str as String)
                var countSuccess = false
                var itemList = [ArticleItem](){
                    didSet{
                        if itemList.count == 2{
                            print("HERE IS 1", itemList.count)
                            countSuccess = true
                            self.Articles.append(itemList)
                            return
                        }
                    }
                }
                for i in 0...15{

                    guard let artURL = xml["rss"]["channel"]["item"][i]["link"].element?.text else{return}
//                    guard let artDate = xml["rss"]["channel"]["item"][i]["pubDate"].element?.text else{print("Nil date");return}
                    guard let artProvider = xml["rss"]["channel"]["item"][i]["source"].element?.text else{print("Nil provider");return}
                    guard let url = URL(string: artURL) else {return}
                    OpenGraph.fetch(url: url) { result in
                        switch result {

                        case .success(let og):
                            guard let artTitle = og[.title] else{return}
                            guard let imageURL = og[.image] else{return}
//                            guard let descText = og[.description] else{return}

                            if artTitle.lowercased().contains("covid") || artTitle.lowercased().contains("corona") || artTitle.lowercased().contains("冠状病毒病") || artTitle.lowercased().contains("コロナ"){print("Found a couple");return}

//                            if descText.lowercased().contains("covid") || descText.lowercased().contains("corona") || descText.lowercased().contains("冠状病毒病") || descText.lowercased().contains("コロナ"){print("Found a couple");return}

//                            let dateFormatterGet = DateFormatter()
//                            dateFormatterGet.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
//
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "yyyy, EEEE MMM d h:mm a"

//                            let date: NSDate? = dateFormatterGet.date(from: (artDate)) as NSDate?
//                            let newDate = dateFormatter.string(from: date! as Date)
//                            var desc: String?
//                            if descText.count >= 280{
//                                desc = descText.prefix(280) + "..."
//                            }else{
//                                desc = descText
//                            }
                            let item = ArticleItem(url: artURL, title: artTitle.htmlDecoded(), desc: "", date: "newDate", source_name: artProvider, image: imageURL)
//                            let item = ArticleItem(url: artURL, title: artTitle.htmlDecoded(), desc: String(desc!).htmlDecoded(), date: newDate, source_name: artProvider, image: imageURL)
                            
                            DispatchQueue.main.async {
                                itemList.append(item)
//                                if self.Articles.indices.contains(insertAt){
//                                    self.Articles[insertAt].append(item)
//                                }else{
//                                    self.Articles.append([item])
//                                }
                            }
//                            guard  self.Articles.indices.contains(insertAt) else{return}
//                                if self.Articles[insertAt].count == 2{break}
                            
                            
                            
                        case .failure(_):
                        print("Error:\n")
                    }

                        }
                }
            }
        task.resume()

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
    @objc func returnBtnSelected(){
//        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
                self.searchView.alpha = 0
                self.searchView.isUserInteractionEnabled = false
//                self.searchView.layoutSubviews()
                self.returnBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                self.profileImage.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
            }
        
    }
}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        StackCollection.widthHorizontalBar?.constant = 20
//
//        StackCollection.leftHorizontalBar?.constant = (view.frame.width*0.176) + scrollView.contentOffset.x/(view.safeAreaLayoutGuide.layoutFrame.width*0.00607)
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let item = targetContentOffset.pointee.x/view.frame.width
//        StackCollection.stackOptionCollectionView.selectItem(at: NSIndexPath(item: Int(item), section: 0) as IndexPath, animated: true, scrollPosition: .init())
//
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == searchCollectionView{
            return CGSize(width: collectionView.frame.width, height: 50)
        }else{
            return CGSize(width:  collectionView.frame.width, height: 54)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == searchCollectionView{
            let Header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchHeader", for: indexPath)
            let lbl: CustomLabel = {
               let lbl = CustomLabel()
                lbl.font = UIFont.boldSystemFont(ofSize: 16)
                lbl.textColor = .lightGray
                lbl.adjustsFontSizeToFitWidth = true
                lbl.text = "Suggestions"
                lbl.translatesAutoresizingMaskIntoConstraints = false
                return lbl
            }()

            Header.addSubview(lbl)
            Header.addConstraintsWithFormat(format: "H:|-14-[v0]|", views: lbl)
            Header.addConstraintsWithFormat(format: "V:[v0]-4-|", views: lbl)
            return Header
        }else if collectionView == collectionView{
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "MMM dd"
            
            let Header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            let lbl: CustomLabel = {
               let lbl = CustomLabel()
                lbl.font = UIFont.boldSystemFont(ofSize: 22)
                lbl.textColor = .black
                lbl.adjustsFontSizeToFitWidth = true
                lbl.text = "Open Chatrooms"
                lbl.translatesAutoresizingMaskIntoConstraints = false
                return lbl
            }()
            let lblDate: CustomLabel = {
               let lbl = CustomLabel()
                lbl.font = UIFont.boldSystemFont(ofSize: 18)
                lbl.textColor = .lightGray
                lbl.adjustsFontSizeToFitWidth = true
                lbl.text = dateFormatterGet.string(from: Date())
                lbl.translatesAutoresizingMaskIntoConstraints = false
                return lbl
            }()
            let profileImageH: CustomUserImage = {
                let imageView = CustomUserImage()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 18
                imageView.layer.borderWidth = 2
                imageView.image = UIImage(named: "\(realmObjc.objects(userObject.self)[0].iconItem)")
                imageView.layer.borderColor = TealConstantColor.cgColor
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuSelected)))

                imageView.translatesAutoresizingMaskIntoConstraints = false
               return imageView
            }()
//            Header.backgroundColor = .blue
            Header.addSubview(lbl)
            Header.addSubview(lblDate)
            Header.addSubview(profileImageH)
            Header.addConstraintsWithFormat(format: "H:|-18-[v0]-[v1(44)]-18-|", views: lbl,profileImageH)
            Header.addConstraintsWithFormat(format: "V:[v0][v1]|", views: lblDate,lbl)
            Header.addConstraintsWithFormat(format: "H:|-18-[v0]-[v1(44)]-18-|", views: lblDate,profileImageH)

//            Header.addConstraintsWithFormat(format: "V:|[v0(44)]|", views: profileImageH)
            profileImageH.bottomAnchor.constraint(equalTo: Header.bottomAnchor).isActive = true
            profileImageH.heightAnchor.constraint(equalToConstant: 44).isActive = true

            return Header
        }else{
            return UICollectionReusableView()
        }

    }
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchCollectionView{
            if searchList == nil{
                return 0
            }else{
                return searchList.count
            }
        }else{
            return events.count
//            return 9
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
            cell.backgroundColor = .white
            cell.title.text = searchList[indexPath.row].eventName
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCells", for: indexPath) as! TopicCells
//            let url = URL(string: events[indexPath.row].imageURL)
//            let data = try? Data(contentsOf: url!)
            cell.articles = Articles[indexPath.row]
//            cell.TopicImage.image = UIImage(data: data!)
//            cell.backgroundImgView.image = UIImage(data: data!)
//            cell.monthLbl.text = events[indexPath.row].month
//            cell.dayLbl.text = events[indexPath.row].day

            cell.TopicTitle.text = events[indexPath.row].name
//            cell.TopicTitle.text = "this is\na test\nfor you"

//            cell.firstText = events[indexPath.row].first!
//            cell.secondText = events[indexPath.row].second!
            cell.typeOfEvent.text = events[indexPath.row].type
            cell.timeOfEvent.text = events[indexPath.row].time
            
            cell.eventItem = events[indexPath.row]
            cell.selectDelegate = self


            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == searchCollectionView{
            return CGSize(width: collectionView.frame.width, height: 60)

        }else{
//            255
//            let size = CGSize(width: collectionView.frame.width, height: 440)
            let sizeOfItem = CGSize(width: (UIScreen.main.bounds.width-104), height: 1000)
            let titleItem = NSString(string:events[indexPath.row].name).boundingRect(with:sizeOfItem , options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)], context: nil)
            let size = CGSize(width: collectionView.frame.width, height: titleItem.height+358)

            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let vc = ViewController()
                vc.title = events[indexPath.row].name
                vc.event = events[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
           
    }
}



//
//  Cells.swift
//  Witty
//
//  Created by Caleb Mesfien on 4/23/21.
//

import UIKit
import GiphyUISDK
import RealmSwift
class FirstViewCells: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(imgIcons)
        addSubview(introTitle)
        addSubview(topicTitle)
        
        NSLayoutConstraint.activate([

            imgIcons.bottomAnchor.constraint(equalTo: introTitle.topAnchor, constant: -8),
            imgIcons.widthAnchor.constraint(equalToConstant: 40),
            imgIcons.heightAnchor.constraint(equalToConstant: 40),
            imgIcons.centerXAnchor.constraint(equalTo: centerXAnchor),

            introTitle.bottomAnchor.constraint(equalTo: topicTitle.topAnchor, constant: -8),
            introTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            topicTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            topicTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            topicTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            topicTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)

            
        ])
    }
    let introTitle: CustomLabel = {
        let label = CustomLabel()
//        label.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        label.textColor = .black
        label.text = "Some in"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let imgIcons: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let topicTitle: CustomLabel = {
        let label = CustomLabel()
        label.text = "-"
        label.textAlignment = .center
        label.numberOfLines = 0
//        label.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class iconCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addConstraintsWithFormat(format: "H:|-6-[v0]-6-|", views: image)
        addConstraintsWithFormat(format: "V:|-6-[v0]-6-|", views: image)
    }
    lazy var image: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.borderWidth = 2.5
        image.layer.borderColor = UIColor.white.cgColor
        
        image.backgroundColor = .white
        image.layer.cornerRadius = 50/2.5
        image.clipsToBounds = false
        image.layer.shadowColor = UIColor.lightGray.cgColor
        image.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        image.layer.shadowRadius = 4.0
        image.layer.shadowOpacity = 0.3
        return image
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EmojiCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(emoji)
        addConstraintsWithFormat(format: "H:|[v0]|", views: emoji)
        addConstraintsWithFormat(format: "V:|[v0]|", views: emoji)
    }
    lazy var emoji: UILabel = {
       let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = .boldSystemFont(ofSize: 24)
        return lbl
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class TopicCells: UICollectionViewCell {
 
    let realmObjc = try! Realm()
    var selectDelegate: itemSelected?
    var eventItem: eventItem?
    var urlItem: String?
    var dateItem: String?
    var articles = [ArticleItem](){
        didSet{
            constraintContainer()
        }
    }
    var isSport = false{
        didSet{
            
        }
    }
    var firstText: String?{
        didSet{
            if secondText?.isEmpty == false{
                firstTeam.text = firstText
                secondTeam.text = secondText!
                constraintContainer()
                setupAnimation()
            }
        }
    }
    var secondText : String?{
        didSet{
            if firstText?.isEmpty == false{
                secondTeam.text = secondText
                firstTeam.text = firstText!
                constraintContainer()

            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .white
//        curvedView
        
//        handleTap()

    }
    
    
     let mainViewCard: CustomView = {
        let view = CustomView()
        view.layer.cornerRadius = 20
//        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    lazy var backgroundViewItem: UIImageView = {
//      let imageView = UIImageView()
//       var blurEffect = UIBlurEffect()
//        imageView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
//
//       let gradient = CAGradientLayer()
//        gradient.frame = bounds
//       gradient.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
//        gradient.locations = [0,0.9]
//
//       imageView.layer.mask = gradient
//       imageView.clipsToBounds = true
//       imageView.translatesAutoresizingMaskIntoConstraints = false
//       return imageView
//   }()
//
     lazy var backgroundImgView: UIImageView = {
       let imageView = UIImageView()
//        var blurEffect = UIBlurEffect()
        imageView.backgroundColor = .black
        imageView.alpha = 0.65
//        blurEffect = UIBlurEffect(style: .systemChromeMaterial) // .extraLight or .dark
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.frame = imageView.frame
//        imageView.addSubview(blurEffectView)
////        imageView.contentMode = .bottom
//
//        let gradient = CAGradientLayer()
//        gradient.frame = bounds
//        gradient.colors = [UIColor.clear.cgColor,UIColor.white.cgColor.copy(alpha: 0.3)!,UIColor.white.cgColor.copy(alpha: 0.65)!, UIColor.white.cgColor]
//
//        gradient.locations = [0,0.05,0.1,0.2]
//
//        imageView.layer.mask = gradient
//
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
//        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
     lazy var TopicImage: UIImageView = {
        let view = UIImageView()
//        view.contentMode = .scaleAspectFill
//        view.backgroundColor = .white
//            view.layer.shadowColor = UIColor.darkGray.cgColor
//            view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//            view.layer.shadowRadius = 8.0
//            view.layer.shadowOpacity = 0.5
//        view.layer.cornerRadius = 25
//        view.image = backgroundImageType
        view.clipsToBounds = true
//        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     let DimTopicLayer: UIImageView = {
       let view = UIImageView()
        view.alpha = 0.55
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dayLbl: CustomLabel = {
       let label = CustomLabel()
       label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
       label.attributedText = NSAttributedString(string: "12", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)])
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
    let monthLbl: CustomLabel = {
       let label = CustomLabel()
       label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
       label.attributedText = NSAttributedString(string: "AAA", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()

     let TopicTitle: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 0
//        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.attributedText = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    let firstTeam: CustomLabel = {
       let label = CustomLabel()
       label.textAlignment = .center
       label.adjustsFontSizeToFitWidth = true
//       label.attributedText = NSAttributedString(string: "Spurs", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)])
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.clipsToBounds = true
        label.textAlignment = .center
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    let atLbl: CustomLabel = {
       let label = CustomLabel()
       label.numberOfLines = 0
       label.textAlignment = .center
       label.adjustsFontSizeToFitWidth = true
       label.attributedText = NSAttributedString(string: "VS.", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    let secondTeam: CustomLabel = {
       let label = CustomLabel()
       label.textAlignment = .center
       label.adjustsFontSizeToFitWidth = true
       label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
       label.textColor = .white
       label.clipsToBounds = true
       label.textAlignment = .center

       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    

     let typeOfEvent: CustomLabel = {
        let lbl = CustomLabel()
        lbl.textColor = .white
        lbl.backgroundColor = UIColor(red: 254/255, green: 181/255, blue: 181/255, alpha: 1)
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lbl.layer.cornerRadius = 8
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    

     let timeOfEvent: CustomLabel = {
        let lbl = CustomLabel()
        lbl.attributedText = NSAttributedString(string: "Sat, 12:00 PM ET", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .semibold)])
        lbl.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let spaceLbl: CustomLabel = {
       let lbl = CustomLabel()
       lbl.attributedText = NSAttributedString(string: "•", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)])
       lbl.textAlignment = .center
       lbl.translatesAutoresizingMaskIntoConstraints = false
       return lbl
   }()

    let chatroomLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Chatroom"
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textColor = TealConstantColor
        lbl.backgroundColor = .white
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
//    let articleLbl: UILabel = {
//       let lbl = UILabel()
//        lbl.attributedText = NSAttributedString(string: "News Articles", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//    let chatNavView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
//        view.layer.cornerRadius = 11.5
//        view.layer.shadowColor = UIColor.lightGray.cgColor
//        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        view.layer.shadowRadius = 8.0
//        view.layer.shadowOpacity = 0.4
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.bounces = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(articleCell.self, forCellWithReuseIdentifier: "articleCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
//
    let firstBackdrop: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 6
        view.alpha = 0.3

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let secondBackdrop: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let joinChatBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.setAttributedTitle(NSAttributedString(string: "💬 Join Chatroom", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]), for: .normal)
        btn.layer.cornerRadius = 20

        btn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        btn.addTarget(self, action: #selector(chatSelected), for: .touchUpInside)
        btn.isEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let curvedView: CurvedView = {
       let view = CurvedView()
        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func constraintContainer(){
        
        addSubview(mainViewCard)
        mainViewCard.addSubview(curvedView)
        mainViewCard.addSubview(collectionView)

        mainViewCard.addSubview(TopicTitle)

        mainViewCard.addSubview(typeOfEvent)
        mainViewCard.addSubview(timeOfEvent)
        addSubview(joinChatBtn)
        

        NSLayoutConstraint.activate([
            curvedView.topAnchor.constraint(equalTo: mainViewCard.topAnchor),
            curvedView.leadingAnchor.constraint(equalTo: mainViewCard.leadingAnchor),
            curvedView.leadingAnchor.constraint(equalTo: mainViewCard.trailingAnchor),
            curvedView.bottomAnchor.constraint(equalTo: mainViewCard.bottomAnchor),
//            IT STARTS HERE

            collectionView.topAnchor.constraint(equalTo: TopicTitle.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: mainViewCard.leadingAnchor, constant: 4),
            collectionView.trailingAnchor.constraint(equalTo: mainViewCard.trailingAnchor, constant: -4),
            collectionView.bottomAnchor.constraint(equalTo: timeOfEvent.topAnchor, constant: -8),

            mainViewCard.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            mainViewCard.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainViewCard.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            mainViewCard.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
//            TopicTitle.bottomAnchor.constraint(equalTo: timeOfEvent.topAnchor, constant: -12),
            TopicTitle.leadingAnchor.constraint(equalTo: mainViewCard.leadingAnchor, constant: 12),
            TopicTitle.trailingAnchor.constraint(equalTo: typeOfEvent.leadingAnchor, constant: -12),
            TopicTitle.topAnchor.constraint(equalTo: mainViewCard.topAnchor, constant: 16),
            
            typeOfEvent.trailingAnchor.constraint(equalTo: mainViewCard.trailingAnchor, constant: -12),
            typeOfEvent.topAnchor.constraint(equalTo: mainViewCard.topAnchor, constant: 16),
            typeOfEvent.widthAnchor.constraint(equalToConstant: 44),
            typeOfEvent.heightAnchor.constraint(equalToConstant: 38),
            
            timeOfEvent.bottomAnchor.constraint(equalTo: joinChatBtn.topAnchor, constant: -8),
            timeOfEvent.trailingAnchor.constraint(equalTo: mainViewCard.trailingAnchor, constant: -12),
            timeOfEvent.widthAnchor.constraint(equalToConstant: timeOfEvent.intrinsicContentSize.width+16),
            timeOfEvent.heightAnchor.constraint(equalToConstant: timeOfEvent.intrinsicContentSize.height+6),

            joinChatBtn.heightAnchor.constraint(equalToConstant: 52),
            joinChatBtn.leadingAnchor.constraint(equalTo: mainViewCard.leadingAnchor),
            joinChatBtn.trailingAnchor.constraint(equalTo: mainViewCard.trailingAnchor),
            joinChatBtn.bottomAnchor.constraint(equalTo: mainViewCard.bottomAnchor),
            

        ])

        
    }
    

    @objc func chatSelected(){
        selectDelegate?.selectedAccount(item: 1, id:eventItem?.id , name: eventItem?.name, url: nil, eventItem: eventItem!)
    }

    func setupAnimation(){
        let image = UIImageView()
        image.image = UIImage(named: "nets")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(image)
        image.bottomAnchor.constraint(equalTo: mainViewCard.bottomAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: mainViewCard.leadingAnchor, constant: 12).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        UIView.animate(withDuration: 1) {
            image.transform = CGAffineTransform(translationX: 0, y: 300)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            image.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class chatCell2: UICollectionViewCell {
    var presentGif: presentGifProtocol?
    override init(frame: CGRect) {
        super.init(frame:frame)
        GitImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gifSelected)))

        constraintContainer()
    }
    var hasGif = String(){
        didSet{
            if hasGif != ""{
                GiphyCore.shared.gifByID(hasGif) { (response, error) in
                    if let media = response?.data {
                        self.GitImageView.media = media
                        
                        DispatchQueue.main.async{
                            self.addSubview(self.GitImageView)
                            NSLayoutConstraint.activate([
                                self.GitImageView.topAnchor.constraint(equalTo: self.userComment.bottomAnchor, constant: 4),
                                self.GitImageView.leadingAnchor.constraint(equalTo: self.userImage.trailingAnchor, constant: 4),
                                self.GitImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.15),
                                self.GitImageView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height*0.15)*media.aspectRatio)
                            ])
                        }
                    }
                }
            }else{
                GitImageView.removeFromSuperview()
            }
        }
    }
    
    let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35/2.5
        imageView.image = UIImage(named: "1")
        imageView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userComment: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let  GitImageView: GPHMediaView = {
        let gif = GPHMediaView()
        gif.clipsToBounds = true
        gif.layer.cornerRadius = 15
        gif.backgroundColor = .clear
//        gif.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gifTapped)))
        gif.contentMode = .scaleAspectFill

        gif.translatesAutoresizingMaskIntoConstraints = false
        return gif
    }()
    func constraintContainer(){
        self.addSubview(userImage)
        self.addSubview(userName)
        self.addSubview(userComment)
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 35),
            userImage.heightAnchor.constraint(equalToConstant: 35),
            
            userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 4),
            userName.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            userName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            userComment.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 4),
            userComment.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 0),
            userComment.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
    @objc func gifSelected(){
        guard let id = GitImageView.media?.id else{return}
        presentGif?.presentGit(id: id)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: ARTICLECELL

class articleCell: UICollectionViewCell{
    let realmObjc = try! Realm()
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintContianer()
    }

    
    let topicImg: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(named: "BlankBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let topicTitle: CustomLabel = {
       let label = CustomLabel()
        label.textColor = .black
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let moreText: CustomLabel = {
       let label = CustomLabel()
        label.text = "More..."
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sourceName: CustomLabel = {
       let label = CustomLabel()
//        label.text = "More..."
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let lineView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func constraintContianer(){
        addSubview(topicImg)
        addSubview(topicTitle)
        addSubview(sourceName)
        addSubview(moreText)
        addSubview(lineView)
        NSLayoutConstraint.activate([

            
            topicImg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            topicImg.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            topicImg.widthAnchor.constraint(equalTo: topicImg.heightAnchor),
            topicImg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),

            topicTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            topicTitle.topAnchor.constraint(equalTo: sourceName.bottomAnchor, constant: 8),
//            topicTitle.bottomAnchor.constraint(equalTo: moreText.topAnchor, constant: -8),
            topicTitle.trailingAnchor.constraint(equalTo: topicImg.leadingAnchor, constant: -24),
            
            sourceName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            sourceName.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            moreText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            moreText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            moreText.heightAnchor.constraint(equalToConstant: moreText.intrinsicContentSize.height),
            
            lineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lineView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//      MARK:SEARCH CELL
class SearchCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        constraintContainer()
    }
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "SearchIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    let title: CustomLabel = {
        let textLabel = CustomLabel()
        textLabel.textColor = .black
//        textLabel.text = "Addison Rae"
        textLabel.font = .systemFont(ofSize: 14, weight: .bold)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    let arrowImage: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "BlackRightArrow")
        img.translatesAutoresizingMaskIntoConstraints = false
       return img
    }()
    func constraintContainer(){
        self.addSubview(profileImage)
        self.addSubview(title)
        self.addSubview(arrowImage)
        NSLayoutConstraint.activate([
            profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18),
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -12),
            
            arrowImage.widthAnchor.constraint(equalToConstant: 25),
            arrowImage.heightAnchor.constraint(equalToConstant: 25),
            arrowImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class BlockedUserCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(usernameLbl)
        addSubview(arrowImg)
        NSLayoutConstraint.activate([
            usernameLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            usernameLbl.trailingAnchor.constraint(equalTo: arrowImg.leadingAnchor, constant: -12),
            
            arrowImg.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            arrowImg.heightAnchor.constraint(equalToConstant: 18),
            arrowImg.widthAnchor.constraint(equalToConstant: 18),
        
        ])
    }
    let usernameLbl: UILabel = {
       let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .bold)
        lbl.textColor = UIColor.black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let arrowImg: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "BlackRightArrow")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

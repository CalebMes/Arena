//
//  ExtraViews.swift
//  Witty
//
//  Created by Caleb Mesfien on 4/4/21.
//

import UIKit
import RealmSwift
import StoreKit
import GiphyUISDK
import MessageUI
import ShimmerSwift
import Lottie







class blackViewComt:UIViewController{
    var ratio = CGFloat(){
        didSet{
            GitImageView.frame = CGRect(x: 12, y: (view.frame.height/2)-((view.frame.width/ratio)/2), width: view.frame.width-24, height: view.frame.width/ratio)
            view.addSubview(GitImageView)
        }
    }
    var hasGif = String(){
        didSet{
            if hasGif != ""{
                GiphyCore.shared.gifByID(hasGif) { (response, error) in
                    if let media = response?.data {
                        DispatchQueue.main.async {
                            self.GitImageView.media = media
                            self.GitImageView.frame = CGRect(x: 12, y: (self.view.frame.height/2)-((self.view.frame.width/media.aspectRatio)/2), width: self.view.frame.width-24, height: self.view.frame.width/media.aspectRatio)
                            self.view.addSubview(self.GitImageView)
                        }

                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

    }
    lazy var GitImageView: GPHMediaView = {
        let gif = GPHMediaView()
        gif.clipsToBounds = true
        gif.layer.cornerRadius = 10
        
        gif.contentMode = .scaleAspectFill
        return gif
    }()
}









// MARK: USER INFO CONTROLLER
class userInfoController: UIViewController{
    var delegate: blackViewProtocol?
    let realmObjc = try! Realm()
//    var userId = String()
    var userInfo: Message?
    var bioText = CGFloat(){
        didSet{
                constraintContainerPublic()
        }
    }
    var isPrivate = Bool(){
        didSet{
            if isPrivate == false{
                constraintContainer()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))
        reportView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reportUserSelected)))
        BlockView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BlockViewSelected)))
//        insta

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
                    
                    if viewTranslation.y >= sender.translation(in: view).y{
                        break
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

    let joinedLbl: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Joined", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
     lazy var joinedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(BlockViewSelected)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     lazy var joinedResponse: UILabel = {
        let lbl = UILabel()
         lbl.attributedText = NSAttributedString(string: "Apr 3, 2021", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.gray])
         lbl.translatesAutoresizingMaskIntoConstraints = false
         return lbl
    }()
    
    let tiktokLbl: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Tiktok", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
     lazy var tiktokView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(BlockViewSelected)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     lazy var tiktokArrow: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "BlackRightArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let instaLbl: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Instagram", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
     lazy var instaView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
//        view.layer.cornerRadius = 12
//        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instaSelected)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     lazy var instaArrow: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "BlackRightArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    let reportLbl: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Report User", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
     lazy var reportView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     lazy var reportArrow: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "BlackRightArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    

    let blockLbl: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Block User", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.systemRed])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
     lazy var BlockView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     lazy var blockArrow: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "BlackRightArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()



    let whiteView: CustomView = {
        let view = CustomView()
//        view.backgroundColor = UIColor(red: 250/255, green: 251/255, blue: 253/255, alpha: 1)
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
//        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewBar: CustomView = {
        let view = CustomView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 233/255, blue: 235/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = view.frame.height*0.06/2.5
        imageView.layer.borderColor = TealConstantColor.cgColor
        imageView.image = UIImage(named:"8")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView

    }()

    
    lazy var name: CustomLabel = {
       let lbl = CustomLabel()
        lbl.textColor = .black
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    lazy var username: CustomLabel = {
       let lbl = CustomLabel()
        lbl.textColor = .lightGray
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    lazy var bio: CustomLabel = {
       let lbl = CustomLabel()
        lbl.textColor = .black
        lbl.text = "🤷 No Bio"
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
//    HERE
    
    
    
    
    let doneLbl: UIButton = {
       let lbl = UIButton()
        lbl.backgroundColor = .white
        lbl.layer.cornerRadius = 12
        lbl.clipsToBounds = true
        lbl.setAttributedTitle(NSAttributedString(string: "Done", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        lbl.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    func constraintContainer(){
        username.text = "Private"
        view.addSubview(whiteView)
        view.addSubview(viewBar)
        whiteView.addSubview(profileImage)
        whiteView.addSubview(name)
        whiteView.addSubview(username)

        view.addSubview(reportView)
        reportView.addSubview(reportLbl)
        reportView.addSubview(reportArrow)

        view.addSubview(BlockView)
        BlockView.addSubview(blockLbl)
        BlockView.addSubview(blockArrow)
        view.addSubview(doneLbl)

        NSLayoutConstraint.activate([


            viewBar.bottomAnchor.constraint(equalTo: whiteView.topAnchor, constant: -8),
            viewBar.widthAnchor.constraint(equalToConstant: 28),
            viewBar.heightAnchor.constraint(equalToConstant: 7),
            viewBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            profileImage.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 8),
            profileImage.centerYAnchor.constraint(equalTo: whiteView.centerYAnchor),
            profileImage.heightAnchor.constraint(equalTo: whiteView.heightAnchor, constant: -16),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),


            name.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            name.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -12),
            name.bottomAnchor.constraint(equalTo: profileImage.centerYAnchor),

            username.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            username.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -12),
            username.topAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: 2),

            whiteView.bottomAnchor.constraint(equalTo: reportView.topAnchor, constant: -12),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            whiteView.heightAnchor.constraint(equalToConstant: 72),


            reportView.bottomAnchor.constraint(equalTo: BlockView.topAnchor, constant: 0.3),
            reportView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            reportView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            reportView.heightAnchor.constraint(equalToConstant: 38),

            reportLbl.leadingAnchor.constraint(equalTo: reportView.leadingAnchor, constant: 16),
            reportLbl.centerYAnchor.constraint(equalTo: reportView.centerYAnchor),

            reportArrow.widthAnchor.constraint(equalToConstant: 18),
            reportArrow.heightAnchor.constraint(equalToConstant: 18),
            reportArrow.centerYAnchor.constraint(equalTo: reportView.centerYAnchor),
            reportArrow.trailingAnchor.constraint(equalTo: reportView.trailingAnchor, constant: -16),





            BlockView.bottomAnchor.constraint(equalTo: doneLbl.topAnchor, constant: -12),
            BlockView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            BlockView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            BlockView.heightAnchor.constraint(equalToConstant: 38),

            blockLbl.leadingAnchor.constraint(equalTo: BlockView.leadingAnchor, constant: 16),
            blockLbl.centerYAnchor.constraint(equalTo: BlockView.centerYAnchor),

            blockArrow.widthAnchor.constraint(equalToConstant: 18),
            blockArrow.heightAnchor.constraint(equalToConstant: 18),
            blockArrow.centerYAnchor.constraint(equalTo: BlockView.centerYAnchor),
            blockArrow.trailingAnchor.constraint(equalTo: BlockView.trailingAnchor, constant: -16),



            doneLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            doneLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            doneLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            doneLbl.heightAnchor.constraint(equalToConstant: 48),



        ])
    }

    func constraintContainerPublic(){


        
        view.addSubview(whiteView)
        view.addSubview(viewBar)
        whiteView.addSubview(profileImage)
        whiteView.addSubview(username)
        whiteView.addSubview(name)
        whiteView.addSubview(bio)
        
        view.addSubview(joinedView)
        joinedView.addSubview(joinedLbl)
        joinedView.addSubview(joinedResponse)
        
        view.addSubview(instaView)
        instaView.addSubview(instaLbl)
        instaView.addSubview(instaArrow)
        
        view.addSubview(tiktokView)
        tiktokView.addSubview(tiktokLbl)
        tiktokView.addSubview(tiktokArrow)
        
        view.addSubview(reportView)
        reportView.addSubview(reportLbl)
        reportView.addSubview(reportArrow)
        
        view.addSubview(BlockView)
        BlockView.addSubview(blockLbl)
        BlockView.addSubview(blockArrow)
        view.addSubview(doneLbl)
        
        
        username.text = "@coder.cm"

        NSLayoutConstraint.activate([
            viewBar.bottomAnchor.constraint(equalTo: whiteView.topAnchor, constant: -8),
            viewBar.widthAnchor.constraint(equalToConstant: 28),
            viewBar.heightAnchor.constraint(equalToConstant: 7),
            viewBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            profileImage.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 8),
            profileImage.topAnchor.constraint(equalTo: whiteView.topAnchor,constant: 12),
            profileImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),

            name.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            name.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -12),
            name.bottomAnchor.constraint(equalTo: profileImage.centerYAnchor),
            
            username.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            username.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -8),
            username.topAnchor.constraint(equalTo: profileImage.centerYAnchor),

            bio.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor,constant: 12),
            bio.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            bio.topAnchor.constraint(equalTo: profileImage.bottomAnchor,constant: 8),
//            bio.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -8),
            
            whiteView.bottomAnchor.constraint(equalTo: joinedView.topAnchor, constant: -12),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
//            whiteView.heightAnchor.constraint(equalToConstant: 120),
            whiteView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06, constant: bioText+28),
//
            joinedView.bottomAnchor.constraint(equalTo: instaView.topAnchor),
            joinedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            joinedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            joinedView.heightAnchor.constraint(equalToConstant: 42),
            
            joinedLbl.leadingAnchor.constraint(equalTo: joinedView.leadingAnchor, constant: 16),
            joinedLbl.centerYAnchor.constraint(equalTo: joinedView.centerYAnchor),
            
            joinedResponse.centerYAnchor.constraint(equalTo: joinedView.centerYAnchor),
            joinedResponse.trailingAnchor.constraint(equalTo: joinedView.trailingAnchor, constant: -16),
            
//            joinedView.widthAnchor.constraint(equalToConstant: 18),
//            instaArrow.heightAnchor.constraint(equalToConstant: 18),
//            instaArrow.centerYAnchor.constraint(equalTo: instaView.centerYAnchor),
//            instaArrow.trailingAnchor.constraint(equalTo: instaView.trailingAnchor, constant: -16),
//
            
            instaView.bottomAnchor.constraint(equalTo: tiktokView.topAnchor),
            instaView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            instaView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            instaView.heightAnchor.constraint(equalToConstant: 42),
            
            instaLbl.leadingAnchor.constraint(equalTo: instaView.leadingAnchor, constant: 16),
            instaLbl.centerYAnchor.constraint(equalTo: instaView.centerYAnchor),
            
            instaArrow.widthAnchor.constraint(equalToConstant: 18),
            instaArrow.heightAnchor.constraint(equalToConstant: 18),
            instaArrow.centerYAnchor.constraint(equalTo: instaView.centerYAnchor),
            instaArrow.trailingAnchor.constraint(equalTo: instaView.trailingAnchor, constant: -16),
            
//
            
            tiktokView.bottomAnchor.constraint(equalTo: reportView.topAnchor, constant: -12),
            tiktokView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tiktokView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tiktokView.heightAnchor.constraint(equalToConstant: 42),
            
            tiktokLbl.leadingAnchor.constraint(equalTo: tiktokView.leadingAnchor, constant: 16),
            tiktokLbl.centerYAnchor.constraint(equalTo: tiktokView.centerYAnchor),
            
            tiktokArrow.widthAnchor.constraint(equalToConstant: 18),
            tiktokArrow.heightAnchor.constraint(equalToConstant: 18),
            tiktokArrow.centerYAnchor.constraint(equalTo: tiktokView.centerYAnchor),
            tiktokArrow.trailingAnchor.constraint(equalTo: tiktokView.trailingAnchor, constant: -16),
            
            
            
            
            reportView.bottomAnchor.constraint(equalTo: BlockView.topAnchor),
            reportView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            reportView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            reportView.heightAnchor.constraint(equalToConstant: 38),
            
            reportLbl.leadingAnchor.constraint(equalTo: reportView.leadingAnchor, constant: 16),
            reportLbl.centerYAnchor.constraint(equalTo: reportView.centerYAnchor),
            
            reportArrow.widthAnchor.constraint(equalToConstant: 18),
            reportArrow.heightAnchor.constraint(equalToConstant: 18),
            reportArrow.centerYAnchor.constraint(equalTo: reportView.centerYAnchor),
            reportArrow.trailingAnchor.constraint(equalTo: reportView.trailingAnchor, constant: -16),
            
            
            
            
            
            BlockView.bottomAnchor.constraint(equalTo: doneLbl.topAnchor, constant: -12),
            BlockView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            BlockView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            BlockView.heightAnchor.constraint(equalToConstant: 38),
            
            blockLbl.leadingAnchor.constraint(equalTo: BlockView.leadingAnchor, constant: 16),
            blockLbl.centerYAnchor.constraint(equalTo: BlockView.centerYAnchor),
            
            blockArrow.widthAnchor.constraint(equalToConstant: 18),
            blockArrow.heightAnchor.constraint(equalToConstant: 18),
            blockArrow.centerYAnchor.constraint(equalTo: BlockView.centerYAnchor),
            blockArrow.trailingAnchor.constraint(equalTo: BlockView.trailingAnchor, constant: -16),
            
            
            doneLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            doneLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            doneLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            doneLbl.heightAnchor.constraint(equalToConstant: 48),
            

        ])

    }
    @objc func instaSelected(){
        guard let instaHandle = userInfo?.instaHandle else {return}
        let instagramHooks = "instagram://user?username"+instaHandle
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/\(instaHandle)")! as URL)
        }
    }
    @objc func reportUserSelected(){
        guard username.text != nil else {
            return
        }
        db.collection("reports").document().setData(["username":username.text!, "id":userInfo!.id, "date":Date(), "message": userInfo!.text])
        delegate?.changeBlackView()
        dismiss(animated: true)
    }

    @objc func BlockViewSelected(){
        guard username.text != nil else {
            return
        }
        let item = BlockedUsers()
        item.username = username.text!
        item.userId = userInfo!.id
        try! realmObjc.write{
            realmObjc.add(item)
        }
        delegate?.changeBlackView()

        dismiss(animated: true)
    }

    @objc func dismissView(){
        delegate?.changeBlackView()
        dismiss(animated: true)
    }
}



//      MARK:CHAT CELL 2



protocol presentGifProtocol {
    func presentGit(id: String)
}




//      MARK:EDIT PROFILE VIEW


class SettingsViewController: UIViewController, UITextFieldDelegate{
    let blackWindow = UIView()
    let realmObjc = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        title = "Settings"
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .white
        
        constraintContainer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.shadowImage = nil

        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }


    fileprivate lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(MenuPopUpViewCell.self, forCellReuseIdentifier: "MenuPopUpViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let privateView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.6
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let privateLbl: UILabel = {
       let lbl = UILabel()
        lbl.attributedText = NSAttributedString(string: "Private", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)])
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    lazy var privateSwitch: UISwitch = {
       let item = UISwitch()
        item.isOn = realmObjc.objects(userObject.self)[0].isPrivate
        item.addTarget(self, action: #selector(switchFlipped), for: .touchUpInside)
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    private func constraintContainer(){
        view.addSubview(privateView)
        privateView.addSubview(privateLbl)
        privateView.addSubview(privateSwitch)
        view.addSubview(settingsTableView)
        NSLayoutConstraint.activate([
            privateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            privateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            privateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            privateView.heightAnchor.constraint(equalToConstant: 52),
            
            privateLbl.leadingAnchor.constraint(equalTo: privateView.leadingAnchor, constant: 12),
            privateLbl.centerYAnchor.constraint(equalTo: privateView.centerYAnchor),
            
            privateSwitch.centerYAnchor.constraint(equalTo: privateView.centerYAnchor),
            privateSwitch.trailingAnchor.constraint(equalTo: privateView.trailingAnchor, constant: -12),
            
            settingsTableView.topAnchor.constraint(equalTo: privateView.bottomAnchor, constant: 12),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),


        ])
    }
    
    @objc func switchFlipped(){
            try! realmObjc.write{
                realmObjc.objects(userObject.self)[0].isPrivate = privateSwitch.isOn
            }
    }

}

let firstBlock = ["Edit Profile", "Blocked Users", "Joined"]
let settingsLabelText2 = ["Username","Name","Bio"]
let socialLinks = ["Instagram", "Tiktok"]
let settingsLabelText = ["Rate App", "Terms & Conditions","Privacy policy", "Report", "Version"]
let accountSettings = ["Log Out"]


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate{

//    inset
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return firstBlock.count
        }else if section == 1{
            return settingsLabelText.count
        }
        return accountSettings.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuPopUpViewCell", for: indexPath) as! MenuPopUpViewCell
        cell.selectionStyle = .none


        if indexPath.section == 0{
            if indexPath.row == 2{
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].joinedDate
                cell.cellResponseActive = true

            }else{
                cell.interactiveCell = true
            }
            cell.cellLabel.text = firstBlock[indexPath.row]
            return cell
        }

        if indexPath.section == 1{
            if indexPath.row == 4{

                cell.cellResponse.text = "v0.1.1"
                cell.cellResponseActive = true
            }else{
                cell.interactiveCell = true
            }
            
            cell.cellLabel.text = settingsLabelText[indexPath.row]
            return cell
        }
        if indexPath.section == 2{
            if indexPath.row == 0{
                cell.interactiveCell = true
                cell.cellLabel.textColor = .systemRed
            }
            cell.cellLabel.text = accountSettings[indexPath.row]
            return cell
        }else{
            return cell
        }

    }
    
    @objc func SwitchFlipped(_ sender: UISwitch){
        if sender.tag == 0{
            print("Done", sender.isOn)
            try! realmObjc.write{
                realmObjc.objects(userObject.self)[0].isPrivate = sender.isOn
            }
        }
    }

    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 38
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let mainView = UIView()
        return mainView
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            if indexPath.row == 0{
                let vc = EditProfileView()
                navigationController?.pushViewController(vc, animated: true)
                return
            }else if indexPath.row == 1{
                let vc = BlockedUsersView()
                navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                let view = SKStoreProductViewController()
                view.delegate = self as? SKStoreProductViewControllerDelegate

                view.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: 1548108223])
                            present(view, animated: true, completion: nil)
            }else if indexPath.row == 1{
                let vc = AboutView()
                vc.urlItem = "https://witty.flycricket.io/terms.html"
                present(vc, animated: true)
            }else if indexPath.row == 2{
                let vc = AboutView()
                vc.urlItem = "https://witty.flycricket.io/privacy.html"
                present(vc, animated: true)
            }else if indexPath.row == 3{
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["wittyappios@gmail.com"])
//                    mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

                    present(mail, animated: true)
                } else {
                    // show failure alert
                }
            }
        }else if indexPath.section == 2{
            showSpinner(onView: view.self)
            try! realmObjc.write{
                realmObjc.deleteAll()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.removeSpinner()
                self.navigationController?.pushViewController(WelcomeView(), animated: true)
                
            }
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


class EditProfileView: UIViewController, UITextFieldDelegate, blackViewProtocol{
    
    func changeBlackView() {
        blackWindow.removeFromSuperview()
        profileImage.image = UIImage(named: "\(realmObjc.objects(userObject.self)[0].iconItem)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        title = "Edit Profile"
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .white
        constraintContainer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
//        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }


    
    fileprivate lazy var profileImage: CustomUserImage = {
        let imageView = CustomUserImage()
        imageView.image = UIImage(named:"\(realmObjc.objects(userObject.self)[0].iconItem)")
        imageView.backgroundColor = UIColor(red: 230/255, green: 233/255, blue: 235/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = (view.frame.height*0.12)/2.5
//        imageView.layer.borderWidth = 2
//        imageView.layer.borderColor = TealConstantColor.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    fileprivate let changeProfileImage: UIButton = {
       let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "Change Profile Image", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]), for: .normal)
        btn.titleLabel?.tintColor = .systemBlue
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(ChangeImageSelected), for: .touchUpInside)
        btn.titleLabel!.font = .systemFont(ofSize: 10, weight: .semibold)
        btn.alpha = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    fileprivate lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
//        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(MenuPopUpViewCell.self, forCellReuseIdentifier: "MenuPopUpViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let explinationLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "If there are options that aren't available, that is due to your account being private."
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 12, weight: .regular)
        lbl.numberOfLines = 0
//        lbl.textAlignment = .
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private func constraintContainer(){
        view.addSubview(profileImage)
        view.addSubview(changeProfileImage)
        view.addSubview(settingsTableView)
        view.addSubview(explinationLbl)
        NSLayoutConstraint.activate([
            
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            profileImage.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),

            changeProfileImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            changeProfileImage.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            
            settingsTableView.topAnchor.constraint(equalTo: changeProfileImage.bottomAnchor, constant: 12),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: 248),
            
            explinationLbl.topAnchor.constraint(equalTo: settingsTableView.bottomAnchor, constant: 12),
            explinationLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            explinationLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)


        ])
    }
    
    
    @objc func ChangeImageSelected(){
//        showSpinner(onView: view.self)
//        let pickerController = UIImagePickerController()
//        pickerController.allowsEditing = true
////        pickerController.delegate = self
//        pickerController.sourceType = .photoLibrary
//        self.present(pickerController, animated: true, completion:{
//            self.removeSpinner()
//        })
        print("BAM")
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

        let vc = changeProfileIcon()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
    }
    
    
    
    

    let blackWindow = UIView()
    let realmObjc = try! Realm()
    @objc func continueSelected(){
        if realmObjc.objects(userObject.self).isEmpty{
//            SetUpComplete()
        }else{
//            updateProfile()
        }
    }
    
    
    
//    func updateProfile(){
//        if hasImage{
//
//            let storageRef = storage.reference().child(realmObjc.objects(userObject.self)[0].FID + "img.png")
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
//        navigationController?.popViewController(animated: true)
//    }

}


//extension EditProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.editedImage] as? UIImage {
//            self.profileImage.image = image
//
//            let storageRef = storage.reference().child(realmObjc.objects(userObject.self)[0].FID + "img.png")
//            if let uploadData = image.jpegData(compressionQuality: 0.1){
//                storageRef.putData(uploadData, metadata: nil) { (StorageMetadata, error) in
//                    if error != nil{
//                        return
//                    }
//                }
//            }
//
//            if realmObjc.objects(userObject.self)[0].image == nil{
//                    db.collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["hasProfileImage" : true])
//            }
//            try! realmObjc.write{
//                realmObjc.objects(userObject.self)[0].image = image.pngData() as NSData?
//            }
//            dismiss(animated: true, completion: nil)
//        }
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
extension EditProfileView: UITableViewDelegate, UITableViewDataSource{

//    inset
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return settingsLabelText2.count
        }
        return socialLinks.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuPopUpViewCell", for: indexPath) as! MenuPopUpViewCell
        cell.selectionStyle = .none
//
        if realmObjc.objects(userObject.self)[0].isPrivate{
            if indexPath.section == 0{
                if indexPath.row != 0{
                    cell.cellLabel.alpha = 0.4
                    cell.arrowImage.alpha = 0.4
                }
            }else{
                cell.cellLabel.alpha = 0.4
                cell.arrowImage.alpha = 0.4
            }
        }
        


        if indexPath.section == 0{
            if indexPath.row == 0{
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].username
            }else if indexPath.row == 1{
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].name
            }else{
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].bio
            }
            cell.interactiveCell = true
            cell.cellLabel.text = settingsLabelText2[indexPath.row]
        }else{
            if indexPath.row == 0{
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].instagramHandle
            }else{
                cell.cellResponse.text = realmObjc.objects(userObject.self)[0].tiktokHandle
            }
            cell.interactiveCell = true
            cell.cellLabel.text = socialLinks[indexPath.row]
        }
            return cell
            
      
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 38
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let mainView = UIView()
        return mainView
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if realmObjc.objects(userObject.self)[0].isPrivate{
            if indexPath.section == 0 && indexPath.row == 0{
                let vc = EditSingleView()
                vc.title = settingsLabelText2[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if indexPath.section == 0{
                if indexPath.row == 2{
                    let vc = BioEditSingleView()
                    vc.title = settingsLabelText2[indexPath.row]
                    vc.textField.text = realmObjc.objects(userObject.self)[0].bio
                    vc.countabel.attributedText = NSAttributedString(string: "\(realmObjc.objects(userObject.self)[0].bio.count)/80", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12, weight: .bold)])
                    navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = EditSingleView()
                    if settingsLabelText2[indexPath.row] == "Name"{
                        vc.textField.text = realmObjc.objects(userObject.self)[0].name
                        vc.countabel.attributedText = NSAttributedString(string: "\(realmObjc.objects(userObject.self)[0].name.count)/30", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)])
                    }else if settingsLabelText2[indexPath.row] == "Username"{
                        vc.textField.text = realmObjc.objects(userObject.self)[0].username
                        vc.countabel.attributedText = NSAttributedString(string: "\(realmObjc.objects(userObject.self)[0].username.count)/30", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12, weight: .bold)])
                    }
                    
                    vc.title = settingsLabelText2[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                let vc = EditSingleView()
                if socialLinks[indexPath.row] == "Instagram"{
                    vc.textField.text = realmObjc.objects(userObject.self)[0].instagramHandle
                    vc.countabel.attributedText = NSAttributedString(string: "\(realmObjc.objects(userObject.self)[0].instagramHandle.count)/30", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12, weight: .bold)])
                }else if socialLinks[indexPath.row] == "Tiktok"{
                    vc.textField.text = realmObjc.objects(userObject.self)[0].tiktokHandle
                    vc.countabel.attributedText = NSAttributedString(string: "\(realmObjc.objects(userObject.self)[0].tiktokHandle.count)/30", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12, weight: .bold)])
                }
                vc.title = socialLinks[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


















//      MARK: MENU VIEW CELL

class MenuPopUpViewCell: UITableViewCell{
    let realmObjc = try! Realm()
    var interactiveCell = false {
        didSet{
            if interactiveCell == true{
                self.addSubview(arrowImage)
                self.addSubview(cellResponse)

                cellResponse.textColor = .lightGray
                NSLayoutConstraint.activate([
                    arrowImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
                    arrowImage.heightAnchor.constraint(equalToConstant: 18),
                    arrowImage.widthAnchor.constraint(equalToConstant: 18),
                    arrowImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    
                    cellResponse.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -8),
                    cellResponse.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    cellResponse.leadingAnchor.constraint(equalTo: cellLabel.trailingAnchor, constant: 16)
                ])

            }
        }
    }
    var cellResponseActive = false {
        didSet{
            if cellResponseActive == true{
                cellResponse.textColor = .lightGray

                self.addSubview(cellResponse)

                NSLayoutConstraint.activate([
                    cellResponse.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
                    cellResponse.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    cellResponse.leadingAnchor.constraint(equalTo: cellLabel.trailingAnchor, constant: 12)
                ])

            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        constraintContainer()
    }
    
    
    fileprivate let cellLabel: CustomLabel = {
       let label = CustomLabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var arrowImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "BlackRightArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let cellResponse: CustomLabel = {
       let label = CustomLabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func constraintContainer(){
        self.addSubview(cellLabel)
        NSLayoutConstraint.activate([
            cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            cellLabel.widthAnchor.constraint(equalToConstant: 140)
        
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




//      MARK: EDIT SINGLE VIEW


class EditSingleView: UIViewController,  UITextFieldDelegate{
    var saveBtn: UIBarButtonItem?
    let realmObjc = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .white
        
        saveBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSelected))
        saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)], for: .normal)
        navigationItem.rightBarButtonItem = saveBtn
        textField.becomeFirstResponder()
        textField.delegate = self
        
        
        constraintContainer()
    }
    @objc func saveSelected(){
                if title == "Username"{
                    db.collection("users").whereField("username", isEqualTo:textField.text!).getDocuments { [self] (QuerySnapshot, error) in
                        if let error = error{
                            print(error)
                        }else{
                            if QuerySnapshot!.isEmpty{
                                try! realmObjc.write {
                                    realmObjc.objects(userObject.self)[0].username = textField.text!
                                }
                                db.collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["username" : textField.text!])
                                showSpinner(onView: view.self)
                                textField.resignFirstResponder()
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    self.removeSpinner()
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }else{
                                let alert = UIAlertController(title: "The username you select is already occupied. Please select another username.", message:.none , preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                }else{
                    if title == "TikTok"{
                        db.collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["tiktokHandle" : textField.text!])

                    }else if title == "Instagram"{
                        db.collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["instagramHandle" : textField.text!])

                    }else if title == "Name"{
                        db.collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["name" : textField.text!])
                    }
                    try! realmObjc.write {
                        if title == "TikTok"{
                            realmObjc.objects(userObject.self)[0].tiktokHandle = textField.text!
                        }else if title == "Instagram"{
                            realmObjc.objects(userObject.self)[0].instagramHandle = textField.text!
                        }else if title == "Name"{
                            realmObjc.objects(userObject.self)[0].name = textField.text!
                        }
                    }
                    showSpinner(onView: view.self)
                    textField.resignFirstResponder()
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.removeSpinner()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .black
//        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    

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
        field.font = UIFont.boldSystemFont(ofSize: 15)
        field.autocorrectionType = .no
        field.delegate = self
        field.keyboardType = .twitter
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    lazy var titleLbl: UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = title
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textColor = .gray
        return lbl
    }()
    fileprivate let reasonForName: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var countabel: CustomLabel = {
       let label = CustomLabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func constraintContainer(){

        view.addSubview(titleLbl)
        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        view.addSubview(reasonForName)
        view.addSubview(countabel)
        NSLayoutConstraint.activate([
            
            titleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            

            textField.topAnchor.constraint(equalTo: titleLbl.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -4),
            textField.heightAnchor.constraint(equalToConstant:36),
            
            
            textFieldView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            textFieldView.heightAnchor.constraint(equalToConstant:0.8),
            
            reasonForName.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            reasonForName.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor),
            reasonForName.trailingAnchor.constraint(equalTo: countabel.leadingAnchor, constant: -32),

            countabel.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor),
            countabel.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            countabel.widthAnchor.constraint(equalToConstant: 50)

        ])
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count >= 5{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
            saveBtn?.isEnabled = true
        }else{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
            saveBtn?.isEnabled = false
        }

        countabel.text = "\(textField.text!.count)/30"
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if title == "Username"{
            if let _ = string.rangeOfCharacter(from: .uppercaseLetters) {
                return false
            }
        }
        
        
        for letter in string{
            if title != "Name"{
                if letter == " "{
                    return false
                }
            }
            for i in "/:;()$&@\",?!'[]{}#%^*+=\\|~<>€£¥•,?!'"{
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
        
        if textField.text!.count >= 5{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
            saveBtn?.isEnabled = true
        }else{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
            saveBtn?.isEnabled = false
        }
        countabel.text = "\(textField.text!.count)/30"

        return count <= 30
    }
}
class BioEditSingleView: UIViewController,  UITextViewDelegate{
    var saveBtn: UIBarButtonItem?
    let realmObjc = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .white
        saveBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSelected))
        saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
        navigationItem.rightBarButtonItem = saveBtn
        textField.becomeFirstResponder()
        textField.delegate = self
        constraintContainer()
    }
    @objc func saveSelected(){
        try! realmObjc.write{
            realmObjc.objects(userObject.self)[0].bio = textField.text
        }
        db.collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["bio" : textField.text!])
        try! realmObjc.write {
                realmObjc.objects(userObject.self)[0].bio = textField.text!
        }

        showSpinner(onView: view.self)
        textField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.removeSpinner()
            self.navigationController?.popViewController(animated: true)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    

    fileprivate let textFieldView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .lightGray

       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    fileprivate lazy var textField: UITextView = {
       let field = UITextView()
//        field.clearButtonMode = .whileEditing
//        field.textContainer.maximumNumberOfLines = 3
        
        field.textContainer.lineBreakMode = .byWordWrapping
        field.backgroundColor = .clear
        field.keyboardAppearance = .light
        field.textColor = .black
        field.tintColor = .lightGray
        field.font = UIFont.boldSystemFont(ofSize: 15)
        field.delegate = self
        field.keyboardType = .twitter
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    fileprivate let reasonForName: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "Character Limit", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let countabel: CustomLabel = {
       let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "0/80", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)])
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func constraintContainer(){

        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        view.addSubview(reasonForName)
        view.addSubview(countabel)
        NSLayoutConstraint.activate([

            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant:96),
            
            
            textFieldView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            textFieldView.heightAnchor.constraint(equalToConstant:0.8),
            
            reasonForName.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            reasonForName.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor),
            reasonForName.trailingAnchor.constraint(equalTo: countabel.leadingAnchor, constant: -32),

            countabel.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor),
            countabel.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            countabel.widthAnchor.constraint(equalToConstant: 50)

        ])
    }
//return
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        for letter in text{
            for i in "/:;()$&@\",?!'[]{}#%^*+=\\|~<>€£¥•,?!'"{
                if letter == i{
                    return false
                }
            }
        }
        guard let textFieldText = textView.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + text.count
        
        if textField.text!.count >= 5{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
            saveBtn?.isEnabled = true
        }else{
            saveBtn!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
            saveBtn?.isEnabled = false
        }
        countabel.text = "\(textField.text!.count)/80"

        return count <= 80
    }
    
}








// MARK: SHIMMER VIEWS


class shimmerViewClass: UIView{
    override init(frame: CGRect){
        super.init(frame: frame)
        LoadingViews()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var LoadImageOne:ShimmeringView = {
       let view = ShimmeringView()
        view.shimmerSpeed = 10
        view.shimmerPauseDuration = 1.5
        let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        blackView.clipsToBounds = true
        blackView.layer.cornerRadius = 20
        view.contentView = blackView
        view.isShimmering = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var  TitleLoader: ShimmeringView = {
        let view = ShimmeringView()
         view.shimmerSpeed = 10
         view.shimmerPauseDuration = 1.5
         let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

         blackView.clipsToBounds = true
         blackView.layer.cornerRadius = 4
         view.contentView = blackView
         view.isShimmering = true

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    lazy var  TitleLoader2: ShimmeringView = {
        let view = ShimmeringView()
         view.shimmerSpeed = 10
         view.shimmerPauseDuration = 1.5
         let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

         blackView.clipsToBounds = true
         blackView.layer.cornerRadius = 4
         view.contentView = blackView
         view.isShimmering = true

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    lazy var  TitleLoader3: ShimmeringView = {
        let view = ShimmeringView()
         view.shimmerSpeed = 10
         view.shimmerPauseDuration = 1.5
         let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

         blackView.clipsToBounds = true
         blackView.layer.cornerRadius = 4
         view.contentView = blackView
         view.isShimmering = true

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    lazy var  DescLoader2: ShimmeringView = {
        let view = ShimmeringView()
         view.shimmerSpeed = 10
         view.shimmerPauseDuration = 1.5
         let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

         blackView.clipsToBounds = true
         blackView.layer.cornerRadius = 4
         view.contentView = blackView
         view.isShimmering = true

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    lazy var  DescLoader3: ShimmeringView = {
        let view = ShimmeringView()
         view.shimmerSpeed = 10
         view.shimmerPauseDuration = 1.5
         let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

         blackView.clipsToBounds = true
         blackView.layer.cornerRadius = 4
         view.contentView = blackView
         view.isShimmering = true

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    lazy var  DescLoader4: ShimmeringView = {
        let view = ShimmeringView()
         view.shimmerSpeed = 10
         view.shimmerPauseDuration = 1.5
         let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

         blackView.clipsToBounds = true
         blackView.layer.cornerRadius = 4
         view.contentView = blackView
         view.isShimmering = true

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    lazy var  DescLoader5: ShimmeringView = {
        let view = ShimmeringView()
         view.shimmerSpeed = 10
         view.shimmerPauseDuration = 1.5
         let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

         blackView.clipsToBounds = true
         blackView.layer.cornerRadius = 4
         view.contentView = blackView
         view.isShimmering = true

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    
    lazy var  smallImg: ShimmeringView = {
        let view = ShimmeringView()
         view.shimmerSpeed = 10
         view.shimmerPauseDuration = 1.5
         let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

         blackView.clipsToBounds = true
         blackView.layer.cornerRadius = 4
         view.contentView = blackView
         view.isShimmering = true

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    lazy var  smallImg2: ShimmeringView = {
        let view = ShimmeringView()
         view.shimmerSpeed = 10
         view.shimmerPauseDuration = 1.5
         let blackView = UIView()
        view.shimmerAnimationOpacity = 0.3
        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

         blackView.clipsToBounds = true
         blackView.layer.cornerRadius = 4
         view.contentView = blackView
         view.isShimmering = true

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()

//    lazy var LoadImageOne2:ShimmeringView = {
//        let view = ShimmeringView()
//         view.shimmerSpeed = 10
//         view.shimmerPauseDuration = 1.5
//         let blackView = UIView()
//        view.shimmerAnimationOpacity = 0.3
//        blackView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
//
//         blackView.clipsToBounds = true
//         blackView.layer.cornerRadius = 20
//         view.contentView = blackView
//         view.isShimmering = true
//
//         view.translatesAutoresizingMaskIntoConstraints = false
//         return view
//     }()
    func LoadingViews(){
        addSubview(LoadImageOne)
        addSubview(TitleLoader)
        addSubview(TitleLoader2)
        addSubview(TitleLoader3)
        addSubview(DescLoader2)
        addSubview(DescLoader3)
        addSubview(DescLoader4)
        addSubview(DescLoader5)
        addSubview(smallImg)
        addSubview(smallImg2)
//        addSubview(LoadImageOne2)
        addConstraintsWithFormat(format: "V:|-[v0(188)]-12-[v1(18)]-4-[v2(18)]-4-[v3(18)]-42-[v4(18)]-4-[v5(18)]-4-[v6(18)]-4-[v7(18)]", views: LoadImageOne, TitleLoader, TitleLoader2, TitleLoader3, DescLoader2, DescLoader3, DescLoader4, DescLoader5)

        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: LoadImageOne)

        addConstraintsWithFormat(format: "H:|-24-[v0(\(UIScreen.main.bounds.width*0.12))]-12-|", views: TitleLoader)
        addConstraintsWithFormat(format: "H:|-24-[v0]-32-[v1(52)]-24-|", views: TitleLoader2, smallImg)
        addConstraintsWithFormat(format: "H:|-24-[v0(\(UIScreen.main.bounds.width*0.4))]-12-|", views: TitleLoader3)
        addConstraintsWithFormat(format: "H:|-24-[v0(\(UIScreen.main.bounds.width*0.12))]-12-|", views: DescLoader2)
        addConstraintsWithFormat(format: "H:|-24-[v0]-32-[v1(52)]-24-|", views: DescLoader3, smallImg2)

//        addConstraintsWithFormat(format: "H:|-24-[v0(\(UIScreen.main.bounds.width*0.7))]-12-|", views: DescLoader3)
        addConstraintsWithFormat(format: "H:|-24-[v0]-32-[v1(52)]-24-|", views: DescLoader4 , smallImg2)
        addConstraintsWithFormat(format: "H:|-24-[v0(\(UIScreen.main.bounds.width*0.4))]-12-|", views: DescLoader5)

//        addConstraintsWithFormat(format: "H:|-12-[v0(52)]", views: )
        addConstraintsWithFormat(format: "V:|-[v0(188)]-12-[v1(18)]-4-[v2(52)]", views: LoadImageOne, TitleLoader, smallImg)
        
        addConstraintsWithFormat(format: "V:|-[v0(188)]-12-[v1(18)]-4-[v2(18)]-4-[v3(18)]-42-[v4(18)]-4-[v5(52)]", views: LoadImageOne, TitleLoader, TitleLoader2, TitleLoader3, DescLoader2, smallImg2)

    }
}








class changeProfileIcon: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    var delegate: blackViewProtocol?
    let realmObjc = try! Realm()
    var selectedItem: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PanGestureFunc)))
        constraintContianer()

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
                    
                    if viewTranslation.y >= sender.translation(in: view).y{
                        break
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
    
    fileprivate let continueButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
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
    
    func constraintContianer(){
        view.addSubview(whiteView)
        whiteView.addSubview(viewBar)
        whiteView.addSubview(collectionView)
        whiteView.addSubview(ProfileIconLbl)

        whiteView.addSubview(fadeViewRight)
        whiteView.addSubview(fadeView)
        whiteView.addSubview(continueButton)
        NSLayoutConstraint.activate([
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 242),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            viewBar.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 8),
            viewBar.widthAnchor.constraint(equalToConstant: 30),
            viewBar.heightAnchor.constraint(equalToConstant: 7),
            viewBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: ProfileIconLbl.bottomAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 62),
            
            ProfileIconLbl.topAnchor.constraint(equalTo: viewBar.bottomAnchor, constant: 8),
            ProfileIconLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ProfileIconLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ProfileIconLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 42),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),

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
    
    @objc func continueSelected(){
        db.collection("users").document(realmObjc.objects(userObject.self)[0].FID).updateData(["iconNum" : selectedItem!])
        try! realmObjc.write{
            realmObjc.objects(userObject.self)[0].iconItem = selectedItem!
        }
        delegate?.changeBlackView()
        dismiss(animated: true)
    }
    
    
    
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
        continueButton.backgroundColor = TealConstantColor
        continueButton.isEnabled = true
    }
    
}



class SideSelectionView: UIViewController{
    var delegate: blackViewProtocol?
    let realmObjc = try! Realm()
    var first: String?
    var second: String?
    var eventID: String?
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .clear
        constraintContainer()
    }
    var viewTranslation = CGPoint(x: 0, y: 0)

    
    let whiteView: CustomView = {
        let view = CustomView()
//        view.backgroundColor = UIColor(red: 250/255, green: 251/255, blue: 253/255, alpha: 1)
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
//        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let lottie: AnimationView = {
       let animation = AnimationView()
        animation.animation = Animation.named("4768-trophy")
        animation.play(toFrame: 90)
        animation.backgroundColor = .clear
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    let lottieConfetti: AnimationView = {
       let animation = AnimationView()
        animation.animation = Animation.named("35875-confetti-on-transparent-background")
        animation.backgroundColor = .clear
        animation.play(toFrame: 111)
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    let titleLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Who do you think\nwill win?"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let descLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Every user that enters this chatroom is asked this question to get a sense of which team is favored to win."
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var firstTeam: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: first!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)]), for: .normal)
        btn.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        btn.addTarget(self, action: #selector(firstTeamSelected), for: .touchUpInside)
        btn.layer.cornerRadius = 4
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var secondTeam: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: second!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)]), for: .normal)
        btn.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(secondTeamSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var SkipBtn: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "I don't care, skip.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)]), for: .normal)
        btn.addTarget(self, action: #selector(skipSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func constraintContainer(){
        view.addSubview(lottieConfetti)
        view.addSubview(whiteView)
        whiteView.addSubview(lottie)
        whiteView.addSubview(titleLbl)
        whiteView.addSubview(descLbl)
        whiteView.addSubview(firstTeam)
        whiteView.addSubview(secondTeam)
        whiteView.addSubview(SkipBtn)
        NSLayoutConstraint.activate([
            lottieConfetti.topAnchor.constraint(equalTo: view.topAnchor),
            lottieConfetti.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lottieConfetti.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lottieConfetti.bottomAnchor.constraint(equalTo:view.bottomAnchor),
            
            whiteView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            whiteView.heightAnchor.constraint(equalToConstant: 326),
            
            lottie.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: -28),
            lottie.widthAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.35),
            lottie.heightAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.35),
            lottie.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            
            titleLbl.topAnchor.constraint(equalTo: lottie.bottomAnchor, constant: -56),
            titleLbl.heightAnchor.constraint(equalToConstant: titleLbl.intrinsicContentSize.height*2),
            titleLbl.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor),
            
            descLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: -10),
//            descLbl.heightAnchor.constraint(equalToConstant: titleLbl.intrinsicContentSize.height*2),
            descLbl.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 22),
            descLbl.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -22),
            
            firstTeam.bottomAnchor.constraint(equalTo: secondTeam.topAnchor, constant: -12),
            firstTeam.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 12),
            firstTeam.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor,constant: -12),
            firstTeam.heightAnchor.constraint(equalToConstant: 42),
            
            secondTeam.bottomAnchor.constraint(equalTo: SkipBtn.topAnchor, constant: -8),
            secondTeam.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 12),
            secondTeam.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor,constant: -12),
            secondTeam.heightAnchor.constraint(equalToConstant: 42),
            
            SkipBtn.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            SkipBtn.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -12),
        ])
    }
    
    @objc func skipSelected(){
        delegate?.changeBlackView()
        dismiss(animated: true)
    }

    @objc func firstTeamSelected(){
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM d, yyyy"
        let used = usedVote()
        try! realmObjc.write{
            used.date = dateFormatterGet.string(from: Date())
            used.eventID = eventID!
            realmObjc.add(used)

        }
        
        db.collection("message").document(eventID!).getDocument { (snapshot, error) in
            guard let item = snapshot?.data()!["firstTeamVotes"] as? Int else{return}
            db.collection("message").document(self.eventID!).updateData(["firstTeamVotes":item+1])
        }
        
        delegate?.changeBlackView()
        dismiss(animated: true)
    }
    @objc func secondTeamSelected(){
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM d, yyyy"
        let used = usedVote()
        try! realmObjc.write{
            used.date = dateFormatterGet.string(from: Date())
            used.eventID = eventID!
            realmObjc.add(used)
        }
        
        db.collection("message").document(eventID!).getDocument { (snapshot, error) in
            guard let item = snapshot?.data()!["secondTeamVotes"] as? Int else{return}
            db.collection("message").document(self.eventID!).updateData(["secondTeamVotes":item+1])
        }
        
        delegate?.changeBlackView()
        dismiss(animated: true)
    }
}

//
//  DEVFile.swift
//  Witty
//
//  Created by Caleb Mesfien on 4/22/21.
//

import UIKit
import FirebaseFirestore

//let isSport = snapshot.data()["isSport"] as! Bool
//let day = snapshot.data()["day"] as! String
//let month = snapshot.data()["month"] as! String
//let time = snapshot.data()["time"] as! String
//let imageURL = snapshot.data()["imageURL"] as! String
//let name = snapshot.data()["name"] as! String
//let type = snapshot.data()["type"] as! String
//let firstTeamVotes = snapshot.data()["firstTeamVotes"] as! Int
//let secondTeamVotes = snapshot.data()["secondTeamVotes"] as! Int

//if isSport{
//    let first = snapshot.data()["first"] as! String
//    let second = snapshot.data()["second"] as! String
//    
class DeveloperView: UIViewController{
    override func viewDidLoad(){
        super.viewDidLoad()
        title = "Developer"
        view.backgroundColor = .white
        constraintContainer()
//        handleTap()
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { (Timer) in
            self.handleTap()
        }
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

    }
    let nameField: UITextField = {
       let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.keyboardAppearance = .light
        field.textColor = .black
        field.setLeftPaddingPoints(12)
        field.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.backgroundColor = .white
        field.layer.cornerRadius = 8
        field.layer.shadowColor = UIColor.lightGray.cgColor
        field.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        field.layer.shadowRadius = 10.0
        field.layer.shadowOpacity = 0.4
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    let firstField: UITextField = {
       let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.keyboardAppearance = .light
        field.textColor = .black
        field.setLeftPaddingPoints(12)
        field.attributedPlaceholder = NSAttributedString(string: "First Team", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.backgroundColor = .white
        field.layer.cornerRadius = 8
        field.layer.shadowColor = UIColor.lightGray.cgColor
        field.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        field.layer.shadowRadius = 10.0
        field.layer.shadowOpacity = 0.4
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    let secondField: UITextField = {
       let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.keyboardAppearance = .light
        field.textColor = .black
        field.setLeftPaddingPoints(12)
        field.attributedPlaceholder = NSAttributedString(string: "Second Team", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.backgroundColor = .white
        field.layer.cornerRadius = 8
        field.layer.shadowColor = UIColor.lightGray.cgColor
        field.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        field.layer.shadowRadius = 10.0
        field.layer.shadowOpacity = 0.4
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()


    let timeField: UITextField = {
       let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.keyboardAppearance = .light
        field.textColor = .black
        field.setLeftPaddingPoints(12)
        field.attributedPlaceholder = NSAttributedString(string: "Time", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.backgroundColor = .white
        field.layer.cornerRadius = 8
        field.layer.shadowColor = UIColor.lightGray.cgColor
        field.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        field.layer.shadowRadius = 10.0
        field.layer.shadowOpacity = 0.4
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    let typeField: UITextField = {
       let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.keyboardAppearance = .light
        field.textColor = .black
        field.setLeftPaddingPoints(12)
        field.attributedPlaceholder = NSAttributedString(string: "Type Emoji", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.backgroundColor = .white
        field.layer.cornerRadius = 8
        field.layer.shadowColor = UIColor.lightGray.cgColor
        field.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        field.layer.shadowRadius = 10.0
        field.layer.shadowOpacity = 0.4
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    fileprivate let continueButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setAttributedTitle(NSAttributedString(string: "Add",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]), for: .normal)
        button.backgroundColor = UIColor(red: 32/255, green: 34/255, blue: 46/255, alpha: 1)
        button.addTarget(self, action: #selector(continueSelected), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let curvedView: CurvedView = {
       let view = CurvedView()
        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func constraintContainer(){
        view.addSubview(nameField)
        view.addSubview(firstField)
        view.addSubview(secondField)
        view.addSubview(timeField)
        view.addSubview(typeField)
        view.addSubview(continueButton)
        view.addSubview(curvedView)
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 42),
            
            firstField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 22),
            firstField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            firstField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            firstField.heightAnchor.constraint(equalToConstant: 42),
            
            secondField.topAnchor.constraint(equalTo: firstField.bottomAnchor, constant: 22),
            secondField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            secondField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            secondField.heightAnchor.constraint(equalToConstant: 42),
            
            timeField.topAnchor.constraint(equalTo: secondField.bottomAnchor, constant: 22),
            timeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            timeField.heightAnchor.constraint(equalToConstant: 42),
            
            typeField.topAnchor.constraint(equalTo: timeField.bottomAnchor, constant: 22),
            typeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            typeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            typeField.heightAnchor.constraint(equalToConstant: 42),
            
            continueButton.widthAnchor.constraint(equalToConstant: 150),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 42),
            continueButton.topAnchor.constraint(equalTo: typeField.bottomAnchor, constant: 22),
            
            curvedView.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 8),
            curvedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            curvedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            curvedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func continueSelected(){
        db.collection("message").addDocument(data: ["time": timeField.text!, "name": nameField.text!, "type":typeField.text!, "firstTeamVotes":1, "secondTeamVotes":1, "first": firstField.text!, "second":secondField.text!])
        continueButton.backgroundColor = .blue
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
    }
    
    
    func handleTap(){
        (0...5).forEach { (_) in
            createAnimation()
        }
    }
    
    fileprivate func createAnimation(){
        let image = drand48() > 0.5 ? UIImage(named: "nets") : UIImage(named: "hawks")
        let dimension = 30 + drand48() + 10
        let img = UIImageView(image: image)
        img.alpha = 0.5
        img.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
//        img.layer.cornerRadius = CGFloat((20 + drand48() + 10)/2)
//        img.backgroundColor = .white
//        img.layer.shadowColor = UIColor.lightGray.cgColor
//        img.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        img.layer.shadowRadius = 10.0
//        img.layer.shadowOpacity = 0.4
        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.path = customPath().cgPath
        animation.duration = 2 + drand48() * 3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        img.layer.add(animation, forKey: nil)
        view.addSubview(img)
    }
}



//func customPath() -> UIBezierPath {
//
//    return path
//}
class CurvedView: UIView{
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 100, y: 300))
    //    let randomYShift = 200 + drand48() * 300
        let endPoint = CGPoint(x: 100, y: -100)
        let cp1 = CGPoint(x: 250, y: 100)
        let cp2 = CGPoint(x: 0, y: 100)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 3
        path.stroke()
    }
}

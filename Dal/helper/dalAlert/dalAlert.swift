//
//  dalAlert.swift
//  Dal
//
//  Created by khalid almalki on 4/8/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import UIKit



public struct DalTextfieldOption {
    let name:String!
    let keyboradType:UIKeyboardType!
    let MustHasData:Bool!
    
}
enum Result {
    case OK, FAILED
}
enum type{
    case icon
    case lable
    case textfield
    case button
}

struct Yp {
    let  name:type
    var yp : CGFloat
}

class dalalert: UIViewController , UITextFieldDelegate{
    
    private var containerView: UIView!
    
    private var iconImage: UIImage!
    private var iconImageView: UIImageView!
    
    private var titleLabel: UILabel!
    
    private var button:UIButton!
    
    private var buttonLabel: UILabel!
    private var textfied:UITextField!
    private var textfiedOption: DalTextfieldOption!
    
    
    
    private var closeAction: ((String)->Void)!
    private var respond: ((Result)->Void)!
    
    private var isAlertOpen: Bool = false
    
    private weak var rootViewController: UIViewController!
    
    private var noButtons: Bool = false
    
    
    // configure frames
    private var viewWidth: CGFloat?
    private var viewHeight: CGFloat?
    private var midHeight:CGFloat?
    
    // font name
    private var textFont = "GeezaPro"
    
    // deafult
    private let padding: CGFloat = 46.0
    private let buttonHeight:CGFloat = 44
    private var iskeyBUp = false
    private var yPostionArray:[Yp] = [Yp]()
    
    
    convenience  init(_ viewController: UIViewController,
                              text: String?=nil,
                              noButtons: Bool = false,
                              buttonText: String? = nil,
                              iconImage: UIImage? = nil,
                              textfied: DalTextfieldOption?=nil) {
        self.init()
        self.show(viewController, text: text, noButtons: noButtons, buttonText: buttonText, iconImage: iconImage, textfied: textfied)
    }
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
        print("nibName")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func Setup() {
        let size = self.rootViewControllerSize()
        self.viewWidth = size.width
        self.viewHeight = size.height
        self.midHeight = size.height/2
        var y: CGFloat = 0
        
        
        if size.height>=700{
            
            y = 150
        }else{
            
            y = 65
        }
        
        
        // position the icon image view, if there is one
        if self.titleLabel != nil {
            
            let height = titleLabel.text?.heightWithConstrainedWidth(width:viewWidth! - (40), font: titleLabel.font)
            titleLabel.frame = CGRect(x: 40/2, y: midHeight!-(titleLabel.requiredHeight()/2), width: viewWidth! - (40), height:height!)
            yPostionArray.append(Yp(name: .lable, yp: titleLabel.frame.origin.y))
            
            y += ceil(titleLabel.requiredHeight())
            
        }
        
        // check if user need textfield
        
        if textfiedOption != nil {
            let Width = viewWidth! - (padding * 2)
            textfied.frame = CGRect(x: ((viewWidth!-Width)/2), y: midHeight!-(buttonHeight/2), width: Width, height: buttonHeight)
            
            
            if titleLabel != nil{
                titleLabel.frame.origin.y = self.textfied.frame.origin.y - ( self.titleLabel.frame.height + 30)
                yPostionArray[0].yp = titleLabel.frame.origin.y
                
            }
            
            
            
            
            
            textfied.bottomBorderColor = .gray
            textfied.placeHolderColor = .gray
            
            yPostionArray.append(Yp(name:.textfield, yp:textfied.frame.origin.y))
            
        }
        
        
        
        if self.iconImageView != nil {
            
            let centerX = (self.viewWidth!-107)/2
            
            self.iconImageView.frame = CGRect(x: centerX, y: 0, width: 107, height: 107)
            
            if textfiedOption != nil && titleLabel != nil{
                
                self.iconImageView.frame.origin.y =  self.titleLabel.frame.origin.y - ( self.iconImageView.frame.height + 50)
                
            }else{
                if titleLabel != nil {
                    self.iconImageView.frame.origin.y =  self.titleLabel.frame.origin.y - ( self.iconImageView.frame.height + 50)
                    
                }else{
                    self.iconImageView.frame.origin.y =  self.textfied.frame.origin.y - ( self.iconImageView.frame.height + 50)
                    
                }
                
            }
            
            yPostionArray.append(Yp(name: .icon, yp: iconImageView.frame.origin.y))
            
            
            y += 107
        }
        
        
        
        
        if !noButtons {
            
            let buttonWidth = viewWidth! - (padding * 2)
            
            button.frame = CGRect(x: ((viewWidth!-buttonWidth)/2), y: viewHeight! - 92  , width: buttonWidth, height: buttonHeight)
            if buttonLabel != nil {
                buttonLabel.frame = CGRect(x: padding, y: (buttonHeight / 2) - 15, width: buttonWidth - (padding * 2), height: 30)
            }
            
            yPostionArray.append(Yp(name: .button, yp: button.frame.origin.y ))
            
            // set button fonts
            if buttonLabel != nil {
                buttonLabel.font = UIFont(name: textFont, size: 20)
            }
            
        }
        
        
        
        // position Bt
        
        //   button.frame = CGRect(x: 47, y: 447, width: 226, height: 44)
        
        
        
        
    }
   private func setupBase()  { // seting up the blur and other views
        
        let sz = screenSize()
        viewWidth = sz.width
        viewHeight = sz.height
        
        
        // Container for the entire alert modal contents
      //  let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.70)
        view.addSubview(containerView!)
        
        containerView.frame.size = sz
    }
    // showing data
    
   private func appear(viewController: UIViewController) {
        // Animate it in
        view.alpha = 0
        definesPresentationContext = true
        modalPresentationStyle = .overFullScreen
        viewController.present(self, animated: false, completion: {
            // Animate it in
            UIView.animate(withDuration: 0.2) {
                UIApplication.shared.isStatusBarHidden = true
                
                self.view.alpha = 1
                
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            }, completion: { finished in
                self.isAlertOpen = true
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    //  self.closeView(true)
                })
            })
        })
    }
    
    // the main method
    private func loadingView(_ viewController: UIViewController,text:String? = nil, didFinish:((Result) -> Void)! = nil){
        
        setupBase()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        containerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if text != nil {
            let textLable = UILabel()
            textLable.text = text
            textLable.textAlignment = .center
            textLable.textColor = .white
            textLable.frame = CGRect(x: 10, y: activityIndicator.center.y+40 , width: (viewWidth!-20), height: 30)
            containerView.addSubview(textLable)
            
        }
        if (didFinish != nil) {
            respond = didFinish
        }
        appear(viewController: viewController)
    }
    
    
    private func show(_ viewController: UIViewController,
                     text: String?=nil,
                     noButtons: Bool = false,
                     buttonText: String? = nil,
                     iconImage: UIImage? = nil,
                     textfied: DalTextfieldOption?=nil
        ) {
        
        rootViewController = viewController
        
        
        setupBase()
        
        
        // Icon
        self.iconImage = iconImage
        if iconImage != nil {
            iconImageView = UIImageView(image: iconImage)
            containerView.addSubview(iconImageView)
        }
        
        // Title
        if text != nil {
            titleLabel = UILabel()
            titleLabel.textColor = .white
            titleLabel.font = UIFont(name: self.textFont, size: 20)
            titleLabel.text = text
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
            containerView.addSubview(titleLabel)
            
            
        }
        
        
        // Button
        self.noButtons = noButtons
        if !noButtons {
            self.noButtons = false
            button = UIButton()
            button.backgroundColor = .clear
            button.layer.cornerRadius = 7
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
            containerView!.addSubview(button)
            // Button text
            buttonLabel = UILabel()
            buttonLabel.font = UIFont(name: textFont, size: 21)
            buttonLabel.numberOfLines = 1
            buttonLabel.textAlignment = .center
            buttonLabel.textColor = .white
            if let text = buttonText {
                buttonLabel.text = text
            } else {
                buttonLabel.text = "OK"
            }
            button.addSubview(buttonLabel)
        }
        // assaing the textfield
        if textfied != nil{
            textfiedOption = textfied
            self.textfied = UITextField()
            self.textfied.textColor = .white
            self.textfied.font = UIFont(name: self.textFont, size: 20)
            self.textfied.textAlignment = .left
            self.textfied.placeholder = textfiedOption.name
            self.textfied.delegate = self
            self.textfied.keyboardType = (textfied?.keyboradType)!
            self.textfied.keyboardAppearance = .dark
            self.textfied.autocorrectionType = .no
            self.textfied.addTarget(self, action: #selector(dalalert.EnableDisableButton), for: UIControlEvents.editingChanged)
            
            containerView.addSubview(self.textfied)
            
            //
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            EnableDisableButton()
            
            
        }
        // geting every in palce
        Setup()
        // show in the main screen
       
        
    }
    
    public func show(){
        appear(viewController: self.rootViewController)

    }
    
    /// Adding action for button which is not cancel button
    ///
    /// - Parameter action: func which gets executed when disapearing
    
    @objc  func buttonTap() {
        
        if closeAction != nil{
            
            if let action = self.closeAction {
                if self.textfiedOption != nil{
                    action(self.textfied.text!)
                    
                }else{
                    action("has been done")
                }
            }
        }
    }
     func addAction(_ action: @escaping (String) -> Void) {
        
        self.closeAction = action
        
    }
   private func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = keyboardFrame.height
        //5
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            //   self.button.constant += changeInHeight
            
            if show{
                print(self.viewHeight as Any)
                
                
                self.button.center.y = self.viewHeight! - (changeInHeight + 45)
                
                if self.viewHeight!<=650{
                    
                    if self.textfiedOption != nil && (self.titleLabel != nil){
                        
                        self.textfied.frame.origin.y = self.button.frame.origin.y - ( self.textfied.frame.height + 50)
                        
                        self.titleLabel.frame.origin.y = self.textfied.frame.origin.y - ( self.titleLabel.frame.height)
                        
                        
                        self.titleLabel.alpha = 0
                        
                    }else{
                        
                        self.textfied.frame.origin.y = self.button.frame.origin.y - ( self.textfied.frame.height + 50)
                        
                    }
                    self.iconImageView.frame.origin.y =  self.textfied.frame.origin.y - ( self.iconImageView.frame.height + 50)
                    
                }
                
            }else{
                
                
                for reYp in self.yPostionArray{
                    
                    if reYp.name == .icon{
                        self.iconImageView.frame.origin.y  = reYp.yp
                        
                    }
                    if reYp.name == .button{
                        self.button.center.y = reYp.yp
                        
                    }
                    if reYp.name == .lable{
                        
                        if self.textfiedOption != nil && (self.titleLabel != nil){
                            self.titleLabel.frame.origin.y = reYp.yp
                            self.titleLabel.alpha = 1
                            
                            
                            
                        }else{
                            self.titleLabel.frame.origin.y = reYp.yp
                            
                        }
                    }
                    if reYp.name == .textfield{
                        self.textfied.frame.origin.y = reYp.yp
                        
                    }
                }
                
                
                
            }
            
            
            
        })
        
    }
    
    override internal func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        iskeyBUp = true
        adjustingHeight(show: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
        iskeyBUp = false
        
    }
    
    
    
    
    
    /// Removes view
    ///
    /// - Parameters:
    ///   - withCallback: callback availabel
    ///   - source: Type of removing view see ActionType
     func closeView(_ withCallback: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
        }, completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                self.view.alpha = 0
            }, completion: { finished in
                self.dismiss(animated: false, completion: {
                    
                    if withCallback {
                        if let action = self.closeAction {
                            if self.textfiedOption != nil{
                                action(self.textfied.text!)
                                
                            }else{
                                action("has been done")
                            }
                        }
                        
                    }else{
                        if (self.respond != nil){
                            
                            self.respond(.FAILED)
                            
                        }
                        
                    }
                    self.removeView()
                })
            })
        })
    }
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        EnableDisableButton()
        
        self.textfied.resignFirstResponder()
        return true
    }
    
    
    @objc private func EnableDisableButton()  {
        
        if textfiedOption.MustHasData == true{
            //  print("textfied.text",textfied.text!)
            if textfied.text! == "" {
                button.isEnabled = false
                button.alpha = 0.5
            }else{
                button.alpha = 1
                button.isEnabled = true
                
            }
            
            
            
            
        }
    }
    
    /// Removes view from superview
    private func removeView() {
        isAlertOpen = false
        removeFromParentViewController()
        view.removeFromSuperview()
        UIApplication.shared.isStatusBarHidden = false
        
    }
    
    
    /// Returns rootViewControllers size
    ///
    /// - Returns: root view controller size
    private func rootViewControllerSize() -> CGSize {
        let size = rootViewController.view.frame.size
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            return CGSize(width: size.height, height: size.width)
        }
        return size
    }
    
    
    /// Gets screen size
    ///
    /// - Returns: screen size
    private func screenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            return CGSize(width: screenSize.height, height: screenSize.width)
        }
        return screenSize
    }
    
    
    /// Tracks touches used when there are no buttons to remove view
    ///
    /// - Parameters:
    ///   - touches: touched actions form user
    ///   - event: touches event
    internal override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let locationPoint = touch.location(in: view)
            let converted = view.convert(locationPoint, from: view)
            if view.point(inside: converted, with: event){
                if noButtons {
                    //  closeView(true)
                }
                if iskeyBUp {
                    
                    if !view.point(inside: touch.location(in: button), with: event) {
                        self.textfied.resignFirstResponder()
                        
                    }
                    EnableDisableButton()
                    
                }
                
            }
        }
    }
}

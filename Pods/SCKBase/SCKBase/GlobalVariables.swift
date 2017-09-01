//
//  GlobalVariables.swift
//  Spotit
//
//  Created by Jean-Louis Murphy on 2017-04-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


public struct user {
      public static let def : UserDefaults = UserDefaults.standard
}

public struct control {
    
      public static let checkout: Bool = false
    
    
}

enum Devices: CGSize {
    case iPhone3GS = "{320, 480}"
    case iPhone5 = "{320, 568}"
    case iPhone6 = "{375, 667}"
    case iPhone6Plus = "{414, 736}"
}

extension CGSize: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let size = CGSizeFromString(value)
        self.init(width: size.width, height: size.height)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        let size = CGSizeFromString(value)
        self.init(width: size.width, height: size.height)
    }
    
    public init(unicodeScalarLiteral value: String) {
        let size = CGSizeFromString(value)
        self.init(width: size.width, height: size.height)
    }
}

public enum httpMet : StringLiteralType {
    
    case post
    case get
    case delete
    
    init() {
        self = httpMet(rawValue: "GET")!
    }
    
    public var value : String {
        switch self {
        case .post : return "POST"
        case .get : return "GET"
        case .delete : return "DELETE"
        }
    }
}

public enum node {
    
    case profile
    
}

public enum omniWallet {
    
    case all, id, balances
    
}

public enum actions {
    case update
}

public struct payment {
    
      public static let types : Array<String> = ["amex", "mastercard", "visa", "interac", "debit"]
    public enum type {
        case visa, mastercard, amex, debit, interac
    }
}


public struct strings {
      public static let fromPerson: String = "is asking you to pay"
      public static let fromCheckout: String = "This bill is from"
      public static let sendToPeer: String = "Please confirm the details of this transfer"
      public static let sendToCheckout: String = "Please confirm the details of this payment"
      public static let actPeer: String = "send"
      public static let actCheckout: String = "pay"
      public static let peerPayee: String = "Send to:"
      public static let checkoutPayee: String = "Merchant:"
      public static let tIDSending: String = "Sending"
      public static let didSeedStore : String = "didSeedPersistentStore"
}

public struct estrings {
    
      public static let userTokError : String = "USER DEFAULT ERROR: No string associated with key:"
    
}

public struct screen {
      public static let height: CGFloat = (UIApplication.shared.keyWindow?.frame.height)!
      public static let width: CGFloat = (UIApplication.shared.keyWindow?.frame.width)!
}

public struct cells {
    
      public static let window = UIApplication.shared.keyWindow
      public static let methodCell: CGFloat = CGFloat(70/667) * screen.height
      public static let tipCell: CGFloat = screen.height * 0.25
      public static let chatcellBorder : CGFloat = 0.5
      public static let chatCellColor : UIColor = UIColor.white
    
}

public struct colors {
      public static let darkenedTransparentBackground : UIColor = UIColor.init(white: 0.5, alpha: 0.5)
      public static let lessBlueMainColor : UIColor = UIColor.rgb(red: 10, green: 120, blue: 190)
      public static let lightBlueMainColor : UIColor = UIColor.rgb(red: 17, green: 142, blue: 203)
      public static let skyBlueMainColor : UIColor = UIColor.rgb(red: 102, green: 204, blue: 255)
    
      public static let lineColor : UIColor = UIColor.rgb(red: 60, green: 63, blue: 75)//UIColor.rgb(red: 39, green: 41, blue: 49)
      public static let turquoiseColor : UIColor = UIColor.rgb(red: 22, green: 149, blue: 203)
      public static let limeColor : UIColor = UIColor.rgb(red: 0, green: 255, blue: 128)
      public static let orchidColor : UIColor = UIColor.rgb(red: 102, green: 102, blue: 255)
      public static let springGreen : UIColor = UIColor.rgb(red: 0, green: 255, blue: 0)
    
      public static let purplishColor : UIColor = UIColor.rgb(red: 63, green: 79, blue: 186)
      public static let darkPurplishColor : UIColor = UIColor.rgb(red: 64, green: 0, blue: 128)
      public static let highlightedPurplishColor: UIColor = UIColor.rgb(red: 43, green: 59, blue: 136)
    
      public static let warningOrange: UIColor = UIColor.rgb(red: 255, green: 128, blue: 0)
    
      public static let clearViu = UIColor.init(white: 0.5, alpha: 0.15)
      public static let blueishLightBorder: UIColor = UIColor.rgb(red: 122, green: 143, blue: 143)
      public static let greenColor: UIColor = UIColor.rgb(red: 22, green: 137, blue: 48)
      public static let backcolorfortest : UIColor = UIColor.rgb(red: 247, green: 252, blue: 249)//UIColor.rgb(red: 255, green: 249, blue: 236)
      public static let standardBorder: UIColor = UIColor.rgb(red: 58, green: 69, blue: 69)
    
    //TabBar
      public static let mainButtonColor: UIColor = lineColor//greenColor//UIColor.rgb(red: 22, green: 219, blue: 48)
      public static let mainButtonBorderColor : UIColor = lineColor
      public static let tabBarTintColor : UIColor = UIColor.rgb(red: 246, green: 246, blue: 246)
      public static let tabBarItemSelected : UIColor = lightBlueMainColor
    
    
    //navBar
      public static let navBarTintColor : UIColor = tabBarTintColor//lightBlueMainColor//backcolorfortest //UIColor.rgb(red: 246, green: 246, blue: 235)//tabBarTintColor
      public static let navBarTitleColor : UIColor = lightBlueMainColor//lightBlueMainColor//lineColor
      public static let navBarBorderColor : UIColor = lineColor//lineColor
      public static let methodsBack = UIColor.rgb(red: 193, green: 193, blue: 200)
      public static let navBarButtonColor : UIColor = purplishColor
    
    //SideList
      public static let sideMenuHigh: UIColor = UIColor.rgb(red: 58, green: 69, blue: 69)
      public static let shadowColor1: CGColor = UIColor.black.withAlphaComponent(0.4).cgColor
      public static let shadowColor2: CGColor = UIColor.clear.cgColor
      public static let methodCell: CGColor = UIColor.rgb(red: 58, green: 69, blue: 69).cgColor
      public static let tipBack : UIColor = UIColor.rgb(red: 235, green: 235, blue: 241)
      public static let greenSlider: Int = 137
      public static let blockButtonColor: UIColor = UIColor.rgb(red: 105, green: 18, blue: 0)
      public static let locSearchBarTintColor : UIColor = UIColor.rgb(red: 236, green: 235, blue: 234)
      public static let chatTextInputBox : UIColor = UIColor.rgb(red: 252, green: 250, blue: 250)
      public static let sideMenuCellTextColor : UIColor = backcolorfortest
    
    //ProfileTab
      public static let profileViewButtonColor : UIColor = purplishColor
    //EditProfile
      public static let editProfileContainerColor: UIColor = UIColor.rgb(red: 165, green: 221, blue: 250)
      public static let toneForEditProfileContainer : UIColor = UIColor.rgb(red: 235, green: 240, blue: 244)
    
    //Login
      public static let loginTfBack: UIColor = UIColor.white
      public static let loginContainer: UIColor = UIColor.white.withAlphaComponent(0.7)
    
    //signoutcolors
    
    
      public static let signoutFromInterface : UIColor = UIColor.rgb(red: 137, green: 0, blue: 100)
    
    public struct accountController {
        
          public static let selectorSubviewTab : UIColor = UIColor.rgb(red: 210, green: 214, blue: 224)
        public struct navBar {
            
              public static let background : UIColor = colors.loginTfBack
            
        }
    }
    
      public static let selector_background : UIColor = colors.lineColor
      public static let controller_main_backGround : UIColor = UIColor.rgb(red: 218, green: 224, blue: 234)
}


public struct paymentcards {
      public static let visablue: UIColor = UIColor.rgb(red: 20, green: 20, blue: 72)
      public static let visalightblue : UIColor = UIColor.rgb(red: 25, green: 25, blue: 77)
}

public struct fonts {
    
      public static let navTitle : UIFont = UIFont.systemFont(ofSize: 20)
    
      public static let navItem : UIFont = UIFont.systemFont(ofSize: 15)
    
      public static let viewTitle : UIFont = UIFont.systemFont(ofSize: 16)
      public static let primaryButton : UIFont = UIFont.systemFont(ofSize: 15)
      public static let secButton : UIFont = UIFont.systemFont(ofSize: 15)
    
      public static let primaryButtonBold : UIFont = UIFont.boldSystemFont(ofSize: 15)
      public static let secButtonBold : UIFont = UIFont.boldSystemFont(ofSize: 15)
    
      public static let editProfileNameLabel : UIFont = UIFont.boldSystemFont(ofSize: 25)
      public static let editProfilePreviewSubLabel : UIFont = UIFont.boldSystemFont(ofSize: 20)//boldSystemFont(ofSize: 20)
    
      public static let checkoutMerchBold : UIFont = UIFont.boldSystemFont(ofSize: 18)
      public static let checkoutMerch : UIFont = UIFont.systemFont(ofSize: 18)
    
    public struct checkout {
          public static let numberPad : UIFont = UIFont.systemFont(ofSize: 25)
          public static let boldNumberPad : UIFont = UIFont.boldSystemFont(ofSize: 25)
        
          public static let amount : UIFont = UIFont.systemFont(ofSize: 60)
        
    }
    
    public struct createFlow {
        
          public static let maintitle: UIFont = UIFont.boldSystemFont(ofSize: 25)
          public static let mainsubtitle: UIFont = UIFont.boldSystemFont(ofSize: 20)
          public static let subtitle: UIFont = UIFont.boldSystemFont(ofSize: 15)
        
          public static let textField: UIFont = UIFont.boldSystemFont(ofSize: 20)
        
          public static let bankformsearch: UIFont = UIFont.boldSystemFont(ofSize: 25)
        
        
        
    }
    public struct accountController {
        public struct subviews {
            public struct pushController {
                  public static let cellTitle : UIFont = UIFont.systemFont(ofSize: 17)
                  public static let boldCellTitle : UIFont = UIFont.boldSystemFont(ofSize: 17)
                  public static let sectionTitle : UIFont = UIFont.boldSystemFont(ofSize: 15)
                  public static let sectionSubTitle : UIFont = UIFont.systemFont(ofSize: 13)
            }
        }
        
        public struct actionViews {
              public static let mainTitle : UIFont = UIFont.boldSystemFont(ofSize: 25)
              public static let subSectionTitle : UIFont = UIFont.boldSystemFont(ofSize: 18)
              public static let subSubSectionTitle : UIFont = UIFont.boldSystemFont(ofSize: 15)
              public static let actionable : UIFont = UIFont.boldSystemFont(ofSize: 18)
        }
        
    }
}

public struct checkColors {
      public static let signupGreen : UIColor = UIColor.rgb(red: 79, green: 213, blue: 61)
}

public struct keyboard {
      public static let alph: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIKLMNOPQRSTUVWXYZ!@#$%^&*()_-=+}{|:'/<>?()[]"
      public static let lowercase : String = "abcdefghijklmnopqrstuvwxyz"
      public static let uppercase : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      public static let guillemet : String = ""
      public static let symbols : String = "!@#$%^&*()_+}{|:'/<>?()[],.;-="
      public static let digits : String = "1234567890"
      public static let all : String = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIKLMNOPQRSTUVWXYZ!@#$%^&*()_-=+}{|:'/<>?()[]"
}

public struct screenLock {
    
      public static let val : Bool = true
}

public struct buttonSizes {
    
    
      public static let buttonPadding : CGFloat = 16
      public static let mainheight: CGFloat = 667 * (0.16 * 0.8 * 0.5)
    
      public static let textfcellheight: CGFloat = ((UIScreen.main.bounds.height * 0.3 * 0.75) - 16) * (1/3)
      public static let textinputSectionPadding : CGFloat = textfcellheight * 1.5
      public static let tfPadding : CGFloat = 8
    
}

public struct DeviceInfo {
    public struct current {
        
          public static var model : String {
            get {
                return "iPhone 6S"
            }
        }
        
    }
}

public struct cardSizes {
    
    public struct wallet {
          public static var size : CGSize {
            get {
                let h = 375 * 0.4 * 0.9 * 0.1
                return CGSize(width: h * 12, height: h * 8)
            }
        }
    }
    
}



public struct sliderviews {
    public struct pads {
          public static let openedWithTab : CGFloat = 48 * 0.8
          public static let closedWithTab : CGFloat = 0
    }
    
    public struct cards {
          public static let applePayEdit : CGSize = CGSize(width: screen.width * 0.8, height: screen.height * 0.35)
    }
    
    public struct tabBar {
        
    }
}

public struct cellForSetting {
    
      public static var size : CGSize = CGSize(width: screen.width, height: 47.25)
    
}

public struct loginSizes {
    public struct signUp {
          public static var subScroll : CGSize {
            get {
                let it = CGSize(width: 375, height: 604.31)
                guard screen.width > 325 else {
                    guard screen.height > 465 else {
                        return CGSize(width: 320, height: 460 - 20 - buttonSizes.mainheight)
                    }
                    return CGSize(width: 320, height: it.height)
                }
                guard screen.height > 465 else {
                    guard screen.width > 325 else {
                        return CGSize(width: 320, height: 460 - 20 - buttonSizes.mainheight)
                    }
                    return CGSize(width: it.width, height: 460 - 20 - buttonSizes.mainheight)
                }
                return it
            }
        }
        
          public static let nextButton: CGSize = CGSize(width: subScroll.width * 0.9, height: buttonSizes.mainheight)
          public static var compLabelPad : CGFloat {
            get {
                return ((16 * 2) + 10)
            }
        }
    }
}

public struct accountStruct {
    struct controller {
          public static let subviewPadding : CGFloat = screen.height * 0.025
          public static let subviewPaddingSide : CGFloat = screen.height * 0.05
          public static let selector : CGSize = CGSize(width: 300, height: screen.height)
          public static let subview : CGSize = CGSize(width: (screen.width - selector.width) - (subviewPaddingSide * 2), height: screen.height - (buttonSizes.mainheight * 2) - (subviewPadding * 2))
          public static let subviewCenterY : CGFloat = (buttonSizes.mainheight * 2) + ((screen.height - (buttonSizes.mainheight * 2)) / 2)
          public static let subviewOpenCent : CGFloat = screen.width - (subview.width / 2) - subviewPaddingSide
        
    }
    struct color {
          public static let selector_background : UIColor = colors.lineColor
          public static let lighter_controller_main_backGround : UIColor = UIColor.rgb(red: 228, green: 234, blue: 244)
          public static let slider_controller_main_backGround : UIColor = UIColor.rgb(red: 250, green: 250, blue: 250)
          public static let controller_main_backGround : UIColor = UIColor.rgb(red: 218, green: 224, blue: 234)
    }
}

public struct Spotit {
      public static let loginSize : CGSize = CGSize(width: 375, height: 667)
}

public struct interfaces {
    
      public static var interfaceview : CGSize {
        get {
            let mx = max(UIScreen.main.bounds.width, 1024)
            return CGSize(width: mx, height: 768)
        }
    }
    
      public static var interfacescrollsubview : CGSize {
        get {
            return CGSize(width: 1024, height: 573.848)
        }
    }
    
      public static var scrollsubcenter : CGFloat {
        get {
            let top : CGFloat = 125
            let H : CGFloat = screen.height / 2
            let h : CGFloat = interfaces.interfacescrollsubview.height / 2
            let inth : CGFloat = interfaces.interfaceview.height / 2
            
            let diff = H - inth
            
            guard diff >= top else {
                
                return h + top - diff
            }
            return inth
        }
    }
    
    //= CGSize(width: 1024, height: 573.848)
}

public struct mapviews {
    public struct legal {
          public static let bottomLayoutPadding: CGFloat = 60
    }
}


public struct placeholders {
    
    
      public static let cheque : CGSize = CGSize(width: 824, height: 350)
    
}


public struct cornerRadii {
    
      public static let checkout: CGFloat = screen.height * 0.1 * 0.5
    
}

public struct mainbuttonconf {
    
      public static let window = UIApplication.shared.keyWindow?.frame.width
    
      public static let size : CGFloat = window! * (50 / 375)
    
}

public struct notifications {
    
    public struct sso {
          public static let tokenAcquiring : String = "GettingTheTokenFromOmni"
    }
    
    public struct data {
        
          public static let entreData : String = "EntreCanApplyData"
        
    }
    
    public struct calls {
          public static let confirmedAcceptPayment : String = "paymentWasAcceptedAndConfirmedFromBillView"
          public static let paymentRecievedAndAcceptedFromCustomer : String = "customerAcceptedAPaymentRequestForGoodsAndServices"
          public static let transferRequestRecievedAndAcceptedFromCustomer : String = "peerIndividualAcceptedATransferRequestForAGoodReason"
          public static let confirmedCreatePaymentRequest : String = "paymentRequestWasConcievedSuccessfullyFromCreatePaymentView"
    }
    
    public struct notifsHandlers {
        
        
          public static let nameForObjectInActorBack : String = "notificationRequestRecievedFromActiveOrBackgroundStateHandleIt"
    }
    
    
}

public struct ids {
      public static let uuid : String = "uuid"
      public static let upid : String = "upid"
      public static let iss : String = "iss"
      public static let sub : String = "sub"
      public static let waid : String = "waid"
}

public struct merchant {
      public static let appleId : String = "merchant.com.Spotit.Spotit"
}
public struct stripe {
    
      public static let pubTest : String = "pk_test_kHVxbB2Wp3zfKEAntcACHP2R"//"pk_test_AwHwYfKC8w5vNmEz5D4cnCGV"//pk_test_kHVxbB2Wp3zfKEAntcACHP2R"
      public static let publive : String = "pk_live_F9sDblecifMfzItAtoB6ztDW"
}


public struct obsKeys {
      public static let remSidePan : String = "sidePanToBeRemovedSinceNavControllerGoingToSecView"
      public static let addSidePan : String = "placeSidePanBackSinceNavControllerReturningToTabBar"
      public static let profileHasChanged : String = "profileEditorHasChangedUserProfileSoUpdate"
      public static let sendProfileHasChanged : String = "tellTabsToUpdateUIsNow"
    //Profile tab activity indicators
      public static let walletActivityBegins : String = "WalletHasSomeActivityHappening"
      public static let walletActivityEnd : String = "WalletHadSomeActivityHappeningSoEndActivity"
      public static let pointsActivityBegins : String = "PointsHasSomeActivityHappening"
      public static let pointsActivityEnd : String = "PointsHadSomeActivityHappeningSoEndActivity"
    
      public static let checkIndicatorEngage : String = "EngageTheCheckingIndicator"
}

public enum ComponentOfDate {
    case day, month, year
}


public enum CurveDirection {
    case left, right
}

public enum viewSides {
    case left, right, top, bottom
    
}

public enum contrastSides {
    case left, right, top, bottom, topRight, topLeft, bottomLeft, bottomRight
}

public enum ContrastSides {
    case left, right, top, bottom, topRight, topLeft, bottomLeft, bottomRight
}

public enum ContrastSide: String {
    case left = "left"
    case right = "right"
    case bottom = "bottom"
    case top = "top"
    case topLeft = "topLeft"
    case topRight = "topRight"
    case bottomRight = "bottomRight"
    case bottomLeft = "bottomLeft"
    
    init() {
        self = ContrastSide(fromRaw: "left")
    }
    
    init(fromRaw: String) {
        self = ContrastSide(fromRaw: fromRaw)
    }
    
    func toContrast() -> contrastSides {
        guard self.rawValue != "left" else {
            return .left
        }
        guard self.rawValue != "right" else {
            return .right
        }
        guard self.rawValue != "bottom" else {
            return .bottom
        }
        guard self.rawValue != "top" else {
            return .top
        }
        guard self.rawValue != "topLeft" else {
            return .topLeft
        }
        guard self.rawValue != "topRight" else {
            return .topRight
        }
        guard self.rawValue != "bottomRight" else {
            return .bottomRight
        }
        return .bottomLeft
    }
}

public enum tokenTypes {
    
    case fb, omni, spotit, device
}

public enum userInfos {
    
    case firstName, lastName, sex, age, email, pin, uuid, sub, upid, iss, waid
    
}

public enum Encryptable {
    
    case firstName, lastName, sex, age, email, pin, uuid, sub, upid, iss, waid, fb, spotit, device
    
}

public enum LoginInfos {
    
    case firstLogin, lastLogin, tokenBirth
    
}

public enum LoginStatus {
    
    case isLoggedIn, notLoggedIn
    
}

public enum loginType {
    
    case uiweb, wkweb, safarivc
}

public enum SafariRoots {
    case viewController, customTabBar, viewControllerSignUp, viewControllerError, download, tabBarNotification
}

public enum syncronize {
    case sync, no
}

public enum timeLabelType {
    case precise, relative
}

public enum methodTypes {
    case legacy, bitcoin, operatingSystem, ripple, giftCards
}

public enum ViewCorner {
    
    case topRight, topLeft, bottomRight, bottomLeft
}


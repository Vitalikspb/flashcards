//
//  HelloViewController.swift


import UIKit
import AttributedString
import SnapKit
import StoreKit
import SwiftyStoreKit

final class SubscriptionViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var closeView = UIView()
    private lazy var closeImage = UIImageView()
    private lazy var restoreButton = UILabel()
    
    private lazy var titleLabel = UILabel()
    private lazy var titleImage = UIImageView()
    private lazy var featureStackView = UIStackView()
    private lazy var feature1 = FeatureHorizontalView()
    private lazy var feature2 = FeatureHorizontalView()
    private lazy var feature3 = FeatureHorizontalView()
    
    private lazy var priceGroup = PriceGroup()
    private lazy var oneMonthView = PriceView()
    private lazy var yearPriceView = PriceView()
    private lazy var sixMonthPriceView = PriceView()
    
    private lazy var buyButton = BuyButton()
    private lazy var privacyLabelLeft = PrivacyLabel()
    private lazy var privacyLabelRight = PrivacyLabel()
    
//    private let purchaseManager = PurchaseManager.shared
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Private Proporties
    private lazy var oneMonthPrice = ""
    private lazy var oneMonthTitle = ""
    private lazy var sixMonthPrice = ""
    private lazy var sixMonthTitle = ""
    private lazy var oneYearPrice = ""
    private lazy var oneYearTitle = ""
    private var currentSubscriptionID: String = AppProducts.twelveMonth.rawValue {
        didSet {
            updateBuyButton()
        }
    }
    
    // MARK: - Life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        selectedPriceChanged()
        setupPurchases()
//        loadPurchase()
        setupConstraints()
        setupNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayoutView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SubscriptionViewController {
    func setupNotifications() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(reloadData),
//                                               name: NSNotification.Name(PurchaseManager.productNotificationIdentifier),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(completeTwelveMonthConsumable),
//                                               name: NSNotification.Name(AppProducts.twelveMonth.rawValue),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(completeSixMonthConsumable),
//                                               name: NSNotification.Name(AppProducts.sixMonth.rawValue),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(completeOneMonthConsumable),
//                                               name: NSNotification.Name(AppProducts.oneMonth.rawValue),
//                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(failureToRestore),
                                               name: NSNotification.Name(PurchaseReceiveMessage.failToRestore.rawValue),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(successToRestore),
                                               name: NSNotification.Name(PurchaseReceiveMessage.successToRestore.rawValue),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(failureToRestore),
                                               name: NSNotification.Name(PurchaseReceiveMessage.cancelToRestore.rawValue),
                                               object: nil)
        
    }
    @objc func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func reloadData() {
        setupPurchases()
        updateBuyButton()
    }
}

extension SubscriptionViewController {
    func presentError() {
        let alertController = CreateAlerts.errorAlert(with: AppSource.Text.Shared.errorWithPurchase,
                                                      and: AppSource.Text.Shared.tryAgainLater)
        self.present(alertController, animated: true, completion: nil)
    }
    func presentErrorWithMessage(_ message: String) {
        let alertController = CreateAlerts.errorAlert(with: AppSource.Text.Shared.errorWithPurchase,
                                                      and: message)
        self.present(alertController, animated: true, completion: nil)
    }
    func successEndOfPurchase() {
        failureEndOfRestore()
        dismiss(animated: true, completion: nil)
    }
    func failureEndOfRestore() {
        buyButton.isLoading = false
        buyButton.isUserInteractionEnabled = true
        restoreButton.isUserInteractionEnabled = true
    }
    @objc func successToRestore() {
        successEndOfPurchase()
    }
    @objc func failureToRestore() {
        failureEndOfRestore()
        presentError()
    }
//    @objc func completeOneMonthConsumable() {
//        addedExpDate(month: 1)
//        successEndOfPurchase()
//    }
//    @objc func completeSixMonthConsumable() {
//        addedExpDate(month: 6)
//        successEndOfPurchase()
//    }
//    @objc func completeTwelveMonthConsumable() {
//        addedExpDate(month: 12)
//        successEndOfPurchase()
//    }

    @objc func selectedPriceChanged() {
        switch priceGroup.selectedIndex {
        case 0: currentSubscriptionID = AppProducts.twelveMonth.rawValue
        case 1: currentSubscriptionID = AppProducts.sixMonth.rawValue
        case 2: currentSubscriptionID = AppProducts.oneMonth.rawValue
        default:
            print("error id")
        }
    }
    func setPremium(_ premium: Bool) {
        
        if premium {
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(true, forKey: UserDefaults.premium)
            dismiss(animated: true, completion: nil)
        }
        buyButton.isLoading = false
        restoreButton.isUserInteractionEnabled = true
    }
    
    func setupPurchases() {

        SwiftyStoreKit.retrieveProductsInfo([AppProducts.twelveMonth.rawValue]) { result in
            if let product = result.retrievedProducts.first {
                self.oneYearPrice = product.localizedPrice!
                self.oneYearTitle = product.localizedTitle
                self.yearPriceView.do {
                    $0.priceLabel.text = self.oneYearPrice
                    $0.periodLabel.text = self.oneYearTitle
                }
                self.updateBuyButton()
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
        SwiftyStoreKit.retrieveProductsInfo([AppProducts.sixMonth.rawValue]) { result in
            if let product = result.retrievedProducts.first {
                    self.sixMonthPrice = product.localizedPrice!
                    self.sixMonthTitle = product.localizedTitle
                self.sixMonthPriceView.do {
                    $0.priceLabel.text = self.sixMonthPrice
                    $0.periodLabel.text = self.sixMonthTitle
                }
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
        SwiftyStoreKit.retrieveProductsInfo([AppProducts.oneMonth.rawValue]) { result in
            if let product = result.retrievedProducts.first {
                self.oneMonthPrice = product.localizedPrice!
                self.oneMonthTitle = product.localizedTitle
                self.oneMonthView.do {
                    $0.priceLabel.text = self.oneMonthPrice
                    $0.periodLabel.text = self.oneMonthTitle
                }
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
        
    }
    
    func updateBuyButton() {
        var price = oneYearPrice
        var period = oneYearTitle
        switch currentSubscriptionID {
        case AppProducts.twelveMonth.rawValue:
            price = oneYearPrice
            period = oneYearTitle
        case AppProducts.sixMonth.rawValue:
            price = sixMonthPrice
            period = sixMonthTitle
        case AppProducts.oneMonth.rawValue:
            price = oneMonthPrice
            period = oneMonthTitle
        default:
            print("currentSubscriptionID error")
        }
        let top: [AttributedString.Attribute] = [
            .font(UIFont.systemFont(ofSize: 16, weight: .semibold)),
            .foreground(.black),
        ]
        
        let bottom: [AttributedString.Attribute] = [
            .font(UIFont.systemFont(ofSize: 15, weight: .regular)),
            .foreground(.black),
        ]
        
        buyButton.titleLabel.attributed.text = AttributedString(string: AppSource.Text.Shared.continueBuyButton, with: top) + "\n" + AttributedString(string: "\(price) / \(period)", with: bottom)
        
    }
    
    @objc func restoreTapped() {
        buyButton.isUserInteractionEnabled = false
        buyButton.isLoading = true
        restoreButton.isUserInteractionEnabled = false
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                self.presentErrorWithMessage("Failed restore purchase")
                self.setPremium(false)
                }
                else if results.restoredPurchases.count > 0 {
                    for purchase in results.restoredPurchases {
                        let downloads = purchase.transaction.downloads
                        if !downloads.isEmpty {
                            SwiftyStoreKit.start(downloads)
                        } else if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                    }
                    self.verifySubscriptions([.twelveMonth, .sixMonth, .oneMonth])
                    
                }
                else {
                    self.presentErrorWithMessage("Failed restore purchase")
                    self.setPremium(false)
                }
        }
    }
    
    @objc func buyTapped() {
        buyButton.isLoading = true
        restoreButton.isUserInteractionEnabled = false
        SwiftyStoreKit.purchaseProduct(currentSubscriptionID, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                self.verifyReceipt { (result) in
                    switch result {
                    case .success(receipt: let receipt):
                        print("receipt verify success: \(receipt.description)")
                    case .error(error: let error):
                        print("\(error.localizedDescription)")
                    }
                }
                self.verifyPurchase(AppProducts(rawValue: purchase.productId)!)
                self.verifySubscriptions([.twelveMonth, .sixMonth, .oneMonth])
                self.setPremium(true)
                self.buyButton.isLoading = false
                self.restoreButton.isUserInteractionEnabled = true
            case .error(let error):
                switch error.code {
                case .unknown: self.presentErrorWithMessage("Unknown error. Please contact support")
                case .clientInvalid: self.presentErrorWithMessage("Not allowed to make the payment")
                case .paymentCancelled: self.presentErrorWithMessage("Payment Cancelled")
                case .paymentInvalid: self.presentErrorWithMessage("The purchase identifier was invalid")
                case .paymentNotAllowed: self.presentErrorWithMessage("The device is not allowed to make the payment")
                case .storeProductNotAvailable: self.presentErrorWithMessage("he product is not available in the current storefront")
                case .cloudServicePermissionDenied: self.presentErrorWithMessage("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: self.presentErrorWithMessage("Could not connect to the network")
                case .cloudServiceRevoked: self.presentErrorWithMessage("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
        
    }
    @objc func privacyLabelRightTapped() {
        UIApplication.shared.open(AppSource.Constants.privacyPolicyURL)
    }
    @objc func privacyLabelLeftTapped() {
        UIApplication.shared.open(AppSource.Constants.termsOfUseURL)
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: AppSource.Constants.verifySharedKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func verifyPurchase(_ purchase: AppProducts) {
        verifyReceipt { result in
            switch result {
            case .success(let receipt):
                let productId = AppProducts.oneMonth.rawValue
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable,
                                                                       productId: productId,
                                                                       inReceipt: receipt)
            case .error:
                print("result: \(result)")
            }
        }
    }
    func verifySubscriptions(_ purchases: Set<AppProducts>) {
        verifyReceipt { result in
            switch result {
            case .success(let receipt):
                let productIds = Set(purchases.map { $0.rawValue })
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
//                self.presentErrorWithMessage("Success restore purchase")
                self.setPremium(true)
            case .error:
                print("result error: \(result)")
            }
        }
    }
    
}

// MARK: - Setup
private extension SubscriptionViewController {
    
    func setupLayoutView() {
        buyButton.layer.cornerRadius = 15
        buyButton.layer.masksToBounds = true
    }
    
    func setupColors() {
        view.backgroundColor = AppSource.Color.background
        restoreButton.backgroundColor = .clear
        closeImage.backgroundColor = .clear
        closeView.backgroundColor = .clear
    }
    
    func setupView() {
        setupColors()
        setupPurchases()
        view.layer.masksToBounds = true
        
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
            $0.text = AppSource.Text.Shared.getPremium
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            
        }
        restoreButton.do {
            $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            $0.text = AppSource.Text.Shared.restore.uppercased()
            $0.textColor = AppSource.Color.textColor
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(restoreTapped))
            $0.addGestureRecognizer(tap)
        }
        closeView.do {
            
            $0.addSubview(closeImage)
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
            $0.addGestureRecognizer(tap)
        }
        closeImage.do {
            $0.image = AppSource.Image.close
            $0.tintColor = AppSource.Color.textColor
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
            $0.addGestureRecognizer(tap)
        }
        titleImage.do {
            $0.image = AppSource.Image.logo
            $0.contentMode = .scaleAspectFill
            $0.isHidden = UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue ? true : false
        }
        featureStackView.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 2
            $0.addArrangedSubview(feature1)
            $0.addArrangedSubview(feature2)
            $0.addArrangedSubview(feature3)
        }
        feature1.do {
            $0.imageView.image = AppSource.Image.noAds
            $0.imageView.image?.withTintColor(.white)
            $0.titleLabel.text = AppSource.Text.Shared.noAds
            $0.titleLabel.textColor = AppSource.Color.textColor
            $0.titleLabel.numberOfLines = 2
            $0.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.backgroundColor = .clear
        }
        feature2.do {
            $0.imageView.image =  AppSource.Image.useLibrary
            $0.imageView.image?.withTintColor(.white)
            $0.titleLabel.text = AppSource.Text.Shared.useLibrary
            $0.titleLabel.textColor = AppSource.Color.textColor
            $0.titleLabel.numberOfLines = 2
            $0.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.backgroundColor = .clear
        }
        feature3.do {
            $0.imageView.image =  AppSource.Image.allFunctions
            $0.imageView.image?.withTintColor(.white)
            $0.titleLabel.text = AppSource.Text.Shared.workWithAllFunction
            $0.titleLabel.textColor = AppSource.Color.textColor
            $0.titleLabel.numberOfLines = 2
            $0.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.backgroundColor = .clear
        }
        [oneMonthView, sixMonthPriceView, yearPriceView].forEach {
            $0.selectedTextColor = AppSource.Color.textColor
            $0.unselectedTextColor = AppSource.Color.textColor
            $0.selectedBackgroundColor = AppSource.Color.subscriptionRed
            $0.unselectedBackgroundColor = .clear
            $0.unselectedElementColor = .lightGray
            $0.selectedElementColor =  AppSource.Color.subscriptionBorderRed
            $0.layer.cornerRadius = 12
        }
        priceGroup.do {
            $0.addItems(priceViews: [yearPriceView, sixMonthPriceView, oneMonthView])
            $0.axis = .vertical
            $0.spacing = 18
            $0.selectedIndex = 0
            $0.addTarget(self, action: #selector(selectedPriceChanged), for: .valueChanged)
        }
        buyButton.do {
            $0.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
            $0.backgroundColor = AppSource.Color.backgroundActionButton
            $0.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            $0.titleLabel.textColor = AppSource.Color.textColor
        }
        privacyLabelLeft.do {
            let terms = AttributedString(string: AppSource.Text.Shared.termsOfUse, with: [
                .font(.systemFont(ofSize: 14, weight: .regular)),
                .foreground(AppSource.Color.textColor)
            ])
            let tap = UITapGestureRecognizer(target: self, action: #selector(privacyLabelLeftTapped))
            $0.addGestureRecognizer(tap)
            $0.attributed.text = terms
            $0.isUserInteractionEnabled = true
        }
        privacyLabelRight.do {
            let privacy = AttributedString(string: AppSource.Text.Shared.privacyPolicy, with: [
                .font(.systemFont(ofSize: 14, weight: .regular)),
                .foreground(AppSource.Color.textColor)
            ])
            let tap = UITapGestureRecognizer(target: self, action: #selector(privacyLabelRightTapped))
            $0.addGestureRecognizer(tap)
            $0.attributed.text = privacy
            $0.isUserInteractionEnabled = true
        }
    }
    // MARK: - Layout
    func setupConstraints() {
        view.addSubview(restoreButton)
        view.addSubview(closeView)
        view.addSubview(titleLabel)
        view.addSubview(titleImage)
        view.addSubview(featureStackView)
        view.addSubview(priceGroup)
        view.addSubview(buyButton)
        view.addSubview(privacyLabelLeft)
        view.addSubview(privacyLabelRight)
        
        restoreButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(closeView.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        closeView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.size.equalTo(35)
        }
        closeImage.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(closeView.snp.bottom).offset(5)
            $0.top.lessThanOrEqualTo(closeView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(35)
        }
        titleImage.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(10)
            $0.top.lessThanOrEqualTo(titleLabel.snp.bottom).offset(40)
            $0.size.greaterThanOrEqualTo(80)
            $0.size.lessThanOrEqualTo(120)
            $0.centerX.equalToSuperview()
        }
        featureStackView.snp.makeConstraints {
            if UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue {
                $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(15)
                $0.top.lessThanOrEqualTo(titleLabel.snp.bottom).offset(60)
            } else {
                $0.top.greaterThanOrEqualTo(titleImage.snp.bottom).offset(15)
                $0.top.lessThanOrEqualTo(titleImage.snp.bottom).offset(60)
            }
            
            $0.leading.equalTo(priceGroup.snp.leading)
            $0.trailing.equalTo(priceGroup.snp.trailing)
            $0.centerX.equalToSuperview()
        }
        priceGroup.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(featureStackView.snp.bottom).offset(15)
            $0.top.lessThanOrEqualTo(featureStackView.snp.bottom).offset(45)
            $0.height.equalTo(180)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
        
        buyButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(priceGroup.snp.bottom).offset(15)
            $0.top.lessThanOrEqualTo(priceGroup.snp.bottom).offset(45)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(65)
        }
        privacyLabelLeft.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(buyButton.snp.bottom).offset(10)
            $0.top.lessThanOrEqualTo(buyButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(40)
            $0.height.equalTo(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        privacyLabelRight.snp.makeConstraints {
            $0.top.equalTo(privacyLabelLeft.snp.top)
            $0.bottom.equalTo(privacyLabelLeft.snp.bottom)
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
    }
}


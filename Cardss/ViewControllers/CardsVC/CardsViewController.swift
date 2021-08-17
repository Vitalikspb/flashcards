

import UIKit
import SnapKit
import Then
import GoogleMobileAds

class CardsViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var topNameView = NameOfViewController()
    private lazy var topView = UIView()
    private lazy var addNewCardsButton = ActionButton()
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var buttonWrapper = UIView()
    private lazy var buttonsView = BottomButtonView()
    private lazy var blurEffect = UIBlurEffect()
    
    private lazy var colorTheme = 0
    private var currentCardsCollection: [CardsModel]!
    private lazy var premiumAccount: Bool = false
    private var interstitial: GADInterstitialAd?
    private var moduleFactory = FactoryPresent()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserDefaultSettings()
        setupThemeColor()
        setupView()
        setupConstraints()
        setupGoogleAds()
        buttonsView.cardsButtom.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
        buttonsView.cardsImage.tintColor = AppSource.Color.selectedStrokeBottomButton
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topNameView.isHidden = false
        topNameView.animate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.topNameView.isHidden = true
        }
        
    }
}

// MARK: - GADFullScreenContentDelegate

extension CardsViewController: GADFullScreenContentDelegate {
    func setupGoogleAds() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AppSource.Constants.googleBanerId,
                                        request: request,
                              completionHandler: { [self] ad, error in
                                if let error = error {
                                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                  return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                              }
            )
    }
    func showAds() {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: self)
          } else {
            print("Ad wasn't ready")
          }
    }
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad presented full screen content.
      func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }
}

// MARK: - Helpers function

private extension CardsViewController {
    
    func setupUserDefaultSettings() {
        UserDefaults.standard.synchronize()
        if !UserDefaults.standard.bool(forKey: UserDefaults.firstLaunchApp) {
            premiumAccount = UserDefaults.standard.bool(forKey: UserDefaults.premium)
        } else {
            premiumAccount = UserDefaults.standard.bool(forKey: UserDefaults.premium)
            currentCardsCollection = UserDefaults.loadFromUD()
        }
        
        guard #available(iOS 13.0, *) else { return }
        switch UserDefaults.standard.integer(forKey: UserDefaults.settingNightMode) {
        case 0:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified }
        case 1:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light }
        case 2:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark }
        default: print("error")
        }
    }
    
    func setupThemeColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            colorTheme = 0 // dark
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        } else {
            colorTheme = 1 // light
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        }
    }
    
    func updateAftedDismiss() {
        setupProperties()
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self = self else { return }
            if !self.premiumAccount {
                self.showAds()
            }
        }
    }
    @objc func addNewPackOfCard() {
        let vc = AddWordController()
        vc.updateCollectionView = { [weak self] in
            guard let self = self else { return }
            self.updateAftedDismiss()
        }
        vc.fromVC = ShowFromVC.AddCards
        present(vc, animated: true, completion: nil)
    }
    
    func showSelectedCell(indexPath: IndexPath) {
        let vc = AddWordController()
        vc.fromVC = ShowFromVC.CollectionCell
        vc.indexPath = indexPath
        vc.updateCollectionView = { [weak self] in
            guard let self = self else { return }
            self.updateAftedDismiss()
        }
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension CardsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            guard let _ = currentCardsCollection[0].cardsCollection?.count else {
                return UICollectionReusableView()
            }
            sectionHeader.label.text = currentCardsCollection[0].cardsCollection?[indexPath.section].theme
            return sectionHeader
        } else { //No footer in this case but can add option for that
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = currentCardsCollection[0].cardsCollection?[section].info.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardsCollectionViewCell.reuseCellIdentifier, for: indexPath) as! CardsCollectionViewCell
        
        guard let _ = currentCardsCollection[0].cardsCollection?.count else { return cell }
        guard let data = currentCardsCollection[0].cardsCollection?[indexPath.section].info[indexPath.row] else { return cell }
        
        let formatterToString = DateFormatter()
        formatterToString.timeStyle = .none
        formatterToString.dateStyle = .short
        formatterToString.timeZone = TimeZone.current
        
        cell.setupCellText(color: AppSource.Color.cellColors[Int.random(in: 0...10)],
                           langLabel: "\(data.nativeLanguage)-\(data.foreignLanguage)",
                           learnedWords: "\(data.fiveStarWords)",
                           countWords: "\(data.countWords)",
                           nameOfPack: data.name,
                           dateOfPack: formatterToString.string(from: data.dateAdded))
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 7, height: 140)
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if currentCardsCollection[0].cardsCollection?.count != 0 {
            return currentCardsCollection[0].cardsCollection?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showSelectedCell(indexPath: indexPath)
    }
    
}

// MARK: - setupColors, setupProperties, setupView

extension CardsViewController {
    
    private func setupColors() {
        view.backgroundColor = AppSource.Color.background
        buttonWrapper.backgroundColor = .clear
        topView.backgroundColor = .clear
        collectionView.backgroundColor = AppSource.Color.background
    }

    func setupProperties() {
        currentCardsCollection = UserDefaults.loadFromUD()
    }
    
    private func setupView() {
        setupColors()
        setupProperties()

        buttonsView.presentStatisticsVC = { [weak self] in
            self?.moduleFactory.switchToSecond(toModule: .statistics)
        }
        buttonsView.presentSettingVC = { [weak self] in
            self?.moduleFactory.switchToSecond(toModule: .settings)
        }
        buttonsView.presentLearnVC = { [weak self] in
            self?.moduleFactory.switchToSecond(toModule: .education)
        }
        
        topView.do {
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = topView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.addSubview(blurEffectView)
            $0.addSubview(addNewCardsButton)
            
        }
        addNewCardsButton.do {
            $0.setTitle(AppSource.Text.CardsVC.edit, for: .normal)
            
            $0.addTarget(self, action: #selector(addNewPackOfCard), for: .touchUpInside)
            $0.transform = .init(translationX: 0, y: 15)
        }
        topNameView.do {
            $0.isHidden = true
            $0.showNameView(AppSource.Text.CardsVC.addNewCards, andImage: AppSource.Image.bullet!)
        }
        collectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            if UIScreen.main.bounds.height <= 667 {
                layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
            } else {
                layout.sectionInset = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
            }
            $0.register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: CardsCollectionViewCell.reuseCellIdentifier)
            $0.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
            $0.delegate = self
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.setCollectionViewLayout(layout, animated: true)
            $0.reloadData()
            $0.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 70, right: 0)
        }
        
        buttonWrapper.do {
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = buttonWrapper.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.addSubview(blurEffectView)
            $0.addSubview(buttonsView)
        }
        buttonsView.do {
            $0.layer.cornerRadius = 20
        }
    }
    
    private func setupConstraints() {
        
        view.addSubview(collectionView)
        view.addSubview(buttonWrapper)
        view.addSubview(topView)
        view.addSubview(topNameView)
        
        topNameView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        }
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        addNewCardsButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().offset(-30)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
        }
        buttonWrapper.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            let sizeHeight = UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue ? 80 : 100
            $0.height.equalTo(sizeHeight)
        }
        buttonsView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-15)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
    }
}


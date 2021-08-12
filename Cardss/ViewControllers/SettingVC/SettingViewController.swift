

import UIKit
import SnapKit
import Then
import FlagKit

enum ThemeColor {
    case unspecified
    case light
    case dark
}

class SettingViewController: UIViewController {
    
    private lazy var topNameView = NameOfViewController()
    private lazy var scrollWrapper = VerticalScrollView()
    
    private lazy var topLabelSwitchWrapper = UIView()
    private lazy var randomOfCardsLabel = UILabel()
    private lazy var randomOfCardsSwitch = UISwitch()
    private lazy var stickView2 = UIView()
    private lazy var changeLearningViewLabel = UILabel()
    private lazy var changeLearningViewSwitch = UISwitch()
    private lazy var stickView3 = UIView()
    private lazy var hintsLabel = UILabel()
    private lazy var hintsSwitch = UISwitch()
    private lazy var stickView1 = UIView()
    private lazy var themeModeUnSpecifiedLabel = UILabel()
    private lazy var themeModeUnSpecifiedSwitch = UISwitch()
    private lazy var stickView6 = UIView()
    private lazy var themeModeLightLabel = UILabel()
    private lazy var themeModeLightImage = UIImageView()
    private lazy var stickView7 = UIView()
    private lazy var themeModeDarkLabel = UILabel()
    private lazy var themeModeDarkImage = UIImageView()
    
    private lazy var showSideCardsTitleLabel = UILabel()
    private lazy var showSideCardsSegmentedControl = UISegmentedControl(items : itemsSideCards)

    private lazy var speakerWrapperView = ChooseButton()
    private lazy var notificationsWrapperView = ChooseButton()
    
    private lazy var subscriptionWrapper = UIView()
    private lazy var gradientView = GradientView()
    private lazy var subscriptionsTitle = UILabel()
    
    private lazy var rateWrapperView = ChooseButton()
    private lazy var shareWrapperView = ChooseButton()
    private lazy var connectWrapperView = ChooseButton()
    private lazy var buttonWrapper = UIView()
    private lazy var buttonsView = BottomButtonView()
    private let itemsSideCards = [AppSource.Text.SettingVC.left,
                                  AppSource.Text.SettingVC.right,
                                  AppSource.Text.SettingVC.random]
    
    private lazy var premiumAccount: Bool = false
    private var moduleFactory = FactoryPresent()
    
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
        setupView()
        setupConstraints()
        setupUserDefaultSettings()
        buttonsView.settingButtom.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
        buttonsView.settingsImage.tintColor = AppSource.Color.selectedStrokeBottomButton
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
        setupConstraints()
        
        topNameView.isHidden = false
        topNameView.animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.topNameView.isHidden = true
        }
    }
}

private extension SettingViewController {
    
    func setupUserDefaultSettings() {
        UserDefaults.standard.synchronize()
        let userDefault = UserDefaults.standard
        randomOfCardsSwitch.isOn = userDefault.bool(forKey: UserDefaults.settingRandomListCard)
        changeLearningViewSwitch.isOn = userDefault.bool(forKey: UserDefaults.changeLearningView)
        hintsSwitch.isOn = userDefault.bool(forKey: UserDefaults.showHints)
        
        switch userDefault.integer(forKey: UserDefaults.settingCardView) {
        case 0: showSideCardsSegmentedControl.selectedSegmentIndex = 0
        case 1: showSideCardsSegmentedControl.selectedSegmentIndex = 1
        case 2: showSideCardsSegmentedControl.selectedSegmentIndex = 2
        default: print("error")
        }
        
        switch userDefault.integer(forKey: UserDefaults.settingNightMode) {
        case 0: updateLayerColor(withTheme: .unspecified)
        case 1: updateLayerColor(withTheme: .light)
        case 2: updateLayerColor(withTheme: .dark)
        default: print("error")
        }
        
    }
    
    
    @objc func randomOfCardsTapped(_ value: Bool) {
            UserDefaults.standard.set(randomOfCardsSwitch.isOn, forKey: UserDefaults.settingRandomListCard)
    }
    
    @objc func changeLearningViewTapped(_ value: Bool) {
        UserDefaults.standard.set(changeLearningViewSwitch.isOn, forKey: UserDefaults.changeLearningView)
    }
    
    @objc func showHintsTapped(_ value: Bool) {
        UserDefaults.standard.set(hintsSwitch.isOn, forKey: UserDefaults.showHints)
    }
    
    @objc func automaticThemeTapped(_ value: Bool) {
            if themeModeUnSpecifiedSwitch.isOn {
                updateLayerColor(withTheme: .unspecified)
            } else {
                updateLayerColor(withTheme: .light)
            }
    }
    
}

extension SettingViewController {
    func showSubscriptionScreen() {
        let vc = SubscriptionViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func subscriptionButtonTapped() {
        showSubscriptionScreen()
    }
    
    @objc func showAccountViewTapped() {
        let vc = AccountViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func showSpeakerViewTapped() {
        let vc = ChooseSpeakerViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func showNotificationViewTapped() {
        let vc = NotificationViewController()
        present(vc, animated: true, completion: nil)
    }
        
    @objc func rateViewTapped() {
        let application = UIApplication.shared
        application.open(AppSource.Constants.review)
    }
    
    @objc func shareViewTapped() {
        let ac = UIActivityViewController(
            activityItems: [AppSource.Constants.appURL],
            applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc func connectViewTapped() {
        let application = UIApplication.shared
        application.open(AppSource.Constants.support)    
    }
    
    @objc func sideCardsChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: UserDefaults.standard.set(0, forKey: UserDefaults.settingCardView)
        case 1: UserDefaults.standard.set(1, forKey: UserDefaults.settingCardView)
        case 2: UserDefaults.standard.set(2, forKey: UserDefaults.settingCardView)
        default: break
        }
    }
    
    @objc func themeColorLightTapped() {
        updateLayerColor(withTheme: .light)
    }
    @objc func themeColorDarkTapped() {
        updateLayerColor(withTheme: .dark)
    }
    
    func updateLayerColor(withTheme color: ThemeColor) {
        guard #available(iOS 13.0, *) else { return }
        switch color {
        case .light:
            UserDefaults.standard.set(1, forKey: UserDefaults.settingNightMode)
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light }
            topLabelSwitchWrapper.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(15)
                $0.leading.trailing.equalToSuperview().inset(15)
                $0.height.equalTo(274)
            }
            [buttonsView.cardsButtom,
             buttonsView.statisticsButtom,
             buttonsView.learnButtom].forEach {
                $0.layer.borderColor = AppSource.Color.unSelectedStrokeBottomButton.cgColor
             }
            themeModeLightImage.isHidden = false
            themeModeDarkImage.isHidden = true
            themeModeUnSpecifiedSwitch.isOn = false
            stickView6.isHidden = false
            themeModeLightLabel.isHidden = false
            stickView7.isHidden = false
            themeModeDarkLabel.isHidden = false
            
        case .dark:
            UserDefaults.standard.set(2, forKey: UserDefaults.settingNightMode)
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark }
            topLabelSwitchWrapper.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(15)
                $0.leading.trailing.equalToSuperview().inset(15)
                $0.height.equalTo(274)
            }
            [buttonsView.cardsButtom,
             buttonsView.statisticsButtom,
             buttonsView.learnButtom].forEach {
                $0.layer.borderColor = AppSource.Color.unSelectedStrokeBottomButton.cgColor
             }
            
            themeModeLightImage.isHidden = true
            themeModeDarkImage.isHidden = false
            themeModeUnSpecifiedSwitch.isOn = false
            stickView6.isHidden = false
            themeModeLightLabel.isHidden = false
            stickView7.isHidden = false
            themeModeDarkLabel.isHidden = false
            
        case .unspecified:
            UserDefaults.standard.set(0, forKey: UserDefaults.settingNightMode)
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified }
            themeModeUnSpecifiedSwitch.isOn = true
            stickView6.isHidden = true
            themeModeLightLabel.isHidden = true
            themeModeLightImage.isHidden = true
            stickView7.isHidden = true
            themeModeDarkLabel.isHidden = true
            themeModeDarkImage.isHidden = true
            
            [buttonsView.cardsButtom,
             buttonsView.statisticsButtom,
             buttonsView.learnButtom].forEach {
                $0.layer.borderColor = AppSource.Color.unSelectedStrokeBottomButton.cgColor
             }
            topLabelSwitchWrapper.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(15)
                $0.leading.trailing.equalToSuperview().inset(15)
                $0.height.equalTo(192)
            }
        }
    }
}

private extension SettingViewController {
    
    func setupColors() {
        view.backgroundColor = AppSource.Color.background
        buttonWrapper.backgroundColor = AppSource.Color.backgroundBottonView
    }
    
    func setupProperties() {
        premiumAccount = UserDefaults.standard.bool(forKey: UserDefaults.premium)

        buttonsView.presentCardsVC = { [weak self] in
            self?.moduleFactory.switchToSecond(toModule: .cards)
        }
        buttonsView.presentStatisticsVC = { [weak self] in
            self?.moduleFactory.switchToSecond(toModule: .statistics)
        }
        buttonsView.presentSettingVC = { [weak self] in
            self?.moduleFactory.switchToSecond(toModule: .settings)
        }
        buttonsView.presentLearnVC = { [weak self] in
            self?.moduleFactory.switchToSecond(toModule: .education)
        }
    }
    
    func setupView() {
        setupColors()
        setupProperties()
        
        scrollWrapper.do {
            $0.backgroundColor = .clear
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
        }
        
        topNameView.do {
            $0.isHidden = true
            $0.showNameView(AppSource.Text.SettingVC.settings, andImage: AppSource.Image.slider!)
        }
        
        topLabelSwitchWrapper.do {
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addSubview(randomOfCardsSwitch)
            $0.addSubview(randomOfCardsLabel)
            $0.addSubview(stickView2)
            $0.addSubview(changeLearningViewSwitch)
            $0.addSubview(changeLearningViewLabel)
            $0.addSubview(stickView3)
            $0.addSubview(hintsSwitch)
            $0.addSubview(hintsLabel)
            $0.addSubview(stickView1)
            $0.addSubview(themeModeUnSpecifiedLabel)
            $0.addSubview(themeModeUnSpecifiedSwitch)
            $0.addSubview(stickView6)
            $0.addSubview(themeModeLightLabel)
            $0.addSubview(themeModeLightImage)
            $0.addSubview(stickView7)
            $0.addSubview(themeModeDarkLabel)
            $0.addSubview(themeModeDarkImage)
        }
        randomOfCardsLabel.do {
            $0.text = AppSource.Text.SettingVC.randomList
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        randomOfCardsSwitch.do {
            $0.addTarget(self, action: #selector(randomOfCardsTapped), for: .valueChanged)
        }
        
        [stickView1, stickView2, stickView3, stickView6, stickView7].forEach{
            $0.do {
                $0.backgroundColor = AppSource.Color.titleStick
            }
        }

        changeLearningViewLabel.do {
            $0.text = AppSource.Text.SettingVC.testOrCards
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        changeLearningViewSwitch.do {
            $0.addTarget(self, action: #selector(changeLearningViewTapped), for: .valueChanged)
        }
        
        hintsLabel.do {
            $0.text = AppSource.Text.SettingVC.showHints
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        hintsSwitch.do {
            $0.addTarget(self, action: #selector(showHintsTapped), for: .valueChanged)
        }
        showSideCardsTitleLabel.do {
            $0.text = AppSource.Text.SettingVC.whichCardDoYouLearn
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        }
        showSideCardsSegmentedControl.do {
            $0.addTarget(self, action: #selector(sideCardsChanged(_:)), for: .valueChanged)
            $0.backgroundColor = AppSource.Color.backgroundBottonView
            $0.selectedSegmentTintColor = AppSource.Color.backgroundWrapperView
        }
        themeModeUnSpecifiedLabel.do {
            $0.text = AppSource.Text.SettingVC.unspecified
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        themeModeUnSpecifiedSwitch.do {
            $0.addTarget(self, action: #selector(automaticThemeTapped(_:)), for: .valueChanged)
        }
        themeModeLightLabel.do {
            $0.text = AppSource.Text.SettingVC.light
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(themeColorLightTapped))
            $0.addGestureRecognizer(tap)
        }
        themeModeLightImage.do {
            $0.image = AppSource.Image.checkmark
            $0.contentMode = .scaleAspectFit
        }
        themeModeDarkLabel.do {
            $0.text = AppSource.Text.SettingVC.dark
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(themeColorDarkTapped))
            $0.addGestureRecognizer(tap)
        }
        themeModeDarkImage.do {
            $0.image = AppSource.Image.checkmark
            $0.contentMode = .scaleAspectFit
        }
        speakerWrapperView.do {
            $0.themeLabel.text = AppSource.Text.SettingVC.voice
            $0.image = AppSource.Image.voice
            let tap = UITapGestureRecognizer(target: self, action: #selector(showSpeakerViewTapped))
            $0.addGestureRecognizer(tap)
        }
        notificationsWrapperView.do {
            $0.themeLabel.text = AppSource.Text.SettingVC.notifications
            $0.image = AppSource.Image.notification
            let tap = UITapGestureRecognizer(target: self, action: #selector(showNotificationViewTapped))
            $0.addGestureRecognizer(tap)
        }
        
        subscriptionWrapper.do {
            $0.isHidden = premiumAccount ? true : false
            $0.backgroundColor = .red
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addSubview(subscriptionsTitle)
            $0.insertSubview(gradientView, at: 0)
        }
        gradientView.do {
            $0.isHidden = premiumAccount ? true : false
            $0.colors = [AppSource.Color.gradientSubscriptionTop,
                         AppSource.Color.gradientSubscriptionBottom]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        subscriptionsTitle.do {
            $0.isHidden = premiumAccount ? true : false
            $0.backgroundColor = .clear
            $0.text = AppSource.Text.Shared.getPremium
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            $0.textAlignment = .center
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(subscriptionButtonTapped))
            $0.addGestureRecognizer(tap)
        }
        
        rateWrapperView.do {
            $0.themeLabel.text = AppSource.Text.SettingVC.estimate
            $0.image = AppSource.Image.rate
            let tap = UITapGestureRecognizer(target: self, action: #selector(rateViewTapped))
            $0.addGestureRecognizer(tap)
            
        }
        shareWrapperView.do {
            $0.themeLabel.text = AppSource.Text.SettingVC.share
            $0.image = AppSource.Image.share
            let tap = UITapGestureRecognizer(target: self, action: #selector(shareViewTapped))
            $0.addGestureRecognizer(tap)
        }
        connectWrapperView.do {
            $0.themeLabel.text = AppSource.Text.SettingVC.support
            $0.image = AppSource.Image.support
            let tap = UITapGestureRecognizer(target: self, action: #selector(connectViewTapped))
            $0.addGestureRecognizer(tap)
        }
        buttonWrapper.do {
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.addSubview(buttonsView)
        }
    }
    
    private func setupConstraints() {
        
        view.addSubview(scrollWrapper)
        
        view.addSubview(buttonWrapper)
        
        
        scrollWrapper.addSubview(topLabelSwitchWrapper)
        scrollWrapper.addSubview(showSideCardsTitleLabel)
        scrollWrapper.addSubview(showSideCardsSegmentedControl)
        scrollWrapper.addSubview(speakerWrapperView)
        scrollWrapper.addSubview(notificationsWrapperView)
        scrollWrapper.addSubview(subscriptionWrapper)
        scrollWrapper.addSubview(rateWrapperView)
        scrollWrapper.addSubview(shareWrapperView)
        scrollWrapper.addSubview(connectWrapperView)
        
        buttonWrapper.addSubview(buttonsView)
        view.addSubview(topNameView)
        
        scrollWrapper.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonWrapper.snp.top)
        }
        topNameView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        }
        topLabelSwitchWrapper.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.trailing.equalToSuperview().inset(15)
            switch UserDefaults.standard.integer(forKey: UserDefaults.settingNightMode) {
            case 1,2: $0.height.equalTo(274)
            case 0: $0.height.equalTo(192)
            default: print("error")
            }
            
        }
        
        randomOfCardsLabel.snp.makeConstraints {
            $0.centerY.equalTo(randomOfCardsSwitch.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
        }
        randomOfCardsSwitch.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView2.snp.makeConstraints {
            $0.leading.equalTo(randomOfCardsLabel.snp.leading)
            $0.trailing.equalTo(randomOfCardsSwitch.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(randomOfCardsSwitch.snp.bottom).offset(7)
        }
        changeLearningViewLabel.snp.makeConstraints {
            $0.centerY.equalTo(changeLearningViewSwitch.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
        }
        changeLearningViewSwitch.snp.makeConstraints {
            $0.top.equalTo(randomOfCardsSwitch.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView3.snp.makeConstraints {
            $0.leading.equalTo(changeLearningViewLabel.snp.leading)
            $0.trailing.equalTo(changeLearningViewSwitch.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(changeLearningViewSwitch.snp.bottom).offset(7)
        }
        hintsLabel.snp.makeConstraints {
            $0.centerY.equalTo(hintsSwitch.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
        }
        hintsSwitch.snp.makeConstraints {
            $0.top.equalTo(changeLearningViewSwitch.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView1.snp.makeConstraints {
            $0.leading.equalTo(hintsLabel.snp.leading)
            $0.trailing.equalTo(hintsSwitch.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(hintsSwitch.snp.bottom).offset(7)
        }
        showSideCardsTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(showSideCardsSegmentedControl.snp.leading).offset(30)
            $0.trailing.equalTo(topLabelSwitchWrapper.snp.trailing)
            $0.top.equalTo(topLabelSwitchWrapper.snp.bottom).offset(15)
        }
        showSideCardsSegmentedControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalTo(showSideCardsTitleLabel.snp.bottom).offset(5)
            $0.height.equalTo(30)
        }
        themeModeUnSpecifiedLabel.snp.makeConstraints {
            $0.centerY.equalTo(themeModeUnSpecifiedSwitch.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalTo(themeModeUnSpecifiedSwitch.snp.leading)
        }
        themeModeUnSpecifiedSwitch.snp.makeConstraints {
            $0.top.equalTo(hintsSwitch.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView6.snp.makeConstraints {
            $0.leading.equalTo(themeModeUnSpecifiedLabel.snp.leading)
            $0.trailing.equalTo(themeModeUnSpecifiedSwitch.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(themeModeUnSpecifiedSwitch.snp.bottom).offset(7)
        }
        themeModeLightLabel.snp.makeConstraints {
            $0.top.equalTo(themeModeLightImage.snp.top).offset(-7)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(themeModeLightImage.snp.bottom).offset(7)
        }
        themeModeLightImage.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.top.equalTo(themeModeUnSpecifiedSwitch.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView7.snp.makeConstraints {
            $0.leading.equalTo(themeModeLightLabel.snp.leading)
            $0.trailing.equalTo(themeModeLightImage.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(themeModeLightImage.snp.bottom).offset(7)
        }
        themeModeDarkLabel.snp.makeConstraints {
            $0.top.equalTo(themeModeDarkImage.snp.top).offset(-7)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(themeModeDarkImage.snp.bottom).offset(7)
        }
        themeModeDarkImage.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.top.equalTo(themeModeLightImage.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        speakerWrapperView.snp.makeConstraints {
            $0.top.equalTo(showSideCardsSegmentedControl.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        notificationsWrapperView.snp.makeConstraints {
            $0.top.equalTo(speakerWrapperView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        
        subscriptionWrapper.snp.makeConstraints {
            $0.top.equalTo(notificationsWrapperView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(80)
        }
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        subscriptionsTitle.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rateWrapperView.snp.makeConstraints {
            if premiumAccount {
                $0.top.equalTo(notificationsWrapperView.snp.bottom).offset(30)
            } else {
                $0.top.equalTo(subscriptionWrapper.snp.bottom).offset(30)
            }
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        
        shareWrapperView.snp.makeConstraints {
            $0.top.equalTo(rateWrapperView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        connectWrapperView.snp.makeConstraints {
            $0.top.equalTo(shareWrapperView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
            $0.bottom.equalToSuperview().offset(-15)
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


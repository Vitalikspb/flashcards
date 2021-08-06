

import UIKit
import SnapKit
import Then
import Realm

class AccountViewController: PopupViewController {
    
    //    MARK: - UI Elements
    private lazy var headerTitleWrapper = UIView()
    private lazy var headerTitleStick = UIView()
    private lazy var headerTitleLabel = UILabel()
    private lazy var doneLabel = UILabel()
    
    private lazy var mainStackView = UIStackView()
    private lazy var nameTextField = UITextField()
    private lazy var passwordTextField = UITextField()
    private lazy var loginButton = ActionButton()
    
    private lazy var resetPasswordLabel = UILabel()
    private lazy var signInLabel = UILabel()
//    private var currentUser: User!
    
    //    MARK: - Private properties
    private lazy var canLoginBoolean: Bool = false
    private lazy var wantToRegistered: Bool = false
    private lazy var tryResetPassword: Bool = false
    private lazy var wasSingIn: Bool = false
    private lazy var login: String = ""
    private lazy var password: String = ""
    private lazy var successLoadFromDB: Bool = false
//    private var handleFirebase: AuthStateDidChangeListenerHandle!
    
    private var owner = [ModelCredential]()
    private lazy var bdRealmManager = CredentialManager()
    
    
    //    MARK: - Life Cycle
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserDefaultSettings()
        setupView()
        registerToolBar()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        handleFirebase = Auth.auth().addStateDidChangeListener { (auth, user) in
//        }
        // сделать метод который будет смотреть был ли вход на первом экране при запуске, если был, то подготавливать экран как будето вошел уже - loginWithRegistration
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        Auth.auth().removeStateDidChangeListener(handleFirebase)
    }
}

//    MARK: - handlers
private extension AccountViewController {
    func setupUserDefaultSettings() {
        if UserDefaults.standard.bool(forKey: UserDefaults.tryAutomaticLogin) {
            setupCredential()
        }
    }
    func automaticLogin(autoLogin value: Bool) {
        UserDefaults.standard.setValue(value, forKey: UserDefaults.tryAutomaticLogin)
    }
    func setupCredential() {
        owner = bdRealmManager.obtainCredentialObject()
        login = owner.first?.loginMail ?? ""
        password = owner.first?.password ?? ""
        guard login != "", password != ""  else { return }
        successLoadFromDB = true
        loginInApp()
    }
    func errorAlert(with text: String) {
        let alertController = CreateAlerts.errorAlert(with: AppSource.Text.Shared.error,
                                                      and: text)
        present(alertController, animated: true)
    }
    func setupUserFromDatabase() {
        // загружать параметры для входа из БД реалм/ сохранять туда же
    }
    @objc func doneLabelTapped() {
        dismissKeyboard()
        doneLabel.isHidden = true
    }
    @objc func resetPasswordTapped() {
        let alertController = CreateAlerts.errorAlert(with: AppSource.Text.AccountVC.resetPassword,
                                                      and: "")
        present(alertController, animated: true)
        nameTextField.text = login
        passwordTextField.placeholder = "Введите новый пароль"
        loginButton.setTitle("Изменить пароль", for: .normal)
        tryResetPassword = true
    }
    func deleteCurrentCredential() {
        if owner.first != nil {
            bdRealmManager.deleteCredentialObject(self.owner.remove(at: 0))
        }
        successLoadFromDB = false
    }
    @objc func signInTapped() {
        wantToRegistered = !wantToRegistered
        if wantToRegistered {
            deleteCurrentCredential()
            loginButton.setTitle(AppSource.Text.AccountVC.register, for: .normal)
            signInLabel.text = AppSource.Text.AccountVC.signIn
            passwordTextField.placeholder = AppSource.Text.AccountVC.createPassword
        } else {
            loginButton.setTitle(AppSource.Text.AccountVC.signIn, for: .normal)
            signInLabel.text = AppSource.Text.AccountVC.register
            passwordTextField.placeholder = AppSource.Text.AccountVC.enterPassword
        }
        
    }
    @objc func loginButtonTapped() {
        doneLabel.isHidden = true
        if tryResetPassword == true {
            // меняем пароль
//            Auth.auth().currentUser?.updatePassword(to: password) { (error) in
//                if error != nil {
//                    let alertController = CreateAlerts.errorAlert(with: "Ошибка смены пароля",
//                                                                  and: "try again")
//                    self.present(alertController, animated: true)
//                }
//            }
            tryResetPassword = false
            loginButton.setTitle(AppSource.Text.AccountVC.signIn, for: .normal)
            saveNewCredential()
        } else {
            
        login = nameTextField.text ?? ""
        password = passwordTextField.text ?? ""
            // проводим регистрицию или вход
        if !wasSingIn {
            // мы не зарегистророваны и проводим вход или регистрацию
            if canLoginBoolean {
                // заполнили все поля и можем пройти регистрацию или вход
                if wantToRegistered {
                    // регистрируемся
                    
                    registerInApp()
                } else {
                    // входим в приложение
                    loginInApp()
                }
            } else {
                errorWithLogin()
            }
            
        } else {
            // был зарегистрирован - выходим из учетной записи
            signOut()
        }
    }
    }
    
    func signOut() {
//        try! Auth.auth().signOut()
        automaticLogin(autoLogin: false)
        deleteCurrentCredential()
        wasSingIn = false
        canLoginBoolean = false
        nameTextField.placeholder = AppSource.Text.AccountVC.enterMail
        nameTextField.isUserInteractionEnabled = true
        passwordTextField.placeholder = AppSource.Text.AccountVC.enterPassword
        passwordTextField.isUserInteractionEnabled = true
        loginButton.setTitle(AppSource.Text.AccountVC.signIn, for: .normal)
        signInLabel.isHidden = false
        resetPasswordLabel.isHidden = false
    }
    func errorWithLogin() {
        if nameTextField.text == "" {
            errorAlert(with: AppSource.Text.AccountVC.enterName)
        } else if nameTextField.text == "" {
            errorAlert(with: AppSource.Text.AccountVC.enterPassword)
        }
        doneLabel.isHidden = true
    }
    func registerInApp() {
//        Auth.auth().createUser(withEmail: login,
//                               password: password) { [weak self] authResult, error in
//            guard let self = self else { return }
//            guard let _ = authResult?.user, error == nil else {
//                let alertController = CreateAlerts.errorAlert(with: error!.localizedDescription,
//                                                              and: "Try again")
//                self.present(alertController, animated: true)
//                return
//            }
//            self.loginWithRegistration(login: self.login)
//        }

    }
    func loginWithRegistration(login name: String) {
        wasSingIn = true
        passwordTextField.text = ""
        passwordTextField.placeholder = name
        passwordTextField.isUserInteractionEnabled = false
        nameTextField.text = ""
        nameTextField.placeholder = AppSource.Text.AccountVC.youSignInWithLogin
        nameTextField.isUserInteractionEnabled = false
        signInLabel.isHidden = true
        resetPasswordLabel.isHidden = true
        loginButton.setTitle(AppSource.Text.AccountVC.logout, for: .normal)
        loginButton.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
        if !successLoadFromDB {
            saveNewCredential()
        }
        automaticLogin(autoLogin: true)
        setupUserFromDatabase()
    }
    func saveNewCredential() {
        owner.first?.loginMail = login
        owner.first?.password = password
        let currentOwner = ModelCredential()
        currentOwner.loginMail = login
        currentOwner.password = password
        bdRealmManager.saveCredentialObject(currentOwner)
    }
    func loginInApp() {
        // входить в фаербэйз и подгрузать все карточки в список из других аккаунтов.
        // сохранять новые карточки в фаербэйз
        // обновлять статискику
//        Auth.auth().signIn(withEmail: login,
//                           password: password) { [weak self] authResult, error in
//            guard let self = self else { return }
//            if error != nil {
//                let alertController = CreateAlerts.errorAlert(with: error!.localizedDescription,
//                                                              and: "Try again")
//                self.present(alertController, animated: true)
//            } else {
//                if self.loginButton.title(for: .normal) == AppSource.Text.AccountVC.signIn {
//                    let alertController = CreateAlerts.errorAlert(with: AppSource.Text.AccountVC.loginSuccess,
//                                                                  and: AppSource.Text.AccountVC.messageSuccess)
//                    self.present(alertController, animated: true)
//                } else if self.loginButton.title(for: .normal) == AppSource.Text.AccountVC.register {
//                    let alertController = CreateAlerts.errorAlert(with: AppSource.Text.AccountVC.registerSuccess,
//                                                                  and: AppSource.Text.AccountVC.messageSuccess)
//                    self.present(alertController, animated: true)
//                }
//                self.loginWithRegistration(login: self.login)
//            }
//        }

    }
    func updateLoginButtomStyle() {
        if nameTextField.text == "" || passwordTextField.text == "" {
            loginButton.setTitleColor(.lightGray, for: .normal)
            canLoginBoolean = false
        } else {
            loginButton.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
            canLoginBoolean = true
        }
    }
}

//    MARK: - UITextFieldDelegate
extension AccountViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneLabel.isHidden = false
        doneLabel.text = AppSource.Text.Shared.done
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneLabel.isHidden = false
        doneLabel.text = AppSource.Text.Shared.done
        textField.resignFirstResponder()
        return true
    }
    @objc func dismissKeyboard() {
        doneLabel.isHidden = true
        doneLabel.text = AppSource.Text.Shared.done
        view.endEditing(true)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateLoginButtomStyle()
    }
}

//    MARK: - Show/hide keyboard
private extension AccountViewController {
    func registerToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let doneButton = UIBarButtonItem(title: AppSource.Text.Shared.done,
                                         style: .done,
                                         target: self,
                                         action: #selector(dismissKeyboard))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        nameTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
    }
    
}
//    MARK: - Setup Views
private extension AccountViewController {
    
    func setupColors() {
        view.backgroundColor = AppSource.Color.background
    }
    
    func setupView() {
        setupColors()
        
//        currentUser = User
        
        doneLabel.do {
            $0.text = AppSource.Text.Shared.done
            $0.textColor = AppSource.Color.selectedStrokeBottomButton
            $0.textAlignment = .right
            $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(doneLabelTapped))
            $0.addGestureRecognizer(tap)
            $0.isHidden = true
        }
        headerTitleWrapper.do {
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.addSubview(headerTitleLabel)
            $0.addSubview(headerTitleStick)
        }
        headerTitleStick.do {
            $0.backgroundColor = AppSource.Color.titleStick
        }
        headerTitleLabel.do {
            $0.text = AppSource.Text.SettingVC.account
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        mainStackView.do {
            $0.alignment = .fill
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = 10
            $0.addArrangedSubview(nameTextField)
            $0.addArrangedSubview(passwordTextField)
            $0.addArrangedSubview(loginButton)
        }
        nameTextField.do {
            $0.placeholder = AppSource.Text.AccountVC.enterMail
            $0.delegate = self
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: $0.frame.height))
            $0.leftViewMode = .always
            $0.borderStyle = .none
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.textColor = AppSource.Color.textColor
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.keyboardType = .emailAddress
        }
        passwordTextField.do {
            $0.placeholder = AppSource.Text.AccountVC.enterPassword
            $0.delegate = self
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: $0.frame.height))
            $0.leftViewMode = .always
            $0.borderStyle = .none
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.textColor = AppSource.Color.textColor
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.keyboardType = .default
            $0.isSecureTextEntry = true
        }
        loginButton.do {
            $0.setTitle(AppSource.Text.AccountVC.signIn, for: .normal)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
            $0.transform = .init(translationX: 0, y: 15)
        }
        resetPasswordLabel.do {
            $0.text = AppSource.Text.AccountVC.resetPassword
            $0.textColor = AppSource.Color.blueTextColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(resetPasswordTapped))
            $0.addGestureRecognizer(tap)
        }
        signInLabel.do {
            $0.text = AppSource.Text.AccountVC.register
            $0.textColor = AppSource.Color.blueTextColor
            $0.textAlignment = .right
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(signInTapped))
            $0.addGestureRecognizer(tap)
        }
    }
    //    MARK: - Setup Constraints
    func setupConstraints() {
        view.addSubview(headerTitleWrapper)
        view.addSubview(doneLabel)
        view.addSubview(mainStackView)
        view.addSubview(resetPasswordLabel)
        view.addSubview(signInLabel)
        
        headerTitleWrapper.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview()
        }
        headerTitleStick.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        headerTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        doneLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(35)
            $0.centerY.equalTo(headerTitleLabel.snp.centerY)
        }
        mainStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-75)
            $0.width.equalTo(300)
            $0.height.equalTo(155)
        }
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        loginButton.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        resetPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).offset(30)
            $0.leading.equalTo(mainStackView.snp.leading)
            $0.trailing.equalTo(signInLabel.snp.leading)
            $0.height.equalTo(20)
        }
        signInLabel.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).offset(30)
            $0.trailing.equalTo(mainStackView.snp.trailing)
            $0.height.equalTo(20)
        }
    }
}

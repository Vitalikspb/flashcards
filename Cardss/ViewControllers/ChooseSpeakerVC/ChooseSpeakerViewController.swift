

import UIKit
import SnapKit
import Then
import Realm

class ChooseSpeakerViewController: PopupViewController {
    
    private lazy var headerTitleWrapper = UIView()
    private lazy var headerTitleStick = UIView()
    private lazy var headerTitleLabel = UILabel()
    private lazy var doneLabel = UILabel()
   
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var listOfSpeaker = ["Karen", "Daniel", "Samantha", "Milena"]
    
    private lazy var selectedSpeaker = ""
    private lazy var oldIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    override init() {
        super.init()
    }
    
    var updateSpeaker: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupUserDefaultSettings()
        tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayoutSubviews()
    }
}

private extension ChooseSpeakerViewController {
    @objc func doneLabelTapped() {
        updateSpeaker?()
        dismiss(animated: true, completion: nil)
    }
    func setupUserDefaultSettings() {
        let name = UserDefaults.standard.string(forKey: UserDefaults.selectedSpeaker) ?? "Milena"
        selectedSpeaker = name
    }
}

extension ChooseSpeakerViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSpeaker.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpeakerTableViewCell.reuseId, for: indexPath) as! SpeakerTableViewCell        
        let name = Speaker.selectName(by: listOfSpeaker[indexPath.row])
        if selectedSpeaker == name {
            cell.accessoryType = .checkmark
            cell.selectedBackgroundView?.backgroundColor = AppSource.Color.background
            cell.nameLabel.textColor = AppSource.Color.selectedStrokeBottomButton
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
        } else {
            cell.accessoryType = .none
            cell.nameLabel.textColor = AppSource.Color.textColor
            cell.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
            cell.layer.borderWidth = 0
        }
        cell.nameLabel.text = listOfSpeaker[indexPath.row]        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: oldIndexPath) as? SpeakerTableViewCell {
            cell.accessoryType = .none
            cell.nameLabel.textColor = AppSource.Color.textColor
            cell.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
            cell.layer.borderWidth = 0
        }
        oldIndexPath = indexPath
        if let cell = tableView.cellForRow(at: indexPath) as? SpeakerTableViewCell {
            cell.accessoryType = .checkmark
            cell.selectedBackgroundView?.backgroundColor = AppSource.Color.background
            cell.nameLabel.textColor = AppSource.Color.selectedStrokeBottomButton
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            let name = cell.nameLabel.text
            selectedSpeaker = Speaker.selectName(by: name ?? "Milena")
            UserDefaults.standard.set(selectedSpeaker, forKey: UserDefaults.selectedSpeaker)
            
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView.init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView.init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}



private extension ChooseSpeakerViewController {
    
    func setupLayoutSubviews() {
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
    }
    
    func setupColors() {
        view.backgroundColor = AppSource.Color.background
    }
    
    func setupView() {
        setupColors()
        
        doneLabel.do {
            $0.text = AppSource.Text.Shared.done
            $0.textColor = AppSource.Color.selectedStrokeBottomButton
            $0.textAlignment = .right
            $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(doneLabelTapped))
            $0.addGestureRecognizer(tap)
            
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
            $0.text = AppSource.Text.SettingVC.voice
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(SpeakerTableViewCell.self,
                        forCellReuseIdentifier: SpeakerTableViewCell.reuseId)
            $0.separatorStyle = .none
            $0.backgroundColor = AppSource.Color.background
            $0.reloadData()
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .singleLine
            $0.separatorColor = AppSource.Color.titleStick
            $0.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    func setupConstraints() {
        view.addSubview(headerTitleWrapper)
        view.addSubview(doneLabel)
        view.addSubview(tableView)
        
        
        
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
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerTitleWrapper.snp.bottom).offset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
    }
}

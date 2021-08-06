

import UIKit
import SnapKit
import Then
import Realm

class NotificationViewController: PopupViewController {
    
    private lazy var headerTitleWrapper = UIView()
    private lazy var headerTitleStick = UIView()
    private lazy var headerTitleLabel = UILabel()
    private lazy var doneLabel = UILabel()
    
    private lazy var scrollWrapper = VerticalScrollView()
    
    private lazy var name = UITextField()
    
    private lazy var mainViewWrapper = UIView()
    
    private lazy var mondayTextLabel = UILabel()
    private lazy var mondaySwitcher = UISwitch()
    private lazy var stickView1 = UIView()
    
    private lazy var tuesdayTextLabel = UILabel()
    private lazy var tuesdaySwitcher = UISwitch()
    private lazy var stickView2 = UIView()
    
    private lazy var wednesdayTextLabel = UILabel()
    private lazy var wednesdaySwitcher = UISwitch()
    private lazy var stickView3 = UIView()
    
    private lazy var thursdayTextLabel = UILabel()
    private lazy var thursdaySwitcher = UISwitch()
    private lazy var stickView4 = UIView()
    
    private lazy var fridayTextLabel = UILabel()
    private lazy var fridaySwitcher = UISwitch()
    private lazy var stickView5 = UIView()
    
    private lazy var saturdayTextLabel = UILabel()
    private lazy var saturdaySwitcher = UISwitch()
    private lazy var stickView6 = UIView()
    
    private lazy var sundayTextLabel = UILabel()
    private lazy var sundaySwitcher = UISwitch()
    
    private lazy var timePickerView = UIDatePicker()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var saveButtonButton = ActionButton()

    private var listOfNotification = [StructNotification]()
    private lazy var bdRealmManager = StorageManager()
    private var saveButtonBoolean = false
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotification()
        registerToolBar()
        setupView()
        setupConstraints()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayoutSubviews()
    }
    
}

private extension NotificationViewController {
    
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
        name.inputAccessoryView = toolBar
    }
    
    func setupNotification() {
        listOfNotification = bdRealmManager.obtainNotificationObject()
        tableView.reloadData()
    }
    
    @objc func setNotificationTapped() {
        
        if saveButtonBoolean {
        var nameNotification = AppSource.Text.NotificationVC.name
        if name.text != "" {
            nameNotification = name.text!
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let time = dateFormatter.string(from: timePickerView.date)
        
        var listOfDays = [String]()
        if mondaySwitcher.isOn { listOfDays.append("  \(AppSource.Text.NotificationVC.mondayShort)") }
        if tuesdaySwitcher.isOn { listOfDays.append("  \(AppSource.Text.NotificationVC.tuesdayShort)") }
        if wednesdaySwitcher.isOn { listOfDays.append("  \(AppSource.Text.NotificationVC.wednesdayShort)") }
        if thursdaySwitcher.isOn { listOfDays.append("  \(AppSource.Text.NotificationVC.thursdayShort)") }
        if fridaySwitcher.isOn { listOfDays.append("  \(AppSource.Text.NotificationVC.fridayShort)") }
        if saturdaySwitcher.isOn { listOfDays.append("  \(AppSource.Text.NotificationVC.saturdayShort)") }
        if sundaySwitcher.isOn { listOfDays.append("  \(AppSource.Text.NotificationVC.sundayShort)") }

        let currentday = StructNotification()
        currentday.name = nameNotification
        currentday.time = time
        currentday.days.append(objectsIn: listOfDays)
        listOfNotification.append(currentday)
        bdRealmManager.saveNotificationObject(currentday)
        tableView.reloadData()
        registerNotification()
        clearStringAfterSave()
        } else {
            if name.text == "" {
                errorAlert(with: AppSource.Text.NotificationVC.nameError)
            } else {
                errorAlert(with: AppSource.Text.NotificationVC.errorDay)
            }
        }
    }
    
    func errorAlert(with text: String) {
        let alertController = CreateAlerts.errorAlert(with: AppSource.Text.Shared.error,
                                                               and: text)
        present(alertController, animated: true)
    }
    
    func registerNotification() {
        
        let title = [AppSource.Text.NotificationVC.notificationString1,
                     AppSource.Text.NotificationVC.notificationString2,
                     AppSource.Text.NotificationVC.notificationString3,
                     AppSource.Text.NotificationVC.notificationString4,
                     AppSource.Text.NotificationVC.notificationString5,
                     AppSource.Text.NotificationVC.notificationString6,
                     AppSource.Text.NotificationVC.notificationString7
        ]

        let manager = LocalNotificationManager()
        for index in 0..<listOfNotification.count {
            let title = title[index]
            let body = listOfNotification[index].name
            var hour = 0
            var minute = 0
            var curDay = 0
            for (_, val) in listOfNotification[index].days.enumerated() {
                switch val {
                case "  \(AppSource.Text.NotificationVC.mondayShort)": curDay = 2
                case "  \(AppSource.Text.NotificationVC.tuesdayShort)": curDay = 3
                case "  \(AppSource.Text.NotificationVC.wednesdayShort)": curDay = 4
                case "  \(AppSource.Text.NotificationVC.thursdayShort)": curDay = 5
                case "  \(AppSource.Text.NotificationVC.fridayShort)": curDay = 6
                case "  \(AppSource.Text.NotificationVC.saturdayShort)": curDay = 7
                case "  \(AppSource.Text.NotificationVC.sundayShort)": curDay = 1
                default: print("error")
                }
                var dateComponents = DateComponents()
                dateComponents.hour = 18
                dateComponents.minute = 28
                let time = listOfNotification[index].time.split(separator: ":")
                
                hour = Int(time[0]) ?? 00
                minute = Int(time[1]) ?? 00
                manager.notifications.append(customNotification(id: UUID().uuidString,
                                                          title: title,
                                                          body: body,
                                                          minuteComponents: minute,
                                                          hourComponents: hour,
                                                          dayNumberComponents: curDay))
            }
        }
        manager.startScheduledNotification()
    }
    
    func setValueToChange(at indexPath: IndexPath) {
        var currentNotificationChange = StructNotification()
        currentNotificationChange = self.listOfNotification[indexPath.row]
        
        name.text = currentNotificationChange.name
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let time = dateFormatter.date(from: currentNotificationChange.time)
        timePickerView.date = time!
        
        for (_, val) in currentNotificationChange.days.enumerated() {
            switch val {
            case "  \(AppSource.Text.NotificationVC.mondayShort)"   : mondaySwitcher.isOn    = true
            case "  \(AppSource.Text.NotificationVC.tuesdayShort)"  : tuesdaySwitcher.isOn   = true
            case "  \(AppSource.Text.NotificationVC.wednesdayShort)": wednesdaySwitcher.isOn = true
            case "  \(AppSource.Text.NotificationVC.thursdayShort)" : thursdaySwitcher.isOn  = true
            case "  \(AppSource.Text.NotificationVC.fridayShort)"   : fridaySwitcher.isOn    = true
            case "  \(AppSource.Text.NotificationVC.saturdayShort)" : saturdaySwitcher.isOn  = true
            case "  \(AppSource.Text.NotificationVC.sundayShort)"   : sundaySwitcher.isOn    = true
            default:
                print("error")
            }
        }
    }
    
    func clearStringAfterSave() {
        name.text = ""
        let arrayOfSwitch = [mondaySwitcher, tuesdaySwitcher, wednesdaySwitcher, thursdaySwitcher,
                             fridaySwitcher, saturdaySwitcher, sundaySwitcher]
        arrayOfSwitch.forEach {
            $0.isOn = false
            $0.isSelected = false
        }
        switchSetToOn()
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId, for: indexPath) as! TableViewCell
        cell.nameLabel.text = listOfNotification[indexPath.row].name
        var day = ""
        listOfNotification[indexPath.row].days.forEach {
            day = day + "\($0)"
        }
        cell.dayLabel.text = day
        cell.timeLabel.text = listOfNotification[indexPath.row].time
        return cell
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
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: AppSource.Text.Shared.delete) { (_, _, _) in
            self.bdRealmManager.deleteNotificationObject(self.listOfNotification.remove(at: indexPath.row))
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension NotificationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneLabel.isHidden = false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switchSetToOn()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneLabel.isHidden = true
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        doneLabel.isHidden = true
        view.endEditing(true)
    }
    
    @objc func doneLabelTapped() {
        dismissKeyboard()
        doneLabel.isHidden = true
    }
    
    @objc func switchSetToOn() {
        let switchArr = [mondaySwitcher, tuesdaySwitcher, wednesdaySwitcher,
                         thursdaySwitcher, fridaySwitcher, saturdaySwitcher,
                         sundaySwitcher]
        for (ind, _) in switchArr.enumerated() {
            if name.text != "" && switchArr[ind].isOn == true {
                saveButtonBoolean = true
                saveButtonButton.setTitleColor(AppSource.Color.blueTextColor, for: .normal)
                break
            } else {
                saveButtonBoolean = false
                saveButtonButton.setTitleColor(.lightGray, for: .normal)
            }
        }
    }
}


private extension NotificationViewController {
    
    func setupLayoutSubviews() {
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        mainViewWrapper.layer.cornerRadius = 10
        mainViewWrapper.layer.masksToBounds = true
    }
    
    func setupColors() {
        view.backgroundColor = AppSource.Color.background
    }
    
    func setupView() {
        setupColors()
        
        scrollWrapper.do {
            $0.backgroundColor = .clear
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
        }
        
        mainViewWrapper.do {
            $0.addSubview(mondaySwitcher)
            $0.addSubview(mondayTextLabel)
            $0.addSubview(stickView1)
            $0.addSubview(tuesdaySwitcher)
            $0.addSubview(tuesdayTextLabel)
            $0.addSubview(stickView2)
            $0.addSubview(wednesdaySwitcher)
            $0.addSubview(wednesdayTextLabel)
            $0.addSubview(stickView3)
            $0.addSubview(thursdaySwitcher)
            $0.addSubview(thursdayTextLabel)
            $0.addSubview(stickView4)
            $0.addSubview(fridaySwitcher)
            $0.addSubview(fridayTextLabel)
            $0.addSubview(stickView5)
            $0.addSubview(saturdaySwitcher)
            $0.addSubview(saturdayTextLabel)
            $0.addSubview(stickView6)
            $0.addSubview(sundaySwitcher)
            $0.addSubview(sundayTextLabel)
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
        }
        
        view.do {_ in
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        [stickView1, stickView2, stickView3, stickView4,
         stickView5, stickView6].forEach {
            $0.backgroundColor =  AppSource.Color.titleStick
         }
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
            $0.text = AppSource.Text.NotificationVC.notification
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        name.do {
            $0.placeholder = AppSource.Text.NotificationVC.name
            $0.delegate = self
            $0.borderStyle = .none
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.textColor = AppSource.Color.textColor
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: $0.frame.height))
            $0.leftViewMode = .always
        }
        
        let switchArr = [mondaySwitcher, tuesdaySwitcher, wednesdaySwitcher,
                         thursdaySwitcher, fridaySwitcher, saturdaySwitcher,
                         sundaySwitcher]
        switchArr.forEach {
            $0.isOn = false
            $0.isSelected = false
            $0.addTarget(self, action: #selector(switchSetToOn), for: .valueChanged)
        }
        let labelArr = [mondayTextLabel, tuesdayTextLabel, wednesdayTextLabel,
                        thursdayTextLabel, fridayTextLabel, saturdayTextLabel,
                        sundayTextLabel]
        labelArr.forEach {
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.snp.makeConstraints {
                $0.width.equalTo(280)
            }
        }
        mondayTextLabel.do {
            $0.text = AppSource.Text.NotificationVC.monday
        }
        tuesdayTextLabel.do {
            $0.text = AppSource.Text.NotificationVC.tuesday
        }
        wednesdayTextLabel.do {
            $0.text = AppSource.Text.NotificationVC.wednesday
        }
        thursdayTextLabel.do {
            $0.text = AppSource.Text.NotificationVC.tuesday
        }
        fridayTextLabel.do {
            $0.text = AppSource.Text.NotificationVC.friday
        }
        saturdayTextLabel.do {
            $0.text = AppSource.Text.NotificationVC.saturday
        }
        sundayTextLabel.do {
            $0.text = AppSource.Text.NotificationVC.sunday
        }
        timePickerView.do {
            $0.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
            $0.datePickerMode = .time
            $0.timeZone = NSTimeZone.system
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.calendar = .current
            $0.tintColor = AppSource.Color.blueTextColor
        }
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseId)
            $0.separatorStyle = .none
            $0.backgroundColor = AppSource.Color.background
            $0.reloadData()
            $0.showsVerticalScrollIndicator = false
        }
        saveButtonButton.do {
            $0.setTitle(AppSource.Text.Shared.save, for: .normal)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.addTarget(self, action: #selector(setNotificationTapped), for: .touchUpInside)
            $0.transform = .init(translationX: 0, y: 15)
        }
    }
    
    func setupConstraints() {
        view.addSubview(headerTitleWrapper)
        view.addSubview(doneLabel)
        view.addSubview(scrollWrapper)
        scrollWrapper.addSubview(name)
        scrollWrapper.addSubview(mainViewWrapper)
        scrollWrapper.addSubview(timePickerView)
        scrollWrapper.addSubview(tableView)
        scrollWrapper.addSubview(saveButtonButton)
        
        scrollWrapper.snp.makeConstraints {
            $0.top.equalTo(headerTitleWrapper.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
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
        name.snp.makeConstraints {
//            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(15)
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
        }
        timePickerView.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(15)
            $0.height.equalTo(34)
            $0.centerX.equalToSuperview()
        }
        mainViewWrapper.snp.makeConstraints {
            $0.top.equalTo(timePickerView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(335)
        }
        mondayTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(mondaySwitcher.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
        }
        mondaySwitcher.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView1.snp.makeConstraints {
            $0.leading.equalTo(mondayTextLabel.snp.leading)
            $0.trailing.equalTo(mondaySwitcher.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(mondaySwitcher.snp.bottom).offset(7)
        }
        tuesdayTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(tuesdaySwitcher.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
        }
        tuesdaySwitcher.snp.makeConstraints {
            $0.top.equalTo(mondaySwitcher.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView2.snp.makeConstraints {
            $0.leading.equalTo(tuesdayTextLabel.snp.leading)
            $0.trailing.equalTo(tuesdaySwitcher.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(tuesdaySwitcher.snp.bottom).offset(7)
        }
        wednesdayTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(wednesdaySwitcher.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
        }
        wednesdaySwitcher.snp.makeConstraints {
            $0.top.equalTo(tuesdaySwitcher.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView3.snp.makeConstraints {
            $0.leading.equalTo(wednesdayTextLabel.snp.leading)
            $0.trailing.equalTo(wednesdaySwitcher.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(wednesdaySwitcher.snp.bottom).offset(7)
        }
        
        thursdayTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(thursdaySwitcher.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
        }
        thursdaySwitcher.snp.makeConstraints {
            $0.top.equalTo(wednesdaySwitcher.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView4.snp.makeConstraints {
            $0.leading.equalTo(thursdayTextLabel.snp.leading)
            $0.trailing.equalTo(thursdaySwitcher.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(thursdaySwitcher.snp.bottom).offset(7)
        }
        fridayTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(fridaySwitcher.snp.centerY)
            $0.leading.equalToSuperview().offset(15)

        }
        fridaySwitcher.snp.makeConstraints {
            $0.top.equalTo(thursdaySwitcher.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView5.snp.makeConstraints {
            $0.leading.equalTo(saturdayTextLabel.snp.leading)
            $0.trailing.equalTo(saturdaySwitcher.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(fridaySwitcher.snp.bottom).offset(7)
        }
        saturdayTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(saturdaySwitcher.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
        }
        saturdaySwitcher.snp.makeConstraints {
            $0.top.equalTo(fridaySwitcher.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        stickView6.snp.makeConstraints {
            $0.leading.equalTo(sundayTextLabel.snp.leading)
            $0.trailing.equalTo(sundaySwitcher.snp.trailing)
            $0.height.equalTo(1)
            $0.top.equalTo(saturdaySwitcher.snp.bottom).offset(7)
        }
        
        sundayTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(sundaySwitcher.snp.centerY)
            $0.leading.equalToSuperview().offset(15)
        }
        sundaySwitcher.snp.makeConstraints {
            $0.top.equalTo(saturdaySwitcher.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }

        saveButtonButton.snp.makeConstraints {
            $0.top.equalTo(mainViewWrapper.snp.bottom)
            $0.height.equalTo(45)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(saveButtonButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(300)
        }
    }
}

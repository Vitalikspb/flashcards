

import UIKit
import SnapKit
import Then
import Charts

class StatisticsViewController: UIViewController {
    
    private lazy var topNameView = NameOfViewController()
    private lazy var scrollWrapper = VerticalScrollView()
    
    private lazy var topWrapper = UIView()
    private lazy var pieChartWrapper = UIView()
    private lazy var titlePieLabel = UILabel()
    private lazy var pieChartsView = PieChartView()
    
    private lazy var starView = UIView()
    private lazy var starFiveStack = StackViewStar()
    private lazy var starThreeStack = StackViewStar()
    private lazy var starOneStack = StackViewStar()
    
    private lazy var starSixLabelStack = UIStackView()
    private lazy var starSixLabel = UILabel()
    private lazy var starFourLabel = UILabel()
    private lazy var starTwoLabel = UILabel()
    
    private lazy var starSixPercentageLabelStack = UIStackView()
    private lazy var starSixPercentageLabel = UILabel()
    private lazy var starFourPercentageLabel = UILabel()
    private lazy var starTwoPercentageLabel = UILabel()
    
    
    private lazy var bottomWrapper = UIView()
    private lazy var pieChartSevenDayWrapper = UIView()
    private lazy var titlePieSevenDayLabel = UILabel()
    private lazy var pieChartSevenDayView = PieChartView()
    
    private lazy var segmentedControl = UISegmentedControl(items : items)
    private lazy var graphicView = UIView()
    
    private lazy var monValueLabel = UILabel()
    private lazy var tueValueLabel = UILabel()
    private lazy var wedValueLabel = UILabel()
    private lazy var thuValueLabel = UILabel()
    private lazy var friValueLabel = UILabel()
    private lazy var satValueLabel = UILabel()
    private lazy var sunValueLabel = UILabel()
    
    private lazy var barChartsView = BarChartView()
    
    private lazy var weekStack = UIStackView()
    private lazy var monLabel = UILabel()
    private lazy var tueLabel = UILabel()
    private lazy var wedLabel = UILabel()
    private lazy var thuLabel = UILabel()
    private lazy var friLabel = UILabel()
    private lazy var satLabel = UILabel()
    private lazy var sunLabel = UILabel()
    
    
    private lazy var buttonWrapper = UIView()
    private lazy var buttonsView = BottomButtonView()
    private lazy var countOfAllWords: Int = 0
    private lazy var repeatsCount: Int = 0
    private lazy var educationTime: Int = 0
    private var arrayOfWeekDay: [UILabel]!
    private var currentCardsCollection: [CardsModel]!
    private var moduleFactory = FactoryPresent()
    
    let items = [AppSource.Text.StatisticsVC.learnedWords,
                 AppSource.Text.StatisticsVC.educationTime,
                 AppSource.Text.StatisticsVC.repeats]
    
    let days: [String] = [AppSource.Text.NotificationVC.mondayShort,
                          AppSource.Text.NotificationVC.tuesdayShort,
                          AppSource.Text.NotificationVC.wednesdayShort,
                          AppSource.Text.NotificationVC.thursdayShort,
                          AppSource.Text.NotificationVC.fridayShort,
                          AppSource.Text.NotificationVC.saturdayShort,
                          AppSource.Text.NotificationVC.sundayShort]
    
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
        buttonsView.statisticsButtom.layer.borderColor = AppSource.Color.selectedStrokeBottomButton.cgColor
        buttonsView.statisticImage.tintColor = AppSource.Color.selectedStrokeBottomButton
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

extension StatisticsViewController: ChartViewDelegate {
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func setupPieChart() {
        var entries = [PieChartDataEntry]()
        let (hour, minutes, _) = secondsToHoursMinutesSeconds(seconds: educationTime)
        var educationString = "\(AppSource.Text.Shared.educationTime):\n\(hour) \(AppSource.Text.Shared.hour) \(minutes) \(AppSource.Text.Shared.minute)"
        if hour == 0 && minutes == 0 {
            educationString = ""
        }
        
        
        var repeatThousand = 0
        var repeatHundred = 0
        var repeatCountString = ""
        
        var tempRepeatCount = repeatsCount
        if repeatsCount > 1000 {
            tempRepeatCount = repeatsCount / 10
        } else if repeatsCount > 10000 {
            tempRepeatCount = repeatsCount / 100
        }
        
        if repeatsCount > 1000 {
            repeatThousand = repeatsCount / 1000
            repeatHundred = repeatsCount % 1000
            repeatCountString = "\(AppSource.Text.Shared.repeatsCount):\n \(repeatThousand) k. \(repeatHundred)"
        } else if repeatsCount != 0 {
            repeatCountString = "\(AppSource.Text.Shared.repeatsCount): \(repeatsCount)"
        } else {
            repeatCountString = ""
        }
        
        
        // из секунд получили минуты для нормального отображения круговой диаграммы
        let tempEducationTime = educationTime / 60
        
        entries.append(PieChartDataEntry(value: Double(countOfAllWords),
                                         label: "\(AppSource.Text.Shared.allWords): \(countOfAllWords)"))
        entries.append(PieChartDataEntry(value: Double(tempRepeatCount),
                                         label: repeatCountString))
        entries.append(PieChartDataEntry(value: Double(tempEducationTime),
                                         label: educationString))
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel()
        set.label = ""
        set.valueColors = [.clear]//[AppSource.Color.textColor]
        set.valueLineColor = .clear//[AppSource.Color.textColor]
        set.entryLabelColor = AppSource.Color.textColor
        set.valueTextColor = .clear//[AppSource.Color.textColor]
        set.valueFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        pieChartsView.legend.enabled = false
        pieChartsView.drawHoleEnabled = false
        let data = PieChartData(dataSet: set)
        pieChartsView.data = data
    }
    
    func setupPieChartSevenDay() {
        var entries = [PieChartDataEntry]()
        let dataCards = currentCardsCollection[0]
        let leaningWordsSevenDaysData = dataCards.countLeaningWordsSevenDays
        var newLearningWordsSevenDays = 0
        for (_, value) in leaningWordsSevenDaysData.enumerated() {
            newLearningWordsSevenDays += value.value
        }
        let educationTimeSevenDaysData = dataCards.educationTimeSevenDays
        var newEducationTimeSevenDays = 0
        for (_, value) in educationTimeSevenDaysData.enumerated() {
            newEducationTimeSevenDays += value.value
        }
        let repeatsCountSevenDaysData = dataCards.repeatsCountSevenDays
        var newRepeatsCountSevenDays = 0
        for (_, value) in repeatsCountSevenDaysData.enumerated() {
            newRepeatsCountSevenDays += value.value
        }
        
        var repeatThousand = 0
        var repeatHundred = 0
        var repeatCountString = ""
        
        var tempRepeatCount = newRepeatsCountSevenDays
        if newRepeatsCountSevenDays > 1000 {
            tempRepeatCount = newRepeatsCountSevenDays / 10
        } else if newRepeatsCountSevenDays > 10000 {
            tempRepeatCount = newRepeatsCountSevenDays / 100
        }
        
        if newRepeatsCountSevenDays > 1000 {
            repeatThousand = newRepeatsCountSevenDays / 1000
            repeatHundred = newRepeatsCountSevenDays % 1000
            repeatCountString = "\(AppSource.Text.Shared.repeatsCount):\n \(repeatThousand) k. \(repeatHundred)"
        } else if repeatsCount != 0 {
            repeatCountString = "\(AppSource.Text.Shared.repeatsCount): \(newRepeatsCountSevenDays)"
        } else {
            repeatCountString = ""
        }
        
        let (hour, minutes, _) = secondsToHoursMinutesSeconds(seconds: newEducationTimeSevenDays)
        
        var educationString = "\(AppSource.Text.Shared.educationTime):\n\(hour) \(AppSource.Text.Shared.hour) \(minutes) \(AppSource.Text.Shared.minute)"
        if hour == 0 && minutes == 0 {
            educationString = ""
        }
        // из секунд получили минуты для нормального отображения круговой диаграммы
        let tempNewEducationTimeSevenDays = newEducationTimeSevenDays / 60
        entries.append(PieChartDataEntry(value: Double(newLearningWordsSevenDays),
                                         label: "\(AppSource.Text.Shared.learnedWords): \(newLearningWordsSevenDays)"))
        entries.append(PieChartDataEntry(value: Double(tempRepeatCount),
                                         label: repeatCountString))
        entries.append(PieChartDataEntry(value: Double(tempNewEducationTimeSevenDays),
                                         label: educationString))
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel()
        set.label = ""
        set.valueColors = [.clear]//[AppSource.Color.textColor]
        set.valueLineColor = .clear//[AppSource.Color.textColor]
        set.entryLabelColor = AppSource.Color.textColor
        set.valueTextColor = .clear//[AppSource.Color.textColor]
        set.valueFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        pieChartSevenDayView.drawHoleEnabled = false
        pieChartSevenDayView.legend.enabled = false
        let data = PieChartData(dataSet: set)
        pieChartSevenDayView.data = data
    }
    
    
    func setupLineChart() {
        let xAxis = barChartsView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        
        let dataCards = currentCardsCollection[0]
        var entries = [ChartDataEntry]()
        let newData = dataCards.countLeaningWordsSevenDays.sorted { $0 < $1 }
        for (index, value) in newData.enumerated() {
            entries.append(BarChartDataEntry(x: Double(index),
                                             y: Double(value.value),
                                             data: days[index]))
        }
        let set = BarChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.pastel()
        set.valueTextColor = .clear
        let data = BarChartData(dataSet: set)
        data.setValueFont(UIFont.systemFont(ofSize: 10, weight: .regular))
        barChartsView.data = data
        barChartsView.leftAxis.enabled = true
        barChartsView.rightAxis.enabled = true
        barChartsView.legend.form = .empty
    }
    
    func setupLineChart1() {
        let xAxis = barChartsView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        
        let dataCards = currentCardsCollection[0]
        var entries = [ChartDataEntry]()
        let newData = dataCards.educationTimeSevenDays.sorted { $0 < $1 }
        for (index, value) in newData.enumerated() {
            let (hour, minutes, _) = secondsToHoursMinutesSeconds(seconds: value.value)
            let educationValue = Double(hour) + (Double(minutes) * 0.01)
            let roundEducationValue = round(educationValue * 100) / 100
            
            if hour == 0 && minutes == 0 {
                arrayOfWeekDay[index].text = "-"
            } else if hour == 0 {
                arrayOfWeekDay[index].text = "\(minutes) \(AppSource.Text.Shared.minuteShort)."
            } else if minutes == 0 {
                arrayOfWeekDay[index].text = "\(hour) \(AppSource.Text.Shared.hourShort)."
            } else {
                arrayOfWeekDay[index].text = "\(hour) \(AppSource.Text.Shared.hourShort)., \(minutes) \(AppSource.Text.Shared.minuteShort)."
            }
            
            entries.append(BarChartDataEntry(x: Double(index),
                                             y: roundEducationValue,
                                             data: days[index]))
            
            
        }
        let set = BarChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.pastel()
        set.valueTextColor = .clear
        let data = BarChartData(dataSet: set)
        data.setValueFont(UIFont.systemFont(ofSize: 10, weight: .regular))
        barChartsView.data = data
        barChartsView.leftAxis.enabled = false
        barChartsView.rightAxis.enabled = false
        barChartsView.legend.form = .empty
    }
    
    func setupLineChart2() {
        let xAxis = barChartsView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        
        let dataCards = currentCardsCollection[0]
        var entries = [ChartDataEntry]()
        let newData = dataCards.repeatsCountSevenDays.sorted { $0 < $1 }
        for (index, value) in newData.enumerated() {
            entries.append(BarChartDataEntry(x: Double(index),
                                             y: Double(value.value),
                                             data: days[index]))
        }
        let set = BarChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.pastel()
        set.valueTextColor = .clear
        let data = BarChartData(dataSet: set)
        data.setValueFont(UIFont.systemFont(ofSize: 10, weight: .regular))
        barChartsView.data = data
        barChartsView.leftAxis.enabled = true
        barChartsView.rightAxis.enabled = true
        barChartsView.legend.form = .empty
    }
    
    func showValueViews(show isShow: Bool) {
        arrayOfWeekDay.forEach {
            $0.isHidden = isShow ? true : false
        }
    }
}

private extension StatisticsViewController {
    func setupUserDefaultSettings() {
        switch UserDefaults.standard.integer(forKey: UserDefaults.statistic) {
        case 0:
            segmentedControl.selectedSegmentIndex = 0
            setupLineChart()
            showValueViews(show: true)
            changeLayoutBottomTopXAxisView(chart: ChartsView.learningWords)
        case 1:
            segmentedControl.selectedSegmentIndex = 1
            setupLineChart1()
            showValueViews(show: false)
            changeLayoutBottomTopXAxisView(chart: ChartsView.educationTime)
        case 2:
            segmentedControl.selectedSegmentIndex = 2
            setupLineChart2()
            showValueViews(show: true)
            changeLayoutBottomTopXAxisView(chart: ChartsView.repeatCount)
        default: print("error")
        }
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
    
}

extension StatisticsViewController {
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            UserDefaults.standard.set(0, forKey: UserDefaults.statistic)
            setupLineChart()
            showValueViews(show: true)
            changeLayoutBottomTopXAxisView(chart: ChartsView.learningWords)
        case 1:
            UserDefaults.standard.set(1, forKey: UserDefaults.statistic)
            setupLineChart1()
            showValueViews(show: false)
            changeLayoutBottomTopXAxisView(chart: ChartsView.educationTime)
        case 2:
            UserDefaults.standard.set(2, forKey: UserDefaults.statistic)
            setupLineChart2()
            showValueViews(show: true)
            changeLayoutBottomTopXAxisView(chart: ChartsView.repeatCount)
        default:
            break
        }
    }
    
    func changeLayoutBottomTopXAxisView(chart: ChartsView) {
        switch chart {
        case .learningWords:
            weekStack.snp.remakeConstraints {
                $0.leading.equalTo(barChartsView.snp.leading).offset(20)
                $0.trailing.equalTo(barChartsView.snp.trailing).offset(-20)
                $0.bottom.equalTo(barChartsView.snp.bottom).offset(-19)
                $0.height.equalTo(35)
            }
        case .educationTime:
            weekStack.snp.remakeConstraints {
                $0.leading.equalTo(barChartsView.snp.leading).offset(10)
                $0.trailing.equalTo(barChartsView.snp.trailing).offset(-10)
                $0.bottom.equalTo(barChartsView.snp.bottom).offset(-19)
                $0.height.equalTo(35)
            }
        case .repeatCount:
            weekStack.snp.remakeConstraints {
                $0.leading.equalTo(barChartsView.snp.leading).offset(22)
                $0.trailing.equalTo(barChartsView.snp.trailing).offset(-22)
                $0.bottom.equalTo(barChartsView.snp.bottom).offset(-19)
                $0.height.equalTo(35)
            }
        }
        
    }
}

extension StatisticsViewController {
    
    private func setupColors() {
        view.backgroundColor = AppSource.Color.background
        buttonWrapper.backgroundColor = AppSource.Color.background
        starView.backgroundColor = .clear
    }
    
    
    func setupProperties() {
        currentCardsCollection = UserDefaults.loadFromUD()
        arrayOfWeekDay = [monValueLabel, tueValueLabel, wedValueLabel, thuValueLabel,
                          friValueLabel, satValueLabel, sunValueLabel]
        let dataCards = currentCardsCollection[0]
        let todayDay = WeekDayCounter.returnDateOfDate()[0]
        let newData = dataCards.countLeaningWordsSevenDays.sorted { $0 > $1 }
        var dateDiff: Int
        
        for (_, value) in newData.enumerated() {
            dateDiff = Calendar.current.dateComponents([.day],
                                                       from: value.key,
                                                       to: todayDay).day ?? 0
            switch dateDiff {
            case 0:
                print("Today date and date in array is match")
            case 1:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[1]: newData[0].value,
                                                                         WeekDayCounter.returnDateOfDate()[2]: newData[1].value,
                                                                         WeekDayCounter.returnDateOfDate()[3]: newData[2].value,
                                                                         WeekDayCounter.returnDateOfDate()[4]: newData[3].value,
                                                                         WeekDayCounter.returnDateOfDate()[5]: newData[4].value,
                                                                         WeekDayCounter.returnDateOfDate()[6]: newData[5].value]
            case 2:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[2]: newData[0].value,
                                                                         WeekDayCounter.returnDateOfDate()[3]: newData[1].value,
                                                                         WeekDayCounter.returnDateOfDate()[4]: newData[2].value,
                                                                         WeekDayCounter.returnDateOfDate()[5]: newData[3].value,
                                                                         WeekDayCounter.returnDateOfDate()[6]: newData[4].value]
            case 3:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[3]: newData[0].value,
                                                                         WeekDayCounter.returnDateOfDate()[4]: newData[1].value,
                                                                         WeekDayCounter.returnDateOfDate()[5]: newData[2].value,
                                                                         WeekDayCounter.returnDateOfDate()[6]: newData[3].value]
            case 4:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[4]: newData[0].value,
                                                                         WeekDayCounter.returnDateOfDate()[5]: newData[1].value,
                                                                         WeekDayCounter.returnDateOfDate()[6]: newData[2].value]
            case 5:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[4]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[5]: newData[0].value,
                                                                         WeekDayCounter.returnDateOfDate()[6]: newData[1].value]
            case 6:
                currentCardsCollection[0].countLeaningWordsSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[4]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[5]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[6]: newData[0].value]
            default:
                // сдвиг по дням составить больше 7 дней и значит выставляем везде 0
                currentCardsCollection[0].countLeaningWordsSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[4]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[5]: 0,
                                                                         WeekDayCounter.returnDateOfDate()[6]: 0]
            }
            // после первого прохода останавливаем цикл
            break
        }
        
        let newData1 = dataCards.educationTimeSevenDays.sorted { $0 > $1 }
        var dateDiff1: Int
        
        for (_, value) in newData1.enumerated() {
            dateDiff1 = Calendar.current.dateComponents([.day],
                                                        from: value.key,
                                                        to: todayDay).day ?? 0
            switch dateDiff1 {
            case 0:
                print("Today date and date in array is match")
            case 1:
                
                currentCardsCollection[0].educationTimeSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[1]: newData1[0].value,
                                                                     WeekDayCounter.returnDateOfDate()[2]: newData1[1].value,
                                                                     WeekDayCounter.returnDateOfDate()[3]: newData1[2].value,
                                                                     WeekDayCounter.returnDateOfDate()[4]: newData1[3].value,
                                                                     WeekDayCounter.returnDateOfDate()[5]: newData1[4].value,
                                                                     WeekDayCounter.returnDateOfDate()[6]: newData1[5].value]
            case 2:
                currentCardsCollection[0].educationTimeSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[2]: newData1[0].value,
                                                                     WeekDayCounter.returnDateOfDate()[3]: newData1[1].value,
                                                                     WeekDayCounter.returnDateOfDate()[4]: newData1[2].value,
                                                                     WeekDayCounter.returnDateOfDate()[5]: newData1[3].value,
                                                                     WeekDayCounter.returnDateOfDate()[6]: newData1[4].value]
            case 3:
                currentCardsCollection[0].educationTimeSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[3]: newData1[0].value,
                                                                     WeekDayCounter.returnDateOfDate()[4]: newData1[1].value,
                                                                     WeekDayCounter.returnDateOfDate()[5]: newData1[2].value,
                                                                     WeekDayCounter.returnDateOfDate()[6]: newData1[3].value]
            case 4:
                currentCardsCollection[0].educationTimeSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[4]: newData1[0].value,
                                                                     WeekDayCounter.returnDateOfDate()[5]: newData1[1].value,
                                                                     WeekDayCounter.returnDateOfDate()[6]: newData1[2].value]
            case 5:
                currentCardsCollection[0].educationTimeSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[4]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[5]: newData1[0].value,
                                                                     WeekDayCounter.returnDateOfDate()[6]: newData1[1].value]
            case 6:
                currentCardsCollection[0].educationTimeSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[4]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[5]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[6]: newData1[0].value]
            default:
                // сдвиг по дням составить больше 7 дней и значит выставляем везде 0
                currentCardsCollection[0].educationTimeSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[4]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[5]: 0,
                                                                     WeekDayCounter.returnDateOfDate()[6]: 0]
            }
            
            // после первого прохода останавливаем цикл
            break
        }
        
        let newData2 = dataCards.repeatsCountSevenDays.sorted { $0 > $1 }
        var dateDiff2: Int
        for (_, value) in newData2.enumerated() {
            dateDiff2 = Calendar.current.dateComponents([.day],
                                                        from: value.key,
                                                        to: todayDay).day ?? 0
            switch dateDiff2 {
            case 0:
                print("Today date and date in array is match")
            case 1:
                
                currentCardsCollection[0].repeatsCountSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[1]: newData2[0].value,
                                                                    WeekDayCounter.returnDateOfDate()[2]: newData2[1].value,
                                                                    WeekDayCounter.returnDateOfDate()[3]: newData2[2].value,
                                                                    WeekDayCounter.returnDateOfDate()[4]: newData2[3].value,
                                                                    WeekDayCounter.returnDateOfDate()[5]: newData2[4].value,
                                                                    WeekDayCounter.returnDateOfDate()[6]: newData2[5].value]
            case 2:
                currentCardsCollection[0].repeatsCountSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[2]: newData2[0].value,
                                                                    WeekDayCounter.returnDateOfDate()[3]: newData2[1].value,
                                                                    WeekDayCounter.returnDateOfDate()[4]: newData2[2].value,
                                                                    WeekDayCounter.returnDateOfDate()[5]: newData2[3].value,
                                                                    WeekDayCounter.returnDateOfDate()[6]: newData2[4].value]
            case 3:
                currentCardsCollection[0].repeatsCountSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[3]: newData2[0].value,
                                                                    WeekDayCounter.returnDateOfDate()[4]: newData2[1].value,
                                                                    WeekDayCounter.returnDateOfDate()[5]: newData2[2].value,
                                                                    WeekDayCounter.returnDateOfDate()[6]: newData2[3].value]
            case 4:
                currentCardsCollection[0].repeatsCountSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[4]: newData2[0].value,
                                                                    WeekDayCounter.returnDateOfDate()[5]: newData2[1].value,
                                                                    WeekDayCounter.returnDateOfDate()[6]: newData2[2].value]
            case 5:
                currentCardsCollection[0].repeatsCountSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[4]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[5]: newData2[0].value,
                                                                    WeekDayCounter.returnDateOfDate()[6]: newData2[1].value]
            case 6:
                currentCardsCollection[0].repeatsCountSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[4]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[5]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[6]: newData2[0].value]
            default:
                // сдвиг по дням составить больше 7 дней и значит выставляем везде 0
                currentCardsCollection[0].repeatsCountSevenDays =  [WeekDayCounter.returnDateOfDate()[0]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[1]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[2]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[3]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[4]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[5]: 0,
                                                                    WeekDayCounter.returnDateOfDate()[6]: 0]
            }
            // после первого прохода останавливаем цикл
            break
        }
        // время обучения должно обновляться при окончании обучения
        educationTime = currentCardsCollection[0].educationTime
        
        // количество повторений должно обновляться при окончании обучения
        repeatsCount = currentCardsCollection[0].repeatsCount
        
        // количество всех слов должно обновляться при сохранении и удалении коллекции карточек
        countOfAllWords = currentCardsCollection[0].countAllWords
        
        // сохраняем обновленные данные локально - количество всех повторений и количество времени обучения
        UserDefaults.saveToUD(currentCardsCollection)
        
        // загружаем правильные данные
        currentCardsCollection = UserDefaults.loadFromUD()
        
        starSixLabel.text = "\(currentCardsCollection[0].countFiveStar) " + AppSource.Text.StatisticsVC.word
        starFourLabel.text = "\(currentCardsCollection[0].countThreeStar) " + AppSource.Text.StatisticsVC.word
        starTwoLabel.text = "\(currentCardsCollection[0].countOneStar) " + AppSource.Text.StatisticsVC.word
        
        let delet: Double = 100.0 // 100 %
        if Double(currentCardsCollection[0].countFiveStar) != 0 &&
            Double(currentCardsCollection[0].countThreeStar) != 0 &&
            Double(currentCardsCollection[0].countOneStar) != 0 {
            let delimFive: Double = Double(currentCardsCollection[0].countAllWords) / Double(currentCardsCollection[0].countFiveStar)
            let delimThree: Double = Double(currentCardsCollection[0].countAllWords) / Double(currentCardsCollection[0].countThreeStar)
            let delimOne: Double = Double(currentCardsCollection[0].countAllWords) / Double(currentCardsCollection[0].countOneStar)
            let fivePercentage: Double = (delet / delimFive)
            let threePercentage: Double = (delet / delimThree)
            let onePercentage: Double = (delet / delimOne)
            
            starSixPercentageLabel.text = "\(round(fivePercentage)) %"
            starFourPercentageLabel.text = "\(round(threePercentage)) %"
            starTwoPercentageLabel.text = "\(round(onePercentage)) %"
        } else {
            starSixPercentageLabel.text = "- %"
            starFourPercentageLabel.text = "- %"
            starTwoPercentageLabel.text = "- %"
        }
        for arrayOfIndex in 0...6 {
            var myarray: [String] = []
            let index = Calendar.current.component(.weekday, from: Date()) - 1
            var curIndex = 0
            var finalArray = [String]()
            for i in 0...6 {
                if index - i < 0 {
                    curIndex = 7 - abs(index - i)
                }
                if index - i == 0 {
                    curIndex = 0
                }
                if index - i > 0 {
                    curIndex = index - i
                }
                myarray.append(String(curIndex))
            }
            finalArray = myarray.reversed()
            let indexWeekDay = Int(finalArray[Int(arrayOfIndex)])!
            let arrayOfWeekDay = [ monLabel, tueLabel, wedLabel, thuLabel,
                                   friLabel, satLabel, sunLabel]
            let nameOfWeekDay = [ AppSource.Text.NotificationVC.sundayShort,
                                  AppSource.Text.NotificationVC.mondayShort,
                                  AppSource.Text.NotificationVC.tuesdayShort,
                                  AppSource.Text.NotificationVC.wednesdayShort,
                                  AppSource.Text.NotificationVC.thursdayShort,
                                  AppSource.Text.NotificationVC.fridayShort,
                                  AppSource.Text.NotificationVC.saturdayShort
            ]
            arrayOfWeekDay[arrayOfIndex].text = nameOfWeekDay[indexWeekDay]
        }
    }
    
    private func setupView() {
        setupColors()
        setupProperties()
        setupPieChart()
        setupPieChartSevenDay()
        setupLineChart()
        
        scrollWrapper.do {
            $0.backgroundColor = .clear
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
        }
        topWrapper.do {
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addSubview(pieChartWrapper)
            $0.addSubview(starView)
        }
        
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
        
        topNameView.do {
            $0.isHidden = true
            $0.showNameView(AppSource.Text.StatisticsVC.statistic, andImage: AppSource.Image.waveform!)
        }
        pieChartWrapper.do {
            $0.addSubview(pieChartsView)
            $0.addSubview(titlePieLabel)
        }
        
        pieChartsView.do {
            $0.delegate = self
            $0.center = view.center
        }
        titlePieLabel.do {
            $0.text = AppSource.Text.Shared.allTimeEducation
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        }
        
        starView.do {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addSubview(starFiveStack)
            $0.addSubview(starThreeStack)
            $0.addSubview(starOneStack)
            $0.addSubview(starSixLabelStack)
            $0.addSubview(starSixPercentageLabelStack)
        }
        starFiveStack.do {
            $0.show(with: 5)
        }
        starThreeStack.do {
            $0.show(with: 3)
        }
        starOneStack.do {
            $0.show(with: 1)
        }
        starSixLabelStack.do {
            $0.alignment = .trailing
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.addArrangedSubview(starSixLabel)
            $0.addArrangedSubview(starFourLabel)
            $0.addArrangedSubview(starTwoLabel)
        }
        starSixLabel.do {
            $0.textAlignment = .right
            $0.textColor = AppSource.Color.textColor
        }
        starFourLabel.do {
            $0.textAlignment = .right
            $0.textColor = AppSource.Color.textColor
        }
        
        starTwoLabel.do {
            $0.textAlignment = .right
            $0.textColor = AppSource.Color.textColor
        }
        starSixPercentageLabelStack.do {
            $0.alignment = .center
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.addArrangedSubview(starSixPercentageLabel)
            $0.addArrangedSubview(starFourPercentageLabel)
            $0.addArrangedSubview(starTwoPercentageLabel)
        }
        starSixPercentageLabel.do {
            $0.textAlignment = .right
            $0.textColor = AppSource.Color.textColor
        }
        starFourPercentageLabel.do {
            $0.textAlignment = .right
            $0.textColor = AppSource.Color.textColor
        }
        starTwoPercentageLabel.do {
            $0.textAlignment = .right
            $0.textColor = AppSource.Color.textColor
        }
        bottomWrapper.do {
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addSubview(pieChartSevenDayWrapper)
            $0.addSubview(graphicView)
            
        }
        pieChartSevenDayWrapper.do {
            $0.addSubview(pieChartSevenDayView)
            $0.addSubview(titlePieSevenDayLabel)
        }
        pieChartSevenDayView.do {
            $0.delegate = self
            $0.center = view.center
        }
        titlePieSevenDayLabel.do {
            $0.text = AppSource.Text.Shared.sevenDayEducation
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        }
        segmentedControl.do {
            $0.selectedSegmentIndex = 0
            $0.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
            $0.backgroundColor = AppSource.Color.backgroundBottonView
            $0.selectedSegmentTintColor = AppSource.Color.backgroundWrapperView
        }
        graphicView.do {
            $0.addSubview(segmentedControl)
            $0.addSubview(barChartsView)
            $0.addSubview(monValueLabel)
            $0.addSubview(tueValueLabel)
            $0.addSubview(wedValueLabel)
            $0.addSubview(thuValueLabel)
            $0.addSubview(friValueLabel)
            $0.addSubview(satValueLabel)
            $0.addSubview(sunValueLabel)
            $0.addSubview(weekStack)
        }
        [monValueLabel, tueValueLabel, wedValueLabel, thuValueLabel,
         friValueLabel, satValueLabel, sunValueLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/3))
            $0.backgroundColor = .clear
         }
        
        barChartsView.do {
            $0.delegate = self
            $0.center = view.center
        }
        weekStack.do {
            $0.backgroundColor = AppSource.Color.backgroundWrapperView
            $0.alignment = .center
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.addArrangedSubview(monLabel)
            $0.addArrangedSubview(tueLabel)
            $0.addArrangedSubview(wedLabel)
            $0.addArrangedSubview(thuLabel)
            $0.addArrangedSubview(friLabel)
            $0.addArrangedSubview(satLabel)
            $0.addArrangedSubview(sunLabel)
        }
        [monLabel, tueLabel, wedLabel, thuLabel,
         friLabel, satLabel, sunLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
         }
        buttonWrapper.do {
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
        }
    }
    private func setupConstraints() {
        view.addSubview(scrollWrapper)
        view.addSubview(buttonWrapper)
        
        scrollWrapper.addSubview(topWrapper)
        scrollWrapper.addSubview(bottomWrapper)
        
        buttonWrapper.addSubview(buttonsView)
        view.addSubview(topNameView)
        scrollWrapper.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonWrapper.snp.top)
        }
        
        topWrapper.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(420)
            $0.bottom.equalTo(bottomWrapper.snp.top).offset(-15)
        }
        
        
        topNameView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        }
        titlePieLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-17)
            $0.centerX.equalToSuperview()
        }
        pieChartWrapper.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(280)
        }
        pieChartsView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        starView.snp.makeConstraints {
            $0.top.equalTo(pieChartWrapper.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        starFiveStack.snp.makeConstraints {
            $0.centerY.equalTo(starSixLabel.snp.centerY).offset(-5)
            $0.height.equalTo(20)
            $0.width.equalTo(90)
            var leadingSize = 40
            leadingSize = UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue ? 10 : 40
            $0.leading.equalToSuperview().offset(leadingSize)
            $0.trailing.equalTo(starSixLabelStack.snp.leading).offset(5)
            
        }
        starThreeStack.snp.makeConstraints {
            $0.centerY.equalTo(starFourLabel.snp.centerY).offset(-5)
            $0.height.equalTo(20)
            $0.width.equalTo(90)
            $0.leading.equalTo(starFiveStack.snp.leading)
            $0.trailing.equalTo(starFiveStack.snp.trailing)
        }
        starOneStack.snp.makeConstraints {
            $0.centerY.equalTo(starTwoLabel.snp.centerY).offset(-5)
            $0.height.equalTo(20)
            $0.width.equalTo(90)
            $0.leading.equalTo(starFiveStack.snp.leading)
            $0.trailing.equalTo(starFiveStack.snp.trailing)
        }
        starSixLabelStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-7)
            $0.trailing.equalTo(starSixPercentageLabelStack.snp.leading).offset(-10)
        }
        starSixPercentageLabelStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-7)
            var trailingSize = -40
            trailingSize = UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue ? -5 : -40
            $0.trailing.equalToSuperview().offset(trailingSize)
            $0.width.equalTo(58)
        }
        bottomWrapper.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(15)
            $0.height.equalTo(715)
        }
        
        pieChartSevenDayWrapper.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(280)
        }
        titlePieSevenDayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-17)
            $0.centerX.equalToSuperview()
        }
        pieChartSevenDayView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        graphicView.snp.makeConstraints {
            $0.top.equalTo(pieChartSevenDayWrapper.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview().inset(15)
            $0.height.equalTo(360)
        }
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.trailing.equalToSuperview()
        }
        [monValueLabel, tueValueLabel, wedValueLabel, thuValueLabel,
         friValueLabel, satValueLabel, sunValueLabel].forEach {
            $0.snp.makeConstraints {
                $0.bottom.equalTo(barChartsView.snp.top).offset(-15)
                $0.height.equalTo(25)
                $0.width.equalTo(80)
            }
         }
        
        monValueLabel.snp.makeConstraints {
            var leadingSize = -3
            if UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue {
                leadingSize = -11
            } else if UIScreen.main.bounds.height <= DeviceHeight.iphone6s.rawValue {
                leadingSize = -7
            } else if UIScreen.main.bounds.height <= DeviceHeight.iphoneX.rawValue {
                leadingSize = -5
            } else if UIScreen.main.bounds.height <= DeviceHeight.iphone11.rawValue {
                leadingSize = -3
            }
            $0.leading.equalTo(barChartsView.snp.leading).offset(leadingSize)
        }
        var leadingSize = -33
        if UIScreen.main.bounds.height <= DeviceHeight.iphoneSE.rawValue {
            leadingSize = -46
        } else if UIScreen.main.bounds.height <= DeviceHeight.iphone6s.rawValue {
            leadingSize = -38
        } else if UIScreen.main.bounds.height <= DeviceHeight.iphoneX.rawValue {
            leadingSize = -38
        } else if UIScreen.main.bounds.height <= DeviceHeight.iphone11.rawValue {
            leadingSize = -33
        }
        tueValueLabel.snp.makeConstraints {
            $0.leading.equalTo(monValueLabel.snp.trailing).offset(leadingSize)
        }
        wedValueLabel.snp.makeConstraints {
            $0.leading.equalTo(tueValueLabel.snp.trailing).offset(leadingSize)
        }
        thuValueLabel.snp.makeConstraints {
            $0.leading.equalTo(wedValueLabel.snp.trailing).offset(leadingSize)
        }
        friValueLabel.snp.makeConstraints {
            $0.leading.equalTo(thuValueLabel.snp.trailing).offset(leadingSize)
        }
        satValueLabel.snp.makeConstraints {
            $0.leading.equalTo(friValueLabel.snp.trailing).offset(leadingSize)
        }
        sunValueLabel.snp.makeConstraints {
            $0.leading.equalTo(satValueLabel.snp.trailing).offset(leadingSize)
            $0.trailing.equalTo(barChartsView.snp.trailing).offset(2)
        }
        barChartsView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        weekStack.snp.remakeConstraints {
            $0.leading.equalTo(barChartsView.snp.leading).offset(20)
            $0.trailing.equalTo(barChartsView.snp.trailing).offset(-20)
            $0.bottom.equalTo(barChartsView.snp.bottom).offset(-19)
            $0.height.equalTo(35)
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


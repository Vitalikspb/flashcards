

import UIKit
import SnapKit
import Then


class AddPackOfCardToLearnViewController: PopupViewController {
    
    private lazy var headerTitleWrapper = UIView()
    private lazy var headerTitleStick = UIView()
    private lazy var headerTitleLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private var currentCardsCollection: [CardsModel]!
    var choosenCardsToLearn: ((_ indexPath: IndexPath,
                               _ nativeArray: [Int: String],
                               _ foreignArray: [Int: String]) -> Void)?
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
}

extension AddPackOfCardToLearnViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCardToLearnCollectionCell.reuseCellIdentifier, for: indexPath) as! AddCardToLearnCollectionCell
        
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
        guard let currentCards = currentCardsCollection[0].cardsCollection?[indexPath.section] else { return }
        let nativeArray = currentCards.info[indexPath.row].arrayNativeWords
        let foreignArray = currentCards.info[indexPath.row].arrayForeignWords
        choosenCardsToLearn?(indexPath, nativeArray, foreignArray)
        dismiss(animated: true, completion: nil)
    }
    
}


private extension AddPackOfCardToLearnViewController {
    
    func setupColors() {
        view.backgroundColor = AppSource.Color.background
        collectionView.backgroundColor = AppSource.Color.background
    }
    func setupProperties() {
        currentCardsCollection = UserDefaults.loadFromUD()
        
    }
    
    func setupView() {
        setupColors()
        setupProperties()
        collectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
            
            $0.register(AddCardToLearnCollectionCell.self,
                        forCellWithReuseIdentifier: AddCardToLearnCollectionCell.reuseCellIdentifier)
            $0.register(SectionHeader.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: "header")
            $0.delegate = self
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.setCollectionViewLayout(layout, animated: true)
            $0.reloadData()
        }
        headerTitleWrapper.do {
            $0.backgroundColor = AppSource.Color.background
            $0.addSubview(headerTitleLabel)
            $0.addSubview(headerTitleStick)
        }
        headerTitleStick.do {
            $0.backgroundColor = AppSource.Color.titleStick
        }
        headerTitleLabel.do {
            $0.text = AppSource.Text.AddPackOfCardToLearnVC.chooseForLearning
            $0.textColor = AppSource.Color.textColor
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        
    }
    
    func setupConstraints() {
        view.addSubview(headerTitleWrapper)
        view.addSubview(collectionView)

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
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerTitleStick.snp.bottom)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
        }
    }
}

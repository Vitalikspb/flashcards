

import UIKit
import SnapKit

public class SectionHeader: UICollectionReusableView {
    var label: UILabel = {
        let label: UILabel = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppSource.Color.textColor
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)

        label.snp.makeConstraints {
            if UIScreen.main.bounds.height <= 667 {
                $0.top.equalToSuperview().offset(40)
            } else {
                $0.top.equalToSuperview().offset(30)
            }
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

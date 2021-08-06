//
//  PrivacyLabel.swift


import UIKit
import AttributedString

class PrivacyLabel: UILabel {
    var mainColor: UIColor = .black {
        didSet {
            setupText()
        }
    }
    
    init() {
        super.init(frame: .zero)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        textAlignment = .center
        backgroundColor = .clear
        sizeToFit()
        clipsToBounds = false
        setupText()
    }
    
    private func setupText() {
        let terms = AttributedString(string: AppSource.Text.Shared.termsOfUse, with: [
            .font(.systemFont(ofSize: 14, weight: .medium)),
            .foreground(mainColor),
            .action([.foreground(mainColor.darker(by: 0.3))], {  UIApplication.shared.open(AppSource.Constants.termsOfUseURL) })
        ])
        
        let and = AttributedString(string: " & ", with: [
            .font(.systemFont(ofSize: 14, weight: .medium)),
            .foreground(mainColor),
        ])
        
        let privacy = AttributedString(string: AppSource.Text.Shared.privacyPolicy, with: [
            .font(.systemFont(ofSize: 14, weight: .medium)),
            .foreground(mainColor),
            .action([.foreground(mainColor.darker(by: 0.3))], {  UIApplication.shared.open(AppSource.Constants.privacyPolicyURL) })
        ])
        
        attributed.text = terms + and + privacy
    }
    
    private func setupTerms() {
        let terms = AttributedString(string: AppSource.Text.Shared.termsOfUse, with: [
            .font(.systemFont(ofSize: 14, weight: .medium)),
            .foreground(mainColor),
            .action([.foreground(mainColor.darker(by: 0.3))], {  UIApplication.shared.open(AppSource.Constants.termsOfUseURL) })
        ])
        
        attributed.text = terms
    }
    
    private func setupPrivacy() {
        let privacy = AttributedString(string: AppSource.Text.Shared.privacyPolicy, with: [
            .font(.systemFont(ofSize: 14, weight: .medium)),
            .foreground(mainColor),
            .action([.foreground(mainColor.darker(by: 0.3))], {  UIApplication.shared.open(AppSource.Constants.privacyPolicyURL) })
        ])
        
        attributed.text = privacy
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

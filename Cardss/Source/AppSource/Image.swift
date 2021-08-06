
import UIKit

extension AppSource.Image {
    //MARK: - showHints View
    static var leftSwipePic: UIImage? {
        UIImage(named: "leftSwipePic")
    }
    static var rightSwipePic: UIImage? {
        UIImage(named: "rightSwipePic")
    }
    static var downSwipePic: UIImage? {
        UIImage(named: "downSwipePic")
    }
    static var longPressVoicePic: UIImage? {
        UIImage(named: "longPressVoicePic")
    }
    static var showWordPic: UIImage? {
        UIImage(named: "showWordPic")
    }
    static var showWordAct: UIImage? {
        UIImage(systemName: "doc.text.viewfinder",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    
    //MARK: - subscription View
    static var allFunctions: UIImage? {
        UIImage(systemName: "checkmark.seal",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var useLibrary: UIImage? {
        UIImage(systemName: "book",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var noAds: UIImage? {
        UIImage(systemName: "play.slash",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    
    //MARK: - settings View
    static var account: UIImage? {
        UIImage(systemName: "personalhotspot",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var support: UIImage? {
        UIImage(systemName: "message",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var share: UIImage? {
        UIImage(systemName: "square.and.arrow.up",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate).imageFlippedForRightToLeftLayoutDirection()
    }
    static var rate: UIImage? {
        UIImage(systemName: "star.circle",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var notification: UIImage? {
        UIImage(systemName: "calendar",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var voice: UIImage? {
        UIImage(systemName: "music.note",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    
    //MARK: - Other View
    static var voiceHand: UIImage? {
        UIImage(named: "voice")
    }
    static var rightArrow: UIImage? {
        UIImage(named: "RightArrow")?.imageFlippedForRightToLeftLayoutDirection()
    }
    static var logo: UIImage? {
        UIImage(named: "logo")
    }
    static var close: UIImage? {
        UIImage(named: "close")
    }
    static var press: UIImage? {
        UIImage(named: "press")
    }
    static var bullet: UIImage? {
        UIImage(systemName: "list.bullet")
    }
    static var waveform: UIImage? {
        UIImage(systemName: "waveform.path.ecg")
    }
    static var slider: UIImage? {
        UIImage(systemName: "slider.horizontal.3")
    }
    static var play: UIImage? {
        UIImage(systemName: "play.circle")
    }
    static var emptyImageOnFlags: UIImage? {
        UIImage(systemName: "wand.and.rays.inverse",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var speakWord: UIImage? {
        UIImage(systemName: "speaker.wave.3",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var book: UIImage? {
        UIImage(systemName: "book",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var star: UIImage? {
        UIImage(systemName: "star",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
    static var checkmark: UIImage? {
        UIImage(systemName: "checkmark",
                withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withRenderingMode(.alwaysTemplate)
    }
}

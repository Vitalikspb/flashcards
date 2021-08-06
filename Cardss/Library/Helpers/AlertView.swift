
import UIKit

class CreateAlerts {
    static func errorAlert(with error: String, and message: String) -> UIAlertController  {
        let alertController = UIAlertController(title: error,
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        let OkButton = UIAlertAction(title: AppSource.Text.Shared.ok,
                                     style: .default,
                                     handler: nil)
        alertController.addAction(OkButton)
        return alertController
    }
    static func errorAlertWithCancel(with error: String, and message: String, complection: @escaping ()->Void) -> UIAlertController  {
        let alertController = UIAlertController(title: error,
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        let OkButton = UIAlertAction(title: AppSource.Text.Shared.ok,
                                     style: .default,
                                     handler: nil)
        let cancelButton = UIAlertAction(title: AppSource.Text.Shared.close,
                                style: .destructive) { (cancel) in
            complection()
        }
        
        alertController.addAction(OkButton)
        alertController.addAction(cancelButton)
        return alertController
    }
    
    static func ResetPasswordAlert() -> UIAlertController  {
        let alertController = UIAlertController(title: AppSource.Text.Shared.warning,
                                                message: AppSource.Text.AccountVC.resetPassword,
                                                preferredStyle: UIAlertController.Style.alert)
        let OkButton = UIAlertAction(title: AppSource.Text.Shared.ok,
                                     style: .default) { (reset) in
            
        }
        alertController.addAction(OkButton)
        return alertController
    }
}

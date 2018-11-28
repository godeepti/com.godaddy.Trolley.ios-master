import UIKit

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet private(set) var emailTextField: UITextField!
    @IBOutlet private(set) var statusLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reset()
    }
    
    private func reset() {
        emailTextField.layer.borderColor = nil
        emailTextField.layer.borderWidth = 0
        statusLabel.text = nil
    }
    
    private func updateWarning() {
        emailTextField.layer.borderColor = UIColor.red.cgColor
        emailTextField.layer.borderWidth = 1
        statusLabel.text = "You must enter a valid email address."
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        if emailTextField.text?.isValidEmail() ?? false {
            let dataStore = DataStore()
            dataStore.save(User(email: emailTextField.text!))
            dismiss(animated: true, completion: nil)
        } else {
            updateWarning()
        }
    }
    
    // MARK: - UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reset()
    }
}

extension String {
    func isValidEmail() -> Bool {
        let pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let regex = try! NSRegularExpression(
            pattern: pattern,
            options: .caseInsensitive
        )
        return regex.firstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: count)
        ) != nil
    }
}

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let dataStore = DataStore()
        if dataStore.fetch(User.self) != nil {
            performSegue(withIdentifier: "PresentHome", sender: nil)
        } else {
            performSegue(withIdentifier: "PresentAuth", sender: nil)
        }
    }
    
}

import UIKit

class StoreViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private(set) var itemNameLabel1: UILabel!
    @IBOutlet private(set) var itemQtyLabel1: UILabel!
    @IBOutlet private(set) var itemStepper1: UIStepper!
    
    @IBOutlet private(set) var itemNameLabel2: UILabel!
    @IBOutlet private(set) var itemQtyLabel2: UILabel!
    @IBOutlet private(set) var itemStepper2: UIStepper!
    
    @IBOutlet private(set) var itemNameLabel3: UILabel!
    @IBOutlet private(set) var itemQtyLabel3: UILabel!
    @IBOutlet private(set) var itemStepper3: UIStepper!
    
    @IBOutlet private(set) var itemNameLabel4: UILabel!
    @IBOutlet private(set) var itemQtyLabel4: UILabel!
    @IBOutlet private(set) var itemStepper4: UIStepper!
    
    @IBOutlet private(set) var itemNameLabel5: UILabel!
    @IBOutlet private(set) var itemQtyLabel5: UILabel!
    @IBOutlet private(set) var itemStepper5: UIStepper!
    
    // MARK: - Properties
    var dataSource: [CartItem] = []
    
    var didSave: (([CartItem]) -> Void)?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    private func update() {
        [
            (dataSource[0], itemNameLabel1, itemQtyLabel1, itemStepper1),
            (dataSource[1], itemNameLabel2, itemQtyLabel2, itemStepper2),
            (dataSource[2], itemNameLabel3, itemQtyLabel3, itemStepper3),
            (dataSource[3], itemNameLabel4, itemQtyLabel4, itemStepper4),
            (dataSource[4], itemNameLabel5, itemQtyLabel5, itemStepper5),
            ].forEach {
                $0.1?.text = $0.0.name + " @ $\($0.0.price)"
                $0.2?.text = "\($0.0.quantity)"
                $0.3?.value = Double($0.0.quantity)
        }
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        didSave?(dataSource)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let index: Int
        switch sender {
        case itemStepper1: index = 0
        case itemStepper2: index = 1
        case itemStepper3: index = 2
        case itemStepper4: index = 3
        case itemStepper5: index = 4
        default: fatalError("Undefined UIStepper")
        }
        
        var item = dataSource[index]
        item.quantity = Int(sender.value)
        dataSource[index] = item
        
        update()
    }
}

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private(set) var tableView: UITableView!
    @IBOutlet private(set) var priceLabel: UILabel!
    
    // MARK: - Properties
    private(set) var cart: Cart!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        if let cart = DataStore().fetch(Cart?.self) {
            self.cart = cart
        } else {
            self.cart = Cart(items: .default)
        }
        
        updatePrice(for: cart)
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "PresentStore"
            else { return }
        
        let storeViewController = segue.destination as! StoreViewController
        storeViewController.dataSource = cart.items
        storeViewController.didSave = { [unowned self] items in
            self.cart.items = items
            DataStore().save(self.cart)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Updates
    private func updatePrice(for cart: Cart) {
        var price: Decimal = 0.0
        cart.items.forEach { item in
            price += Decimal(item.quantity) * item.price
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        priceLabel.text = formatter.string(from: NSDecimalNumber(decimal: price))
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "PresentStore", sender: nil)
    }
    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
        let dataStore = DataStore()
        dataStore.removeAll(Cart.self)
        dataStore.removeAll(User.self)
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeTableViewCell.id,
            for: indexPath
        ) as! HomeTableViewCell
        
        guard let item = cart?.items[indexPath.row]
            else { return cell }
        
        cell.configure(with: item)
        
        return cell
    }
    
}

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - ID
    static var id: String { return String(describing: self) }
    
    // MARK: - Outlets
    @IBOutlet private(set) var nameLabel: UILabel!
    @IBOutlet private(set) var qtyLabel: UILabel!
    @IBOutlet private(set) var priceLabel: UILabel!
    
    // MARK: - Configuration
    func configure(with item: CartItem) {
        nameLabel.text = item.name
        qtyLabel.text = "Qty: \(item.quantity)"
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        priceLabel.text = formatter.string(from: NSDecimalNumber(decimal: item.price))
    }
}

extension Array where Element == CartItem {
    static var `default`: [Element] {
        return [
            CartItem(name: "Apples", quantity: 0, price: 1),
            CartItem(name: "Bananas", quantity: 0, price: 1.50),
            CartItem(name: "Oranges", quantity: 0, price: 2),
            CartItem(name: "Kiwis", quantity: 0, price: 0.50),
            CartItem(name: "Pears", quantity: 0, price: 0.75)
        ]
    }
}

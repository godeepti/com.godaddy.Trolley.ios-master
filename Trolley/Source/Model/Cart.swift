import Foundation

struct Cart: Codable {
    var items: [CartItem]
}

struct CartItem: Codable {
    var name: String
    var quantity: Int
    var price: Decimal
}

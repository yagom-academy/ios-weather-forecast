
import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let iconID: String
    
    private enum CodingKeys: String, CodingKey {
        case id, main, description
        case iconID = "icon"
    }
}

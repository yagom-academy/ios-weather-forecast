import Foundation

struct Coordinate: Decodable {
    let longitude: Double   //경도
    let latitude: Double    //위도
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

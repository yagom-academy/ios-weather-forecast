import Foundation

struct Coordinate {
    let longitude: Double   //경도
    let latitude: Double    //위도
    
    enum CodingKeys: String, CodingKey {
        case longtitude = "lon"
        case latitude = "lat"
    }
}

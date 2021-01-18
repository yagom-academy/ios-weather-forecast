import Foundation

///날씨 정보
/// - id : 날씨 ID
/// - main : 주 날씨
/// - description : 날씨 상세(?) 정보
/// - icon : 날씨 아이콘
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

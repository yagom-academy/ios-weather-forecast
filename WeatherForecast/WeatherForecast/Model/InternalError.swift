
enum InternalError: String, Error {
    case invalidURL = "날씨 정보를 받아올 수 없습니다."
    case invalidLocation = "위치 정보를 찾을 수 없습니다."
    case failedServeData = "데이터를 가져오는데에 실패했습니다."
}


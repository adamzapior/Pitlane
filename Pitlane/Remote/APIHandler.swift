import Alamofire
import Foundation

typealias NetworkResult<T> = Result<T, NetworkError>

typealias NetworkError = AFError

class APIHandler {
    private init() { }

    static func get<T: Decodable>(
        _ url: String
    ) async -> Result<T, NetworkError> {
        await AF.request(url)
            .serializingDecodable(T.self, decoder: JSONDecoder())
            .result
    }
}

//
//  NetworkProvider.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import Alamofire
import Foundation


protocol NetworkProvider: AnyObject {

    func getAssets(
        search: String?,
        limit: Int?,
        offset: Int?,
        completion: @escaping  NetworkHandler<[CoincapAPI.Asset]>)
    
    func getHistPrices(
        assetId: String,
        start: TimeInterval,
        end: TimeInterval,
        interval: String,
        completion: @escaping NetworkHandler<[CoincapAPI.HistPrice]>
    )

}


final class NetworkProviderImpl: NetworkProvider {


    // MARK: - NetworkProvider
    
    func getAssets(
        search: String?,
        limit: Int?,
        offset: Int?,
        completion: @escaping  NetworkHandler<[CoincapAPI.Asset]>
    ) {

        let url = delegate.getBaseApiUrl().appendingPathComponent("assets")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = []

        if let search = search {
            components.queryItems?.append(URLQueryItem(name: "search", value: search))
        }

        if let limit = limit {
            components.queryItems?.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        
        if let offset = offset {
            components.queryItems?.append(URLQueryItem(name: "offset", value: "\(offset)"))
        }

        let request = AF.request(components)
        request.responseDecodable(of: CoincapAPI.List<CoincapAPI.Asset>.self) { [weak self] response in
            self?.handleArrayResponse(response: response, completion: completion)
        }
        
    }
    
    func getHistPrices(
        assetId: String,
        start: TimeInterval,
        end: TimeInterval,
        interval: String,
        completion: @escaping NetworkHandler<[CoincapAPI.HistPrice]>
    ) {

        let url = delegate.getBaseApiUrl()
            .appendingPathComponent("assets")
            .appendingPathComponent("\(assetId)")
            .appendingPathComponent("history")

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "interval", value: interval))
        components.queryItems?.append(URLQueryItem(name: "start", value: "\(Int64(start))"))
        components.queryItems?.append(URLQueryItem(name: "end", value: "\(Int64(end))"))

        let request = AF.request(components)
        request.responseDecodable(of: CoincapAPI.List<CoincapAPI.HistPrice>.self) { [weak self] response in
            self?.handleArrayResponse(response: response, completion: completion)
        }
    }

    
    // MARK: - NetworkProviderImpl
    
    let delegate: NetworkProviderDelegate
    
    init(delegate: NetworkProviderDelegate) {
        self.delegate = delegate
    }

    private var apiBaseUrl: String {
        return delegate.getBaseApiUrl().absoluteString
    }
    
    private func handleResponse<T>(
        response: Alamofire.DataResponse<T, Alamofire.AFError>,
        completion: NetworkHandler<T>)
    {
        guard let state = response.value else {
            NetworkProviderImpl.logError(response: response)
            if response.response?.statusCode == 401 {
                completion(.failure(.limitsExceeded))
                return
            }
            completion(.failure(.other))
            return
        }
        NetworkProviderImpl.logSuccess(response: response)
        completion(.success(state))
    }
    
    private func handleArrayResponse<T>(
        response: Alamofire.DataResponse<CoincapAPI.List<T>, Alamofire.AFError>,
        completion: NetworkHandler<[T]>)
    {
        guard let state = response.value else {
            NetworkProviderImpl.logError(response: response)
            if response.response?.statusCode == 429 {
                completion(.failure(.limitsExceeded))
                return
            }
            completion(.failure(.other))
            return
        }
        NetworkProviderImpl.logSuccess(response: response)
        completion(.success(state.data))
    }

    private static func logError<T>(response: DataResponse<T, AFError>) {
        let errorMsg = """
        Request [\(response.request?.url?.absoluteString ?? "unknown")] failed.
        Response result: [\(response.result)]
        """
        Logger.shared.log(errorMsg)
    }

    private static func logSuccess<T>(response: DataResponse<T, AFError>) {
        let successMsg = """
        Request [\(response.request?.url?.absoluteString ?? "unknown")] succeeded.
        """
        Logger.shared.log(successMsg)
    }

    
}

//
//  NetworkService.swift
//  Articles
//
//  Created by Sudharshan on 12/09/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidData
    case decodingFailed(Error)
}

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .useProtocolCachePolicy
        config.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 200 * 1024 * 1024, diskPath: "urlcache")
        return URLSession(configuration: config)
    }()
    
    func fetchArticles(from urlString: String, completion: @escaping (Result<ArticleResponse, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else { completion(.failure(.invalidURL)); return }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            guard let data = data else { completion(.failure(.invalidData)); return }
            
            do {
                // Try to decode an enclosing object (e.g. { "articles": [...] })
                if let wrapper = try? JSONDecoder().decode(ArticleResponse.self, from: data){
                    completion(.success(wrapper))
                    return
                }
                
                // Or decode a raw array
                let articles = try JSONDecoder().decode(ArticleResponse.self, from: data)
                completion(.success(articles))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }
}

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
    
    private let session = URLSession.shared
    
    func fetchArticles(from urlString: String, completion: @escaping (Result<ArticleResponse, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else { completion(.failure(.invalidURL)); return }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            guard let data = data else { completion(.failure(.invalidData)); return }
            
            do {
                let articles = try JSONDecoder().decode(ArticleResponse.self, from: data)
                completion(.success(articles))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }
}

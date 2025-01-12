//
//  NetworkManager.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 05.11.2024.
//

import Foundation
import Combine

enum CombineError: Error {
    case failed
    case badResponse
}

class NetworkManager {
    static var shared = NetworkManager()
    private let baseUrl = "https://files.rcsb.org/ligands/download/"
    
    func fetchLigand(name: String) -> AnyPublisher<String, CombineError> {
        guard let url = URL(string: "https://files.rcsb.org/ligands/download/\(name)_ideal.sdf") else {
            print("Invalid URL ")
            return Fail<String, CombineError>(error: .failed).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(
                receiveSubscription: { _ in print("Subscription started") },
                receiveOutput: { output in
                    print("Received output:", output)
                    if let response = output.response as? HTTPURLResponse {
                        print("HTTP Status Code:", response.statusCode)
                    }
                },
                receiveCompletion: { completion in print("Completion:", completion) },
                receiveCancel: { print("Pipeline canceled") }
            )
            .receive(on: DispatchQueue.main)
            .tryMap({ data, response in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    print(httpResponse.statusCode)
                    throw CombineError.badResponse
                }
                
                if let molString = String(data: data, encoding: .utf8) {
                    return molString
                }
                throw CombineError.failed
            })
            .mapError({ error in
                print("Network error: \(error.localizedDescription)")
                return CombineError.failed
            })
            .eraseToAnyPublisher()
    }
    
}

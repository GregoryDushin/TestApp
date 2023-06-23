//
//  RocketLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 23.06.2023.
//

import Foundation

// MARK: - JSON ROCKET PARSING

protocol RocketLoaderProtocol {
    func rocketDataLoad(completion: @escaping (Result<[RocketModelElement], Error>) -> Void)
}

final class RocketLoader: RocketLoaderProtocol {
    private let decoder = JSONDecoder()
    private let session: URLSession

    init(urlSession: URLSession = .shared) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.session = urlSession
    }

    func rocketDataLoad(completion: @escaping (Result<[RocketModelElement], Error>) -> Void) {
        guard let url = URL(string: Url.rocketUrl) else { return }

        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else { return }

            do {
                let json = try self.decoder.decode([RocketModelElement].self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

//
//  S3BucketFileFacade.swift
//  play
//
//  Created by Gürhan Kuraş on 3/15/22.
//

import Foundation
import UIKit
import os

class FileUploader2 {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: FileUploader2.self))
    

    let fileUploader: FileUploader
    let fileService: FileService
    let client: HttpClient
    var fileName: String?
    
    init(client: HttpClient, fileUploader: FileUploader, fileService: FileService, fileName: String? = nil) {
        self.client = client
        self.fileUploader = fileUploader
        self.fileService = fileService
        self.fileName = fileName
    }
    
    func fetch(for section: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> ()) {
        fetchUploadURL(for: section, fileName: fileName) { [weak self] result in
            guard let self = self else {
                Self.logger.debug("SELF KACTI")
                return
            }
            switch result {
            case .success(let urlInfo):
                var url: URL!
                do {
                    url = try self.fileService.savetoCache(image: image)
                } catch  {
                    completion(.failure(error))
                    return
                }
                let presignedUrl = URL(string: urlInfo.url)!
                self.fileUploader.upload(to: presignedUrl, fromFile: url) { result in
                    switch result {
                    case .success(_):
                        completion(.success(()))
                    case .failure(let error):
                        Self.logger.debug("\(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func fetchUploadURL(for type: String, fileName: String?, completion: @escaping (Result<PresignedUrlInfo, Error>) -> ()) {
        var components = URLComponents()
        components.host = hostName
        components.port = port
        components.scheme = "http"
        components.path = "/upload"
        components.queryItems = [
            URLQueryItem(name: "type", value: type)
        ]
        if let fileName = fileName {
            components.queryItems?.append(URLQueryItem(name: "fileName", value: fileName))
        }
        
        guard let url = components.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        client.request(request) { result in
            switch result {
            case .success(let bundle):
                let status = bundle.response.statusCode
                if status == 200 {
                    guard let urlInfo = try? JSONDecoder().decode(PresignedUrlInfo.self, from: bundle.data!) else {
                        completion(.failure(URLError(.badServerResponse)))
                        return
                    }
                    completion(.success(urlInfo))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        /*
        return network.get(url: url)
            .tryMap({ data in
                let info = try JSONDecoder().decode(PresignedUrlInfo.self, from: data)
                
                guard let presignedUrl = URL(string: info.url) else {
                    throw PresignedURLFetcherError.badPresignedURL
                }
                return presignedUrl
            })
            
            .eraseToAnyPublisher()
         */
    }
}


/*
class S3BucketImageUploadFacade {
    let fileService = FileService(fileManager: .default)
    let urlFetcher = PresignedURLFetcher(network: .shared)
    let fileUploader = FileUploader(session: .shared)
    
    enum FacadeError: Error {
        case temporarySaveFailed
    }

    func upload(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        
        let fileService = FileService(fileManager: .default)
        guard let tempFileUrl = try? fileService.savetoCache(image: image) else {
            print("TEMPORARY FILE SAVING FAILED")
            completion(.failure(FacadeError.temporarySaveFailed))
            return
        }
        
        urlFetcher.fetch { [weak self] result in
            switch result {
            case .success(let url):
                print(url)
                self?.fileUploader.upload(to: url, fromFile: tempFileUrl) { result in
                    switch result {
                    case .success(_):
                        completion(.success(url.path))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
 */

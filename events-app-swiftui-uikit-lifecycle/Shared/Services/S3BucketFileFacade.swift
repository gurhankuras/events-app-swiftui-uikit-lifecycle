//
//  S3BucketFileFacade.swift
//  play
//
//  Created by Gürhan Kuraş on 3/15/22.
//

import Foundation
import UIKit


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

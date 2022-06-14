//
//  FileService.swift
//  play
//
//  Created by Gürhan Kuraş on 3/15/22.
//

import Foundation
import UIKit

struct DummyError: Error {
    
}

// TODO: instead of a new class write extension for file manager and conform file manager to needed protocols
class FileService {
    let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    // TODO: fix the issue that temporary file disappears before loading
    func saveAsTemporary(image: UIImage) throws -> URL {
        let imageURL = fileManager.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).jpg")

        let jpegData = image.jpegData(compressionQuality: 0.2);
        try jpegData?.write(to: imageURL);
        return imageURL
    }
    
    func savetoCache(image: UIImage) throws -> URL {
        guard let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw DummyError()
        }
        let url = directory.appendingPathComponent("\(UUID().uuidString).jpg")
        let jpegData = image.jpegData(compressionQuality: 0.6);
        try jpegData?.write(to: url);
        return url
    }
    
    func remove(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }
}

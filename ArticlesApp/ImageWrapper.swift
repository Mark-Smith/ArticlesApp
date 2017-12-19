//
//  ImageWrapper.swift
//  ArticlesApp
//
//  Created by Mark Smith on 18/12/2017.
//  Copyright © 2017 ___MARKSMITH___. All rights reserved.
//

//import Foundation
import UIKit

// Swift 4.0
public struct ImageWrapper: Codable {
    public let image: UIImage
    
    public enum CodingKeys: String, CodingKey {
        case image
    }
    
    // Image is a standard UI/NSImage conditional typealias
    public init(image: UIImage) {
        self.image = image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        guard let image = UIImage(data: data) else {
            throw StorageError.decodingFailed
        }
        
        self.image = image
    }
    
    // cache_toData() wraps UIImagePNG/JPEGRepresentation around some conditional logic with some whipped cream and sprinkles.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = image.cache_toData() else {
            throw StorageError.encodingFailed
        }
        
        try container.encode(data, forKey: CodingKeys.image)
    }
}

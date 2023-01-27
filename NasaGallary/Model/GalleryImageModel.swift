//
//  GalleryImageModel.swift
//  NasaGallary
//
//  Created by Megha  on 26/01/23.
//

import Foundation
import UIKit
import Foundation
import ObjectMapper

struct GetGalleryImageModel: Codable {
    
    var copyright            : String!
    var date         : String!
    var explanation             : String!
    var hdurl          : String!
    var media_type : String!
    var service_version : String!
    var title : String!
    var url : String!
    
    
    enum codingKeys: String, CodingKey{
        case copyright = "copyright"
        case date = "date"
        case explanation = "explanation"
        case hdurl = "hdurl"
        case media_type = "media_type"
        case service_version = "service_version"
        case title = "title"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        copyright = try? (values.decodeIfPresent(String.self,forKey: .copyright) ?? "")
        date = try? (values.decodeIfPresent(String.self,forKey: .date) ?? "")
        explanation = try? (values.decodeIfPresent(String.self,forKey: .explanation) ?? "")
        hdurl = try (values.decodeIfPresent(String.self,forKey: .hdurl))
        media_type = try (values.decodeIfPresent(String.self,forKey: .media_type))
        service_version = try (values.decodeIfPresent(String.self,forKey: .service_version))
        title = try (values.decodeIfPresent(String.self,forKey: .title))
        url = try (values.decodeIfPresent(String.self,forKey: .url))
    }
}

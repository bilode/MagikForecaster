//
//  Router.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 02/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {

    static let authenticationToken = "BR8CFVUrVHZQfQYxBnABKAVtVGEKfAQjUCwKaQ9qUSwDaABhUTFXMQBuVSgEKwcxVXgGZQswBzcEb1cvXy1WNwVvAm5VPlQzUD8GYwYpASoFK1Q1CioEI1AyCmQPZ1EsA2EAYVE2VysAbVUyBCoHM1V5BnkLNQc6BGFXNF81VjMFbwJuVTFUMlAgBnsGMwFhBTJUMAoyBGlQNgpvD2VRZANoAGFRMVc2AHFVMAQ2BzNVYgZiCzwHNwRlVy9fLVZMBRUCe1V2VHRQagYiBisBYAVoVGA%3D"
    static let c = "54d9faad96bd1e677e34199fbfa99f7f"

    case fetch(lat: String, lon: String)

    private var baseURL: String {
        return "https://www.infoclimat.fr/public-api"
    }

    private var path: String {
        return "/gfs/json"
    }

    private var method: HTTPMethod {
        return .get
    }

    internal func asURLRequest() throws -> URLRequest {

        let parameters: [String: Any] = {
            switch self {
            case let .fetch(lat: lat, lon: lon):
                return ["_ll": "\(lat),\(lon)",
                    "_c": Router.c,
                    "_auth": Router.authenticationToken]
            }
        }()

        let url = try (self.baseURL + self.path).asURL()
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        return try URLEncoding.default.encode(request, with: parameters)
    }
}

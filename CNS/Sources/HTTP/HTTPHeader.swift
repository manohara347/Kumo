//
//  HTTPHeader.swift
//  CNS
//
//  Created by ライアン on 10/23/18.
//  Copyright © 2018 Duet Health. All rights reserved.
//

import Foundation

public extension String.Encoding {
    
    public var stringValue: String? {
        return CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(rawValue)) as String?
    }
    
}

public struct MIMEType: RawRepresentable {
    public typealias RawValue = String
    
    public static func applicationJSON(charset: String.Encoding = .utf8) -> MIMEType {
        let charsetString = charset.stringValue.map { "; charset=\($0)" } ?? ""
        return MIMEType("application/json\(charsetString)")
    }
    
    public static func multipartFormData(boundary: String) -> MIMEType {
        return MIMEType("multipart/form-data; boundary=\(boundary)")
    }
    
    public let rawValue: String
    
    public init?(rawValue: String) {
        fatalError("NOT YET IMPLEMENTED")
    }
    
    private init(_ value: String) {
        self.rawValue = value
    }
    
}

public struct HTTPHeader: Hashable {
    
    public static let accept = HTTPHeader(rawValue: "Accept")
    public static let acceptLanguage = HTTPHeader(rawValue: "Accept-Language")
    public static let authorization = HTTPHeader(rawValue: "Authorization")
    public static let contentType = HTTPHeader(rawValue: "Content-Type")
    
    public static func custom(_ value: String) -> HTTPHeader {
        return HTTPHeader(rawValue: value)
    }
    
    let rawValue: String
    
    fileprivate init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}

public extension URLSessionConfiguration {
    
    func set(value: Any, for header: HTTPHeader) {
        if httpAdditionalHeaders != nil {
            httpAdditionalHeaders![header.rawValue] = value
        } else {
            httpAdditionalHeaders = [header.rawValue: value]
        }
    }
    
    public var httpHeaders: [HTTPHeader: Any]? {
        get {
            return httpAdditionalHeaders.map {
                Dictionary(uniqueKeysWithValues: $0.compactMap { pair in
                    guard let string = pair.key.base as? String else { return nil }
                    return (HTTPHeader(rawValue: string), pair.value)
                })
            }
        }
    }
    
}

public extension URLRequest {
    
    public var httpHeaders: [HTTPHeader: String]? {
        get {
            return allHTTPHeaderFields.map {
                Dictionary(uniqueKeysWithValues: $0.map { pair in
                    return (HTTPHeader(rawValue: pair.key), pair.value)
                })
            }
        }
        set {
            allHTTPHeaderFields = newValue.map {
                Dictionary(uniqueKeysWithValues: $0.map { pair in
                    return (pair.key.rawValue, pair.value)
                })
            }
        }
    }
    
    public mutating func set(accept: MIMEType) {
        addValue(accept.rawValue, forHTTPHeaderField: HTTPHeader.accept.rawValue)
    }
    
    public mutating func set(contentType: MIMEType) {
        addValue(contentType.rawValue, forHTTPHeaderField: HTTPHeader.contentType.rawValue)
    }
    
    public mutating func set(value: String, for header: HTTPHeader) {
        addValue(value, forHTTPHeaderField: header.rawValue)
    }
    
}

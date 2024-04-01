//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/1/24.
//

import Foundation

// Lesson: restrict result to 2
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    // Lesson: catch not only the error but status code as well
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}


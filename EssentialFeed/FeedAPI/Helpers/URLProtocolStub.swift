//
//  URLProtocolStub.swift
//  EssentialFeed
//
//  Created by Romeo Flauta on 4/17/24.
//

import Foundation

public class URLProtocolStub: URLProtocol {
	private struct Stub {
		let onStartLoading: (URLProtocolStub) -> Void
	}

	private static var _stub: Stub?
	private static var stub: Stub? {
		get { return queue.sync { _stub } }
		set { queue.sync { _stub = newValue } }
	}

	private static let queue = DispatchQueue(label: "URLProtocolStub.queue")

	public static func stub(data: Data?, response: URLResponse?, error: Error?) {
		stub = Stub(onStartLoading: { urlProtocol in
			guard let client = urlProtocol.client else { return }

			if let data {
				client.urlProtocol(urlProtocol, didLoad: data)
			}

			if let response {
				client.urlProtocol(urlProtocol, didReceive: response, cacheStoragePolicy: .notAllowed)
			}

			if let error {
				client.urlProtocol(urlProtocol, didFailWithError: error)
			} else {
				client.urlProtocolDidFinishLoading(urlProtocol)
			}
		})
	}

	public static func observeRequests(observer: @escaping (URLRequest) -> Void) {
		stub = Stub(onStartLoading: { urlProtocol in
			urlProtocol.client?.urlProtocolDidFinishLoading(urlProtocol)

			observer(urlProtocol.request)
		})
	}

	public static func onStartLoading(observer: @escaping () -> Void) {
		stub = Stub(onStartLoading: { _ in observer() })
	}

	public static func removeStub() {
		stub = nil
	}

    public override class func canInit(with request: URLRequest) -> Bool {
		return true
	}

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

    public override func startLoading() {
        URLProtocolStub.stub?.onStartLoading(self)
	}

    public override func stopLoading() {}
}

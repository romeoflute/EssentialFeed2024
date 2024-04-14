//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Romeo Flauta on 4/13/24.
//

struct FeedImageViewModel<Image> {
	let description: String?
	let location: String?
	let image: Image?
    let bytes: Int?
	let isLoading: Bool
	let shouldRetry: Bool

	var hasLocation: Bool {
		return location != nil
	}
}

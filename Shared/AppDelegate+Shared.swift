//
//  AppDelegate+Shared.swift
//  NetNewsWire
//
//  Created by Brent Simmons on 4/15/24.
//  Copyright © 2024 Ranchero Software. All rights reserved.
//

import Foundation
import Images
import ParserObjC

extension AppDelegate: FaviconDownloaderDelegate, FeedIconDownloaderDelegate {

	var appIconImage: IconImage? {
		IconImage.appIcon
	}

	func downloadMetadata(_ url: String) async throws -> RSHTMLMetadata? {

		await HTMLMetadataDownloader.downloadMetadata(for: url)
	}

	func initializeDownloaders() {

		FaviconDownloader.shared.delegate = self
		FeedIconDownloader.shared.delegate = self
	}

	func handleUnreadCountDidChange() {
		
		AppNotification.postAppUnreadCountDidChange(from: self, unreadCount: unreadCount)
		postUnreadCountDidChangeNotification()
		updateBadge()
	}

	func updateBadge() {

#if os(macOS)
		queueUpdateDockBadge()
#elseif os(iOS)
		UNUserNotificationCenter.current().setBadgeCount(unreadCount)
#endif
	}
}

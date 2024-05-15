//
//  UIImageView.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 15/5/24.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func cancelDownloading() {
        kf.cancelDownloadTask()
    }

    func download(image url: URL?) {
        guard let url = url else { return }
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}

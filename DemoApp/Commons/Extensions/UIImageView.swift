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

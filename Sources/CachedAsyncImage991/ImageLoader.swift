import Foundation
import UIKit.UIImage

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published private(set) var isLoading = false
    private let url: URL?
    private let cache = ImageCacheService.shared

    init(url: URL?) { self.url = url }

    @MainActor
    func load() async {
        guard let url = url, !isLoading else { return }
        if let image = cache[url], self.image != image {
            self.image = image
            return
        }
        isLoading = true
        if let (data, _) = try? await URLSession.shared.data(from: url),
           let loadedImage = UIImage(data: data) {
            cache[url] = loadedImage
            self.image = loadedImage
        }
        isLoading = false
    }
}

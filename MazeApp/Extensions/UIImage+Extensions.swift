import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    typealias Dependencies = HasMainQueue & HasURLSessionable
    func loadImage(urlString: String?,
                    placeholder: String? = nil,
                    dependencies: Dependencies,
                    completion: (() -> Void)? = nil) -> URLSessionDataTask?  {
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            completion?()
            return nil
        }
        guard let urlString = urlString, let url = URL(string: urlString) else {
            setupPlaceholderIfNeeded(placeholder,
                                     dependencies: dependencies,
                                     completion: completion)
            return nil
        }
        let task = dependencies.session.dataTask(with: .init(url: url)) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            guard let data = data, error == nil else {
                self.setupPlaceholderIfNeeded(placeholder,
                                              dependencies: dependencies,
                                              completion: completion)
                return
            }
            dependencies.mainQueue.async {
                let imageToCache = UIImage(data: data)
                imageCache.setObject(imageToCache!,
                                     forKey: url.absoluteString as NSString)
                self.image = imageToCache
                completion?()
            }
        }
        task.resume()
        return task
    }
    
    func setupPlaceholderIfNeeded(_ placeholder: String?, dependencies: HasMainQueue, completion: (() -> Void)?) {
        if let placeholder = placeholder {
            dependencies.mainQueue.async {
                self.image = .init(systemName: placeholder)
                self.tintColor = .systemTeal
                completion?()
            }
        }
    }
}

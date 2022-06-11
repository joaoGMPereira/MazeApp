import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    typealias Dependencies = HasMainQueue & HasURLSessionable
    func loandImage(urlString: String?,
                    placeholder: String? = nil,
                    dependencies: Dependencies,
                    completion: (() -> Void)? = nil)  {
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            completion?()
            return
        }
        guard let urlString = urlString, let url = URL(string: urlString) else {
            setupPlaceholderIfNeeded(placeholder,
                                     dependencies: dependencies,
                                     completion: completion)
            return
        }
        dependencies.session.dataTask(with: .init(url: url)) { [weak self] data, response, error in
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
        }.resume()
    }
    
    func setupPlaceholderIfNeeded(_ placeholder: String?, dependencies: HasMainQueue, completion: (() -> Void)?) {
        if let placeholder = placeholder {
            dependencies.mainQueue.async {
                self.image = .init(named: placeholder)
                completion?()
            }
        }
    }
}

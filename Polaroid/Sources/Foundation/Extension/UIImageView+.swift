//
//  UIImageView+.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

extension UIImageView {
    func load(urlStr: String) {
        DispatchQueue.global().async {
            let image = UIImage(contentsOfFile: urlStr)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @discardableResult
    func setImageWithCahe(
        with url: URL,
        placeHolder: UIImage? = nil,
        cacheExpiration: TimeInterval = 300,
        config: CacheConfiguration = .default
    ) -> URLSessionTask? {
        @CacheWrapper<Data>(url: url, config: config)
        var savedObject
        var task: URLSessionTask?
        switch savedObject {
        case .some(let cacheableData):
            if cacheableData.date.distance(to: .now) < cacheExpiration {
                DispatchQueue.main.async {
                    self.image = UIImage(data: cacheableData.value)
                }
                return task
            }
            let urlRequest = cacheableData.toURLRequest(url: url)
            task = URLSession.shared.dataTask(
                with: urlRequest
            ) { [weak self] data, response, error in
                guard let self else { return }
                if let error {
                    setPlaceHolderWithError(
                        placeHolder: placeHolder,
                        NetworkError.requestFailed(error)
                    )
                    return
                }
                guard let response else {
                    setPlaceHolderWithError(
                        placeHolder: placeHolder,
                        NetworkError.noResponse
                    )
                    return
                }
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    setPlaceHolderWithError(
                        placeHolder: placeHolder,
                        NetworkError.invalidResponseType
                    )
                    return
                }
                guard httpURLResponse.statusCode != 304 else {
                    savedObject = cacheableData.updatingDate()
                    DispatchQueue.main.async {
                        self.image = UIImage(data: cacheableData.value)
                    }
                    return
                }
                guard 200..<300 ~= httpURLResponse.statusCode else {
                    setPlaceHolderWithError(
                        placeHolder: placeHolder,
                        NetworkError.statusCodeError(
                            statusCode: httpURLResponse.statusCode
                        )
                    )
                    return
                }
                guard let data else {
                    setPlaceHolderWithError(
                        placeHolder: placeHolder,
                        NetworkError.noData
                    )
                    return
                }
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                if let newObject = CacheableObject(
                    value: data,
                    headers: httpURLResponse.allHeaderFields
                ) {
                    savedObject = newObject
                }
            }
        case .none:
            task = URLSession.shared.dataTask(
                with: url
            ) { [weak self] data, response, error in
                guard let self else { return }
                if let error {
                    setPlaceHolderWithError(
                        placeHolder: placeHolder,
                        NetworkError.requestFailed(error)
                    )
                    return
                }
                guard let response else {
                    setPlaceHolderWithError(
                        placeHolder: placeHolder,
                        NetworkError.noResponse
                    )
                    return
                }
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    setPlaceHolderWithError(
                        placeHolder: placeHolder,
                        NetworkError.invalidResponseType
                    )
                    return
                }
                guard 200..<300 ~= httpURLResponse.statusCode else {
                    setPlaceHolderWithError(
                        placeHolder: placeHolder,
                        NetworkError.statusCodeError(
                            statusCode: httpURLResponse.statusCode
                        )
                    )
                    return
                }
                guard let data else {
                    Logger.error(NetworkError.noData)
                    return
                }
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                if let newObject = CacheableObject(
                    value: data,
                    headers: httpURLResponse.allHeaderFields
                ) {
                    savedObject = newObject
                }
            }
        }
        task?.resume()
        return task
    }
    
    @discardableResult
    func setImageWithCahe(
        with endpoint: EndpointRepresentable,
        placeHolder: UIImage? = nil,
        cacheExpiration: TimeInterval = 300,
        config: CacheConfiguration = .default
    ) -> URLSessionTask? {
        guard let url = endpoint.toURL() else { return nil }
        return setImageWithCahe(
            with: url,
            placeHolder: placeHolder,
            cacheExpiration: cacheExpiration,
            config: config
        )
    }
    
    private func setPlaceHolderWithError(
        placeHolder: UIImage?,
        _ error: Error
    ) {
        DispatchQueue.main.async {
            self.image = placeHolder
        }
        Logger.error(error)
    }
}

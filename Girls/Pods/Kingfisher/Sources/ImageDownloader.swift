//
//  ImageDownloader.swift
//  Kingfisher
//
//  Created by Wei Wang on 15/4/6.
//
//  Copyright (c) 2016 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if os(OSX)
import AppKit
#else
import UIKit
#endif

/// Progress update block of downloader.
public typealias ImageDownloaderProgressBlock = DownloadProgressBlock

/// Completion block of downloader.
public typealias ImageDownloaderCompletionHandler = ((_ image: Image?, _ error: NSError?, _ imageURL: URL?, _ originalData: Data?) -> ())

/// Download task.
public struct RetrieveImageDownloadTask {
    let internalTask: URLSessionDataTask
    
    /// Downloader by which this task is intialized.
    public fileprivate(set) weak var ownerDownloader: ImageDownloader?

    /**
     Cancel this download task. It will trigger the completion handler with an NSURLErrorCancelled error.
     */
    public func cancel() {
        ownerDownloader?.cancelDownloadingTask(self)
    }
    
    /// The original request URL of this download task.
    public var URL: Foundation.URL? {
        return internalTask.originalRequest?.url
    }
    
    /// The relative priority of this download task. 
    /// It represents the `priority` property of the internal `NSURLSessionTask` of this download task.
    /// The value for it is between 0.0~1.0. Default priority is value of 0.5.
    /// See documentation on `priority` of `NSURLSessionTask` for more about it.
    public var priority: Float {
        get {
            return internalTask.priority
        }
        set {
            internalTask.priority = newValue
        }
    }
}

private let defaultDownloaderName = "default"
private let downloaderBarrierName = "com.onevcat.Kingfisher.ImageDownloader.Barrier."
private let imageProcessQueueName = "com.onevcat.Kingfisher.ImageDownloader.Process."
private let instance = ImageDownloader(name: defaultDownloaderName)


/**
The error code.

- BadData: The downloaded data is not an image or the data is corrupted.
- NotModified: The remote server responsed a 304 code. No image data downloaded.
- InvalidURL: The URL is invalid.
*/
public enum KingfisherError: Int {
    case badData = 10000
    case notModified = 10001
    case invalidURL = 20000
}

/// Protocol of `ImageDownloader`.
@objc public protocol ImageDownloaderDelegate {
    /**
    Called when the `ImageDownloader` object successfully downloaded an image from specified URL.
    
    - parameter downloader: The `ImageDownloader` object finishes the downloading.
    - parameter image:      Downloaded image.
    - parameter URL:        URL of the original request URL.
    - parameter response:   The response object of the downloading process.
    */
    @objc optional func imageDownloader(_ downloader: ImageDownloader, didDownloadImage image: Image, forURL URL: URL, withResponse response: URLResponse)
}

/// `ImageDownloader` represents a downloading manager for requesting the image with a URL from server.
open class ImageDownloader: NSObject {
    
    class ImageFetchLoad {
        var callbacks = [CallbackPair]()
        var responseData = NSMutableData()

        var options: KingfisherOptionsInfo?
        
        var downloadTaskCount = 0
        var downloadTask: RetrieveImageDownloadTask?
    }
    
    // MARK: - Public property
    /// This closure will be applied to the image download request before it being sent. You can modify the request for some customizing purpose, like adding auth token to the header or do a url mapping.
    open var requestModifier: ((NSMutableURLRequest) -> Void)?

    /// The duration before the download is timeout. Default is 15 seconds.
    open var downloadTimeout: TimeInterval = 15.0
    
    /// A set of trusted hosts when receiving server trust challenges. A challenge with host name contained in this set will be ignored. You can use this set to specify the self-signed site.
    open var trustedHosts: Set<String>?
    
    /// Use this to set supply a configuration for the downloader. By default, NSURLSessionConfiguration.ephemeralSessionConfiguration() will be used. You could change the configuration before a downloaing task starts. A configuration without persistent storage for caches is requsted for downloader working correctly.
    open var sessionConfiguration = URLSessionConfiguration.ephemeral {
        didSet {
            session = URLSession(configuration: sessionConfiguration, delegate: sessionHandler, delegateQueue: OperationQueue.main)
        }
    }
    
    /// Whether the download requests should use pipeling or not. Default is false.
    open var requestsUsePipeling = false
    
    fileprivate var sessionHandler: ImageDownloaderSessionHandler?
    fileprivate var session: URLSession?
    
    /// Delegate of this `ImageDownloader` object. See `ImageDownloaderDelegate` protocol for more.
    open weak var delegate: ImageDownloaderDelegate?
    
    // MARK: - Internal property
    let barrierQueue: DispatchQueue
    let processQueue: DispatchQueue
    
    typealias CallbackPair = (progressBlock: ImageDownloaderProgressBlock?, completionHander: ImageDownloaderCompletionHandler?)
    
    var fetchLoads = [URL: ImageFetchLoad]()
    
    // MARK: - Public method
    /// The default downloader.
    open class var defaultDownloader: ImageDownloader {
        return instance
    }
    
    /**
    Init a downloader with name.
    
    - parameter name: The name for the downloader. It should not be empty.
    
    - returns: The downloader object.
    */
    public init(name: String) {
        if name.isEmpty {
            fatalError("[Kingfisher] You should specify a name for the downloader. A downloader with empty name is not permitted.")
        }
        
        barrierQueue = DispatchQueue(label: downloaderBarrierName + name, attributes: DispatchQueue.Attributes.concurrent)
        processQueue = DispatchQueue(label: imageProcessQueueName + name, attributes: DispatchQueue.Attributes.concurrent)
        
        super.init()
        
        sessionHandler = ImageDownloaderSessionHandler()
        session = URLSession(configuration: sessionConfiguration, delegate: sessionHandler, delegateQueue: OperationQueue.main)
    }
    
    func fetchLoadForKey(_ key: URL) -> ImageFetchLoad? {
        var fetchLoad: ImageFetchLoad?
        barrierQueue.sync(execute: { () -> Void in
            fetchLoad = self.fetchLoads[key]
        })
        return fetchLoad
    }
}

// MARK: - Download method
extension ImageDownloader {
    /**
    Download an image with a URL.
    
    - parameter URL:               Target URL.
    - parameter progressBlock:     Called when the download progress updated.
    - parameter completionHandler: Called when the download progress finishes.
    
    - returns: A downloading task. You could call `cancel` on it to stop the downloading process.
    */
    public func downloadImageWithURL(_ URL: Foundation.URL,
                           progressBlock: ImageDownloaderProgressBlock?,
                       completionHandler: ImageDownloaderCompletionHandler?) -> RetrieveImageDownloadTask?
    {
        return downloadImageWithURL(URL, options: nil, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
    /**
    Download an image with a URL and option.
    
    - parameter URL:               Target URL.
    - parameter options:           The options could control download behavior. See `KingfisherOptionsInfo`.
    - parameter progressBlock:     Called when the download progress updated.
    - parameter completionHandler: Called when the download progress finishes.

    - returns: A downloading task. You could call `cancel` on it to stop the downloading process.
    */
    public func downloadImageWithURL(_ URL: Foundation.URL,
                                 options: KingfisherOptionsInfo?,
                           progressBlock: ImageDownloaderProgressBlock?,
                       completionHandler: ImageDownloaderCompletionHandler?) -> RetrieveImageDownloadTask?
    {
        return downloadImageWithURL(URL,
            retrieveImageTask: nil,
                      options: options,
                progressBlock: progressBlock,
            completionHandler: completionHandler)
    }
    
    internal func downloadImageWithURL(_ URL: Foundation.URL,
                       retrieveImageTask: RetrieveImageTask?,
                                 options: KingfisherOptionsInfo?,
                           progressBlock: ImageDownloaderProgressBlock?,
                       completionHandler: ImageDownloaderCompletionHandler?) -> RetrieveImageDownloadTask?
    {
        if let retrieveImageTask = retrieveImageTask, retrieveImageTask.cancelledBeforeDownlodStarting {
            return nil
        }
        
        let timeout = self.downloadTimeout == 0.0 ? 15.0 : self.downloadTimeout
        
        // We need to set the URL as the load key. So before setup progress, we need to ask the `requestModifier` for a final URL.
        let request = NSMutableURLRequest(url: URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        request.httpShouldUsePipelining = requestsUsePipeling
        
        self.requestModifier?(request)
        
        // There is a possiblility that request modifier changed the url to `nil` or empty.
        if request.url == nil || request.url!.absoluteString.isEmpty {
            completionHandler?(nil, NSError(domain: KingfisherErrorDomain, code: KingfisherError.invalidURL.rawValue, userInfo: nil), nil, nil)
            return nil
        }
        
        var downloadTask: RetrieveImageDownloadTask?
        setupProgressBlock(progressBlock, completionHandler: completionHandler, forURL: request.url!) {(session, fetchLoad) -> Void in
            if fetchLoad.downloadTask == nil {
                let dataTask = session.dataTask(with: request)
                
                fetchLoad.downloadTask = RetrieveImageDownloadTask(internalTask: dataTask, ownerDownloader: self)
                fetchLoad.options = options
                
                dataTask.priority = options?.downloadPriority ?? URLSessionTask.defaultPriority
                dataTask.resume()
                
                // Hold self while the task is executing.
                self.sessionHandler?.downloadHolder = self
            }
            
            fetchLoad.downloadTaskCount += 1
            downloadTask = fetchLoad.downloadTask
            
            retrieveImageTask?.downloadTask = downloadTask
        }
        return downloadTask
    }
    
    // A single key may have multiple callbacks. Only download once.
    internal func setupProgressBlock(_ progressBlock: ImageDownloaderProgressBlock?, completionHandler: ImageDownloaderCompletionHandler?, forURL URL: Foundation.URL, started: ((URLSession, ImageFetchLoad) -> Void)) {

        barrierQueue.sync(flags: .barrier, execute: { () -> Void in
            
            let loadObjectForURL = self.fetchLoads[URL] ?? ImageFetchLoad()
            let callbackPair = (progressBlock: progressBlock, completionHander: completionHandler)
            
            loadObjectForURL.callbacks.append(callbackPair)
            self.fetchLoads[URL] = loadObjectForURL
            
            if let session = self.session {
                started(session, loadObjectForURL)
            }
        })
    }
    
    func cancelDownloadingTask(_ task: RetrieveImageDownloadTask) {
        barrierQueue.sync(flags: .barrier, execute: { () -> Void in
            if let URL = task.internalTask.originalRequest?.url, let imageFetchLoad = self.fetchLoads[URL] {
                imageFetchLoad.downloadTaskCount -= 1
                if imageFetchLoad.downloadTaskCount == 0 {
                    task.internalTask.cancel()
                }
            }
        }) 
    }
    
    func cleanForURL(_ URL: Foundation.URL) {
        barrierQueue.sync(flags: .barrier, execute: { () -> Void in
            self.fetchLoads.removeValue(forKey: URL)
            return
        })
    }
}

// MARK: - NSURLSessionDataDelegate

// See https://github.com/onevcat/Kingfisher/issues/235

/// Delegate class for `NSURLSessionTaskDelegate`.
/// The session object will hold its delegate until it gets invalidated.
/// If we use `ImageDownloader` as the session delegate, it will not be released.
/// So we need an additional handler to break the retain cycle.
class ImageDownloaderSessionHandler: NSObject, URLSessionDataDelegate {
    
    // The holder will keep downloader not released while a data task is being executed.
    // It will be set when the task started, and reset when the task finished.
    var downloadHolder: ImageDownloader?
    
    /**
    This method is exposed since the compiler requests. Do not call it.
    */
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        completionHandler(Foundation.URLSession.ResponseDisposition.allow)
    }
    
    /**
    This method is exposed since the compiler requests. Do not call it.
    */
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        guard let downloader = downloadHolder else {
            return
        }
        
        if let URL = dataTask.originalRequest?.url, let fetchLoad = downloader.fetchLoadForKey(URL) {
            fetchLoad.responseData.append(data)
            
            for callbackPair in fetchLoad.callbacks {
                DispatchQueue.main.async(execute: { () -> Void in
                    callbackPair.progressBlock?(Int64(fetchLoad.responseData.length), dataTask.response!.expectedContentLength)
                })
            }
        }
    }
    
    /**
    This method is exposed since the compiler requests. Do not call it.
    */
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let URL = task.originalRequest?.url {
            if let error = error { // Error happened
                callbackWithImage(nil, error: error as NSError?, imageURL: URL, originalData: nil)
            } else { //Download finished without error
                processImageForTask(task, URL: URL)
            }
        }
    }

    /**
    This method is exposed since the compiler requests. Do not call it.
    */
    internal func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard let downloader = downloadHolder else {
            return
        }
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trustedHosts = downloader.trustedHosts, trustedHosts.contains(challenge.protectionSpace.host) {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
                return
            }
        }
        
        completionHandler(.performDefaultHandling, nil)
    }
    
    fileprivate func callbackWithImage(_ image: Image?, error: NSError?, imageURL: URL, originalData: Data?) {
        
        guard let downloader = downloadHolder else {
            return
        }
        
        if let callbackPairs = downloader.fetchLoadForKey(imageURL)?.callbacks {
            let options = downloader.fetchLoadForKey(imageURL)?.options ?? KingfisherEmptyOptionsInfo
            
            downloader.cleanForURL(imageURL)
            
            for callbackPair in callbackPairs {
                dispatch_async_safely_to_queue(options.callbackDispatchQueue, { () -> Void in
                    callbackPair.completionHander?(image: image, error: error, imageURL: imageURL, originalData: originalData)
                })
            }
            
            if downloader.fetchLoads.isEmpty {
                downloadHolder = nil
            }
        }
    }
    
    fileprivate func processImageForTask(_ task: URLSessionTask, URL: Foundation.URL) {

        guard let downloader = downloadHolder else {
            return
        }
        
        // We are on main queue when receiving this.
        downloader.processQueue.async(execute: { () -> Void in
            
            if let fetchLoad = downloader.fetchLoadForKey(URL) {
                
                let options = fetchLoad.options ?? KingfisherEmptyOptionsInfo
                if let image = Image.kf_imageWithData(fetchLoad.responseData, scale: options.scaleFactor) {
                    
                    downloader.delegate?.imageDownloader?(downloader, didDownloadImage: image, forURL: URL, withResponse: task.response!)
                    
                    if options.backgroundDecode {
                        self.callbackWithImage(image.kf_decodedImage(scale: options.scaleFactor), error: nil, imageURL: URL, originalData: fetchLoad.responseData)
                    } else {
                        self.callbackWithImage(image, error: nil, imageURL: URL, originalData: fetchLoad.responseData)
                    }
                    
                } else {
                    // If server response is 304 (Not Modified), inform the callback handler with NotModified error.
                    // It should be handled to get an image from cache, which is response of a manager object.
                    if let res = task.response as? HTTPURLResponse, res.statusCode == 304 {
                        self.callbackWithImage(nil, error: NSError(domain: KingfisherErrorDomain, code: KingfisherError.notModified.rawValue, userInfo: nil), imageURL: URL, originalData: nil)
                        return
                    }
                    
                    self.callbackWithImage(nil, error: NSError(domain: KingfisherErrorDomain, code: KingfisherError.badData.rawValue, userInfo: nil), imageURL: URL, originalData: nil)
                }
            } else {
                self.callbackWithImage(nil, error: NSError(domain: KingfisherErrorDomain, code: KingfisherError.badData.rawValue, userInfo: nil), imageURL: URL, originalData: nil)
            }
        })
    }
}

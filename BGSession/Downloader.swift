//
//  Downloader.swift
//  BGSession
//
//  Created by Jakub Olejník on 31.05.2021.
//

import Foundation
import UserNotifications

public final class Downloader: NSObject {
    public static let shared = Downloader()
    
    public var backgroundCompletionHandler = { }
    
    private var session: URLSession!
    
    // MARK: - Initializers
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public interface
    
    public func start() {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgsession")
        configuration.isDiscretionary = false // just for debug purposes, for real download should be `true`
        configuration.sessionSendsLaunchEvents = true
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    @discardableResult
    public func downloadFile(_ url: URL) -> URLSessionDownloadTask {
        let task = session.downloadTask(with: url)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            DispatchQueue.main.async {
                task.resume()
                let content = UNMutableNotificationContent()
                content.title = "Download start!"
                content.sound = .default
                
                let request = UNNotificationRequest(identifier: url.absoluteString + ".start", content: content, trigger: nil)
                
                UNUserNotificationCenter.current().add(request)
                
                NSLog("Download start")
            }
        }
        return task
    }
}

extension Downloader: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            let content = UNMutableNotificationContent()
            content.title = "Download complete!"
            content.sound = .default
            
            let request = UNNotificationRequest(identifier: location.absoluteString + ".end", content: content, trigger: nil)
            
            NSLog("Download end")
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        NSLog("Download write %d/%d", totalBytesWritten, totalBytesExpectedToWrite)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        NSLog("Download resume %d/%d", fileOffset, expectedTotalBytes)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        NSLog("Download error: %@", error.debugDescription)
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        NSLog("Download session error: %@", error.debugDescription)
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async(execute: backgroundCompletionHandler)
        backgroundCompletionHandler = { }
    }
}

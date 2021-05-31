//
//  ViewController.swift
//  BGSession
//
//  Created by Jakub Olejník on 31.05.2021.
//

import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://olejnjak.cz/files/video.mp4")! // ~400MB
//        let url = URL(string: "https://olejnjak.cz/files/video-hq.m4v")! // ~1GB
        Downloader.shared.downloadFile(url)
    }
}


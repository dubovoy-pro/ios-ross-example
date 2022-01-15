//
//  Logger.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import Foundation
import CocoaLumberjack

public final class Logger {

    public static let shared = Logger()

    public func log(_ text: String) {
        DDLogInfo(text) // save on disk
        print(text) // show in xCode console
    }
    
    public func makeShareableLogFiles() -> [URL] {
        Logger.shared.fileLogger.flush()
        let filesInCache = fileLogger.logFileManager.sortedLogFilePaths
        return makeShareableCopy(logFilePathes: filesInCache)
    }

    private let fileLogger = DDFileLogger()

    private init() {
        
        // setup logs to disk
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours in each file
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7 // one weak of logs totally
        DDLog.add(fileLogger) // setup saving logs to disk
    }

    private func makeShareableCopy(logFilePathes: [String]) -> [URL] {
        guard let dir = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else {
            return []
        }

        var shareFileUrls = [URL]()
        for path in logFilePathes {
            guard let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
                continue
            }
            guard let fileNameSubstring = path.split(separator: "/").last else {
                    continue
            }
            let fileName = String(fileNameSubstring).replacingOccurrences(of: "log", with: "txt")
            let shareableFileURL = dir.appendingPathComponent(fileName)
            do {
                try content.write(to: shareableFileURL, atomically: false, encoding: .utf8)
                shareFileUrls.append(shareableFileURL)
            }
            catch {
                print(error)
            }
        }
        return shareFileUrls
    }
}


import UIKit
public class LogSharingWindow: UIWindow {
    
    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            
            let sharedFiles = Logger.shared.makeShareableLogFiles()
            
            let sharingVC = UIActivityViewController(
                activityItems: sharedFiles,
                applicationActivities: [])
            
            if let rootVC = rootViewController {
                rootVC.present(sharingVC, animated: true)
            } else {
                rootViewController = sharingVC
            }
        }
    }

}

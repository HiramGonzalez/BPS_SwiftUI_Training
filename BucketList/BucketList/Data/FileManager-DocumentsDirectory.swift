//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by BPS.Dev01 on 6/28/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

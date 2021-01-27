//
//  Bundle.swift
//  Samokat
//
//  Created by Daniyar on 7/30/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

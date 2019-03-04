//
//  Date+HCI.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/3/4.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

extension Date {
    var readableString: String {
        return formatter.string(from: self)
    }
}

private var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

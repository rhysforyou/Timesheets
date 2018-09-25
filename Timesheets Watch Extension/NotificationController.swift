//
//  NotificationController.swift
//  Timesheets Watch Extension
//
//  Created by Rhys Powell on 21/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class NotificationController: WKUserNotificationInterfaceController {
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var subtitleLabel: WKInterfaceLabel!
    @IBOutlet var bodyLabel: WKInterfaceLabel!

    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        titleLabel.setText(content.title)
        titleLabel.setHidden(content.title.isEmpty)
        subtitleLabel.setText(content.subtitle)
        subtitleLabel.setHidden(content.subtitle.isEmpty)
        bodyLabel.setText(content.body)
    }
}

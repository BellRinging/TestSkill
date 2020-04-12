//
//  NotificationViewController.swift
//  TestNotificationContent
//
//  Created by Kwok Wai Yeung on 3/4/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

}

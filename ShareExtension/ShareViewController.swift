//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Administrator on 01/07/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import UIKit
import Social

import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    var urlString: String?
    var name: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "Add"
        
        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        
        let contentTypeURL = kUTTypeURL as String
        let contentTypeText = kUTTypeText as String
        
        for attachment in extensionItem.attachments as! [NSItemProvider]{
            if attachment.isURL{
                attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (result, error) in
                    let url = result as! URL?
                    self.urlString = url!.absoluteString
                    _ = self.isContentValid()
                })
            }
        }
        
        
    }

    override func isContentValid() -> Bool {
        if urlString != nil, !self.textView.text.isEmpty{
            return true
        }
        return false
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        
        return []
    }

}
extension NSItemProvider{
    var isURL: Bool{
        return hasItemConformingToTypeIdentifier(kUTTypeURL as String)
    }
}

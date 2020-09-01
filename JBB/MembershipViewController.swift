//
//  MembershipViewController.swift
//  JBB
//
//  Created by Bobby Keffury on 8/31/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import WebKit

class MembershipViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString("<iframe src=\"https://www.podbean.com/media/player/multi?playlist=http%3A%2F%2Fplaylist.podbean.com%2F7247111%2Fplaylist_multi.xml&amp;vjs=1&amp;size=430&amp;skin=3&amp;episode_list_bg=%23ffffff&amp;bg_left=%23000000&amp;bg_mid=%23000000&amp;bg_right=%23000000&amp;podcast_title_color=%23BDBDBD&amp;episode_title_color=%23ffffff&amp;auto=0&amp;share=0&amp;fonts=Helvetica&amp;download=0&amp;rtl=0&amp;show_playlist_recent_number=20\" title=\"The Juco Pod\" width =\(webView.frame.width) height=\(webView.frame.height) scrolling=\"no\" style=\"position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;\"></iframe>", baseURL: nil)
    }
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

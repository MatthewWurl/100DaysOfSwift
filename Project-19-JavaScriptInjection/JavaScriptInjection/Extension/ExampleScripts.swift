//
//  ExampleScripts.swift
//  Extension
//
//  Created by Matt X on 12/24/22.
//

import Foundation

enum ExampleScripts: String {
    case displayAlert = """
    alert(`Page title: ${document.title}\nPage URL: ${document.URL}`);
    """
    case replacePageContent = """
    document.body.innerHTML = "";

    var p = document.createElement("p");
    p.textContent = "I have replaced the page content!";
    document.body.appendChild(p);
    """
}

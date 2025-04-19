//
//  Final_Year_ProjectApp.swift
//  Final_Year_Project
//
//  Created by Macboook on 25/05/2024.
//

import SwiftUI

@main
struct Final_Year_ProjectApp: App {
    var body: some Scene {
        WindowGroup {
            Welcome().environmentObject(UserManager.shared)
        }
    }
}

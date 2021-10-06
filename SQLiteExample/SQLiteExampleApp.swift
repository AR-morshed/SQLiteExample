//
//  SQLiteExampleApp.swift
//  SQLiteExample
//
//  Created by Arman Morshed on 5/10/21.
//

import SwiftUI

@main
struct SQLiteExampleApp: App {
    
    init() {
        DatabaseManager.shared.connectToDatabase()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

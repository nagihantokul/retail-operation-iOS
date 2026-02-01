//
//  Retail_Operation_AppApp.swift
//  Retail_Operation_App
//
//  Created by Nagihan Tokul on 1/27/26.
//

import SwiftUI

@main
struct Retail_Operation_AppApp: App {
    @StateObject private var customerStore = CustomerStore()
    @StateObject private var salesStore = SalesStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(customerStore)
                .environmentObject(salesStore)
        }
    }
}

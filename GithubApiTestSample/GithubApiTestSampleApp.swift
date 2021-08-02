//
//  GithubApiTestSampleApp.swift
//  GithubApiTestSample
//
//  Created by Yusuke Hasegawa on 2021/07/29.
//

import SwiftUI

@main
struct GithubApiTestSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}

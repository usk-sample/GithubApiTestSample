//
//  ContentView.swift
//  GithubApiTestSample
//
//  Created by Yusuke Hasegawa on 2021/07/29.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}

//
//  ContentView.swift
//  GithubApiTestSample
//
//  Created by Yusuke Hasegawa on 2021/07/29.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    @State var text: String = ""
    
    var body: some View {

        VStack {
            
            TextField.init("search respository", text: $text) { _ in
            } onCommit: {
                if !text.isEmpty {
                    self.viewModel.search(query: text)
                }
            }
            .padding(4)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Divider()
            
            Group {
                
                if viewModel.loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 50, height: 50)
                        .scaleEffect(2.0)
                } else if !viewModel.hasError {
                    
                    //show list
                    List {
                        ForEach.init(viewModel.items) { item in
                            VStack {
                                Text(item.name)
                                Text(item.owner.login)
                            }
                        }
                    }.frame(maxHeight: .infinity)
                    
                } else {
                    //show error
                    
                    VStack {
                        Image(systemName: "xmark.octagon.fill")
                            .font(.system(size: 80))
                        Text("Error").font(.title)
                        Text("Error Error \n Error").font(.body)
                    }
                    .padding()
                    .foregroundColor(.gray)
                    
                }
            }.frame(maxHeight: .infinity)
            
        }
        

    }
}

extension SearchRepositoryItem: Identifiable { }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}

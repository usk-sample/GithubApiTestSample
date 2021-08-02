//
//  RepositoryRow.swift
//  GithubApiTestSample
//
//  Created by Yusuke Hasegawa on 2021/08/02.
//

import SwiftUI
import NukeUI

struct RepositoryRow: View {
    
    var item: SearchRepositoryItem
    
    var body: some View {
        VStack {
            HStack {
                Text(item.name).font(.title2).bold()
                    .truncationMode(.tail)
                Text(item.fullName).font(.body).foregroundColor(.gray)
                Spacer()
            }
            HStack {
                LazyImage.init(source: item.owner.avatarUrl)
                    .frame(width: 30, height: 30)
                Text(item.owner.login).font(.body)
                Spacer()
            }
        }.padding(4)
    }
}

struct RepositoryRow_Previews: PreviewProvider {
    static var previews: some View {
        
        let user = GithubUser.init(id: 0, login: "apple", avatarUrl: "https://avatars.githubusercontent.com/u/10639145?v=4", url: "https://api.github.com/users/apple", type: "Organization")
        
        RepositoryRow(item: .init(id: 0, name: "swift-format", fullName: "apple/swift-format", owner: user, private: false, description: "swift format", fork: false, url: "", createdAt: Date(), updatedAt: Date(), homepage: nil, stargazersCount: 10, watchersCount: 10, language: "swift", forksCount: 10, license: .init(key: "mit", name: "MIT", url: nil)))
            .previewLayout(.fixed(width: 375, height: 100))
    }
}

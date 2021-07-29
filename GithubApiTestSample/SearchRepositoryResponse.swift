//
//  SearchRepositoryResponse.swift
//  GithubApiTestSample
//
//  Created by Yusuke Hasegawa on 2021/07/29.
//

import Foundation

//https://docs.github.com/ja/rest/reference/search#search-repositories

struct SearchRepositoryResponse: Codable {
    let totalCount: Int
    let items: [SearchRepositoryItem]
}

struct SearchRepositoryItem: Codable {
    let id: Int
    let name: String
    let fullName: String
    let owner: GithubUser
    let `private`: Bool
    let description: String
    let fork: Bool
    let url: String
    let cratedAt: Date
    let updatedAt: Date
    let homepage: String
    let stargazersCount: Int
    let watchersCount: Int
    let language: String
    let forksCount: Int
    let license: GithubLicense
}

struct GithubUser: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
    let type: String
}

//https://docs.github.com/ja/rest/reference/licenses
struct GithubLicense: Codable {
    let key: String
    let name: String
    let url: String
}

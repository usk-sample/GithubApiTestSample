//
//  ViewModel.swift
//  GithubApiTestSample
//
//  Created by Yusuke Hasegawa on 2021/07/30.
//

import Combine
import Foundation

class ViewModel: NSObject, ObservableObject {
    
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol = ApiClient()) {
        self.apiClient = apiClient
    }
    
    @Published var text: String = ""
    @Published var loading: Bool = false
    @Published var items: [SearchRepositoryItem] = []
    @Published var hasNext: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    
    private var cancellations = Set<AnyCancellable>()
    
}

extension ViewModel {
    
    func search(debounce: TimeInterval = 3.0) {
        
        self.loading = true
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        perform(#selector(doSearch), with: nil, afterDelay: debounce)
        
    }
    
}

private extension ViewModel {
    
    @objc func doSearch() {
        
        debugPrint("doSearch:\(text)")
        
        apiClient.searchRepositories(query: text)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.loading = false
                switch completion {
                case .finished:
                    self?.hasError = false
                case .failure(let error):
                    debugPrint("*** error")
                    debugPrint(error)
                    self?.hasError = true
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.items = response.items
            }.store(in: &cancellations)
        
    }
    
}

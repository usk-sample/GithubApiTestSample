//
//  View+Snapshot.swift
//  GithubApiTestSampleTests
//
//  Created by Yusuke Hasegawa on 2021/08/02.
//

import SwiftUI

extension View {
    
    func snapshot(targetSize: CGSize = .init(width: 390, height: 844)) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .white
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
}

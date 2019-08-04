//
//  Dynamic.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 04/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

class Dynamic<T> {

    typealias Listener = (T) -> Void
    var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ v: T) {
        value = v
    }
}

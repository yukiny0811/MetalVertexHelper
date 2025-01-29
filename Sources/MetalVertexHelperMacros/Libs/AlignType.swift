//
//  AlignType.swift
//  MetalVertexHelper
//
//  Created by Yuki Kuwashima on 2025/01/29.
//

enum AlignType: Int, Equatable, Comparable {
    case one = 1
    case two = 2
    case four = 4
    case eight = 8
    case sixteen = 16
    case thirtytwo = 32
    static func < (lhs: AlignType, rhs: AlignType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

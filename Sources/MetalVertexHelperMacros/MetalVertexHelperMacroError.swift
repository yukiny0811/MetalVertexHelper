//
//  MetalVertexHelperMacroError.swift
//  MetalVertexHelper
//
//  Created by Yuki Kuwashima on 2025/01/29.
//

import Foundation

public enum MetalVertexHelperMacroError: LocalizedError {
    case failed(description: String)
    public var errorDescription: String? {
        switch self {
        case .failed(let description):
            return description
        }
    }
}

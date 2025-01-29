//
//  File.swift
//  MetalVertexHelper
//
//  Created by Yuki Kuwashima on 2025/01/29.
//

import XCTest
@testable import MetalVertexHelper
import simd

class Tests: XCTestCase {
    
    func testAnything() throws {
        
        @VertexObject
        struct Vertex {
            var a: Float
            var b: simd_float2
            var c: simd_float3
            var d: simd_float4
            var e: Float
            var f: simd_float3
            var g: simd_float2
        }
        let v = Vertex(a: 1, b: .one * 2, c: .one * 3, d: .one * 4, e: 1 * 5, f: .one * 6, g: .one * 7)
//        (1.0, 0.0, 2.0, 2.0, 3.0, 3.0, 3.0, 0.0, 4.0, 4.0, 4.0, 4.0, 5.0, 0.0, 0.0, 0.0, 6.0, 6.0, 6.0, 0.0, 7.0, 7.0, 0.0, 0.0)
        
    }
}

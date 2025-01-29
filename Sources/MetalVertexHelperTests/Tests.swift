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
            var f: simd_float4
        }
        let a = Vertex(a: 3.0, f: .init(2, 3, 4, 5))
        print(a.cObject)
        print(Vertex.memorySize)
        print(MemoryLayout<Vertex>.stride)
    }
}

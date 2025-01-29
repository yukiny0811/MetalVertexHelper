//
//  MetalVertexHelperPlugin.swift
//  MetalVertexHelper
//
//  Created by Yuki Kuwashima on 2025/01/29.
//

import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct MetalVertexHelperPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        VertexObject.self,
    ]
}

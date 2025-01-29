import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
    public var errorDescription: String? { self }
}

@main
struct MetalVertexHelperPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        VertexObject.self,
    ]
}

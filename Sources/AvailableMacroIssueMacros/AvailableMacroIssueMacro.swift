import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum BackwardCompatibleMacro: PeerMacro {
  static func expansion(
    of node: SwiftSyntax.AttributeSyntax,
    providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
    in context: some SwiftSyntaxMacros.MacroExpansionContext
  ) throws -> [SwiftSyntax.DeclSyntax] {
    let accessors = declaration.as(VariableDeclSyntax.self)?.bindings.first?.accessorBlock?.accessors
    guard let accessors else {
      fatalError()
    }
    return [
      """
      var version: String {
        if #available(macOS 15, *) {
          \(accessors)
        } else {
          \(accessors)
        }
      } 
      """
    ]
  }
}

@main
struct AvailableMacroIssuePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BackwardCompatibleMacro.self,
    ]
}

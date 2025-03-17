import AvailableMacroIssue

@available(*, deprecated)
struct Value1 {
    let text: String = "macOS 14"
}

@available(macOS 15, *)
struct Value2 {
    let text: String = "macOS 15+"
}

struct Version {
    
    @BackwardCompatible
    var _value: String {
        value(.init())
    }
    
    @_disfavoredOverload
    func value(_ value: Value1) -> String {
        value.text
    }

    @available(macOS 15, *)
    func value(_ value: Value2) -> String {
        value.text
    }
}

print(Version().version)

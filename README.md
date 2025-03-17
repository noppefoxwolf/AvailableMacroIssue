# Macro availablility issue

When you use macros to generate code that contains method overrides, type inference results will be different than if you unfold it manually.


```
@available(*, deprecated)
struct Value1 {
    let text: String = "macOS 14"
}

@available(macOS 15, *)
struct Value2 {
    let text: String = "macOS 15+"
}
```


## with Macro
```
struct Version {
    
    @BackwardCompatibleBody
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

print(Version().version) // macOS 14
```

## Inlined macro
```
struct Version {
    
    
    var _value: String {
        value(.init())
    }
    
    var version: String {
        if #available(macOS 15, *) {
            
            value(.init())
        } else {
            
            value(.init())
        }
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

print(Version().version) // macOS 15+
```

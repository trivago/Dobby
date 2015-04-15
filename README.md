# Dobby

Dobby provides a few helpers for mocking and stubbing.

## Mock

A mock can be used to record interactions with an object:

```swift
struct MyMock {
    let mock = Mock<Interaction2<String, String>>()
    
    func myMethod(first: String, second: String) -> String {
        record(mock, interaction(first, second))
        return first + second
    }
}
```

Interactions can be verified:

```swift
var myMock = MyMock()
myMock.myMethod("first", second: "second")

expect(verify(myMock.mock, [ interaction("first", any()) ])).to(beTrue())
```

## Stub

A stub can be used to alter the behavior of a method:

```swift
class MyClass {
    func myMethod(first: String, _ second: String) -> String {
        return first + second
    }
}
```

```swift
class MyClassMock: MyClass {
    let stub = Stub<Interaction2<String, String>, String>()
    
    override func myMethod(first: String, _ second: String) -> String {
        return invoke(stub, interaction(first, second)) ?? super.myMethod(first, second)
    }
}
```

Behavior can be modified on-the-fly:

```swift
var myClassMock = MyClassMock()

behave(myClassMock.stub, interaction(filter { count($0) == 0 }, any()), "no first")
behave(myClassMock.stub, interaction(any(), filter { count($0) == 0 }), "no second")

expect(myClassMock.myMethod("", "second")).to(equal("no first"))
expect(myClassMock.myMethod("first", "")).to(equal("no second"))
```

## Argument & Interaction

In addition to mocks and stubs, another two helpers are provided for working with arguments and interactions.

### Argument

An argument either represents a filter, a value or any value.

```swift
filter { (x: Int) in return x > 2 }
```

```swift
value(2)
```

```swift
any()
```

### Interaction

An interaction holds up to five arguments. It's basically an equatable tuple of arguments:

```swift
interaction()
```

```swift
interaction(1, 2, 3)
```

```swift
interaction(1, any(), 3, filter { $0 > 4 }, 5)
```

## About

Dobby was built by [Rheinfabrik](http://www.rheinfabrik.de) 🏭

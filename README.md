# Dobby

Dobby provides a few helpers for mocking and stubbing.

## Mock

A mock can be used to record interactions with an object:

```swift
struct MyMock {
    let mock = Mock<String>()

    func myMethod(input: String) -> String {
        record(mock, input)
        return input.uppercaseString
    }
}
```

Interactions can be verified:

```swift
let myMock = MyMock()
myMock.myMethod("lowercase")
myMock.myMethod("another lowercase")

verify(myMock.mock).to(contain("another lowercase"))
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
    let myMethodStub = Stub<Interaction2<String, String>, String>()
    override func myMethod(first: String, _ second: String) -> String {
        // Call super if the stub doesn't define any behavior for the interaction.
        return invoke(myMethodStub, interaction(first, second)) ?? super.myMethod(first, second)
    }
}
```

Behavior can be modified on-the-fly:

```swift
let myClassMock = MyClassMock()

behave(myClassMock.myMethodStub, interaction(filter { isEmpty($0) }, any()), "no first")
behave(myClassMock.myMethodStub, interaction(any(), filter { isEmpty($0) }), "no second")

expect(myClassMock.myMethod("", "second")).to(equal("no first"))
expect(myClassMock.myMethod("first", "")).to(equal("no second"))
expect(myClassMock.myMethod("first", "second")).to(equal("first second"))
```

## Argument & Interaction

In addition to mocks and stubs, another two helpers are provided for working with arguments and interactions.

### Argument

An argument either represents a filter, a value or any value.

```swift
let arg: Argument<Int> = filter { $0 > 2 }
```

```swift
let arg: Argument<Int> = value(2)
```

```swift
let arg: Argument<Int> = any()
```

### Interaction

An interaction holds up to five arguments. It's basically an equatable tuple of arguments:

```swift
let int: Interaction0 = interaction()
```

```swift
let int: Interaction3<Int, Int, Int> = interaction(1, 2, 3)
```

```swift
let int: Interaction5<Int, Bool, Int, Float, Int> = interaction(1, any(), 3, filter { $0 > 4 }, 5)
```

## Advanced usage

What if multiple interactions are to be verified? Here is an example:

```swift
class StringTools {
    func uppercase(input: String) -> String {
        return input.uppercaseString
    }

    func concat(first: String, _ second: String) -> String {
        return first + second
    }
}
```

In this scenario, an equatable enum can be defined for all interactions:

```swift
enum StringToolsMockInteraction: Equatable {
   case Uppercase(Argument<String>)
   case Concat(Argument<String>, Argument<String>)
}

func == (lhs: StringToolsMockInteraction, rhs: StringToolsMockInteraction) -> Bool {
    switch (lhs, rhs) {
    case let (.Uppercase(left), .Uppercase(right)):
        return left == right
    case let (.Concat(first1, second1), .Concat(first2, second2)):
        return first1 == first2 && second1 == second2
    default:
        return false
    }
}
```

This enables recording and differentiation of multiple interactions using the same mock:

```swift
class StringToolsMock: StringTools {
    let mock = Mock<StringToolsMockInteraction>()
    
    let uppercaseStub = Stub<StringToolsMockInteraction, String>()
    override func uppercase(input: String) -> String {
        record(mock, .Uppercase(value(input)))
        return invoke(uppercaseStub, .Uppercase(value(input))) ?? super.uppercase(input)
    }

    let concatStub = Stub<StringToolsMockInteraction, String>()
    override func concat(first: String, _ second: String) -> String {
        record(mock, .Concat(value(first), value(second)))
        return invoke(concatStub, .Concat(value(first), value(second))) ?? super.concat(first, second)
    }
}
```

So that multiple interactions can be easily verified:

```swift
let stringToolsMock = StringToolsMock()

behave(stringToolsMock.concatStub, .Concat(any(), any()), "")

expect(stringToolsMock.uppercase("input")).to(equal("INPUT"))
expect(stringToolsMock.concat("first", "second")).to(equal(""))

verify(stringToolsMock.mock).to(equal([
    .Uppercase(value("input")),
    .Concat(value("first"), value("second"))
]))
```

## About

Dobby was built by [Rheinfabrik](http://www.rheinfabrik.de) 🏭

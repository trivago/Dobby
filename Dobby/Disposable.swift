public final class Disposable {
    private var action: (() -> ())?

    public var disposed: Bool {
        return action == nil
    }

    public init(action: () -> ()) {
        self.action = action
    }
    
    public func dispose() {
        action?()
        action = nil
    }
}

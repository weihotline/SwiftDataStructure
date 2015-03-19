import Foundation

// LRUCache class
public class LRUCache<K: Hashable, V: Comparable> {
    // techniques for creating readonly variables
    // for those who know JavaScript well,
    // this just looks like private variables accessed by privileged methods
    private var _hits: Int
    private var _misses: Int
    var hits: Int {
        get { return _hits }
    }

    var misses: Int {
        get { return _misses }
    }

    var linksDict: Dictionary<K, Link<V>>
    var linkedList: LinkedList<V>
    var maxSize: Int
    var prc: (K) -> V

    init(maxSize: Int, closure: (K) -> V) {
        linksDict = [:]
        linkedList = LinkedList<V>()
        self.prc = closure
        self.maxSize = maxSize

        // Logging
        _misses = 0
        _hits = 0
    }

    subscript(key: K) -> V {
        get {
            // if the key is already cached
            if linksDict[key] != nil {
                let link = linksDict[key]!
                link.remove()
                linkedList.pushLink(link)

                _hits++
                return link.value!
            }

            _misses++

            // reach maximum size, remove the oldest entry
            if linksDict.count == maxSize {
                let link = linkedList.shiftLink()
                link.remove()
                // O(n)
                for (key, value) in linksDict {
                    if value === link {
                        linksDict.removeValueForKey(key)!
                        break
                    }
                }
            }

            // cache new entry
            let value = prc(key)
            linksDict[key] = linkedList.push(value)

            return value
        }
    }
}// end LRUCache class



//*******************************************************
// LinkedList (Doubly)
public class LinkedList<T: Comparable> {
    private var head: SentinelLink<T>!
    private var tail: SentinelLink<T>!
    var isEmpty: Bool {
        /* when head link's next points to tail link,
           it is empty */
        get { return head.next === tail }
    }

    init() {
        self.head = SentinelLink(side: "head")
        self.tail = SentinelLink(side: "tail")

        self.head.insertRight(self.tail)
    }

    func pop() -> T? {
        return popLink().value
    }

    func popLink() -> Link<T> {
        assert(!isEmpty, "can't pop from empty list!")

        let link = tail.prev
        link!.remove()
        return link!
    }

    func push(value: T) -> Link<T> {
        return pushLink(Link(value: value))
    }

    func pushLink(link: Link<T>) -> Link<T> {
        tail.insertLeft(link)
        return link
    }

    func shift() -> T? {
        return shiftLink().value
    }

    func shiftLink() -> Link<T> {
        assert(!isEmpty, "can't shift from empty list!")

        let link = head.next
        link!.remove()
        return link!
    }

    func unshift(value: T) -> Link<T> {
        return unshiftLink(Link(value: value))
    }

    func unshiftLink(link: Link<T>) -> Link<T> {
        head.insertRight(link)
        return link
    }
}// end LinkedList class



// Link class
public class Link<T: Comparable> {
    // value, next and prev can be nil, so use ?
    var value: T?
    var next: Link<T>?
    var prev: Link<T>?
    var isDetached: Bool {
        get { return next == nil && prev == nil }
    }

    init(value: T?) {
        self.value = value
    }

    func insertLeft(link: Link<T>) {
        assert(link.isDetached,
            "trying to insert a link that is not detached!")

        link.next = self
        link.prev = self.prev
        if self.prev != nil {
            self.prev!.next = link
        }
        self.prev = link
    }

    func insertRight(link: Link<T>) {
        assert(link.isDetached,
            "trying to insert a link that is not detached!")

        link.prev = self
        link.next = self.next
        if self.next != nil {
            self.next!.prev = link
        }
        self.next = link
    }

    func remove() {
        if self.prev != nil {
            self.prev!.next = self.next
        }

        if self.next != nil {
            self.next!.prev = self.prev
        }

        self.next = nil
        self.prev = nil
    }
}// end Link class



// SentinelLink: head and tail links
internal class SentinelLink<T: Comparable>: Link<T> {
    var side: String!
    override var value: T? {
        get {
            NSException(name: "Exception",
                reason: "Sentinels don't have values!",
                userInfo: nil).raise()

            return nil
        }

        set {
            NSException(name: "Exception",
                reason: "Sentinels don't have values!",
                userInfo: nil).raise()
        }
    }

    override var prev: Link<T>? {
        get {
            return super.prev
        }

        set(newLink) {
            /* only tail link can set prev */
            if side == "tail" {
                super.prev = newLink
            } else if newLink == nil {
                /* the first sentinel may allow superfluous
                set of prev to `nil`. */
            } else {
                NSException(name: "Exception",
                    reason: "can't set prev of first sentinel",
                    userInfo: nil).raise()
            }
        }
    }

    override var next: Link<T>? {
        get {
            return super.next
        }

        set(newLink) {
            /* only head link can set prev */
            if side == "head" {
                super.next = newLink
            } else if newLink == nil {
                /* the first sentinel may allow superfluous
                set of prev to `nil`. */
            } else {
                NSException(name: "Exception",
                    reason: "can't set prev of first sentinel",
                    userInfo: nil).raise()
            }
        }
    }

    init(side: String) {
        let validSides = ["head", "tail"]

        if (find(validSides, side) == nil) {
            NSException(name: "Exception",
                reason: "incorrect side choice",
                userInfo: nil).raise()
        }
        super.init(value: nil)
        self.side = side
    }

    override func remove() {
        NSException(name: "Exception",
            reason: "Can't remove a sentinel!",
            userInfo: nil).raise()
    }
}// end SentinelLink class
/******************************************************/




/********************* TestCase classes ***************/
class UncachedFibo {
    var calculations: Int = 0

    init() {}
    func calculate(n: Int) -> Int {
        calculations += 1

        if n == 0 { return 0 }
        if n == 1 { return 1 }

        return calculate(n - 2) + calculate(n - 1)
    }
}// end UncachedFibo


class CachedFibo {
    var cache: LRUCache<Int, Int>?

    init(maxSize: Int) {
        self.cache = LRUCache<Int, Int>(maxSize: maxSize) {
            self.calculate($0, useCache: false)
        }
    }

    func calculate(n: Int, useCache: Bool = true) -> Int {
        if useCache { return cache![n] }

        if n == 0 { return 0 }
        if n == 1 { return 1 }

        return calculate(n - 2) + calculate(n - 1)
    }
}// end CachedFibo

// TestDriver main
func main() {
    let uncachedFibo = UncachedFibo()
    println("Uncached Fibonacci calculation: ")
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    print("35th fibonacci number: ")
    println(uncachedFibo.calculate(35))
    var currentTime = NSDate.timeIntervalSinceReferenceDate()
    var timeElapsed = Double(currentTime - startTime) * 1000
    println("Execution time in ms: " + (String(format: "%.02f", timeElapsed)))
    println("Number of Calculations: \(uncachedFibo.calculations)")
    println("")

    println("Cached Fibonacci calculation: ")
    let cachedFibo = CachedFibo(maxSize: 50)
    startTime = NSDate.timeIntervalSinceReferenceDate()
    print("35th fibonacci number: ")
    println(cachedFibo.calculate(35))
    currentTime = NSDate.timeIntervalSinceReferenceDate()
    timeElapsed = Double(currentTime - startTime) * 1000
    println("Execution time in ms: " + (String(format: "%.02f", timeElapsed)))
    println("Cache hits: \(cachedFibo.cache!.hits)")
    println("Cache misses: \(cachedFibo.cache!.misses)")
}

main()

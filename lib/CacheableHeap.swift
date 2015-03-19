import Foundation

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
        assert(isEmpty, "can't pop from empty list!")

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
        assert(isEmpty, "can't shift from empty list!")

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

class LRUCache<K: Hashable, V: Comparable> {
    private var _hits: Int
    private var _misses: Int
    var hits: Int {
        get {
            return _hits
        }
    }

    var misses: Int {
        get {
            return _misses
        }
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
            if linksDict[key] != nil {
                let link = linksDict[key]!
                link.remove()
                linkedList.pushLink(link)

                _hits++
                return link.value!
            }

            _misses++

            if linksDict.count == maxSize {
                let link = linkedList.shiftLink()
                // incomplete: delete link.value from linksDict
            }

            let value = prc(key)
            linksDict[key] = linkedList.push(value)

            return value
        }
    }
}

public class CachebleBinaryMinHeap<T: Comparable> {
    internal var store: Array<T>
    internal var indexMap: Dictionary<String, Int>
    public var count: Int {
        get {
            return store.count
        }
    }
    public var isEmpty: Bool {
        get {
            return store.count == 0
        }
    }

    public init() {
        store = []
        indexMap = [:]
    }

    public func extract() -> T {
        if count == 0 {
            NSException(name: "Exception", reason: "No element to extract", userInfo: nil).raise()
        }

        self.dynamicType.iswap(&store, indexMap: &indexMap, parentIdx: 0, childIdx: store.count - 1)

        let val = store.removeLast(),
        key = "\(val)"
        indexMap.removeValueForKey(key)

        if !isEmpty {
            self.dynamicType.heapifyDown(&store, indexMap: &indexMap, parentIdx: 0, len: store.count)
        }

        return val
    }

    public func peek() -> T {
        if count == 0 {
            NSException(name: "Exception", reason: "No element to peek", userInfo: nil).raise()
        }

        return store[0]
    }

    public func push(val: T) {
        store.append(val)
        let key = "\(val)"

        indexMap[key] = store.count - 1
        self.dynamicType.heapifyUp(&store, indexMap: &indexMap, childIdx: store.count - 1, len: store.count)
    }

    class func getChildIndices(len: Int, parentIdx: Int) -> (Int?, Int?) {
        let children = [2 * parentIdx + 1, 2 * parentIdx + 2].filter() { $0 < len }
        switch children.count {
        case 0:
            return (nil, nil)
        case 1:
            return (children[0], nil)
        default:
            return (children[0], children[1])
        }
    }

    class func getParentIndex(childIdx: Int) -> Int{
        assert(childIdx != 0, "root has not parent")

        return (childIdx - 1) / 2
    }

    class func heapifyDown(inout array: Array<T>,
                           inout indexMap: Dictionary<String, Int>,
                           parentIdx: Int, len: Int) -> Array<T> {

        let (lChildIdx, rChildIdx) = getChildIndices(len, parentIdx: parentIdx),
        parentVal = array[parentIdx]

        var children: Array<T> = []

        if lChildIdx != nil {
            children.append(array[lChildIdx!])
        }

        if rChildIdx != nil {
            children.append(array[rChildIdx!])
        }

        if (children.filter() { $0 < parentVal }).count == 0 {
            return array
        }

        var swapIdx: Int
        if children.count == 1 {
            swapIdx = lChildIdx!
        } else {
            swapIdx = children[0] < children[1] ? lChildIdx! : rChildIdx!
        }

        iswap(&array, indexMap: &indexMap, parentIdx: parentIdx, childIdx: swapIdx)
        return heapifyDown(&array, indexMap: &indexMap, parentIdx: swapIdx, len: len)
    }

    class func heapifyUp(inout array: Array<T>,
                         inout indexMap: Dictionary<String, Int>,
                         childIdx: Int, len: Int) -> Array<T> {

        if childIdx == 0 { return array }
        let parentIdx = getParentIndex(childIdx),
        childVal = array[childIdx],
        parentVal = array[parentIdx]

        if childVal >= parentVal {
            return array
        } else {
            iswap(&array, indexMap: &indexMap, parentIdx: parentIdx, childIdx: childIdx)
            return heapifyUp(&array, indexMap: &indexMap, childIdx: parentIdx, len: len)
        }
    }

    class func iswap(inout array: Array<T>,
                     inout indexMap: Dictionary<String, Int>,
                     parentIdx: Int, childIdx: Int) {

        let parentVal = array[parentIdx],
        childVal = array[childIdx],
        parentKey = "\(parentVal)",
        childKey = "\(childVal)"

        array[parentIdx] = childVal
        array[childIdx] = parentVal

        indexMap.updateValue(childIdx, forKey: parentKey)
        indexMap.updateValue(parentIdx, forKey: childKey)
    }
}

class UncachedFibber {
    var calculations: Int = 0

    init() {}

    func calculate(n: Int) -> Int {
        calculations += 1

        if n == 0 {
            return 0
        }

        if n == 1 {
            return 1
        }

        return calculate(n - 2) + calculate(n - 1)
    }
}

class CachedFibber {
    var cache: LRUCache<Int, Int>?

    init(maxSize: Int) {
        self.cache = LRUCache<Int, Int>(maxSize: maxSize) { self.calculate($0, useCache: false) }
    }

    func calculate(n: Int, useCache: Bool = true) -> Int {
        if useCache {
            return cache![n]
        }

        if n == 0 {
            return 0
        }

        if n == 1 {
            return 1
        }

        return calculate(n - 2) + calculate(n - 1)
    }
}

func testDriver() {
    let uncachedFibber = UncachedFibber()
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    println(uncachedFibber.calculate(35))
    var currentTime = NSDate.timeIntervalSinceReferenceDate()
    var timeElapsed = Double(currentTime - startTime) * 1000
    println("Execution time in ms: " + (String(format: "%.02f", timeElapsed)))
    println("Number of Calculations: \(uncachedFibber.calculations)")

    let cachedFibber = CachedFibber(maxSize: 50)
    startTime = NSDate.timeIntervalSinceReferenceDate()
    println(cachedFibber.calculate(35))
    currentTime = NSDate.timeIntervalSinceReferenceDate()
    timeElapsed = Double(currentTime - startTime) * 1000
    println("Execution time in ms: " + (String(format: "%.02f", timeElapsed)))
    println("Cache hits: \(cachedFibber.cache!.hits)")
    println("Cache misses: \(cachedFibber.cache!.misses)")
}

testDriver()

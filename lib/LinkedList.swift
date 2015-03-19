import Foundation

// LinkedList (Doubly)
public class LinkedList<T: Comparable> {
    private var head: SentinelLink<T>!
    private var tail: SentinelLink<T>!
    var isEmpty: Bool {
        /* when head link's next points to tail link,
           it is empty */
        get { return head.next === tail }
    }
    var size: Int

    init() {
        self.head = SentinelLink(side: "head")
        self.tail = SentinelLink(side: "tail")
        self.size = 0

        self.head.insertRight(self.tail)
    }

    func pop() -> T? {
        return popLink().value
    }

    func popLink() -> Link<T> {
        assert(!isEmpty, "can't pop from empty list!")

        let link = tail.prev!
        link.remove()
        size--
        return link
    }

    func push(value: T) -> Link<T> {
        return pushLink(Link(value: value))
    }

    func pushLink(link: Link<T>) -> Link<T> {
        tail.insertLeft(link)
        size++
        return link
    }

    func shift() -> T? {
        return shiftLink().value
    }

    func shiftLink() -> Link<T> {
        assert(!isEmpty, "can't shift from empty list!")

        let link = head.next!
        link.remove()
        size--
        return link
    }

    func unshift(value: T) -> Link<T> {
        return unshiftLink(Link(value: value))
    }

    func unshiftLink(link: Link<T>) -> Link<T> {
        head.insertRight(link)
        size++
        return link
    }

    func peekFirst() -> Link<T>? {
        return isEmpty ? nil : head.next!
    }

    func peekLast() -> Link<T>? {
        return isEmpty ? nil : tail.prev!
    }
}// end LinkedList class



// Link class
public class Link<T: Comparable> {
    // value, next, and prev can be nil, so use ?
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
    /* SentinelLink should not have values */
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
} // end SentinelLink class



// TestDriver main
func main() {
    var linkedlist = LinkedList<Int>()
    print("The size should start with 0: ")
    println(linkedlist.size == 0)
    linkedlist.push(1)
    linkedlist.push(2)
    linkedlist.pushLink(Link<Int>(value: 3))

    println("pushing 1, 2, 3 to the linkedlist")
    var lastElement = linkedlist.peekLast()!.value!
    print("last element is 3: ")
    println(lastElement == 3)
    var firstElement = linkedlist.peekFirst()!.value!
    print("first element is 1: ")
    println(firstElement == 1)

    linkedlist.pop()
    lastElement = linkedlist.peekLast()!.value!
    print("Pop the last element, now last element is 2: ")
    println(lastElement == 2)
    linkedlist.shift()
    firstElement = linkedlist.peekFirst()!.value!
    print("Shift the first element, now first element is 2: ")
    println(firstElement == 2)

    print("The size is 1: ")
    println(linkedlist.size == 1)

    linkedlist.pop()
    print("Remove the last Link. isEmpty should be true: ")
    println(linkedlist.isEmpty)
}

main()

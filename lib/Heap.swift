import Foundation

public class BinaryMinHeap<T: Comparable> {
    internal var store: Array<T>
    internal var count: Int {
        get {
            return store.count
        }
    }

    public init() {
        store = []
    }

    public func extract() -> T {
        if count == 0 {
            NSException(name: "Exception", reason: "No element to extract", userInfo: nil).raise()
        }

        let val = store[0]
        if count > 1 {
            store[0] = store.removeLast()
            self.dynamicType.heapifyDown(&store, parentIdx: 0, len: store.count)
        } else {
            store.removeLast()
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
        self.dynamicType.heapifyUp(&store, childIdx: store.count - 1, len: store.count)
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

    class func heapifyDown(inout array: Array<T>, parentIdx: Int, len: Int) -> Array<T> {

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

        swap(&array[parentIdx], &array[swapIdx])
        return heapifyDown(&array, parentIdx: swapIdx, len: len)
    }

    class func heapifyUp(inout array: Array<T>, childIdx: Int, len: Int) -> Array<T> {
        if childIdx == 0 {
            return array
        }

        let parentIdx = getParentIndex(childIdx),
        childVal = array[childIdx],
        parentVal = array[parentIdx]

        if childVal >= parentVal {
            return array
        } else {
            swap(&array[childIdx], &array[parentIdx])
            return heapifyUp(&array, childIdx: parentIdx, len: len)
        }
    }
}

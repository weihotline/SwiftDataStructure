import Foundation

public class CacheableBinaryMinHeap<T: Comparable> {
    internal var store: Array<T>
    internal var indexMap: Dictionary<String, Int>
    public var count: Int {
        get { return store.count }
    }
    public var isEmpty: Bool {
        get { return store.count == 0 }
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

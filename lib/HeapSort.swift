import Foundation

// HeapSort
class HeapSort<T: Comparable> {
    // time complexity: O(nlogn)
    // space complexity: O(1) in-place, no extra stackframe
    class func sort(var array: Array<T>) -> Array<T> {
        let count = array.count
        if count < 2 { return array }

        for heapSize in 2...(count) {
            BinaryMinHeap.heapifyUp(&array, childIdx: heapSize - 1, len: heapSize)
        }

        for var heapSize = count; heapSize >= 2; heapSize-- {
            swap(&array[heapSize - 1], &array[0])
            BinaryMinHeap.heapifyDown(&array, parentIdx: 0, len: heapSize - 1)
        }

        return array.reverse()
    }
}// end HeapSort



/********************************************************/
// BinaryMinHeap class
public class BinaryMinHeap<T: Comparable> {
    var store: Array<T>
    var count: Int {
        get { return store.count }
    }

    public init() {
        store = []
    }

    public func extract() -> T {
        if count == 0 {
            NSException(name: "Exception",
                        reason: "No element to extract",
                        userInfo: nil).raise()
        }

        let val = store[0]
        if count > 1 {
            // take the last element, put it on the top and start heapify it down
            store[0] = store.removeLast()
            // O(logn)
            self.dynamicType.heapifyDown(&store, parentIdx: 0, len: store.count)
        } else {
            store.removeLast()
        }

        return val
    }

    public func peek() -> T {
        if count == 0 {
            NSException(name: "Exception",
                        reason: "No element to peek",
                        userInfo: nil).raise()
        }

        return store[0]
    }

    public func push(val: T) {
        store.append(val)
        // O(logn)
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
}// end BinaryMinHeap class
/********************************************************************/




// TestDriver main
func main() {
    let emptyArray: Array<Int> = []
    print("it should return an empty array: ")
    println(HeapSort<Int>.sort(emptyArray).isEmpty)

    var array: Array<Int> = [ 123, 432, 12, 322, 45, 34, 2, 1 ]
    let sortedArray = [ 1, 2, 12, 34, 45, 123, 322, 432 ]
    print("it should return a sorted array: ")
    println(HeapSort<Int>.sort(array) == sortedArray)

    array = [ 2, 1 ]
    print("it should return a sorted array: ")
    println(HeapSort<Int>.sort(array) == [ 1, 2 ])
}

main()

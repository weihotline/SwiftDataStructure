import Foundation

class HeapSort<T: Comparable> {
    class func sort(var array: Array<T>) -> Array<T> {
        let count = array.count
        for heapSize in 2...(count - 1) {
            BinaryMinHeap.heapifyUp(&array, childIdx: heapSize - 1, len: heapSize)
        }
        
        for var heapSize = count; heapSize >= 2; heapSize-- {
            swap(&array[heapSize - 1], &array[0])
            BinaryMinHeap.heapifyDown(&array, parentIdx: 0, len: heapSize - 1)
        }
        
        return array.reverse()
    }
}
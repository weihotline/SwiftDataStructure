class QuickSort<T: Comparable> {
    // notInPlaceSort class level method
    // average time complexity: O(nlogn)
    // worst case time complexity: O(n^2)
    // worst case space complexity: O(n^2)
    class func notInPlaceSort(array: Array<T>) -> Array<T> {
        if array.count == 0 {
            return array
        }

        let pivot = array[0]

        var left: Array<T> = [],
        middle: Array<T> = [],
        right: Array<T> = []

        for el in array {
            if el < pivot {
                left.append(el)
            } else if el > pivot {
                right.append(el)
            } else {
                middle.append(el)
            }
        }

        return notInPlaceSort(left) + middle + notInPlaceSort(right)
    }

    // in-place sort class level method
    // average time complexity: O(nlogn)
    // worst case time complexity: O(n^2)
    // average space complexity: O(logn) auxiliary
    // worst case space complexity: O(n) auxiliary
    class func sort(inout array: Array<T>, startIdx: Int = 0,
        var length: Int? = nil) -> Array<T> {

        if length == nil { length = array.count }
        if length < 2 { return array }

        var pivotIdx = startIdx
        let pivot = array[startIdx],
        end = startIdx + length!

        // partition: three-way swap
        for idx in (startIdx + 1)..<(end) {
            let curEl = array[idx]

            if curEl < pivot {
                array[idx] = array[pivotIdx+1]
                array[pivotIdx+1] = pivot
                array[pivotIdx] = curEl

                pivotIdx++
            }
        }
        /* after partitioning, we have [unsorted lesser left half] | pivot | [unsorted bigger right half].
           now we have to sort left half and right half.
        */

        let leftLength = pivotIdx - startIdx,
        rightLength = length! - (leftLength + 1)

        sort(&array, startIdx: startIdx, length: leftLength)
        sort(&array, startIdx: pivotIdx + 1, length: rightLength)

        return array
    }
}// end QuickSort



// TestDriver main
func main() {
    var emptyArray: Array<Int> = []
    print("it should return an empty array: ")
    print(QuickSort<Int>.notInPlaceSort(emptyArray).isEmpty)
    print(" ")
    println(QuickSort<Int>.sort(&emptyArray).isEmpty)

    var array: Array<Int> = [ 123, 432, 12, 322, 45, 34, 2, 1 ]
    var sortedArray = QuickSort<Int>.notInPlaceSort(array)
    print("notInPlaceSort should return a sorted array: ")
    println(sortedArray == [ 1, 2, 12, 34, 45, 123, 322, 432 ])
    print("it should not alter the original array: ")
    println(array == [ 123, 432, 12, 322, 45, 34, 2, 1 ])

    sortedArray = QuickSort<Int>.sort(&array)
    print("in-place sort should return itself (sorted): ")
    println(sortedArray == [ 1, 2, 12, 34, 45, 123, 322, 432 ])
    print("it should alter the original array: ")
    println(array == [ 1, 2, 12, 34, 45, 123, 322, 432 ])
}

main()

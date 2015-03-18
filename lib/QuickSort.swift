class QuickSort<T: Comparable> {
    class func notInPlaceSort(array: Array<T>) -> Array<T> {
        if array.count == 0 {
            return array
        }

        let pivot = array[0]

        let left = array.filter() { $0 < pivot },
        middle = array.filter() { $0 == pivot },
        right = array.filter() { $0 > pivot }

        return notInPlaceSort(left) + middle + notInPlaceSort(right)
    }

    class func sort(inout array: Array<T>, startIdx: Int = 0,
        var length: Int = Int.min) -> Array<T> {

        if length == Int.min { length = array.count }
        if length < 2 { return array }

        var pivotIdx = startIdx

        let pivot = array[startIdx],
        end = startIdx + length

        // partition
        for idx in (startIdx + 1)..<(end) {
            let curEl = array[idx]

            if curEl < pivot {

                array[idx] = array[pivotIdx+1]
                array[pivotIdx+1] = pivot
                array[pivotIdx] = curEl

                pivotIdx++
            }
        }

        let leftLength = pivotIdx - startIdx,
        rightLength = length - (leftLength + 1)

        sort(&array, startIdx: startIdx, length: leftLength)
        sort(&array, startIdx: pivotIdx+1, length: rightLength)

        return array
    }
}

var array: Array<Int> = [ 123, 432, 12, 322, 45, 34, 2, 1 ]
QuickSort<Int>.sort(&array)
println(array)

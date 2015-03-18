class MergeSort<T: Comparable> {
    class func sort(array: Array<T>) -> Array<T> {

        let length = array.count

        if (length < 2) {
            return array
        }

        let midpoint = length / 2,
        left = Array(array[0..<midpoint]),
        right = Array(array[midpoint..<length])

        return merge(sort(left), right: sort(right))
    }

    class func merge(var left: Array<T>, var right: Array<T>) -> Array<T> {
        var mergedArray: Array<T> = []

        while left.count != 0 && right.count != 0 {
            if left[0] < right[0] {
                mergedArray.append(left.removeAtIndex(0))
            } else {
                mergedArray.append(right.removeAtIndex(0))
            }
        }

        return mergedArray + left + right
    }
}

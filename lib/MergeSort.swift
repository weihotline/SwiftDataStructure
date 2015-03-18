// encapsulation
class MergeSort<T: Comparable> {
    // class level method
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
}// end MergeSort

// TestDriver main
func main() {
    let emptyArray: Array<Int> = []
    print("it should return an empty array: ")
    println(MergeSort<Int>.sort(emptyArray) == [])

    let sortedArray: Array<Int> = [ 1, 2, 3 ]
    let unsortedArray: Array<Int> = [ 12, 34, 2, 32, 123, 4, 5, 1 ]
    print("it should return a sorted array: ")
    print(MergeSort<Int>.sort(sortedArray) == [ 1, 2, 3 ])
    print(" ")
    println(MergeSort<Int>.sort(unsortedArray) == [ 1, 2, 4, 5, 12, 32, 34, 123 ])

    print("since this is not an in-place sort, the original array should not be modified: ")
    println(unsortedArray == [ 12, 34, 2, 32, 123, 4, 5, 1 ])
}

main()

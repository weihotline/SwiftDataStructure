class HashTable<K: Hashable, V: Comparable> {
    private let defaultSize = 101
    private let maxLoad = 0.50
    internal var buckets: Array<Array<(K, V)>> = []
    var count: Int
    var isEmpty: Bool {
        get { return count == 0 }
    }

    init() {
        for _ in 0..<defaultSize {
            self.buckets.append(Array<(K, V)>())
        }

        count = 0
    }

    func put(#key: K, value: V) -> Bool {
        // overhead O(1) randomized
        if containsKey(key) {
            return false
        }

        // O(n), happen infrequently, amortized O(1)
        if (Double(count + 1) / Double(buckets.count)) > maxLoad {
            resize()
        }

        addToBucket((key, value), buckets: &buckets)

        count++
        return true
    }

    func get(key: K) -> V? {
        // O(1) randomized/evenly distributed
        for (itemKey, itemValue) in bucketFor(key, buckets: buckets) {
            if key == itemKey {
                return itemValue
            }
        }

        return nil
    }

    func containsKey(key: K) -> Bool {
        return get(key) != nil
    }

    func containsValue(value: V) -> Bool {
        // O(n)
        for bucket in buckets {
            for (_, itemValue) in bucket {
                if value == itemValue {
                    return true
                }
            }
        }

        return false
    }

    func remove(key: K) -> Void {
        // overhead O(1) randomized
        assert(containsKey(key), "key doesn't exist in the Hashtable")
        // O(1) randomized/evenly distributed data
        removeFromBucket(key, buckets: &buckets)
        count--
    }

    private func bucketFor(key: K, buckets: Array<Array<(K, V)>>)
        -> Array<(K, V)> {
            return buckets[key.hashValue % buckets.count]
    }

    private func addToBucket(pair: (K, V),
        inout buckets: Array<Array<(K, V)>>) {
            let (key, _) = pair
            buckets[key.hashValue % buckets.count].append(pair)
    }

    private func removeFromBucket(key: K,
        inout buckets: Array<Array<(K, V)>>) {
            let bucketPos = key.hashValue % buckets.count
            var foundIdx: Int!

            for (index, (itemKey, _)) in enumerate(buckets[bucketPos]) {
                if key == itemKey {
                    foundIdx = index
                }
            }

            buckets[bucketPos].removeAtIndex(foundIdx)
    }

    private func resize() {
        var newBuckets: Array<Array<(K, V)>> = []

        for _ in 0..<(buckets.count * 2) {
            newBuckets.append(Array<(K, V)>())
        }

        // O(n)
        for bucket in buckets {
            for entry in bucket {
                addToBucket(entry, buckets: &newBuckets)
            }
        }

        self.buckets = newBuckets
    }
}

var hash = HashTable<String, Int>()
println(hash.isEmpty)

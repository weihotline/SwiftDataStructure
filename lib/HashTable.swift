// HashTable class
public class HashTable<K: Hashable, V: Comparable> {
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

        // resize: O(n), happen infrequently, amortized O(1)
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
        assert(containsKey(key),
               "key doesn't exist in the Hashtable")
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

            // O(1) for evenly distributed data
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
}// end HashTable class



// TestDriver main
func main() {
    var hash = HashTable<String, Int>()
    print("hash starts with empty size: ")
    println(hash.isEmpty)

    print("it should return true if key-value pair successfully added: ")
    println(hash.put(key: "a", value: 1))
    hash.put(key: "b", value: 2)
    hash.put(key: "c", value: 3)
    hash.put(key: "d", value: 4)
    hash.put(key: "e", value: 5)

    print("it should return false if key does already exist: ")
    println(!hash.put(key: "a", value: 2))

    print("the number of entries is 5: ")
    println(hash.count == 5)

    print("#get: it should return nil if the key does not exist: ")
    println(hash.get("f") == nil)

    print("it should return the correct value: ")
    println(hash.get("d") == 4)

    print("it should return true if the key exists in the hashtable: ")
    println(hash.containsKey("a"))

    print("it should return true if the key exists in the hashtable: ")
    println(hash.containsValue(2))

    print("it should return false if the key exists in the hashtable: ")
    println(!hash.containsKey("q"))

    print("it should return false if the key exists in the hashtable: ")
    println(!hash.containsValue(10))

    print("the number of entries is reduced to 3 after 2 removals: ")
    hash.remove("a")
    hash.remove("b")
    println(hash.count == 3)
}

main()

## Implementation of Data Structures in Swift
I love data structure. Understanding data structure is always beneficial for software development. When it comes to performance, picking the correct data structure becomes more important. Feel free to contact me at <weihotline@gmail.com> if you like Swift and these implementations.

## List of Common Data Structures
* [LinkedList](https://github.com/weihotline/SwiftDataStructure/blob/master/lib/LinkedList.swift)
* [HashTable](https://github.com/weihotline/SwiftDataStructure/blob/master/lib/HashTable.swift)
* [BinaryMinHeap](https://github.com/weihotline/SwiftDataStructure/blob/master/lib/BinaryMinHeap.swift)
* [AVLTree](https://github.com/weihotline/SwiftDataStructure/blob/master/lib/AVLTree.swift)
* [Graph](https://github.com/weihotline/SwiftDataStructure/blob/master/lib/Graph.swift)
* [LRUCache](https://github.com/weihotline/SwiftDataStructure/blob/master/lib/LRUCache.swift)
* [MergeSort](https://github.com/weihotline/SwiftDataStructure/blob/master/lib/MergeSort.swift)
* [QuickSort](https://github.com/weihotline/SwiftDataStructure/blob/master/lib/QuickSort.swift)
* [HeapSort](https://github.com/weihotline/SwiftDataStructure/blob/master/lib/HeapSort.swift)

## Tips for writing simple swift script
<p>
1. Make sure xcode is installed
<pre> <code>$ xcodebuild -version
</code></pre>
2. Swift is still in its early stages. You might find traditional Objective-c useful (e.g., NSDate).
<pre> <code>import Foundation
</code></pre>
3. Run swift in the terminal (playground is quite buggy)
<pre> <code>$ swift &lt;filename.swift&gt;
</code></pre>
4. Use swift compiler
<pre> <code>$ swiftc &lt;filename.swift&gt;
 $ ./&lt;filename&gt;
</code></pre>
5. Compilation error: cannot load underlying module for 'CoreGraphics'
<pre> <code>// add SDKROOT env varible to the .bash_profile
 export SDKROOT=$(xcrun --show-sdk-path --sdk macosx)
</code></pre>
</p>

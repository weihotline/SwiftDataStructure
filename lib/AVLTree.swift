import Foundation

// AVLTree class
class AVLTree<T: Comparable> {
    var root: AVLTreeNode<T>?
    var isEmpty: Bool {
        get { return root == nil }
    }

    init() {
        self.root = nil
    }

    func isInclude(value: T) -> Bool {
        let (vertex, _) = findNode(value)
        return vertex != nil
    }

    func insert(value: T) -> Bool {
        if isEmpty {
            root = AVLTreeNode(value: value)
            return true
        }

        var (vertex, parent) = findNode(value)

        if vertex != nil {
            return false
        }

        vertex = AVLTreeNode(value: value)

        if value < parent!.value {
            parent!.left = vertex
        } else {
            parent!.right = vertex
        }

        vertex?.parent = parent

        update(parent)
        return true
    }

    func traverse() {
        self.traverse(root) { println($0.value) }
    }

    private func traverse(vertex: AVLTreeNode<T>?,
        closure: (AVLTreeNode<T>) -> Void) {
            if vertex == nil { return }
            traverse(vertex!.left, closure: closure)
            closure(vertex!)
            traverse(vertex!.right, closure: closure)
    }

    private func findNode(value: T) ->
        (vertex: AVLTreeNode<T>?, parent: AVLTreeNode<T>?) {
            var vertex = root,
            parent: AVLTreeNode<T>!

            while vertex != nil {
                if vertex!.value == value {
                    break
                }

                parent = vertex
                if value < vertex!.value {
                    vertex = vertex!.left
                } else {
                    vertex = vertex!.right
                }
            }

            return (vertex, parent)
    }

    private func update(vertex: AVLTreeNode<T>?) {
        if vertex == nil { return }

        if vertex!.balance == -2 {
            if vertex!.left!.balance == 1 {
                leftRotate(vertex!.left!)
            }

            rightRotate(vertex!)
        } else if vertex!.balance == 2 {
            if vertex!.right!.balance == -1 {
                rightRotate(vertex!.right!)
            }

            leftRotate(vertex!)
        } else if vertex!.isBalanced {
            // already balanced
        } else {
            // This should never happen
            NSException(name: "Exception",
                reason: "something went wrong!",
                userInfo: nil).raise()
        }

        vertex!.recalculateDepth()
        update(vertex!.parent)
    }

    private func leftRotate(parent: AVLTreeNode<T>) {
        var parentParent = parent.parent,
        parentSide = parent.parentSide,
        rChild = parent.right,
        rlChild = rChild?.left

        if parentParent != nil &&
            parentSide == "left" {
                parentParent!.left = rChild
        } else if parentParent != nil &&
            parentSide == "right" {
                parentParent!.right = rChild
        } else {
            root = rChild
        }
        rChild?.parent = parentParent

        rChild?.left = parent
        parent.parent = rChild

        parent.right = rlChild
        if rlChild != nil {
            rlChild!.parent = parent
        }

        parent.recalculateDepth()
    }

    private func rightRotate(parent: AVLTreeNode<T>) {
        var parentParent = parent.parent,
        parentSide = parent.parentSide,
        lChild = parent.left,
        lrChild = lChild?.right

        if parentParent != nil &&
            parentSide == "left" {
                parentParent!.left = lChild
        } else if parentParent != nil &&
            parentSide == "right" {
                parentParent!.right = lChild
        } else {
            root = lChild
        }
        lChild?.parent = parentParent

        lChild?.right = parent
        parent.parent = lChild

        parent.left = lrChild
        if lrChild != nil {
            lrChild!.parent = parent
        }

        parent.recalculateDepth()
    }
}// end AVLTree class


// AVLTreeNode class
class AVLTreeNode<T: Comparable> {
    var value: T!
    var depth: Int!
    var parent: AVLTreeNode<T>?
    var left: AVLTreeNode<T>?
    var right: AVLTreeNode<T>?
    var balance: Int {
        get {
            let cDepth = childrenDepth()
            return cDepth.right - cDepth.left
        }
    }
    var isBalanced: Bool {
        get { return abs(balance) < 2 }
    }
    var parentSide: String? {
        get { return parent?.left === self ? "left" : "right" }
    }

    init(value: T) {
        self.value = value
        self.depth = 1
    }

    func recalculateDepth() {
        let cDepth = childrenDepth()
        depth = maxElement([cDepth.right, cDepth.left]) + 1
    }

    private func childrenDepth() -> (left: Int, right: Int) {
        let rDepth = (right != nil ? right!.depth : 0),
        lDepth = (left != nil ? left!.depth : 0)

        return (lDepth, rDepth)
    }
}// end AVLTreeNode



// TestDriver main
func main() {
    var avltree = AVLTree<Int>()
    print("it should start with empty tree: ")
    println(avltree.isEmpty == true)

    avltree.insert(2)
    avltree.insert(4)
    avltree.insert(5)
    print("it should rotate and now the root value is 4: ")
    println(avltree.root!.value == 4)

    print("it should return false for non-existed value: ")
    println(!avltree.isInclude(0))
    print("it should return true for existed value: ")
    println(avltree.isInclude(5))

    avltree.insert(6)
    avltree.insert(7)
    avltree.insert(1)
    avltree.insert(0)
    avltree.insert(8)
    avltree.insert(3)
    println("it should autobalance: (inorder display) ")
    println("inorder: 0 1 2 3 4 5 6 7 8")
    avltree.traverse()
}

main()

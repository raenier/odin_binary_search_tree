require_relative 'node'

class Tree
  attr_accessor :array_input, :root

  def initialize(arr)
    @array_input = arr
    @root = nil
  end

  def build_tree(arr = sorted_input)
    #base case
    return nil  if arr.empty?

    middle_index = arr.size/2
    root_part = arr.slice(middle_index, 1)
    left_part = arr.slice(0, middle_index)
    right_part = arr.slice(middle_index + 1, arr.size)

    # create the node, from the middle array
    new_node = Node.new(root_part.first)

    #recursively build trees on left and right part of array
    new_node.left = build_tree(left_part)
    new_node.right = build_tree(right_part)

    #return node,assign it to root
    #the last call to this is the first root of the recursion
    self.root = new_node
  end

  def insert(value, node = root)
    return Node.new(value) if node.nil?
    return nil if value == node.value

    # traverse the tree finding where to put value
    if value < node.value
      new_node = insert(value, node.left)
      node.left = new_node if node.left.nil?
    else
      new_node = insert(value, node.right)
      node.right = new_node if node.right.nil?
    end
  end

  def delete(value, node = root)
    return node if node.nil?

    if value < node.value
      node.left = delete(value, node.left)
      return node
    elsif value > node.value
      node.right = delete(value, node.right)
      return node
    else
      #if key is found
      if node.left.nil?
        # accounts child on right and also if leaf
        node.right
      elsif node.right.nil?
        # accounts child on left
        node.left
      else
        # if successor has two children
        # find min value on right part to be successor
        successor = min_value_node(node.right)
        # copy successors value to node value
        node.value = successor.value
        # recursively delete successor
        node.right = delete(successor.value, node.right)
        return node
      end
    end
  end

  def min_value_node(node = root)
    return node if node.left.nil?

    min_value_node(node.left)
  end

  def find(value, node = root)
    return 'Not Found' if node.nil?
    return node if value == node.value

    if value < node.value
      find(value, node.left)
    else
      find(value, node.right)
    end
  end

  def level_order
    queue = [root]
    accumulated_results = []

    until queue.empty?
      node = queue.shift

      result = block_given? ? yield(node.value) : node.value
      accumulated_results << result

      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
    end

    return accumulated_results
  end

  def recursive_level_order(queue = [root], accumulated_results = [], &block)
    # level order traversal using recursion
    return accumulated_results if queue.empty?

    # yield the node
    node = queue.shift
    accumulated_results << (block_given? ? yield(node.value) : node.value)

    # enqueue the children
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?

    #recursive call to function with updated queue and results
    recursive_level_order(queue, accumulated_results, &block)
  end

  def preorder(node = root, accumulated_results = [], &block)
    return accumulated_results if node.nil?

    accumulated_results << (block_given? ? yield(node.value) : node.value)
    acc = preorder(node.left, accumulated_results, &block)
    preorder(node.right, acc, &block)
  end

  def inorder(node = root, accumulated_results = [], &block)
    return accumulated_results if node.nil?

    acc = inorder(node.left, accumulated_results, &block)
    accumulated_results << (block_given? ? yield(node.value) : node.value)
    inorder(node.right, acc, &block)
  end

  def postorder(node = root, accumulated_results = [], &block)
    return accumulated_results if node.nil?

    acc = postorder(node.left, accumulated_results, &block)
    postorder(node.right, acc, &block)
    accumulated_results << (block_given? ? yield(node.value) : node.value)
  end

  def height(node = root)
    return 0 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)
    if left_height > right_height
      return 1 + left_height
    else
      return 1 + right_height
    end
  end

  def balanced?(node = root)
    left_height = height(node.left)
    right_height = height(node.right)
    height_difference = left_height - right_height
    [1, 0, -1].include? height_difference
  end

  def rebalance(node = root)
    new_sorted_array = inorder
    build_tree(new_sorted_array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def sorted_input
    @sorted_input ||= array_input.uniq.sort
  end
end

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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def sorted_input
    @sorted_input ||= array_input.uniq.sort
  end
end

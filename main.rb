require_relative 'lib/tree'
require 'awesome_print'

arr = (Array.new(15) { rand(1..100) })
tree = Tree.new(arr)
tree.build_tree
tree.pretty_print
puts "Is the tree created balanced? #{tree.balanced?}"

puts "Print elements in Level Order: "
ap tree.level_order
puts "Print elements in Pre Order: "
ap tree.preorder
puts "Print elements in In Order: "
ap tree.inorder
puts "Print elements in Post Order: "
ap tree.postorder

puts "Unbalancing the tree by adding several numbers > 100"
tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.insert(104)
tree.insert(105)
puts "Balanced?: #{tree.balanced?}"
puts "Rebalancing the tree"
tree.rebalance
puts "Balanced?: #{tree.balanced?}"

puts "Print elements in Level Order: "
ap tree.level_order
puts "Print elements in Pre Order: "
ap tree.preorder
puts "Print elements in In Order: "
ap tree.inorder
puts "Print elements in Post Order: "
ap tree.postorder

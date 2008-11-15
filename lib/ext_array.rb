class Array
  # Because Array#rand is defined in the ActiveSupport library
  # I should use Kernel.rand to call the original rand method.
  def shuffle
    self.sort{|a,b|Kernel.rand(3)-1}.reverse.sort{|a,b|Kernel.rand(3)-1}
  end

  def any
    self[Kernel.rand(size)]
  end
end

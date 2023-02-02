# The Crystal method we want to run inside Ruby
def summation(n)
  n < 2 ? n : n + summation(n - 1)
end

# Init is called when the lib is required
fun init = Init_crystal
  # Crystal garbage collector initialization
  GC.init
  # Crystal main method
  LibCrystalMain.__crystal_main(0, Pointer(Pointer(UInt8)).null)

  # In order to be able to have the first argument as self, I need a proc instead of a method
  # If you attempt to do it using a method definiton (def), it throws the following error:
  #
  # Error: cannot use 'self' as a parameter name
  summation_with_type_conversion = ->(self : Krystal::VALUE, ruby_number : Krystal::VALUE) do
    crystal_int = Krystal.rb_num2ll(ruby_number)
    Krystal.rb_ll2inum(summation(crystal_int))
  end

  # Defines Crystal as a Ruby class
  crystal = Krystal.rb_define_class("Crystal", Krystal.rb_cObject)

  # Defines summation as a method inside Krystal class. It creates a proc that will be use to call
  # summation_cr_wrapper method
  Krystal.rb_define_method(crystal, "summation", summation_with_type_conversion, 1)
end

# A lib declaration groups C functions and types that belong to a library.
lib Krystal
  # Represents Ruby object (Pointer to Nil)
  # https://github.com/ruby/ruby/blob/da9ee7bcf361887a28a1dd6769a4f47261dea7aa/include/ruby/internal/value.h#L30
  type VALUE = Void*

  # Represents Ruby class (which is also an object)
  # https://github.com/ruby/ruby/blob/4ce642620f10ae18171b41e166aaad3944ef482a/object.c#L52
  $rb_cObject : VALUE

  # Converts Crystal Int64 to Ruby number
  # https://github.com/ruby/ruby/blob/cb4e2cb55a59833fc4f1f6db2f3082d1ffcafc80/include/ruby/internal/arithmetic/long_long.h#L39
  fun rb_ll2inum(value : Int64) : VALUE

  # Converts Ruby number to Crystal Int64
  # https://github.com/ruby/ruby/blob/cb4e2cb55a59833fc4f1f6db2f3082d1ffcafc80/include/ruby/internal/arithmetic/long_long.h#L55
  fun rb_num2ll(value : VALUE) : Int64

  # Used to define a Ruby class
  # VALUE rb_define_class(const char *name, VALUE super);
  # https://github.com/ruby/ruby/blob/cb4e2cb55a59833fc4f1f6db2f3082d1ffcafc80/include/ruby/internal/module.h#L67
  fun rb_define_class(name : UInt8*, super : VALUE) : VALUE

  # Used to define a Ruby method inside a Ruby class
  #  * rb_define_method(klass, "method", RUBY_METHOD_FUNC(func), arity);
  # https://github.com/ruby/ruby/blob/7060b23ffa25fb53884e99e4ab1fa8919f666beb/include/ruby/internal/anyargs.h#L357
  fun rb_define_method(klass : VALUE, name : UInt8*, func : VALUE, VALUE -> VALUE, argc : Int64)
end

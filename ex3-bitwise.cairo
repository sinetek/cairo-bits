
# Use the required builtins (!!)
%builtins output bitwise

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.serialize import serialize_word

# Exercise:  write a function that demonstrates bitwise operations.

func simple_and{bitwise_ptr: BitwiseBuiltin*}() -> (result: felt):
	let (result : felt) = bitwise_and(0x5a, 0xa5)
	return (result)
end

# Needs the bitwise builtin (!!)
func main{output_ptr: felt*, bitwise_ptr: BitwiseBuiltin*}():
	let a = 0x10
	let (b : felt) = simple_and{bitwise_ptr=bitwise_ptr}()
	serialize_word(a)
	serialize_word(b)
        return ()
end


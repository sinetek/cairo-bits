
%builtins output 

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.memset import memset

# Ex4: Memset can fill memory segment with a given value.
#
# Example usage:
#    cairo-compile --output ex4.json ex4-memset.cairo &&
#    cairo-run --program ex4.json --layout all --print_memory --print_info

func main{output_ptr: felt*}() -> ():
    alloc_locals

    let (region1: felt*) = alloc()
    let (region2: felt*) = alloc()

    memset(region1, 1234567890, 20)
    memset(region2, 9876543210, 10)

    return ()
end

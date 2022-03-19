
# Use the output builtin.
%builtins output

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word

# Exercise:  write a function that computes the product of all the even entries
# of an array ([arr] * [arr + 2] * ...).

func array_esum(arr : felt*, size) -> (sum):
        if size == 0:
                return (sum=0)
        end

        # size is not zero.
        let (sum_of_rest) = array_esum(arr = arr + 2, size = size - 2)
        return (sum = [arr] + sum_of_rest)

end

func main{output_ptr: felt*}():
        const ARRAY_SIZE = 6
        
        # alloc an array
        let (ptr) = alloc()

        # populate with some values
        # ..
        assert [ptr+0] = 6
        assert [ptr+1] = 5
        assert [ptr+2] = 4
        assert [ptr+3] = 3
        assert [ptr+4] = 2
        assert [ptr+5] = 1

        let (sum) = array_esum(arr = ptr, size=ARRAY_SIZE)
        serialize_word(sum)
        return ()

end


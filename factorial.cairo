
# Use the output builtin.
%builtins output

# Import the serialize_word() function.
from starkware.cairo.common.serialize import serialize_word

# Naive factorial.

func factorial(n) -> (result):
    if n == 1:
        return (n)
    end
    let (a) = factorial(n-1)
    return (n*a)
end


func main{output_ptr: felt*}():
    let (y) = factorial(10)
    serialize_word(y)
    return ()
end


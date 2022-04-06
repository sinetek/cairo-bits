
%builtins output range_check bitwise

from sha256 import sha256, finalize_sha256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.memset import memset
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

# Ex5: Compute SHA-256 hash of the empty input.
#
# Example usage:
#     cairo-compile --output ex5.json ex5-empty-hash.cairo &&
#     cairo-run --program ex5.json --layout all --print_memory --print_info --print_output

func main{output_ptr: felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> ():
    alloc_locals

    let (region1: felt*) = alloc()   # input
    let (region2: felt*) = alloc()   # work area passed to hash function.

    # we don't pass any input information so this is not needed.
    memset(region1, 0, 0)

    #
    #            region1  -----
    #                     -----
    # output  << sha256 <<-----
    #               |
    #               v
    #            region2
    #
    # a word of explanation. the output pointer leads to region2[24],
    # you can read the next 8 cells for the hash value.

    let (hash : felt*) = sha256{sha256_ptr=region2}(region1, 0)
    finalize_sha256(region2, region2)

    # inspect output
    serialize_word([hash+0])
    serialize_word([hash+1])
    serialize_word([hash+2])
    serialize_word([hash+3])
    serialize_word([hash+4])
    serialize_word([hash+5])
    serialize_word([hash+6])
    serialize_word([hash+7])

    # -hash value-
    # e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

    assert hash[0] = 0xe3b0c442
    assert hash[1] = 0x98fc1c14
    assert hash[2] = 0x9afbf4c8
    assert hash[3] = 0x996fb924
    assert hash[4] = 0x27ae41e4
    assert hash[5] = 0x649b934c
    assert hash[6] = 0xa495991b
    assert hash[7] = 0x7852b855

    return ()
end

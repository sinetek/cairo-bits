
%builtins output range_check bitwise

from sha256 import sha256, finalize_sha256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.memset import memset
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

# Ex8: Compute SHA-256 hash of an input vector for 55 bytes.
#
# Example usage:
#     cairo-compile --output ex8.json ex8-hash-55-bytes.cairo &&
#     cairo-run --program ex8.json --layout all --print_memory --print_info --print_output

func main{output_ptr: felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> ():
    alloc_locals

    let (region1: felt*) = alloc()   # input
    let (region2: felt*) = alloc()   # work area passed to hash function.

    # note the padding.
    assert [region1+0] = '0000'
    assert [region1+1] = '1111'
    assert [region1+2] = '2222'
    assert [region1+3] = '3333'
    assert [region1+4] = '4444'
    assert [region1+5] = '5555'
    assert [region1+6] = '6666'
    assert [region1+7] = '7777'
    assert [region1+8] = '8888'
    assert [region1+9] = '9999'
    assert [region1+10] = '1010'
    assert [region1+11] = '1111'
    assert [region1+12] = '1212'
    assert [region1+13] = '131\x00'

    let (hash : felt*) = sha256{sha256_ptr=region2}(region1, 55)
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

    # NIST.1
    assert hash[0] = 0x0f3a61a7
    assert hash[1] = 0x0249c0fa
    assert hash[2] = 0xdec5ac26
    assert hash[3] = 0xb2c03abb
    assert hash[4] = 0x8564ead1
    assert hash[5] = 0x371a7149
    assert hash[6] = 0xf2daf67f
    assert hash[7] = 0x8947d64d

    return ()
end

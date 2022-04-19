
%builtins output range_check bitwise

from sha256 import sha256, finalize_sha256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.memset import memset
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

# Ex7: Compute SHA-256 hash of the input string 'abc'.
#
# Example usage:
#     cairo-compile --output ex7.json ex7-abc-hash.cairo &&
#     cairo-run --program ex7.json --layout all --print_memory --print_info --print_output

func main{output_ptr: felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> ():
    alloc_locals

    let (region1: felt*) = alloc()   # input
    let (region2: felt*) = alloc()   # work area passed to hash function.

    # note the padding.
    assert [region1] = 'abc\x00'

    let (hash : felt*) = sha256{sha256_ptr=region2}(region1, 3)
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
    assert hash[0] = 0xba7816bf
    assert hash[1] = 0x8f01cfea
    assert hash[2] = 0x414140de
    assert hash[3] = 0x5dae2223
    assert hash[4] = 0xb00361a3
    assert hash[5] = 0x96177a9c
    assert hash[6] = 0xb410ff61
    assert hash[7] = 0xf20015ad

    return ()
end


# Use the output builtin.
%builtins output

# Import the serialize_word() function.
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.registers import get_fp_and_pc

struct Location:
    member row : felt
    member col : felt
end

func verify_valid_location(loc : Location*):
    # check that row is in range 0 to 3.
    tempvar row = loc.row
    assert row * (row - 1) * (row - 2) * (row - 3) = 0
    
    # check that col is in range 0 to 3.
    tempvar col = loc.col
    assert col * (col - 1) * (col - 2) * (col - 3) = 0
    
    return ()
end

func verify_adjacent_locations(loc0 : Location*, loc1 : Location*):
    alloc_locals
    local row_diff = loc0.row - loc1.row
    local col_diff = loc0.col - loc1.col
    
    if row_diff == 0:
        # the difference in the column must be either 1 or -1.
        assert col_diff * col_diff = 1
        return ()
    else:
        # the difference in the row must be either 1 or -1.
        assert row_diff * row_diff = 1
        assert col_diff = 0
        return ()
    end
end

func verify_location_list(loc_list : Location*, n_steps):
    # Always verify that the location is valid, even if
    # n_steps = 0 (remember that there is always one more
    # location than steps).
    verify_valid_location(loc=loc_list)

    if n_steps == 0:
    # exercise:  verify that the last location is indeed (3, 3)
    assert (loc_list.col - 2) * (loc_list.row - 2)= 1
        return ()
    end

    verify_adjacent_locations(
        loc0=loc_list, loc1=loc_list + Location.SIZE)

    # Call verify_location_list recursively.
    verify_location_list(
        loc_list=loc_list + Location.SIZE, n_steps=n_steps - 1)
    return ()
end

func main{output_ptr: felt*}():
    alloc_locals

    local loc_tuple : (Location, Location, Location, Location, Location) = (
        Location(row=0, col=2),
        Location(row=1, col=2),
        Location(row=1, col=3),
        Location(row=2, col=3),
        Location(row=3, col=3),
        )

    # Get the value of the frame pointer register (fp) so that
    # we can use the address of loc_tuple.
    let (__fp__, _) = get_fp_and_pc()
    # Since the tuple elements are next to each other we can use the
    # address of loc_tuple as a pointer to the 5 locations.
    verify_location_list(
        loc_list=cast(&loc_tuple, Location*), n_steps=4)

    # ex2:  make sure that the program fails on invalid input. Let's build
    # up some test arrays that contain faulting data.
    local loc_tuple_fail1 : (Location, Location, Location, Location, Location) = (
        Location(row=10, col=2),
        Location(row=1, col=2),
        Location(row=1, col=3),
        Location(row=2, col=3),
        Location(row=3, col=3),
        )
    local loc_tuple_fail2 : (Location, Location, Location, Location, Location) = (
        Location(row=1, col=2),
        Location(row=1, col=2),
        Location(row=1, col=3),
        Location(row=2, col=3),
        Location(row=3, col=3),
        )
    local loc_tuple_fail3 : (Location, Location, Location, Location, Location) = (
        Location(row=1, col=2),
        Location(row=1, col=2),
        Location(row=1, col=3),
        Location(row=2, col=3),
        Location(row=1, col=3),
        )

    verify_location_list(
        loc_list=cast(&loc_tuple_fail1, Location*), n_steps=4)
    verify_location_list(
        loc_list=cast(&loc_tuple_fail2, Location*), n_steps=4)
    verify_location_list(
        loc_list=cast(&loc_tuple_fail3, Location*), n_steps=4)

    return ()
end


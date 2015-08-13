import 'dappsys/test/test.sol';
import 'dappsys/owned.sol';
import 'dappsys/protected_test.sol'; // MockAuthority

contract OwnedContract is DSOwned {
    bool public breached;
    function breach() auth() {
        breached = true;
    }
}
contract OwnedTest is Test {
    OwnedContract o;
    function setUp() {
        o = new OwnedContract();
    }
    function testOwnerCanBreach() {
        o.breach();
        assertTrue(o.breached(), "owner failed to call");
    }
    function testNonOwnerCantBreach() {
        o._ds_change_authority( DSAuthorityInterface(0x0) );
        o.breach();
        //log_address( o._ds_protector() );
        assertFalse(o.breached(), "non-owner breached");
    }
}
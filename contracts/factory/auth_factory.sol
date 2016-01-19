import 'auth/basic_authority.sol';

contract DSAuthFactory {
    function buildDSBasicAuthority() returns (DSBasicAuthority) {
        var c = new DSBasicAuthority();
        c.updateAuthority(msg.sender, false);
        return c;
    }
}

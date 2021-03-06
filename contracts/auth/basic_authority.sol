import 'auth/authority.sol';
import 'auth/auth.sol';

// A `DSAuthority` which contains a whitelist map from can_call arguments to return value.
// Note it is itself a `DSAuth` - ie it is not self-authorized by default.
contract DSBasicAuthority is DSAuthority
                           , DSAuth
{
    mapping(address=>mapping(address=>mapping(bytes4=>bool))) _can_call;

    // See `DSAuthority.sol`
    function canCall( address caller_address
                    , address code_address
                    , bytes4 sig )
             constant
             returns (bool)
    {
        return _can_call[caller_address][code_address][sig];
    }

    event DSSetCanCall( address caller_address
                      , address code_address
                      , bytes4 sig
                      , bool can );
    function setCanCall( address caller_address
                       , address code_address
                       , bytes4 sig
                       , bool can )
             auth()
             returns (bool success)
    {
        _can_call[caller_address][code_address][sig] = can;
        DSSetCanCall( caller_address, code_address, sig, can );
        return true;
    }
}

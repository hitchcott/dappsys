// A base contract for single-contract tokens. All the data is held in
// the storage locally and there are no extra functions (initial issuance
// is done via constructor argument).
// Contracts that plan to ever export data should be using `token/controller.sol`.
import 'token/token.sol';

contract DSTokenBase is DSToken {
    mapping( address => uint ) _balances;
    mapping( address => mapping( address => uint ) ) _approvals;
    uint _supply;
    function DSTokenBase( uint initial_balance ) {
        _balances[msg.sender] = initial_balance;
        _supply = initial_balance;
    }
    function totalSupply() constant returns (uint supply) {
        return _supply;
    }
    function balanceOf( address who ) constant returns (uint value) {
        return _balances[who];
    }
    function transfer( address to, uint value) returns (bool ok) {
        return transferFrom( msg.sender, to, value );
    }
    function transferFrom( address from, address to, uint value) returns (bool ok) {
        // if you don't have enough balance, return false
        if( _balances[from] < value ) {
            return false;
        }
        if( from != msg.sender ) {
            // if you aren't the owner and don't have approval, return false
            if( _approvals[from][msg.sender] < value ) {
                return false;
            } else {
                // if you aren't the owner but do have approval, subtract value
                _approvals[from][msg.sender] -= value;
            }
        }
        // transfer and return true
        _balances[from] -= value;
        _balances[to] += value;
        Transfer( from, to, value );
        return true;
    }
    function approve(address spender, uint value) returns (bool ok) {
        _approvals[msg.sender][spender] = value;
        Approval( msg.sender, spender, value );
        return true;
    }
    function allowance(address owner, address spender) constant returns (uint _allowance) {
        return _approvals[owner][spender];
    }
}

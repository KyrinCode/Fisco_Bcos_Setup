
pragma solidity ^0.4.16;
 
// interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
 
contract TokenERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals = 18;
    uint256 private _totalSupply;
 
    mapping (address => uint256) public _balances;
    // mapping (address => mapping (address => uint256)) public allowances;
 
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed from, uint256 value);
 
 
    constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
        _totalSupply = initialSupply * 10 ** uint256(_decimals);
        _balances[msg.sender] = _totalSupply;
        _name = tokenName;
        _symbol = tokenSymbol;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }
 
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(_balances[_from] >= _value);
        require(_balances[_to] + _value > _balances[_to]);
        uint previous_Balances = _balances[_from] + _balances[_to];
        _balances[_from] -= _value;
        _balances[_to] += _value;
        Transfer(_from, _to, _value);
        assert(_balances[_from] + _balances[_to] == previous_Balances);
    }
 
    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }
 
    // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    //     require(_value <= allowances[_from][msg.sender]);     // Check allowances
    //     allowances[_from][msg.sender] -= _value;
    //     _transfer(_from, _to, _value);
    //     return true;
    // }
 
    // function approve(address _spender, uint256 _value) public
    //     returns (bool success) {
    //     allowances[msg.sender][_spender] = _value;
    //     Approval(msg.sender, _spender, _value);
    //     return true;
    // }
 
    // function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
    //     tokenRecipient spender = tokenRecipient(_spender);
    //     if (approve(_spender, _value)) {
    //         spender.receiveApproval(msg.sender, _value, this, _extraData);
    //         return true;
    //     }
    // }
 
    function burn(uint256 _value) public returns (bool success) {
        require(_balances[msg.sender] >= _value);
        _balances[msg.sender] -= _value;
        _totalSupply -= _value;
        Burn(msg.sender, _value);
        return true;
    }
 
    // function burnFrom(address _from, uint256 _value) public returns (bool success) {
    //     require(_balances[_from] >= _value);
    //     require(_value <= allowances[_from][msg.sender]);
    //     _balances[_from] -= _value;
    //     allowances[_from][msg.sender] -= _value;
    //     totalSupply -= _value;
    //     Burn(_from, _value);
    //     return true;
    // }
}

contract ICTCoin is TokenERC20 {
    constructor() TokenERC20(1000000, "ICT Coin", "ICT") public {
    }
}
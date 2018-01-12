pragma solidity ^0.4.16;

contract MyToken {
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals;
    address public owner;

    uint256 public icoSupply;
    uint256 public teamSupply1;
    uint256 public teamSupply2;
    uint256 public teamSupply3;
    uint256 public bountySupply;
    uint256 public adviserSupply;
    uint256 public reserveSupply1;
    uint256 public reserveSupply2;

    // ico dates in unix timestamp
    uint256 public icoStartDate;
    uint256 public icoEndDate;

    //teamSupply1 date
    uint256 public openTeamSupply1Date;
    uint256 public closeTeamSupply1Date;

    //teamSupply2 date
    uint256 public openTeamSupply2Date;
    uint256 public closeTeamSupply2Date;

    //teamSupply3 date
    uint256 public openTeamSupply3Date;
    uint256 public closeTeamSupply3Date;

    //reserveSupply1 date
    uint256 public openReserveSupply1Date;
    uint256 public closeReserveSupply1Date;

    //reserveSupply2 date
    uint256 public openReserveSupply2Date;
    uint256 public closeReserveSupply2Date;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed burner, uint256 value);

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;

    // Initializes contract with initial supply tokens to the creator of the contract
    function MyToken(
        string tokenName,
        string tokenSymbol,
        uint256 icoStart,
        uint256 icoEnd,
        uint256 openTeamSupply1,
        uint256 closeTeamSupply1,
        uint256 openTeamSupply2,
        uint256 closeTeamSupply2,
        uint256 openTeamSupply3,
        uint256 closeTeamSupply3,
        uint256 openReserveSupply1,
        uint256 closeReserveSupply1,
        uint256 openReserveSupply2,
        uint256 closeReserveSupply2
    ) public{
        name = tokenName;
        symbol = tokenSymbol;
        decimals = 18;
        balanceOf[msg.sender] = 180000000 * 10 ** uint256(decimals); // initial supply of 180 million tokens
        owner = msg.sender;

        // Check ico start and end date
        require(icoStart >= now);
        require(icoEnd >= icoStart);
        // Set ico start and end date
        icoStartDate = icoStart;
        icoEndDate = icoEnd;

        // Check teamSupply1 start and end date
        require(openTeamSupply1 >= now);
        require(closeTeamSupply1 >= openTeamSupply1);
        // Set teamSupply1 start and end date
        openTeamSupply1Date = openTeamSupply1;
        closeTeamSupply1Date = closeTeamSupply1;

        // Check teamSupply2 start and end date
        require(openTeamSupply2 >= now);
        require(closeTeamSupply2 >= openTeamSupply2);
        // Set teamSupply2 start and end date
        openTeamSupply2Date = openTeamSupply2;
        closeTeamSupply2Date = closeTeamSupply2;

        // Check teamSupply3 start and end date
        require(openTeamSupply3 >= now);
        require(closeTeamSupply3 >= openTeamSupply3);
        // Set teamSupply3 start and end date
        openTeamSupply3Date = openTeamSupply3;
        closeTeamSupply3Date = closeTeamSupply3;

        // Check reserveSupply1 start and end date
        require(openReserveSupply1 >= now);
        require(closeReserveSupply1 >= openReserveSupply1);
        // Set reserveSupply1 start and end date
        openReserveSupply1Date = openReserveSupply1;
        closeReserveSupply1Date = closeReserveSupply1;

        // Check reserveSupply2 start and end date
        require(openReserveSupply2 >= now);
        require(closeReserveSupply2 >= openReserveSupply2);
        // Set reserveSupply2 start and end date
        openReserveSupply2Date = openReserveSupply2;
        closeReserveSupply2Date = closeReserveSupply2;

        // Set token supplies
        icoSupply = 120000000 * 10 ** uint256(decimals); // 120 million tokens for the ico
        teamSupply1 = 6000000 * 10 ** uint256(decimals); // 6 million tokens for the team
        teamSupply2 = 6000000 * 10 ** uint256(decimals); // 6 million tokens for the team
        teamSupply3 = 6000000 * 10 ** uint256(decimals); // 6 million tokens for the team
        bountySupply = 5400000 * 10 ** uint256(decimals); // 5,4 million tokens for bounties
        adviserSupply = 21600000 * 10 ** uint256(decimals); // 21,6 million tokens for advisers
        reserveSupply1 = 7500000 * 10 ** uint256(decimals); // 7,5 million tokens for reserve
        reserveSupply2 = 7500000 * 10 ** uint256(decimals); // 7,5 million tokens for reserve
    }

    function transfer(address _to, uint256 _value) public{
        // Owner of the contract can't use this method
        require(msg.sender != owner);

        // Check if sender has balance and for overflows
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        // Add and subtract new balances
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);
    }

    function transferIco(address _to, uint256 _value) public{
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // Check the ico start and end date
        require(now >= icoStartDate);
        require(now <= icoEndDate);

        // Limit the ico amount
        require(icoSupply - _value >= 0);

        // Check if sender has balance and for overflows
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        // Add and subtract new balances
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);

        // Update icoSupply
        icoSupply -= _value;
    }

    function burnIcoSupply() public returns (bool success){
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // Check that the ico has ended
        require(now > icoEndDate);

        // burn tokens
        Burn(msg.sender, icoSupply);

        // set supply to zero
        icoSupply = 0;

        return true;
    }

    function transferAdviser(address _to, uint256 _value) public{
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // Check the ico start and end date
        // Adviser supply uses the same dates as the ico
        require(now >= icoStartDate);
        require(now <= icoEndDate);

        // Limit the amount
        require(adviserSupply - _value >= 0);

        // Check if sender has balance and for overflows
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        // Add and subtract new balances
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);

        // Update icoSupply
        adviserSupply -= _value;
    }

    function burnAdviserSupply() public returns (bool success){
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // Check the date, adviserSupply can be burned after ico
        require(now > icoEndDate);

        // burn tokens
        Burn(msg.sender, adviserSupply);

        // set supply to zero
        adviserSupply = 0;

        return true;
    }

    function transferTeamSupply1(address _to, uint256 _value) public{
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // check the start and end date
        require(now >= openTeamSupply1Date);
        require(now <= closeTeamSupply1Date);

        // Limit the amount
        require(teamSupply1 - _value >= 0);

        // Check if sender has balance and for overflows
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        // Add and subtract new balances
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);

        // update supply
        teamSupply1 -= _value;
    }

    function burnTeamSupply1() public returns (bool success){
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // Check the date
        require(now > closeTeamSupply1Date);

        // burn tokens
        Burn(msg.sender, teamSupply1);

        // set supply to zero
        teamSupply1 = 0;

        return true;
    }

    function transferTeamSupply2(address _to, uint256 _value) public{
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // check the start and end date
        require(now >= openTeamSupply2Date);
        require(now <= closeTeamSupply2Date);

        // Limit the amount
        require(teamSupply2 - _value >= 0);

        // Check if sender has balance and for overflows
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        // Add and subtract new balances
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);

        // update supply
        teamSupply2 -= _value;
    }

    function burnTeamSupply2() public returns (bool success){
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // Check the date
        require(now > closeTeamSupply2Date);

        // burn tokens
        Burn(msg.sender, teamSupply2);

        // set supply to zero
        teamSupply2 = 0;

        return true;
    }

    function transferTeamSupply3(address _to, uint256 _value) public{
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // check the start and end date
        require(now >= openTeamSupply3Date);
        require(now <= closeTeamSupply3Date);

        // Limit the amount
        require(teamSupply3 - _value >= 0);

        // Check if sender has balance and for overflows
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        // Add and subtract new balances
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);

        // update supply
        teamSupply3 -= _value;
    }

    function burnTeamSupply3() public returns (bool success){
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // Check the date
        require(now > closeTeamSupply3Date);

        // burn tokens
        Burn(msg.sender, teamSupply3);

        // set supply to zero
        teamSupply3 = 0;

        return true;
    }

    function transferReserveSupply1(address _to, uint256 _value) public{
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // check the start and end date
        require(now >= openReserveSupply1Date);
        require(now <= closeReserveSupply1Date);

        // Limit the amount
        require(reserveSupply1 - _value >= 0);

        // Check if sender has balance and for overflows
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        // Add and subtract new balances
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);

        // update supply
        reserveSupply1 -= _value;
    }

    function burnReserveSupply1() public returns (bool success){
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // Check the date
        require(now > closeReserveSupply1Date);

        // burn tokens
        Burn(msg.sender, reserveSupply1);

        // set supply to zero
        reserveSupply1 = 0;

        return true;
    }

    function transferReserveSupply2(address _to, uint256 _value) public{
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // check the start and end date
        require(now >= openReserveSupply2Date);
        require(now <= closeReserveSupply2Date);

        // Limit the amount
        require(reserveSupply2 - _value >= 0);

        // Check if sender has balance and for overflows
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        // Add and subtract new balances
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);

        // update supply
        reserveSupply2 -= _value;
    }

    function burnReserveSupply2() public returns (bool success){
        // Only the owner of contract can use this method
        require(msg.sender == owner);

        // Check the date
        require(now > closeReserveSupply2Date);

        // burn tokens
        Burn(msg.sender, reserveSupply2);

        // set supply to zero
        reserveSupply2 = 0;

        return true;
    }
}
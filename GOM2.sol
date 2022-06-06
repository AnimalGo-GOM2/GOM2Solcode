// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract GoMoney2 is ERC20Snapshot, AccessControl {
    
    bytes32 public constant FREEZE_ROLE = keccak256("FREEZE_ROLE");
    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");

    constructor() payable ERC20('GoMoney2', 'GOM2') {
        _mint(msg.sender, 1000000000 * uint(10) ** decimals());
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(FREEZE_ROLE, msg.sender);
        _setupRole(SNAPSHOT_ROLE, msg.sender);
    }

    mapping (address => bool) public frozen;

    event Freeze(address holder);
    event Unfreeze(address holder);

    modifier notFrozen(address holder) {
        require(!frozen[holder]);
        _;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function transfer(
        address to,
        uint256 value
    ) notFrozen(msg.sender) public override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from, 
        address to, 
        uint256 amount
    ) notFrozen(from) public override returns (bool) {
        require(allowance(from, to) >= amount);
        _transfer(from, to, amount);
        return true;
    }

    function burn(uint256 amount) notFrozen(msg.sender) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _burn(msg.sender, amount);
    }

    function freezeAccount(address _holder) public onlyRole(FREEZE_ROLE) returns (bool) {
        require(!frozen[_holder]);
        frozen[_holder] = true;
        emit Freeze(_holder);
        return true;
    }

    function unfreezeAccount(address _holder) public onlyRole(FREEZE_ROLE) returns (bool) {
        require(frozen[_holder]);
        frozen[_holder] = false;
        emit Unfreeze(_holder);
        return true;
    }

    function snapshot() public onlyRole(SNAPSHOT_ROLE) returns (uint256) {
        uint256 snapshotId = _snapshot();
        emit Snapshot(snapshotId);
        return snapshotId;
    }
}

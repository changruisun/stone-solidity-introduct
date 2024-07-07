// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract Owner {
    
    struct Identity {
        address addr;
        string name;
    }

    enum State { 
        HasOwner,
        NoOwner
    }

    // ? 事件定义有啥用, 这个地方不明白， indexed又是什么？
    event OwnerSet(address indexed olderOwner, address indexed newOwner);
    event OwnerRemove(address indexed olderOwner);

    // 函数修饰器
    // msg.sender 怎么来的？
    modifier isOwner() {
        require(msg.sender == owner.addr, "Caller is not owner");
        _;
    }

    // 状态变量
    Identity private owner;
    State private state;

    // 构造函数
    // memory 是什么意思
    constructor(string memory name) {
        owner.name = name;
        owner.addr = msg.sender;
        state = State.HasOwner;
        emit OwnerSet(address(0), owner.addr);
    }

    //这个地方有疑惑，owner.addr 到底是参数addr， 还是send的addr
    function changeOwner(address addr, string calldata name) public isOwner {
        owner.addr = msg.sender;
        owner.name = name;
        emit OwnerSet(owner.addr, addr);
    }

    //delete owner 这个属于什么操作，清理内存吗？还是重置内存变量
    function removeOwner() public isOwner {        
        emit OwnerRemove(owner.addr);
        delete owner;
        state = State.NoOwner;
    }

    // external view 是什么意思呢
    function getOwner() external view  returns (address, string memory) {
        return (owner.addr, owner.name);
    }

    function getState() external view  returns (State) {
        return state;
    }

}
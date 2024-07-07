// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract ContractLearn {
    uint constant ratio = 3;
    uint a = 10;
    // constant 必须明确定义，定义的时候就得赋值，不能更改，不能赋值为变量，
    // ratio = a;

    // immutable 相对于constant多了一个宽松，构造函数中可以初始化一次
    uint immutable n = 5;

    constructor() {
        n = 5;
    }
    // immutable 普通函数，不能初始化
    // function f() public {
    //     n = 5;
    // }

   

    address private owner;

     // 将权限检查抽取出来成为一个修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // 添加 onlyOwner 修饰器来对调用者进行限制
    // 只有 owner 才有权限调用这个函数
    function mint() external onlyOwner { 
        // Function code goes here
    }

    // 添加 onlyOwner 修饰器来对调用者进行限制
    // 只有 owner 才有权限调用这个函数
    function changeOwner() external onlyOwner {
        // Function code goes here
    }

    /**
    * 在程序设计中，若一个函数符合以下要求，则它可能被认为是纯函数：
    * 相同的输入值时，需产生相同的输出
    * 函数的输出和输入值以外的其他隐藏信息或状态无关，也和由I/O设备产生的外部输出无关
    * 不能有语义上可观察的函数副作用，诸如“触发事件”，使输出设备输出，或更改输出值以外的内容等
    * 简单而言就是：纯函数不读不写，没有副作用
    */

     // pure 既不能查询，也不能修改函数状态。只能使用函数参数进行简单计算并返回结果
    function add(uint lhs, uint rhs) public pure returns(uint) {
        return lhs + rhs;
    }

    /** 
    * 怎样才算查询合约状态， view
    * 读取状态变量
    * 访问 address(this).balance 或者 <address>.balance
    * 访问 block , tx , msg 的成员
    * 调用未标记为 pure 的任何函数
    * 使用包含某些操作码的内联汇编
    */
    uint count;
    function GetCount() public view returns(uint) {
        return count;
    }

    /** 
    * 怎样才算修改合约状态， payable
    * 修改状态变量
    * 触发事件
    * 创建其他合约
    * 使用 selfdestruct 来销毁合约
    * 通过函数调用发送以太币
    * 调用未标记为 view 或 pure 的任何函数
    * 使用低级别调用，如 transfer, send, call, delegatecall 等
    * 使用包含某些操作码的内联汇编
    */
    function deposit() external payable {
        // deposit to current contract
    }

}

contract Callee {}

contract Caller {
    address payable callee;

    // 注意： 记得在部署的时候给 Caller 合约转账一些 Wei，比如 100
    constructor() payable{
        callee = payable(address(new Callee()));
    }

    // 失败，因为Callee既没有定义receive函数，也没有定义fallback函数
    function tryTransfer() external {
        callee.transfer(1);
    }

    // 失败，因为Callee既没有定义receive函数，也没有定义fallback函数
    function trySend() external {
        bool success = callee.send(1);
        require(success, "Failed to send Ether");
    }

    // 失败，因为Callee既没有定义receive函数，也没有定义fallback函数
    function tryCall() external {
        (bool success, bytes memory data) = callee.call{value: 1}("");
        require(success, "Failed to send Ether");
    }

}
    // 定义 receive 函数的时候要注意 Gas 不足的问题
    // 用send,transfer函数转账到该合约都会被 revert
    // 原因是消耗的 Gas 超过了 2300
    contract Example {
        uint a;
        // receive 函数的定义格式是固定的，其可见性（visibility）必须为 external，状态可变性（state mutability）必须为 payable
        receive() external payable {
            a += 1;
        }
    }
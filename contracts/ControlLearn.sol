
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;
contract Crontrol {

    function splitEther(address payable addr1, address payable addr2) public   payable {
        require(msg.value % 2 == 0, "Even value required."); // 检查传入的ether是不是偶数
        if (msg.value % 2 == 0) { // 检查传入的ether是不是偶数
            revert("Even value revertd.");
        } 
        uint balanceBeforeTransfer = address(this).balance;
        addr1.transfer(msg.value / 2);
        addr2.transfer(msg.value / 2);
        assert(address(this).balance == balanceBeforeTransfer);
    }

}
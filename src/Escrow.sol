// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Escrow {

    //definations
    
    // escrow = {sender, receiver, amount, status}
    struct escrow {
        address sender;
        address receiver;
        uint256 amount;
        int status;
        uint256 id;
        // address arbitrator;
    }
    
    // sender address => [list of assotiated escrows]
    escrow[] public escrows;

    //Functions
    // Create Escrow
    function createEscrow(address receiver) public payable{
        require(msg.value > 50000, "Value less than 50000 wei");
        escrows.push(escrow(msg.sender, receiver, msg.value, 0, escrows.length));
    }
    
    // Release Escrow
    function releaseEscrow(address receiver, uint256 index) public {

        escrow storage e = escrows[index];
        require(e.receiver == receiver, "Wrong receiver");
        require(e.sender == msg.sender, "Wrong Sender");
        require(e.status == 0, "Escrow Already released");
        (bool callSuccess, ) = payable(receiver).call{value: e.amount}("");
        require(callSuccess, "Payment Failed");
        e.status = 1; //escrow released
    }

    function refundEscrow(address sender, uint256 index)public {
        escrow storage e = escrows[index];
        require(e.sender == sender, "Wrong receiver");
        require(e.receiver == msg.sender, "Wrong Sender");
        require(e.status == 0, "Escrow Already released");
        (bool callSuccess, ) = payable(sender).call{value: e.amount}("");
        require(callSuccess, "Payment Failed");
        e.status = -1; //refunded
    }

    // Show all Escrows related to the sender's address
    function showAll() public view returns(escrow[] memory, escrow[] memory){
        uint256 rcount=0;
        uint256 scount=0;

        for(uint256 i=0;i<escrows.length;i++){
            escrow storage e = escrows[i];
            if(e.receiver==msg.sender){
                rcount++;
            }else if(e.sender==msg.sender){
                scount++;
            }
        }

        escrow[] memory rEscrows = new escrow[](rcount);
        escrow[] memory sEscrows = new escrow[](scount);
        uint256 rIdx=0;
        uint256 sIdx=0;
        for(uint256 i=0;i<escrows.length;i++){
            if(escrows[i].receiver==msg.sender){
                rEscrows[rIdx++] = escrows[i];
            }else if(escrows[i].sender==msg.sender){
                sEscrows[sIdx++] = escrows[i];
            }
        }
        return (sEscrows, rEscrows);
    }
}

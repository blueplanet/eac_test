contract SchedulerInterface {
    //
    // params:
    // - uintArgs[0] callGas
    // - uintArgs[1] callValue
    // - uintArgs[2] windowStart
    // - uint8 windowSize
    // - bytes callData
    // - address toAddress
    //
    function scheduleTransaction(address toAddress,
                                 bytes callData,
                                 uint8 windowSize,
                                 uint[3] uintArgs) public returns (address);
}

contract DelayedPayment {
    SchedulerInterface constant scheduler = SchedulerInterface(0xf91902fcd3eaac65f589f6d40dab0ed90168826e);

    uint lockedUntil;
    address recipient;

    function DelayedPayment(address _recipient, uint numBlocks) {
        // set the time that the funds are locked up
        lockedUntil = block.number + numBlocks;
        recipient = _recipient;

        uint[3] memory uintArgs = [
            200000,      // the amount of gas that will be sent with the txn.
            0,           // the amount of ether (in wei) that will be sent with the txn
            lockedUntil  // the first block number on which the transaction can be executed.
        ];
        scheduler.scheduleTransaction.value(2 ether)(
            address(this),  // The address that the transaction will be sent to.
            "",             // The call data that will be sent with the transaction.
            255,            // The number of blocks this will be executable.
            uintArgs       // The tree args defined above
        );
    }

    function() {
        if (this.balance > 0) {
            payout();
        }
    }

    function payout() public returns (bool) {
        if (now < lockedUntil) return false;

        return recipient.call.value(this.balance)();
    }
}

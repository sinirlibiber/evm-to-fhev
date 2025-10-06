# EVM to FHEvm Contract Converter

A powerful tool to convert EVM (Ethereum Virtual Machine) smart contracts to FHEvm (Fully Homomorphic Encryption) contracts, enabling privacy-preserving blockchain applications.

## 🎯 Features

### ✅ **Complete FHEvm Support**
- **Arithmetic Operations**: `FHE.add()`, `FHE.sub()`, `FHE.mul()`, `FHE.div()`, `FHE.rem()`
- **Bitwise Operations**: `FHE.and()`, `FHE.or()`, `FHE.xor()`, `FHE.not()`, `FHE.shl()`, `FHE.shr()`
- **Comparison Operations**: `FHE.lt()`, `FHE.gt()`, `FHE.le()`, `FHE.ge()`, `FHE.eq()`, `FHE.ne()`
- **Ternary Operations**: `FHE.select()` for conditional logic
- **Random Generation**: `FHE.randEbool()`, `FHE.randEuint32()`, etc.

### 🔐 **Access Control List (ACL)**
- **Method Chaining**: `ciphertext.allowThis().allow(address)`
- **Permanent Access**: `FHE.allow(ciphertext, address)`
- **Transient Access**: `FHE.allowTransient(ciphertext, address)`
- **Public Access**: `FHE.makePubliclyDecryptable(ciphertext)`
- **Sender Verification**: `FHE.isSenderAllowed()` for security

### 🔀 **Conditional Branching**
- **FHE.select()**: Ternary operator for encrypted conditions
- **If/Else Conversion**: Automatic conversion of if/else to FHE.select
- **Async Decryption**: Public branching with `FHE.requestDecryption()`
- **Conditional Updates**: Safe conditional assignments with encrypted values
- **Loop Conversion**: Automatic conversion of while/for loops to finite loops
- **Array Operations**: Safe array access and assignment with encrypted indexes
- **Obfuscated Branching**: Privacy-preserving branching patterns for AMM-like scenarios

### 🚨 **Error Handling**
- **Error Logging**: Encrypted error codes with timestamps for each user
- **Conditional Error Setting**: Set errors based on encrypted conditions using `FHE.select()`
- **Safe Transfers**: Transfer operations with automatic error logging
- **Error Queries**: Frontend can query error states for user feedback
- **Event Notifications**: `ErrorChanged` events for real-time error tracking

### 🔓 **Asynchronous Decryption**
- **Decryption Requests**: `FHE.requestDecryption()` for async decryption
- **Callback Handling**: Custom callback functions for decryption results
- **Signature Verification**: `FHE.checkSignatures()` for security validation
- **Replay Protection**: Request ID tracking to prevent replay attacks
- **Pending State Management**: Track decryption request status

### 🗳️ **Voting Contract Transformation**
- **Privacy-Preserving Voting**: Encrypted vote counts and individual votes
- **Voting Status Management**: Open, DecryptionInProgress, ResultsDecrypted states
- **Voter Management**: Add/remove voters with encrypted counters
- **Vote Casting**: Encrypted vote submission with input validation
- **Result Decryption**: Asynchronous vote result revelation

### 🎲 **Encrypted Inputs**
- **External Types**: `externalEuint64`, `externalEbool`, `externalEaddress`
- **Input Validation**: ZKPoK verification with `FHE.asEuint64(input, proof)`
- **Single Proof**: Efficient input packing for multiple parameters
- **Type Casting**: Proper conversion between encrypted types

### 🔧 **Advanced Features**
- **Type Mapping**: `uint64` → `euint64`, `address` → `eaddress`, `bool` → `ebool`
- **Initialization Checks**: `FHE.isInitialized()` for encrypted variables
- **Type Casting**: `FHE.asEaddress()`, `FHE.asEuint64()` for conversions
- **Inheritance**: `SepoliaConfig`, `ReentrancyGuard` support
- **Reorg Protection**: Two-step ACL authorization with timelock to prevent reorg attacks

## 🚀 Quick Start

### Installation
```bash
npm install
```

### Development
```bash
npm run dev
```

Visit `http://localhost:5173` to use the tool.

## 📚 Examples

### 1. **Counter Example** - Basic Operations
```solidity
// Input: Simple counter with increment/decrement
contract Counter {
  uint32 private _count;
  
  function increment(uint32 value) external {
    _count += value;
  }
}

// Output: FHEvm counter with encrypted operations
contract CounterFHE is SepoliaConfig, ReentrancyGuard {
  using FHE for *;
  
  euint32 private _count;
  
  function increment(externalEuint32 value, bytes calldata inputProof) external {
    euint32 encryptedValue = FHE.asEuint32(value, inputProof);
    _count = FHE.add(_count, encryptedValue);
    _count.allowThis().allow(msg.sender);
  }
}
```

### 2. **Auction Example** - Complex Logic
```solidity
// Input: Blind auction with mappings
contract SimpleAuction {
  mapping(address => uint64) private bids;
  
  function bid(uint64 amount) external {
    if (bids[msg.sender] != 0) {
      bids[msg.sender] += amount;
    } else {
      bids[msg.sender] = amount;
    }
  }
}

// Output: FHEvm auction with encrypted bids
contract SimpleAuctionFHE is SepoliaConfig, ReentrancyGuard {
  using FHE for *;
  
  mapping(address => euint64) private bids;
  
  function bid(externalEuint64 amount, bytes calldata inputProof) external {
    euint64 encryptedAmount = FHE.asEuint64(amount, inputProof);
    
    ebool hasBid = FHE.isInitialized(bids[msg.sender]);
    bids[msg.sender] = FHE.select(hasBid, 
      FHE.add(bids[msg.sender], encryptedAmount), 
      encryptedAmount);
    
    bids[msg.sender].allowThis().allow(msg.sender);
  }
}
```

### 3. **Confidential ERC20** - Secure Transfer
```solidity
// Input: Standard ERC20 transfer
function transfer(address to, uint64 amount) external {
  require(balances[msg.sender] >= amount, "Insufficient balance");
  balances[msg.sender] -= amount;
  balances[to] += amount;
}

// Output: FHEvm secure transfer with ACL
function transfer(address to, externalEuint64 amount, bytes calldata inputProof) external {
  euint64 encryptedAmount = FHE.asEuint64(amount, inputProof);
  require(FHE.isSenderAllowed(encryptedAmount), "Unauthorized access");
  
  ebool canTransfer = FHE.le(encryptedAmount, balances[msg.sender]);
  euint64 actualTransfer = FHE.select(canTransfer, encryptedAmount, FHE.asEuint64(0));
  
  balances[to] = FHE.add(balances[to], actualTransfer);
  balances[to].allowThis().allow(to);
  
  balances[msg.sender] = FHE.sub(balances[msg.sender], actualTransfer);
  balances[msg.sender].allowThis().allow(msg.sender);
}
```

### 4. **Reorg Protection Example** - Secure ACL Authorization
```solidity
// Input: Private key sale with immediate ACL grant
contract PrivateKeySale {
  euint256 private privateKey;
  
  function buyPrivateKey() external payable {
    require(msg.value == 1 ether, "Must pay 1 ETH");
    privateKey.allow(msg.sender); // ❌ Immediate ACL - vulnerable to reorg
  }
}

// Output: FHEvm with two-step ACL and reorg protection
contract PrivateKeySaleFHE is SepoliaConfig, ReentrancyGuard {
  using FHE for *;
  
  euint256 private privateKey;
  uint256 private reorgBlockDelay = 95;
  mapping(address => uint256) private pendingACLRequests;
  mapping(address => bool) private aclGranted;
  
  function buyPrivateKey() external payable {
    require(msg.value == 1 ether, "Must pay 1 ETH");
    // ✅ Store purchase info, delay ACL grant
    pendingACLRequests[msg.sender] = block.number;
  }
  
  function grantACL() external {
    require(pendingACLRequests[msg.sender] > 0, "No pending request");
    require(block.number > pendingACLRequests[msg.sender] + reorgBlockDelay, 
            "Too early - risk of reorg");
    // ✅ Safe ACL grant after delay
    aclGranted[msg.sender] = true;
    privateKey.allow(msg.sender);
  }
}
```

### 5. **Branching Example** - Conditional Logic with Encrypted Values
```solidity
// Input: Auction with conditional logic
contract AuctionWithBranching {
  function bid(uint64 value) external {
    if (value > highestBid) {
      highestBid = value;
      highestBidder = msg.sender;
    }
  }
  
  function complexLogic(uint64 val1, uint64 val2) external {
    uint64 result = val1 > val2 ? val1 : val2;
    
    if (val1 % 2 == 0) {
      result = result * 2;
    } else {
      result = result + 1;
    }
  }
}

// Output: FHEvm with encrypted branching
contract AuctionWithBranchingFHE is SepoliaConfig, ReentrancyGuard {
  using FHE for *;
  
  euint64 private highestBid;
  eaddress private highestBidder;
  
  function bid(externalEuint64 value, bytes calldata inputProof) external {
    euint64 bid = FHE.asEuint64(value, inputProof);
    
    // Convert if/else to FHE.select
    ebool isAbove = FHE.lt(highestBid, bid);
    highestBid = FHE.select(isAbove, bid, highestBid);
    highestBidder = FHE.select(isAbove, FHE.asEaddress(msg.sender), highestBidder);
    
    highestBid.allowThis();
    highestBidder.allowThis();
  }
  
  function complexLogic(externalEuint64 val1, externalEuint64 val2, bytes calldata inputProof) external {
    euint64 encryptedVal1 = FHE.asEuint64(val1, inputProof);
    euint64 encryptedVal2 = FHE.asEuint64(val2, inputProof);
    
    // Convert ternary to FHE.select
    ebool isGreater = FHE.gt(encryptedVal1, encryptedVal2);
    euint64 result = FHE.select(isGreater, encryptedVal1, encryptedVal2);
    
    // Convert if/else to FHE.select
    ebool isEven = FHE.eq(FHE.rem(encryptedVal1, FHE.asEuint64(2)), FHE.asEuint64(0));
    result = FHE.select(isEven, FHE.mul(result, FHE.asEuint64(2)), FHE.add(result, FHE.asEuint64(1)));
    
    highestBid = result;
    highestBid.allowThis();
  }
}
```

### 6. **Loop and Array Example** - Complex Operations with Encrypted Values
```solidity
// Input: Contract with loops and array operations
contract LoopAndArrayExample {
  uint64[] private dataArray;
  uint64 private currentValue;
  
  function problematicLoop(uint64 maxVal) external {
    uint64 x = 0;
    while(x < maxVal) {
      x += 2;
    }
    currentValue = x;
  }
  
  function arrayAccess(uint64 index) external {
    uint64 value = dataArray[index];
    currentValue = value;
  }
  
  function complexLogic(uint64[] memory values, uint64 target) external {
    uint64 sum = 0;
    for (uint32 i = 0; i < values.length; i++) {
      if (sum < target) {
        sum += values[i];
      }
    }
    currentValue = sum;
  }
}

// Output: FHEvm with converted loops and array operations
contract LoopAndArrayExampleFHE is SepoliaConfig, ReentrancyGuard {
  using FHE for *;
  
  euint64[] private dataArray;
  euint64 private currentValue;
  
  // Loop and array constants
  uint32 private constant MAX_ITERATIONS = 100;
  uint32 private constant MAX_ARRAY_SIZE = 50;
  
  function finiteLoop(externalEuint64 maxVal, externalEuint64 step, bytes calldata inputProof) external {
    euint64 encryptedMaxVal = FHE.asEuint64(maxVal, inputProof);
    euint64 encryptedStep = FHE.asEuint64(step, inputProof);
    
    euint64 x = FHE.asEuint64(0);
    for (uint32 i = 0; i < MAX_ITERATIONS; i++) {
      ebool shouldContinue = FHE.lt(x, encryptedMaxVal);
      euint64 toAdd = FHE.select(shouldContinue, encryptedStep, FHE.asEuint64(0));
      x = FHE.add(x, toAdd);
    }
    currentValue = x;
    currentValue.allowThis();
  }
  
  function safeArrayAccess(externalEuint64 index, bytes calldata inputProof) external {
    euint64 encryptedIndex = FHE.asEuint64(index, inputProof);
    
    euint64 result = FHE.asEuint64(0);
    for (uint32 i = 0; i < dataArray.length && i < MAX_ARRAY_SIZE; i++) {
      ebool isEqual = FHE.eq(encryptedIndex, FHE.asEuint64(i));
      result = FHE.select(isEqual, dataArray[i], result);
    }
    currentValue = result;
    currentValue.allowThis();
  }
  
  function complexLogic(externalEuint64[] memory values, externalEuint64 target, bytes calldata inputProof) external {
    euint64 encryptedTarget = FHE.asEuint64(target, inputProof);
    euint64 sum = FHE.asEuint64(0);
    
    for (uint32 i = 0; i < values.length && i < MAX_ARRAY_SIZE; i++) {
      ebool shouldAdd = FHE.lt(sum, encryptedTarget);
      euint64 toAdd = FHE.select(shouldAdd, FHE.asEuint64(values[i], inputProof), FHE.asEuint64(0));
      sum = FHE.add(sum, toAdd);
    }
    
    currentValue = sum;
    currentValue.allowThis();
  }
}
```

### 7. **Error Handling Example** - User Feedback with Encrypted Data
```solidity
// Input: Contract with traditional error handling
contract ErrorHandlingExample {
  uint64 private balance;
  
  function withdraw(uint64 amount) external {
    require(balance >= amount, "Insufficient balance");
    balance -= amount;
  }
  
  function transfer(address to, uint64 amount) external {
    require(balance >= amount, "Insufficient balance");
    balance -= amount;
    // Transfer logic here
  }
}

// Output: FHEvm with encrypted error handling
contract ErrorHandlingExampleFHE is SepoliaConfig, ReentrancyGuard {
  using FHE for *;
  
  euint64 private balance;
  
  // Error handling variables
  euint8 private NO_ERROR;
  euint8 private NOT_ENOUGH_FUNDS;
  euint8 private INVALID_INPUT;
  euint8 private ACCESS_DENIED;
  euint8 private OPERATION_FAILED;
  mapping(address => LastError) private _lastErrors;
  
  event ErrorChanged(address indexed user);
  
  struct LastError {
    euint8 error;      // Encrypted error code
    uint timestamp;    // Timestamp of the error
  }
  
  constructor() {
    // Initialize error codes
    NO_ERROR = FHE.asEuint8(0);
    NOT_ENOUGH_FUNDS = FHE.asEuint8(1);
    INVALID_INPUT = FHE.asEuint8(2);
    ACCESS_DENIED = FHE.asEuint8(3);
    OPERATION_FAILED = FHE.asEuint8(4);
    
    // Allow contract to use error codes
    NO_ERROR.allowThis();
    NOT_ENOUGH_FUNDS.allowThis();
    INVALID_INPUT.allowThis();
    ACCESS_DENIED.allowThis();
    OPERATION_FAILED.allowThis();
  }
  
  function withdraw(externalEuint64 amount, bytes calldata inputProof) external {
    euint64 encryptedAmount = FHE.asEuint64(amount, inputProof);
    
    // Check if user has enough balance
    ebool canWithdraw = FHE.le(encryptedAmount, balance);
    
    // Log the error state
    setLastError(FHE.select(canWithdraw, NO_ERROR, NOT_ENOUGH_FUNDS), msg.sender);
    
    // Perform withdrawal conditionally
    euint64 actualWithdrawal = FHE.select(canWithdraw, encryptedAmount, FHE.asEuint64(0));
    balance = FHE.sub(balance, actualWithdrawal);
    balance.allowThis();
  }
  
  function safeTransfer(euint64 amount, address to) external returns (bool success) {
    ebool canTransfer = FHE.le(amount, balance);
    
    // Log the error state
    setLastError(FHE.select(canTransfer, NO_ERROR, NOT_ENOUGH_FUNDS), msg.sender);
    
    // Perform transfer conditionally
    euint64 actualTransfer = FHE.select(canTransfer, amount, FHE.asEuint64(0));
    balance = FHE.sub(balance, actualTransfer);
    balance.allowThis();
    
    return true;
  }
  
  function getLastError(address user) public view returns (euint8 error, uint timestamp) {
    LastError memory lastError = _lastErrors[user];
    return (lastError.error, lastError.timestamp);
  }
  
  function setLastError(euint8 error, address addr) private {
    _lastErrors[addr] = LastError(error, block.timestamp);
    emit ErrorChanged(addr);
  }
}
```

### 8. **Decryption Example** - Asynchronous Decryption with Callbacks
```solidity
// Input: Contract with encrypted values that need decryption
contract DecryptionExample {
  euint64 private encryptedValue;
  bool private isDecryptionPending;
  
  function setValue(uint64 value) external {
    encryptedValue = FHE.asEuint64(value);
  }
  
  function requestDecryption() external {
    // Request decryption of encrypted value
    bytes32[] memory cts = new bytes32[](1);
    cts[0] = FHE.toBytes32(encryptedValue);
    uint256 requestId = FHE.requestDecryption(cts, this.decryptionCallback.selector);
    isDecryptionPending = true;
  }
  
  function decryptionCallback(uint256 requestId, uint64 decryptedValue, bytes[] memory signatures) external {
    FHE.checkSignatures(requestId, signatures);
    // Handle decrypted value
    isDecryptionPending = false;
  }
}

// Output: FHEvm with comprehensive decryption handling
contract DecryptionExampleFHE is SepoliaConfig, ReentrancyGuard {
  using FHE for *;
  
  euint64 private encryptedValue;
  uint64 private decryptedValue;
  
  // Decryption variables
  bool private isDecryptionPending = false;
  uint256 private latestRequestId;
  mapping(uint256 => bool) private processedRequests;
  
  event DecryptionCompleted(uint256 requestId, uint64 value);
  
  function setValue(externalEuint64 value, bytes calldata inputProof) external {
    encryptedValue = FHE.asEuint64(value, inputProof);
    encryptedValue.allowThis();
  }
  
  function requestDecryptionForValue() public returns (uint256) {
    require(!isDecryptionPending, "Decryption is in progress");
    
    bytes32[] memory cts = new bytes32[](1);
    cts[0] = FHE.toBytes32(encryptedValue);
    
    latestRequestId = FHE.requestDecryption(cts, this.decryptionCallback.selector);
    isDecryptionPending = true;
    
    return latestRequestId;
  }
  
  function decryptionCallback(uint256 requestId, uint64 decryptedResult, bytes[] memory signatures) external {
    require(requestId == latestRequestId, "Invalid requestId");
    require(!processedRequests[requestId], "Request already processed");
    
    FHE.checkSignatures(requestId, signatures);
    processedRequests[requestId] = true;
    isDecryptionPending = false;
    
    decryptedValue = decryptedResult;
    emit DecryptionCompleted(requestId, decryptedResult);
  }
  
  function getDecryptedValue() public view returns (uint64) {
    return decryptedValue;
  }
  
  function isDecryptionInProgress() public view returns (bool) {
    return isDecryptionPending;
  }
  
  function getLatestRequestId() public view returns (uint256) {
    return latestRequestId;
  }
}
```

### 9. **Voting Contract Transformation** - Privacy-Preserving Voting System
```solidity
// Input: Standard Solidity voting contract
contract SimpleVoting {
    mapping(address => bool) public hasVoted;
    uint64 public yesVotes;
    uint64 public noVotes;
    uint256 public voteDeadline;

    function vote(bool support) public {
        require(block.timestamp <= voteDeadline, "Too late to vote");
        require(!hasVoted[msg.sender], "Already voted");
        hasVoted[msg.sender] = true;

        if (support) {
            yesVotes += 1;
        } else {
            noVotes += 1;
        }
    }

    function getResults() public view returns (uint64, uint64) {
        return (yesVotes, noVotes);
    }
}

// Output: FHEvm privacy-preserving voting contract
contract SimpleVotingFHE is SepoliaConfig, ReentrancyGuard {
    using FHE for *;
    
    enum VotingStatus {
        Open,
        DecryptionInProgress,
        ResultsDecrypted
    }
    
    mapping(address => bool) public hasVoted;
    VotingStatus public status;
    
    uint64 public decryptedYesVotes;
    uint64 public decryptedNoVotes;
    uint256 public voteDeadline;
    
    euint64 private encryptedYesVotes;
    euint64 private encryptedNoVotes;
    
    // Decryption variables
    bool private isDecryptionPending = false;
    uint256 private latestRequestId;
    mapping(uint256 => bool) private processedRequests;
    
    event VoteResultsDecrypted(uint256 requestId, uint64 yesVotes, uint64 noVotes);
    
    constructor() {
        encryptedYesVotes = FHE.asEuint64(0);
        encryptedNoVotes = FHE.asEuint64(0);
        
        FHE.allowThis(encryptedYesVotes);
        FHE.allowThis(encryptedNoVotes);
        
        status = VotingStatus.Open;
    }
    
    function vote(externalEbool support, bytes calldata inputProof) public {
        require(block.timestamp <= voteDeadline, "Too late to vote");
        require(!hasVoted[msg.sender], "Already voted");
        require(status == VotingStatus.Open, "Voting is not open");
        
        hasVoted[msg.sender] = true;
        ebool isSupport = FHE.asEbool(support, inputProof);
        
        // Update vote counts conditionally
        encryptedYesVotes = FHE.select(isSupport, 
            FHE.add(encryptedYesVotes, FHE.asEuint64(1)), 
            encryptedYesVotes);
        encryptedNoVotes = FHE.select(isSupport, 
            encryptedNoVotes, 
            FHE.add(encryptedNoVotes, FHE.asEuint64(1)));
        
        FHE.allowThis(encryptedYesVotes);
        FHE.allowThis(encryptedNoVotes);
    }
    
    function requestVoteDecryption() public returns (uint256) {
        require(block.timestamp > voteDeadline, "Voting is not finished");
        require(!isDecryptionPending, "Decryption is in progress");
        require(status == VotingStatus.Open, "Voting status invalid");
        
        bytes32[] memory cts = new bytes32[](2);
        cts[0] = FHE.toBytes32(encryptedYesVotes);
        cts[1] = FHE.toBytes32(encryptedNoVotes);
        
        latestRequestId = FHE.requestDecryption(cts, this.voteDecryptionCallback.selector);
        isDecryptionPending = true;
        status = VotingStatus.DecryptionInProgress;
        
        return latestRequestId;
    }
    
    function voteDecryptionCallback(uint256 requestId, uint64 yesVotes, uint64 noVotes, bytes[] memory signatures) external {
        require(requestId == latestRequestId, "Invalid requestId");
        require(!processedRequests[requestId], "Request already processed");
        require(status == VotingStatus.DecryptionInProgress, "Invalid status");
        
        FHE.checkSignatures(requestId, signatures);
        processedRequests[requestId] = true;
        isDecryptionPending = false;
        
        decryptedYesVotes = yesVotes;
        decryptedNoVotes = noVotes;
        status = VotingStatus.ResultsDecrypted;
        
        emit VoteResultsDecrypted(requestId, yesVotes, noVotes);
    }
    
    function getResults() public view returns (uint64, uint64) {
        require(status == VotingStatus.ResultsDecrypted, "Results not yet decrypted");
        return (decryptedYesVotes, decryptedNoVotes);
    }
    
    function getVotingStatus() public view returns (VotingStatus) {
        return status;
    }
}
```

## 🔧 Configuration Options

### Conversion Options
- ✅ **Encrypt Private Variables**: Convert private variables to encrypted types
- ✅ **Encrypt Function Parameters**: Convert function parameters to encrypted types
- ✅ **Use FHEvm Library**: Add proper FHEvm imports and inheritance
- ✅ **Add Encryption Helpers**: Generate getter/setter functions with ACL
- ✅ **Enable Reorg Protection**: Add two-step ACL authorization with configurable block delay

### Type Mapping
| Solidity Type | FHEvm Type | External Type |
|---------------|------------|---------------|
| `uint8` | `euint8` | `externalEuint8` |
| `uint16` | `euint16` | `externalEuint16` |
| `uint32` | `euint32` | `externalEuint32` |
| `uint64` | `euint64` | `externalEuint64` |
| `uint128` | `euint128` | `externalEuint128` |
| `uint256` | `euint256` | `externalEuint256` |
| `address` | `eaddress` | `externalEaddress` |
| `bool` | `ebool` | `externalEbool` |

## 🛡️ Security Features

### Access Control
- **Sender Verification**: `FHE.isSenderAllowed()` prevents inference attacks
- **Granular Permissions**: Specific access rules for individual addresses
- **Transient Storage**: Gas-efficient temporary permissions
- **Public Decryption**: Controlled public access when needed

### Best Practices
- **Input Validation**: ZKPoK verification for all encrypted inputs
- **Overflow Protection**: Safe arithmetic operations with `FHE.select()`
- **Permission Management**: Automatic ACL setup for encrypted variables
- **Method Chaining**: Fluent syntax for permission management
- **Reorg Protection**: Two-step ACL authorization for critical encrypted data

### Reorg Attack Prevention
- **Two-Step Process**: Separate purchase/request from ACL grant
- **Block Delay**: Wait 95+ blocks between request and grant (configurable)
- **State Tracking**: Track pending requests and granted permissions
- **Emergency Revocation**: Ability to revoke access if needed

### Branching Best Practices
- **FHE.select()**: Use for all conditional assignments with encrypted values
- **Async Decryption**: Use `FHE.requestDecryption()` for public branching logic
- **Conditional Updates**: Always use FHE.select for updating encrypted state
- **Gas Optimization**: Minimize unnecessary FHE.select operations
- **Access Control**: Re-authorize updated ciphertexts with `FHE.allowThis()`
- **Finite Loops**: Convert while/for loops to finite loops with MAX_ITERATIONS
- **Array Safety**: Use loop-based selection for encrypted array indexes
- **Obfuscation**: Always perform operations on all branches to hide execution path

### Error Handling Best Practices
- **Error Logging**: Always log encrypted error codes for user feedback
- **Conditional Operations**: Use FHE.select for conditional error setting
- **Event Notifications**: Emit events for real-time error tracking
- **Timestamp Tracking**: Include timestamps for error debugging
- **Error Queries**: Provide public methods for frontend error queries
- **Safe Operations**: Perform operations conditionally based on error states

### Decryption Best Practices
- **Async Pattern**: Always use asynchronous decryption with callbacks
- **Signature Verification**: Always verify KMS signatures in callbacks
- **Replay Protection**: Track request IDs to prevent replay attacks
- **Pending State**: Manage decryption pending state to prevent multiple requests
- **Request Validation**: Validate request IDs match expected values
- **Event Emission**: Emit events for decryption completion notifications

### Voting Contract Best Practices
- **Status Management**: Use enums to track voting phases (Open, DecryptionInProgress, ResultsDecrypted)
- **Encrypted Vote Counts**: Keep vote counts encrypted until decryption is requested
- **Conditional Updates**: Use FHE.select for conditional vote count updates
- **Access Control**: Verify voting permissions before allowing votes
- **Deadline Enforcement**: Check vote deadlines before allowing voting
- **Result Protection**: Only reveal results after successful decryption

## 📖 Usage Guide

### 1. **Load Example**
Click on any example button to load a pre-built contract:
- **Counter Example**: Basic arithmetic operations
- **Auction Example**: Complex logic with mappings
- **Advanced Math**: Full FHE operations suite
- **Casting Example**: Type casting and trivial encryption
- **Random Example**: Random number generation
- **Encrypted Inputs**: Proper input handling
- **ACL Example**: Access control management
- **Confidential ERC20**: Secure transfer patterns
- **Reorg Protection**: Two-step ACL authorization with timelock
- **Branching Example**: Conditional logic with encrypted values
- **Loop Example**: Loop conversion and array operations with encrypted values
- **Error Handling**: User feedback and error logging with encrypted data
- **Decryption Example**: Asynchronous decryption with callback handling
- **Voting Contract**: Privacy-preserving voting system transformation

### 2. **Configure Options**
- **Encrypt Private Variables**: Automatically encrypt private state variables
- **Encrypt Function Parameters**: Convert function parameters to encrypted types
- **Use FHEvm Library**: Add proper imports and inheritance
- **Add Encryption Helpers**: Generate helper functions with ACL
- **Enable Reorg Protection**: Add two-step ACL authorization (recommended for critical data)
- **Block Delay**: Configure reorg protection delay (default: 95 blocks)

### 3. **Convert Contract**
Click "Convert" to generate the FHEvm version of your contract.

### 4. **Review Output**
- **Converted Contract**: FHEvm-compatible Solidity code
- **Conversion Log**: Details of what was converted
- **Encrypted Variables**: List of variables that were encrypted

## 🔍 Limitations

### Current Limitations
- ❌ Complex Solidity syntax (structs, enums, events)
- ❌ Inheritance chains and interfaces
- ❌ External contract calls and delegate calls
- ❌ Assembly and low-level operations
- ❌ Complex data structures (dynamic arrays)

### Recommended Use Cases
- ✅ **Simple contracts** with basic operations
- ✅ **Learning and education** purposes
- ✅ **Prototyping** FHEvm concepts
- ✅ **Basic examples** and demonstrations

## 🛠️ Technical Stack

- **Frontend**: React + TypeScript + Vite
- **Code Editor**: Monaco Editor with Solidity syntax highlighting
- **Styling**: Tailwind CSS
- **Parsing**: Custom Solidity parser with regex
- **Conversion**: AST-based transformation logic

## 🤝 Contributing

This tool is designed for educational and prototyping purposes. For production use, consider:

1. **Using proper Solidity parser** (solidity-parser-antlr)
2. **Implementing AST-based conversion** for complex contracts
3. **Adding comprehensive test coverage**
4. **Implementing security analysis**

## 📄 License

This project is for educational purposes. Use at your own risk for production applications.

## 🔗 Resources

- [FHEvm Documentation](https://docs.fhevm.org/)
- [FHEvm GitHub](https://github.com/fhenix/fhevm)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [Ethereum Documentation](https://ethereum.org/developers/docs/)

---

**Note**: This tool is designed for learning and prototyping. For production FHEvm contracts, always review and test the generated code thoroughly.

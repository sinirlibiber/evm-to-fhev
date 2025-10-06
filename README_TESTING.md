# 🚀 EVM-to-FHEvm Smart Contract Testing Suite

## 📋 Tổng quan

Dự án này cung cấp **20 smart contract phổ biến** được thiết kế để test và chuyển đổi sang FHEvm contracts. Mỗi contract đều có chức năng riêng biệt và có thể được sử dụng để test các tính năng khác nhau của Fully Homomorphic Encryption trên Ethereum.

## 🎯 Mục tiêu

- ✅ Tạo 20 smart contract phổ biến với các chức năng khác nhau
- ✅ Viết unit tests cho từng contract
- ✅ Chuẩn bị cho việc chuyển đổi sang FHEvm
- ✅ Cung cấp foundation để test privacy features

## 📁 Cấu trúc dự án

```
evm-to-fhevm/
├── contracts/                 # Smart contracts
│   ├── 01_SimpleStorage.sol
│   ├── 02_ERC20Token.sol
│   ├── 03_Crowdfunding.sol
│   ├── ...
│   └── 20_DeFi.sol
├── tests/                     # Unit tests
│   ├── 01_SimpleStorage.test.js
│   ├── 02_Crowdfunding.test.js
│   ├── 03_VotingSystem.test.js
│   └── 04_Lottery.test.js
├── scripts/                   # Deployment scripts
├── hardhat.config.js          # Hardhat configuration
├── package.json               # Dependencies
├── run-all-tests.sh          # Test runner script
├── TESTING.md                # Testing documentation
├── CONTRACTS_SUMMARY.md      # Contracts overview
└── README_TESTING.md         # This file
```

## 🚀 Quick Start

### 1. Cài đặt dependencies
```bash
npm install
```

### 2. Compile contracts
```bash
npx hardhat compile
```

### 3. Chạy tất cả tests
```bash
./run-all-tests.sh
```

### 4. Hoặc chạy từng bước
```bash
npx hardhat test
```

## 📊 Danh sách Contracts

### 🔧 Core Contracts (1-5)
1. **SimpleStorage** - Lưu trữ dữ liệu đơn giản
2. **ERC20Token** - Token ERC20 với minting/burning
3. **Crowdfunding** - Huy động vốn từ cộng đồng
4. **VotingSystem** - Hệ thống bỏ phiếu
5. **Lottery** - Xổ số với random selection

### 🔐 Security Contracts (6-10)
6. **TimeLock** - Khóa thời gian cho giao dịch
7. **MultiSigWallet** - Ví đa chữ ký
8. **Staking** - Staking với rewards
9. **NFTMarketplace** - Marketplace cho NFT
10. **DAO** - Tổ chức tự trị phi tập trung

### 💰 Financial Contracts (11-15)
11. **FlashLoan** - Flash loan với callback
12. **Insurance** - Bảo hiểm với policy management
13. **Escrow** - Escrow cho giao dịch an toàn
14. **SupplyChain** - Theo dõi chuỗi cung ứng
15. **RealEstate** - Quản lý bất động sản

### 🎮 Application Contracts (16-20)
16. **Game** - Game blockchain đơn giản
17. **EnergyTrading** - Giao dịch năng lượng tái tạo
18. **Identity** - Quản lý danh tính
19. **Charity** - Quyên góp từ thiện
20. **DeFi** - Lending và borrowing

## 🧪 Testing

### Chạy tests cụ thể
```bash
# Test một contract
npx hardhat test tests/01_SimpleStorage.test.js

# Test với coverage
npx hardhat coverage

# Test với gas report
npx hardhat test --gas

# Test với verbose output
npx hardhat test --verbose
```

### Test Coverage
Mỗi test file bao gồm:
- ✅ Deployment tests
- ✅ Functionality tests
- ✅ Edge cases
- ✅ Event tests
- ✅ Access control tests
- ✅ Error handling tests

## 🔄 FHEvm Conversion

### Privacy Features có thể thêm:
1. **Encrypted Variables**: `uint256` → `euint32`
2. **Encrypted Functions**: Private computation
3. **Encrypted Inputs**: `externalEuint32` parameters
4. **ACL Support**: Permission management
5. **Decryption Helpers**: Async decryption

### Security Enhancements:
1. **Reorg Protection**: Two-step authorization
2. **Branching Logic**: `FHE.select` for conditions
3. **Loop Handling**: Finite loops with encrypted conditions
4. **Error Handling**: Encrypted error codes
5. **Array Operations**: Encrypted indexing

## 📈 Test Metrics

### Coverage Targets:
- **Function Coverage**: >90%
- **Branch Coverage**: >85%
- **Line Coverage**: >90%
- **Gas Optimization**: Monitor usage
- **Security Validation**: Vulnerability testing

### Performance Metrics:
- **Compilation Time**: <30 seconds
- **Test Execution**: <2 minutes
- **Gas Usage**: Optimized for each contract
- **Memory Usage**: Efficient data structures

## 🛠️ Development

### Adding New Contracts:
1. Tạo contract trong `contracts/` folder
2. Viết tests trong `tests/` folder
3. Update documentation
4. Run tests để verify

### Adding New Tests:
1. Tạo test file với naming convention
2. Import required dependencies
3. Write comprehensive test cases
4. Include edge cases và error scenarios

## 📚 Documentation

### Files:
- **TESTING.md**: Detailed testing guide
- **CONTRACTS_SUMMARY.md**: Complete contracts overview
- **hardhat.config.js**: Configuration details
- **package.json**: Dependencies list

### Best Practices:
- ✅ Write clear test descriptions
- ✅ Test both success và failure cases
- ✅ Verify events được emit đúng
- ✅ Test access control
- ✅ Monitor gas usage

## 🔧 Configuration

### Hardhat Config:
```javascript
module.exports = {
  solidity: "0.8.19",
  networks: {
    hardhat: { chainId: 1337 },
    localhost: { url: "http://127.0.0.1:8545" }
  },
  paths: {
    sources: "./contracts",
    tests: "./tests",
    cache: "./cache",
    artifacts: "./artifacts"
  }
};
```

### Dependencies:
- **Hardhat**: Development environment
- **Ethers.js**: Ethereum library
- **Chai**: Testing framework
- **OpenZeppelin**: Security libraries

## 🚨 Troubleshooting

### Common Issues:
1. **Compilation Errors**: Check Solidity version
2. **Test Failures**: Verify test logic
3. **Gas Issues**: Optimize contract code
4. **Network Issues**: Use hardhat network

### Debug Commands:
```bash
# Debug specific test
npx hardhat test --verbose

# Check gas usage
npx hardhat test --gas

# Run with console.log
npx hardhat test --grep "test name"

# Clean and rebuild
npx hardhat clean && npx hardhat compile
```

## 🎯 Next Steps

### Immediate:
1. ✅ Run all tests
2. ✅ Verify contract functionality
3. ✅ Check test coverage
4. ✅ Optimize gas usage

### Future:
1. 🔄 Convert to FHEvm contracts
2. 🔄 Add privacy features
3. 🔄 Deploy to testnet
4. 🔄 Performance optimization

## 📞 Support

### Resources:
- [Hardhat Documentation](https://hardhat.org/docs)
- [Ethers.js Documentation](https://docs.ethers.io)
- [Solidity Documentation](https://docs.soliditylang.org)
- [FHEvm Documentation](https://docs.fhevm.org)

### Issues:
- Check existing documentation
- Review test cases
- Verify configuration
- Contact development team

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**🎉 Happy Testing! 🎉**

Bộ 20 smart contract này cung cấp foundation vững chắc để test và chuyển đổi sang FHEvm, mở ra khả năng privacy-preserving applications trên Ethereum. 
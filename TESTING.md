# Smart Contract Testing Guide

## Tổng quan

Dự án này bao gồm 20 smart contract phổ biến với các chức năng khác nhau, được thiết kế để test và chuyển đổi sang FHEvm contracts.

## Danh sách Contracts

### 1. SimpleStorage.sol
- **Chức năng**: Lưu trữ dữ liệu đơn giản
- **Test**: `tests/01_SimpleStorage.test.js`
- **Tính năng**: Store, retrieve, increment, user data tracking

### 2. ERC20Token.sol
- **Chức năng**: Token ERC20 với minting và burning
- **Tính năng**: Mint, burn, transfer, ownership management

### 3. Crowdfunding.sol
- **Chức năng**: Huy động vốn từ cộng đồng
- **Test**: `tests/02_Crowdfunding.test.js`
- **Tính năng**: Campaign creation, contributions, fund claiming, refunds

### 4. VotingSystem.sol
- **Chức năng**: Hệ thống bỏ phiếu
- **Test**: `tests/03_VotingSystem.test.js`
- **Tính năng**: Proposal creation, voting, execution, receipt tracking

### 5. Lottery.sol
- **Chức năng**: Xổ số với random number generation
- **Tính năng**: Ticket purchase, winner selection, round management

### 6. TimeLock.sol
- **Chức năng**: Khóa thời gian cho giao dịch
- **Tính năng**: Transaction scheduling, execution, cancellation

### 7. MultiSigWallet.sol
- **Chức năng**: Ví đa chữ ký
- **Tính năng**: Multi-signature transactions, confirmation management

### 8. Staking.sol
- **Chức năng**: Staking với rewards
- **Tính năng**: Staking, rewards distribution, withdrawal

### 9. NFTMarketplace.sol
- **Chức năng**: Marketplace cho NFT
- **Tính năng**: NFT listing, buying, bidding, auction

### 10. DAO.sol
- **Chức năng**: Tổ chức tự trị phi tập trung
- **Tính năng**: Proposal creation, voting, execution, quorum management

### 11. FlashLoan.sol
- **Chức năng**: Flash loan với callback
- **Tính năng**: Flash loan execution, fee calculation

### 12. Insurance.sol
- **Chức năng**: Bảo hiểm với policy management
- **Tính năng**: Policy creation, claims, approval, payment

### 13. Escrow.sol
- **Chức năng**: Escrow cho giao dịch an toàn
- **Tính năng**: Transaction management, dispute resolution

### 14. SupplyChain.sol
- **Chức năng**: Theo dõi chuỗi cung ứng
- **Tính năng**: Product tracking, verification, event logging

### 15. RealEstate.sol
- **Chức năng**: Quản lý bất động sản
- **Tính năng**: Property registration, buying, renting

### 16. Game.sol
- **Chức năng**: Game blockchain đơn giản
- **Tính năng**: Player management, monster battles, leveling

### 17. EnergyTrading.sol
- **Chức năng**: Giao dịch năng lượng tái tạo
- **Tính năng**: Energy production, consumption, trading

### 18. Identity.sol
- **Chức năng**: Quản lý danh tính
- **Tính năng**: Identity verification, attribute management

### 19. Charity.sol
- **Chức năng**: Quyên góp từ thiện
- **Tính năng**: Campaign creation, donations, fund distribution

### 20. DeFi.sol
- **Chức năng**: Lending và borrowing
- **Tính năng**: Collateral management, interest calculation, liquidation

## Cài đặt và Chạy Tests

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
npx hardhat test
```

### 4. Chạy test cụ thể
```bash
npx hardhat test tests/01_SimpleStorage.test.js
```

### 5. Chạy với coverage
```bash
npx hardhat coverage
```

## Cấu trúc Test

Mỗi test file bao gồm:

1. **Setup**: Deploy contracts và setup test environment
2. **Deployment Tests**: Kiểm tra deployment thành công
3. **Functionality Tests**: Test các chức năng chính
4. **Edge Cases**: Test các trường hợp đặc biệt
5. **Event Tests**: Kiểm tra events được emit đúng
6. **Access Control**: Test quyền truy cập

## Chuyển đổi sang FHEvm

Sau khi test thành công, các contract này có thể được chuyển đổi sang FHEvm bằng cách:

1. Sử dụng tool EVM-to-FHEvm converter
2. Chọn contract cần chuyển đổi
3. Áp dụng các transformation rules
4. Generate FHEvm-compatible code

## Best Practices

1. **Test Coverage**: Đảm bảo test coverage > 90%
2. **Edge Cases**: Test các trường hợp boundary
3. **Gas Optimization**: Monitor gas usage
4. **Security**: Test các vulnerability phổ biến
5. **Documentation**: Comment rõ ràng cho mỗi test case

## Troubleshooting

### Lỗi thường gặp:

1. **Compilation Error**: Kiểm tra Solidity version
2. **Test Timeout**: Tăng timeout trong hardhat config
3. **Gas Limit**: Tăng gas limit cho complex tests
4. **Network Issues**: Sử dụng hardhat network cho local testing

### Debug Commands:
```bash
# Debug specific test
npx hardhat test --verbose

# Run with console.log
npx hardhat test --grep "test name"

# Check gas usage
npx hardhat test --gas
``` 
#!/bin/bash

echo "🚀 EVM-to-FHEvm Smart Contract Testing Suite"
echo "=============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi

print_status "Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    print_error "Failed to install dependencies"
    exit 1
fi

print_status "Compiling contracts..."
npx hardhat compile

if [ $? -ne 0 ]; then
    print_error "Failed to compile contracts"
    exit 1
fi

print_success "Contracts compiled successfully!"

echo ""
print_status "Running all tests..."
echo ""

# Run tests with detailed output
npx hardhat test --verbose

if [ $? -eq 0 ]; then
    echo ""
    print_success "All tests passed! ✅"
    echo ""
    print_status "Test Summary:"
    echo "  - 20 Smart Contracts created"
    echo "  - Unit tests for core functionality"
    echo "  - Ready for FHEvm conversion"
    echo ""
    print_status "Next steps:"
    echo "  1. Use the EVM-to-FHEvm converter tool"
    echo "  2. Select contracts to convert"
    echo "  3. Apply FHE transformations"
    echo "  4. Generate encrypted contracts"
else
    echo ""
    print_error "Some tests failed! ❌"
    echo ""
    print_status "Troubleshooting:"
    echo "  1. Check contract compilation errors"
    echo "  2. Verify test dependencies"
    echo "  3. Review test cases"
    echo "  4. Check Solidity version compatibility"
fi

echo ""
print_status "Test files created:"
ls -la tests/ | grep "\.test\.js$" | while read line; do
    echo "  - $line"
done

echo ""
print_status "Contract files created:"
ls -la contracts/ | grep "\.sol$" | while read line; do
    echo "  - $line"
done

echo ""
print_success "Testing suite completed!" 
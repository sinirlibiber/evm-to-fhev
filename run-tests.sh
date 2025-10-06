#!/bin/bash

echo "🚀 Installing dependencies..."
npm install

echo "🔧 Compiling contracts..."
npx hardhat compile

echo "🧪 Running all tests..."
npx hardhat test

echo "✅ Tests completed!" 
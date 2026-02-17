# 🚀 SimpleCrowdfunding (ETH Crowdfunding)

---

## 🧾 Overview

**SimpleCrowdfunding** is a basic Solidity smart contract that allows users to **contribute Ether** to a fundraising campaign with a **goal** and a **deadline**.

- If the campaign **reaches the goal** after the deadline, the **admin** can withdraw the raised funds.
- If the campaign **does not reach the goal** after the deadline, contributors can **claim a refund**.

This project is intended to practice:
- Smart contract structure
- State variables (`uint256`, `address`, `bool`)
- `mapping` for user contributions
- `payable` functions and receiving ETH
- `require` validations
- Modifiers (`onlyAdmin`)
- Events
- ETH transfers using `.call`
- Basic safety pattern: **CEI (Checks-Effects-Interactions)**

---

## 🚀 Features

| Feature | Description |
|--------|-------------|
| ETH Contributions | Anyone can contribute ETH before the deadline. |
| Goal + Deadline | Campaign has a target (`goal`) and end time (`deadline`). |
| Contribution Tracking | Stores each user’s contribution in a mapping. |
| Admin Withdraw | Admin withdraws only if the goal is reached after deadline. |
| Refunds | Contributors can claim refunds if goal is not reached after deadline. |
| Events | Emits events for contributions, withdrawals, and refunds. |

---

## 📌 Contract Details

- **Contract Name:** `SimpleCrowdfunding`
- **Solidity Version:** `0.8.33`
- **License:** LGPL-3.0-only
- **Admin:** `msg.sender` at deployment
- **Goal:** Set at deployment (`goal_`)
- **Deadline:** `block.timestamp + durationSeconds_`

---

## 🧠 How It Works

### ✅ Contribute
Users call `contribute()` and send ETH (`msg.value`).  
Their contribution is stored in `contribution[msg.sender]`, and the contract updates `totalRaised`.

### ✅ Withdraw (Admin)
After the deadline:
- If `totalRaised >= goal`, the admin can call `withdrawFunds()` once.
- Funds are transferred to the admin using `.call`.

### ✅ Refund (Users)
After the deadline:
- If `totalRaised < goal`, contributors can call `claimRefund()` to receive back their ETH.

---

## 🔐 Safety Notes

### CEI Pattern (Checks-Effects-Interactions)
Both withdrawal and refund follow the CEI pattern:
1. **Checks:** validate conditions (`require`)
2. **Effects:** update contract state (e.g., set balance to 0)
3. **Interactions:** transfer ETH using `.call`

---

## 🧪 Deploy & Test (Remix)

### 1) Compile
1. Open Remix IDE: https://remix.ethereum.org
2. Create `SimpleCrowdfunding.sol` and paste the contract code
3. Go to **Solidity Compiler**
4. Select compiler version **0.8.33**
5. Click **Compile**

### 2) Deploy
1. Go to **Deploy & Run Transactions**
2. Select contract: `SimpleCrowdfunding`
3. Fill constructor parameters:
   - `goal_`: e.g. `1000000000000000000` (1 ETH in wei)
   - `durationSeconds_`: e.g. `300` (5 minutes)
4. Click **Deploy**

### 3) Contribute (Test)
1. In Remix, set **Value** to e.g. `0.2 ether`
2. Call `contribute()`
3. Verify:
   - `contribution(<your_address>)` increased
   - `totalRaised` increased
   - Event `ContributionMade` appears in logs

### 4) After Deadline
Wait until `block.timestamp >= deadline`.

#### ✅ Case A: Goal reached
- Admin calls `withdrawFunds()`
- Verify:
  - Transaction succeeds
  - `fundsWithdrawn` becomes `true`
  - Event `FundsWithdrawn` appears

#### ✅ Case B: Goal NOT reached
- Each contributor calls `claimRefund()`
- Verify:
  - `contribution(<user>)` becomes `0`
  - Event `RefundClaimed` appears

---
## 📜 License
This project is licensed under **LGPL-3.0-only**.

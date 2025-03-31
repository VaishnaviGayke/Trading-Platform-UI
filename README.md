# Trading-Platform-UI

# 💹 Trading Platform UI - Qt/QML + Flask

A cross-platform real-time trading application built using *Qt/QML*, *JavaScript*, and a *Flask backend*. The app fetches live BTC/USD prices and order book data from public APIs, allows users to simulate trades (Buy/Sell), and keeps a record of trade history.

---

## 📦 Features

- ✅ Live BTC/USD price ticker from CoinGecko
- ✅ Real-time Order Book updates every 2 seconds
- ✅ Interactive Canvas-based Price Line Chart
- ✅ Trade Action Panel for Buy/Sell orders
- ✅ Full Trade History (Backend storage + upcoming UI panel)
- ✅ Responsive layout with dark theme
- ✅ Built with *QtQuick 2.15*, *JavaScript*, and *Flask*

---

## 🖼️ UI Overview

- **Left Sidebar:** Market, Wallet, Profile, and Trade Panel
- **Top Bar:** Live Ticker
- **Center:** Line chart plotting live order book prices
- **Right:** Order Book with BUY/SELL entries
- **Popup:** Confirms trade actions

---

## 🛠️ Tech Stack

| Layer | Tech Used |
|-------|-----------|
| UI Frontend | Qt 6 (QtQuick 2.15, QML, JavaScript) |
| Backend API | Python + Flask |
| Price Source | CoinGecko API |
| Layout System | QML Anchors & Layouts |
| Trade Logic | XMLHttpRequest + Flask POST |

---

## 🚀 Getting Started

### 1. Clone the Repository
git clone https://github.com/VaishnaviGayke/trading-platform-ui.git
cd trading-platform-ui

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: 1200
    height: 700
    title: "Trading Platform UI"
    color: "#1e1f2b"

    property real btcPrice: 0
    property var orderBook: []

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var priceXhr = new XMLHttpRequest()
            priceXhr.onreadystatechange = function() {
                if (priceXhr.readyState === XMLHttpRequest.DONE && priceXhr.status === 200) {
                    var response = JSON.parse(priceXhr.responseText)
                    btcPrice = response.price
                }
            }
            priceXhr.open("GET", "http://127.0.0.1:5050/price")
            priceXhr.send()

            var orderXhr = new XMLHttpRequest()
            orderXhr.onreadystatechange = function() {
                if (orderXhr.readyState === XMLHttpRequest.DONE && orderXhr.status === 200) {
                    orderBook = JSON.parse(orderXhr.responseText)
                    canvas.requestPaint()
                }
            }
            orderXhr.open("GET", "http://127.0.0.1:5050/orderbook")
            orderXhr.send()
        }
    }

    Rectangle {
        id: tickerBar
        height: 50
        width: parent.width
        color: "#3e4160"
        anchors.top: parent.top
        anchors.left: parent.left

        Label {
            anchors.centerIn: parent
            text: "Live Ticker: BTC/USD - $" + btcPrice
            color: "white"
            font.pixelSize: 18
        }
    }

    Rectangle {
        id: sidebar
        width: 220
        color: "#2e2e40"
        anchors.top: tickerBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 20

            Label { text: "📈 Market"; color: "white" }
            Label { text: "💼 Wallet"; color: "white" }
            Label { text: "🧑 Profile"; color: "white" }

            Rectangle {
                id: tradePanel
                width: parent.width
                height: 240
                color: "#2a2a3a"
                radius: 6

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Label {
                        text: "Trade Panel"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    TextField {
                        id: priceInput
                        placeholderText: "Price (USD)"
                        color: "white"
                        background: Rectangle { color: "#3a3a4a"; radius: 4 }
                    }

                    TextField {
                        id: quantityInput
                        placeholderText: "Quantity (BTC)"
                        color: "white"
                        background: Rectangle { color: "#3a3a4a"; radius: 4 }
                    }

                    Row {
                        spacing: 10
                        Button {
                            text: "Buy"
                            background: Rectangle { color: "#007f00"; radius: 4 }
                            onClicked: {
                                if (priceInput.text !== "" && quantityInput.text !== "")
                                    confirmationPopup.open("Buy", priceInput.text, quantityInput.text)
                            }
                        }
                        Button {
                            text: "Sell"
                            background: Rectangle { color: "#a00000"; radius: 4 }
                            onClicked: {
                                if (priceInput.text !== "" && quantityInput.text !== "")
                                    confirmationPopup.open("Sell", priceInput.text, quantityInput.text)
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: orderPanel
        width: 220
        color: "#2c2c3d"
        anchors.top: tickerBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            Label {
                text: "Order Book"
                color: "white"
                font.bold: true
            }

            Repeater {
                model: orderBook
                delegate: Rectangle {
                    width: parent.width
                    height: 30
                    radius: 4
                    color: modelData.type === "BUY" ? "#0f0f0f" : "#400000"
                    border.color: modelData.type === "BUY" ? "#009900" : "#aa0000"
                    border.width: 1

                    Row {
                        anchors.fill: parent
                        spacing: 10
                        anchors.margins: 6

                        Label {
                            text: modelData.type
                            color: modelData.type === "BUY" ? "lightgreen" : "#ff7777"
                            font.bold: true
                        }
                        Label { text: "$" + modelData.price.toFixed(2); color: "white" }
                        Label { text: modelData.quantity + " BTC"; color: "lightgray" }
                    }
                }
            }
        }
    }

    Canvas {
        id: canvas
        anchors.top: tickerBar.bottom
        anchors.left: sidebar.right
        anchors.right: orderPanel.left
        anchors.bottom: parent.bottom
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = "#1e1f2b"
            ctx.fillRect(0, 0, width, height)

            if (orderBook.length > 0) {
                var prices = orderBook.map(o => o.price)
                var minPrice = Math.min.apply(null, prices)
                var maxPrice = Math.max.apply(null, prices)
                var spacing = width / (prices.length - 1)

                ctx.beginPath()
                ctx.strokeStyle = "#00ffff"
                ctx.lineWidth = 2

                for (var i = 0; i < prices.length; ++i) {
                    var x = i * spacing
                    var y = height - ((prices[i] - minPrice) / (maxPrice - minPrice)) * height
                    if (i === 0) ctx.moveTo(x, y)
                    else ctx.lineTo(x, y)
                }
                ctx.stroke()
            }
        }
    }

    Popup {
        id: confirmationPopup
        property string action: ""
        property string price: ""
        property string quantity: ""

        width: 300
        height: 150
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle { color: "#2c2c2c"; radius: 8 }

        function open(type, priceVal, qtyVal) {
            action = type
            price = priceVal
            quantity = qtyVal
            confirmationPopup.open()
        }

        Column {
            anchors.centerIn: parent
            spacing: 10

            Label {
                text: action + " Order Confirmation"
                font.pixelSize: 16
                font.bold: true
                color: "white"
            }

            Label {
                text: "Price: $" + price + " | Qty: " + quantity + " BTC"
                color: "#cccccc"
            }

            Button {
                text: "Confirm"
                onClicked: {
                    confirmationPopup.close()
                    priceInput.text = ""
                    quantityInput.text = ""
                    // TODO: Hook for POST /trade backend
                }
            }
        }
    }
}

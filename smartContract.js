var url = "http://rinkeby.caralabs.me:18575";
var provider = new ethers.providers.JsonRpcProvider(url);
var walletLocator = new ethers.Wallet(accounts.personas[0].privatekey, provider);
var walletRenter = new ethers.Wallet(accounts.personas[1].privatekey, provider);
var contractAddress = '0xcb3504205d0a6046967f18394f254acef8990454';
var contract = new ethers.Contract(contractAddress, ABI, provider);
var contractWithSignerLocator = contract.connect(walletLocator);
var contractWithSignerRenter = contract.connect(walletRenter);

function showRentalValue() {
    $("#rentalValue").html("🤔");
    contract.rentalValue()
    .then((result) => {
        var value = result;
        $("#rentalValue").html(" " + value); //não é possível passar apenas a variável, senão o JS vê como bigNumber e dá erro
    });
}

function showRenter(){
    $("#viewRenter").html("🤔");
    contractWithSignerLocator.getRenter()
    .then((address) => {
        $("#viewRenter").html(address);
        console.log(address);
    } )
}

function newRentalValue(){
    var newIndex = $("#newIndex").val();
    contractWithSignerLocator.readjustRentalValue(newIndex)
    .then((transaction) => {
        console.log(transaction);
        $("#loading").html("🤔");
        transaction.wait()
        .then((newValue) => {
            alert("Value reset successfully! 🤑");
            contract.rentalValue()
            .then((shownewValue) => {
                let showValue = shownewValue;
                $("#loading").html("The new rental value is " + showValue);
            })

        })
    })
}

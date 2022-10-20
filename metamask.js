import { useState, useEffect } from "react";
import ErrorMessage from "./ErrorMessage";
import "./App.css"
import { ethers } from "ethers";
import { Button, Card } from "react-bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";
const ethereum = window.ethereum;


function App() {
const [error, setError] = useState();
const [address, setAdress] = useState("");
const [balance, setBalance] = useState(null);
const ethereum = window.ethereum;
;
//const { account, chainId } = useMetaMask();
const btnhandler = () => {
if (window.ethereum) {

// res[0] for fetching a first wallet
window.ethereum
.request({ method: "eth_requestAccounts" })
.then((res) => accountChangeHandler(res[0]));
} else {
alert("install metamask extension!!");
}
};

const accountChangeHandler = (account) => {

//console.log(`Accounts:\n${accountChangeHandler.join('\n')}`);
console.log("account");

}

const disconnectHandle = () => {
window.ethereum.on('disconnect', (code, reason) => {
console.log("account");
})

}
/*
ethereum.on('accountsChanged', accountChangeHandler);

ethereum.removeListener('accountsChanged', accountChangeHandler);

window.ethereum.on('disconnect', (code, reason) => {
console.log("account");
})*/






const networks = {
polygon: {
chainId: `0x${Number(137).toString(16)}`,
chainName: "Polygon Mainnet",
nativeCurrency: {
name: "MATIC",
symbol: "MATIC",
decimals: 18
},
rpcUrls: ["https://polygon-rpc.com/"],
blockExplorerUrls: ["https://polygonscan.com/"]
},
bsc: {
chainId: `0x${Number(97).toString(16)}`,
chainName: "Smart Chain - Testnet",
nativeCurrency: {
name: "Binance Chain Native Token",
symbol: "BNB",
decimals: 18
},
rpcUrls: [
"https://bsc-dataseed1.binance.org",
"https://bsc-dataseed2.binance.org",
"https://bsc-dataseed3.binance.org",
"https://bsc-dataseed4.binance.org",
"https://bsc-dataseed1.defibit.io",
"https://bsc-dataseed2.defibit.io",
"https://bsc-dataseed3.defibit.io",
"https://bsc-dataseed4.defibit.io",
"https://bsc-dataseed1.ninicoin.io",
"https://bsc-dataseed2.ninicoin.io",
"https://bsc-dataseed3.ninicoin.io",
"https://bsc-dataseed4.ninicoin.io",
"wss://bsc-ws-node.nariox.org"
],
blockExplorerUrls: ["https://bscscan.com"]
}
};

const changeNetwork = async ({ networkName, setError }) => {
try {
if (!window.ethereum) throw new Error("No crypto wallet found");
await window.ethereum.request({
method: "wallet_addEthereumChain",
params: [
{
...networks[networkName]
}
]
});
} catch (err) {
setError(err.message);
}
};




const handleNetworkSwitch = async (networkName) => {
setError();
await changeNetwork({ networkName, setError });
};

const networkChanged = (chainId) => {
console.log({ chainId });
};

useEffect(() => {
window.ethereum.on("chainChanged", networkChanged);

return () => {
window.ethereum.removeListener("chainChanged", networkChanged);
};
}, []);

return (
<div className="credit-card w-full lg:w-1/2 sm:w-auto shadow-lg mx-auto rounded-xl bg-white">
<main className="mt-4 p-4 bg-purplle rounded-lg">
<h1 className="text-xl font-semibold text-gray-700 text-center">
<div>
<span class="_geVuqPBMEs6PV1FWNUU" bg >{disconnectHandle}</span>
<span class="wqA8WjPT3HL0nZkIXsWh">You need to connect to supported network</span>
</div>
</h1>
<div className="mt-4 ">
<button
onClick={() => handleNetworkSwitch("polygon")}
className="mt-2 mb-2 btn btn-primary submit-button focus:ring focus:outline-none w-full"
>
Switch to Polygon
</button>
<button
onClick={() => handleNetworkSwitch("bsc")}
class="UbQxYBXfgGDIuLkCeyyJ D8zB9M68yGMBQS9EDSfl custom-btn bg-info"
>
Switch to BSC network
</button>

<Button onClick={btnhandler} variant="primary">

Connect to wallet
</Button>
<div class="HJeoCzUYNiRmq4rT8LW7"><span>Wrong network</span>

</div>



<ErrorMessage message={error} />
</div>
</main>
</div>
);
}
export default App;
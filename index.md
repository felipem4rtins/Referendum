<html>
    <body>
        <div>
  			<p>Pergunta: <a id='subject'></a></p>
  			<button id='voteYes'>Sim</button>
  			<button id='voteNo'>Não</button>
  			<p>Conta Conectada: <a id='coinbase'></a></p>
			<p>Número do Bloco Atual: <a id='blockNumber'></a></p>
			<p>Endereço do Contrato: <a id='address'></a></p>
      <p>Votos a favor: <a id='yes'></a></p>
      <p>Votos contra: <a id='no'></a></p>
      <p>Total de votos: <a id='totalVotes'></a></p>
	    </div>

		<!-- To use web3, jquery and materialize (for toast warnings) libs -->
		<script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.36/dist/web3.min.js"></script>
		<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" crossorigin="anonymous"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>

        <script>
			var contract;
            $(document).ready(function(){
				// making conection with blockchain
				if (typeof web3 !== 'undefined') {
                    // Use MetaMask's provider
                    web3 = new Web3(web3.currentProvider);

                } else {
			    // Use localhost provider or some IP address
                    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
                }

				/////////////////////////////
				// To see on console
				web3.eth.getAccounts().then(console.log);
				web3.eth.getBlockNumber().then(console.log);
				web3.eth.isMining().then(console.log);

        // Create variables to use on html page
				web3.eth.getCoinbase().then(function(coinbase){
					$('#coinbase').html(coinbase);
				})

				// Create variables to use on html page
				web3.eth.getBlockNumber().then(function(blockNumber){
					$('#blockNumber').html(blockNumber);
				})

				/////////////////////////////
				// Sample of a contract's address deployed in Ropsten test network
				 var address = "0x52Fb9423BaFC35b50cF68C1F7C6D793eB3DfAf55"
				// Deployed Contract's Adress, substitute here with your contract's address
				// var address = "0xB40dCa2c4b6B84C1131eBDdCf3df6D2f294B0ba8"
				$('#address').html(address)
				// Deployed Contract's ABI
				var abi = [
	{
		"constant": false,
		"inputs": [],
		"name": "Reveal",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "voteNo",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "voteYes",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_subject",
				"type": "string"
			},
			{
				"name": "_referedumDurationInDays",
				"type": "uint256"
			},
			{
				"name": "_maxVotes",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "GetNo",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "GetSubject",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "GetTotal",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "GetYes",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "StagePrint",
		"outputs": [
			{
				"name": "",
				"type": "uint8"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "voters",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];

				// connect, via web3, your variable contract to the deployed contract, using his ABI and address
				contract = new web3.eth.Contract(abi, address);
                contract.methods.GetSubject().call().then(function(subject)
                {
                    $('#subject').html(subject);
                })
                contract.methods.GetYes().call().then(function(yes)
                {
                    $('#yes').html(yes);
                })
                contract.methods.GetNo().call().then(function(no)
                {
                    $('#no').html(no);
                })
                contract.methods.GetTotal().call().then(function(totalVotes)
                {
                    $('#totalVotes').html(totalVotes);
                })
			})

			$('#voteYes').click(function()
			{
				M.toast({html:'Transaction received and will be mined!'});
				console.log("Transaction received and will be mined!");

				web3.eth.getAccounts().then(function(accounts)
				{
					var acc = accounts[0];
					return contract.methods.voteYes().send({from: acc});
				}).then(function(tx)
				{
					console.log(tx);
					if(!alert("Transaction mined at block " + tx.blockNumber + "\nBlockHash = " + tx.blockHash)){window.location.reload();}
				}).catch(function(tx)
				{
					if (tx){
						alert('Some error has occurred, go to console!')
					}
					console.log(tx);
					//M.toast({html:tx})
				})
			})

			$('#voteNo').click(function()
			{
				M.toast({html:'Transaction received and will be mined!'});
				console.log("Transaction received and will be mined!");

				web3.eth.getAccounts().then(function(accounts)
				{
					var acc = accounts[0];
					return contract.methods.voteNo().send({from: acc});
				}).then(function(tx)
				{
					console.log(tx);
					if(!alert("Transaction mined at block " + tx.blockNumber + "\nBlockHash = " + tx.blockHash)){window.location.reload();}
				}).catch(function(tx)
				{
					if (tx){
						alert('Some error has occurred, go to console!')
					}
					console.log(tx);
					//M.toast({html:tx})
				})
			})
        </script>
    </body>
</html>

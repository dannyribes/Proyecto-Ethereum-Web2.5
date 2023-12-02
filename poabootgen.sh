set -x
#!/bin/bash

# Specify the path to addresses.txt
addresses_file="addr.txt"
# Clean up the content of addresses.txt (truncate the file)
> "$addresses_file"
# Specify the folder containing the JSON file for the current node
folder="node1/keystore"
# Specify the folder for the current node
node_folder="node1"
# Remove the entire folder associated with the current node
echo "Removing node folder for node1: $node_folder"
rm -rf "$node_folder"/*
# Generate Ethereum account for the current node
password_file="pwd.txt"
geth --datadir "node1" account new --password "$password_file"
# Get the name of the JSON file starting with "UTC" and without an extension in the specified folder
json_file=$(find "$folder" -type f -name 'UTC*' -exec basename {} \;)
# Check if a matching JSON file is found
if [ -n "$json_file" ]; then
    # Read the JSON file and extract the address using jq
    address=$(jq -r '.address' "$folder/$json_file")

    # Print the extracted address
    echo "Ethereum Address for node$node: $address"

    # Append the address to addresses.txt
    echo "$address" >> addr.txt
else
    echo "No matching JSON file found in $folder starting with 'UTC' and without an extension."
fi

# Print the extracted address
echo "Account Address for node1: $address"

# Constructed extraData
extraData="0x0000000000000000000000000000000000000000000000000000000000000000$address"
echo "Constructed extraData: $extraData"



# Step 2: Create the genesis.json file
cat > genesis.json <<EOF
{
  "config": {
    "chainId": 8888,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "clique": {
      "period": 15,
      "epoch": 30000
    }
  },
  "nonce": "0x0",
  "timestamp": "0x6567c799",
  "extraData": "0x00000000000000000000000000000000000000000000000000000000000000005c78815158d7acbc59401c12202f2c20d8e165c30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "gasLimit": "0x47b760",
  "difficulty": "0x1",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "alloc": {
    "37d5126b4c0e6789343b8e074840f5c6da43f47e": {
      "balance": "0x200000000000000000000000000000000000000000000000000000000000000"
    }
  },
  "number": "0x0",
  "gasUsed": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "baseFeePerGas": null
}
EOF


docker rm bootnode ethe-node-8888

# Step 3: Initialize the node with the genesis.json file
docker run --rm -it -v ${PWD}/node1:/node1 -v ${PWD}/genesis.json:/genesis.json ethereum/client-go:v1.11.5 init --datadir node1 /genesis.json

# Step 4: Generate a bootnode key
docker run -v $(pwd):/keys ethereum/client-go:v1.11.5 bootnode --genkey=/keys/boot.key

# Step 5: Run the bootnode
docker run -d -v $(pwd):/keys -p 30301:30301/udp --name bootnode ethereum/client-go:v1.11.5 bootnode --nodekey=/keys/boot.key --verbosity=3

# Step 6: Obtain the enode
bootnode_enode=$(docker exec -i $(docker ps -q --filter "name=bootnode") geth --exec "admin.nodeInfo.enode" attach /keys/boot.ipc)

# Step 7: Deploy the node
docker run -d -p 8545:8545 -v /ethereum_ipc:/ipc -v ${PWD}/node1:/node1 --name ethe-node-8888 ethereum/client-go:v1.11.5 --datadir node1 --http --http.api personal,eth,miner,net,web3,rpc --http.addr 0.0.0.0 --http.port 8545 --mine --allow-insecure-unlock --miner.etherbase $account_address --unlock "$account_address" --http.corsdomain="*" --miner.threads 1 --ipcpath /ipc/geth8888.ipc --password /node1/pwd.txt --bootnodes "$bootnode_enode"

# Print instructions for connecting MetaMask
echo "Connect MetaMask to the PoA node using the RPC endpoint http://localhost:8545."

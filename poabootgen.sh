set -x
# Specify the path to addresses.txt
addresses_file="addr.txt"
# Clean up the content of addresses.txt (truncate the file)
> "$addresses_file"
# Specify the folder containing the JSON file for the current node
node_folder="node1"
folder="node1/keystore"
# Remove the entire folder associated with the current node
echo "Removing node folder for node1"
rm -rf node1
# Generate Ethereum account for the current node
password_file="pwd.txt"
mkdir -p "$node_folder"
cp "$password_file" "$node_folder/"
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
#         "0x000000000000000000000000000000000000000000000000000000000000000020d8e165c30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
extraData="0x0000000000000000000000000000000000000000000000000000000000000000"$address"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
echo "Constructed extraData: $extraData"

timestamp=$(date +%s)
timestamp_hex=$(printf "0x%x" $timestamp)



# Step 2: Create the genesis.json file
cat > genesis_poa.json <<EOF
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
    "ethash": {},
    "clique": {
      "period": 15,
      "epoch": 30000
    }
  },
  "nonce": "0x0",
  "timestamp": "$timestamp_hex",
  "extraData": "$extraData",
  "gasLimit": "0x47b760",
  "difficulty": "0x1",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "alloc": {
    "00000000000000000000000000000000000000fd": {
      "balance": "0x1"
    },
    "00000000000000000000000000000000000000fe": {
      "balance": "0x1"
    },
    "00000000000000000000000000000000000000ff": {
      "balance": "0x1"
    },
    "37d5126b4c0e6789343b8e074840f5c6da43f47e": {
      "balance": "0x200000000000000000000000000000000000000000000000000000000000000"
    }
  },
  "eip1559": {
    "maxFeePerGas": "0x1",
    "maxPriorityFeePerGas": "0x1"
  },
  "number": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000"
}
EOF

# Generate a key using the --genkey option
bootnode --genkey=boot.key

# Start the bootnode with the generated key and set verbosity to 3 in the background
bootnode --nodekey=boot.key --verbosity=3 > bootnode_output.log 2>&1 &

# Wait for the background process to complete
wait $!

# Extract the enode information from the log file
enode=$(grep -oP 'enode://[^\s]+' bootnode_output.log)

# Print the enode information
echo "Enode: $enode"


docker stop ethe-node-8888
docker rm ethe-node-8888


# Step 3: Initialize the node with the genesis.json file
docker run --rm -it -v ${PWD}/node1:/node1 -v ${PWD}/genesis_poa.json:/genesis_poa.json ethereum/client-go:v1.11.5 init --datadir node1 /genesis_poa.json

# Docker run command
docker run -d -p 8545:8545  -v ${PWD}/node1:/node1 --name ethe-node-8888 ethereum/client-go:v1.11.5 \
    --datadir node1 \
    --http --http.api personal,eth,miner,net,web3,rpc \
    --http.addr 0.0.0.0 --http.port 8545 \
    --mine --allow-insecure-unlock \
    --miner.etherbase "$address" \
    --unlock "$address" \
    --http.corsdomain="*" \
    --miner.threads 1 \
    --ipcpath /ipc/geth8888.ipc \
    --password /node1/pwd.txt \
    --bootnodes "$enode"




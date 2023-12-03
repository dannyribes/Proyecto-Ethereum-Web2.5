# Specify the path to addresses.txt
addresses_file="addr.txt"
# Set the variables
NETWORK_ID="8888"  # Replace with your desired network ID
GENESIS_FILE="genesis.json"  # Replace with the actual path to your genesis.json file
# Clean up the content of addresses.txt (truncate the file)
> "$addresses_file"
for node in {2..3}; do
    # Specify the folder containing the JSON file for the current node
    folder="node$node/keystore"
    # Specify the folder for the current node
    node_folder="node$node"
    # Remove the entire folder associated with the current node
    echo "Removing node folder for node$node: $node_folder"
    rm -rf "$node_folder"/*
   # Generate Ethereum account for the current node
    password_file="pwd.txt"
    account_address=$(geth --datadir "node$node" account new --password "$password_file" | awk '/Address:/{print $2}')
    echo "Account address newly created: $account_address"
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
done

# Specify the Docker Compose file
docker_compose_file="docker-compose.yml"

# Clean up the content of docker-compose.yml (truncate the file)
> "$docker_compose_file"

# Add the Docker Compose configuration
cat >> "$docker_compose_file" <<EOF
version: '3'

services:
EOF

# Loop through nodes and add Docker Compose configuration
for node in {2..3}; do
  node_folder="node$node"
  password_file="pwd.txt"
  address=$(sed -n "${node}p" "$addresses_file")
  # Add Docker Compose configuration for each node
  cat >> "$docker_compose_file" <<EOF
  node${node}-init:
    image: ethereum/client-go:v1.11.5
    command: ["init", "--datadir", "/node${node}", "/genesis.json"]
    volumes:
      - ${PWD}/node${node}:/node${node}
      - ${PWD}/genesis.json:/genesis.json
    working_dir: /
    stdin_open: true
    tty: true

  node$node:
    image: ethereum/client-go:v1.11.5
    command: ["--datadir", "/gethdata", "--authrpc.addr", "0.0.0.0", "--authrpc.port", "8545", "--authrpc.vhosts", "eth,net,web3,personal,miner,clique", "--unlock", "$address", "--password", "/gethdata/password.txt", "--mine", "--allow-insecure-unlock"]
    ports:
      - "854$node:8545"
    volumes:
      - ./$node_folder:/gethdata
EOF

  # Create a directory for each node and copy the password file
  mkdir -p "$node_folder"
  cp "$password_file" "$node_folder/"
done

echo "Docker Compose file generated successfully."

# Start the Ethereum nodes using Docker Compose
docker-compose up -d
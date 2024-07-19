function view() {
    # Check `pandoc` and `busybox` are executable
    if ! command -v pandoc &> /dev/null || ! command -v busybox &> /dev/null; then
        echo "Binary 'pandoc' and 'busybux' are required. Please install them first."
        return 1
    fi
  
    # Set and generate the destination directory
    OUTPUT_DIR="/tmp/view-$(date --utc --iso-8601=ns)"
    mkdir -p "$OUTPUT_DIR"
  
    # Check the file is avilable
    INPUT_FILE=$1
    if [[ -z "$INPUT_FILE" ]]; then
        echo "Usage: view <file>"
        return 1
    fi
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo "'$INPUT_FILE' is not found"
        return 1
    fi
  
    # Generate the converted HTML
    echo '<html><head><meta charset="utf-8"/></head><body>' > "$OUTPUT_DIR/index.html"
    pandoc "$INPUT_FILE" >> "$OUTPUT_DIR/index.html"
    echo '</body></html>' >> "$OUTPUT_DIR/index.html"
  
    # Look for an available port from 8000
    function find-port() {
        local port=$1
        while lsof -i:$port &> /dev/null; do
            ((port++))
        done
        echo $port
    }
    PORT=$(find-port 8000)
  
    # Start the server in background
    (cd "$OUTPUT_DIR"; busybox httpd -f -p $PORT) > /dev/null 2>&1 &
    SERVER_PID=$!
    sleep 0.5
  
    # Catch CTRL-C and stop the server
    function clean-up() {
        echo "\nStopping server [$SERVER_PID]"
        kill $SERVER_PID > /dev/null 2>&1 || true
        rm -r $OUTPUT_DIR
        return 0
    }
    trap clean-up INT
  
    # Echo the URL and attempt to open it
    URL="http://localhost:$PORT"
    echo "Serving $INPUT_FILE at $URL"
    if command -v xdg-open &> /dev/null; then
        xdg-open "$URL"
    elif command -v open &> /dev/null; then
        open "$URL"
    else
        echo "Could not detect a browser command to open the URL."
    fi

    # Wait for server background terminated
    wait $SERVER_PID
}


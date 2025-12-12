#!/usr/bin/env bash

# Requires ollama and gemma3:4b installed

OLLAMA_PID=""
MODEL="gemma3:4b"

start_ollama() {
    if pgrep -x "ollama" >/dev/null; then
        echo "Ollama is already running."
        return
    fi

    echo "Starting Ollama..."
    ollama serve &
    OLLAMA_PID=$!

    echo "Waiting for Ollama to become ready..."
    until curl -s http://localhost:11434/api/version >/dev/null 2>&1; do
        sleep 1
    done

    echo "Ollama is ready!"
}

prompt_model() {
    if ! pgrep -x "ollama" >/dev/null; then
        echo "Ollama is not running. Start it first."
        return
    fi

    echo ""
    read -p "Enter your prompt: " USER_PROMPT
    echo ""

    if [ -z "$USER_PROMPT" ]; then
        echo "Empty prompt, returning to menu."
        return
    fi

    ollama run "$MODEL" <<< "$USER_PROMPT"
}

stop_ollama() {
    if pgrep -x "ollama" >/dev/null; then
        echo "Stopping Ollama..."
        pkill -x ollama
        echo "Ollama stopped, you can close the terminal."
    else
        echo "Ollama is not running."
    fi
}

menu() {
    while true; do
        echo ""
        echo "============== OLLAMA MENU =============="
        echo "1) Start Ollama"
        echo "2) Enter prompt for model ($MODEL)"
        echo "3) Stop Ollama"
        echo "=========================================="
        read -p "Choose an option: " choice

        case $choice in
            1) start_ollama ;;
            2) prompt_model ;;
            3) stop_ollama ;;
            *) echo "Invalid option." ;;
        esac
    done
}

menu
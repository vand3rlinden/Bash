# Installation per bash script
1. Make a bashscript directory in your user directory `cd ~`: `mkdir bashscripts`
2. Open the directory: `cd bashscripts`
3. Make a file such as `get_spfdmarc.sh`: `nano get_spfdmarc.sh`
4. Copy the bash script in the editor and save the file

# Execute the bash scripts
1. Make `get_spfdmarc.sh` executable: `chmod +x get_spfdmarc.sh`
2. Now, you can execute the script to send the email: `./get_spfdmarc.sh example.com` or run `bash get_spfdmarc.sh example.com`

# Run Bash Scripts in the Zsh Shell
Bash and Zsh are compatible with each other, which means you can use your Bash scripts in your Zsh shell.
To confirm your Shell run: `which $SHELL`

I chose Bash for this scripts instead of Zsh because I want it to be portable across many systems, including both Linux and macOS. While the default shell on macOS is Zsh and on many Linux distributions it’s Bash, Bash scripts tend to be more compatible with Zsh than the other way around.
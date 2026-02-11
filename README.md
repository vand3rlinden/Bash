# Installation per bash script
1. Make a Bash directory in your user directory `cd ~`: `mkdir bash`
2. Open the directory: `cd bash`
3. Make a file such as `email-buddy.sh`: `nano email-buddy.sh`
4. Copy the bash script in the editor and save the file

> **NOTE:** There are multiple ways to install the scripts, such as downloading them directly or using `git clone` to clone the repository.

# Execute the bash scripts
1. Make `email-buddy.sh` executable: `chmod +x email-buddy.sh`
2. Now, you can execute the script: `./email-buddy.sh example.com` 
 
> **NOTE:** You can also simply run `bash email-buddy.sh`. In that case, you do not need to make the `.sh` file executable

# Run Bash Scripts in the Zsh Shell
Bash and Zsh are compatible with each other, which means you can use your Bash scripts in your Zsh shell.
To confirm your Shell run: `which $SHELL`

I chose Bash for this scripts instead of Zsh because I want it to be portable across many systems, including both Linux and macOS. While the default shell on macOS is Zsh and on many Linux distributions it’s Bash, Bash scripts tend to be more compatible with Zsh than the other way around.
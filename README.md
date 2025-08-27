# Auto Git-Pull Installer

This tool installs a daily cron job that automatically pulls the latest changes
from a Git repository.  

I needed a hands-off method of maintaining local versions of a repository on multiple machines. Here it is. This will make a daily pull of your repository. Drop this into the repository's root folder, run the installer, and you should be in business.

---

## Installation

### 1. Download or Clone
Clone this repo or copy the installer script (`install.sh`) into the root of any Git repository you want to keep updated.

<pre>
```bash
git clone https://github.com/your-username/auto-git-pull.git
cd auto-git-pull
```
</pre>

### 2. Make Executable
Ensure the installer script has execute permissions:

<pre>
```bash
chmod +x install.sh
```
</pre>

### 3. Run Installer
Run the installer to configure the auto-pull:

<pre>
```bash
./install.sh
```
</pre>

During setup you will be prompted for:
    • Repository path → e.g. /Users/joe/Projects/electric-monument-server
    • Time of day → in 24-hour format, e.g. 07:30 for 7:30 AM

The installer will:
    • Create a helper script git-auto-pull.sh in your repo
    • Add a cron job that runs this script daily at the time you specified
    • Log all output to git-auto-pull.log

### Uninstallation
To remove the cron job and disable auto-pull for this repo, run:

./install.sh --remove

This only removes the cron entry. Your repository and log file remain intact.
#!/bin/bash

echo "Step 1: Add new bash to /etc/shells"
echo '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells

echo "Step 2: Change default shell"
chsh -s /opt/homebrew/bin/bash

echo "Step 3: Update PATH in your profile"
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc

echo "Done! Restart your terminal or run: source ~/.zshrc"
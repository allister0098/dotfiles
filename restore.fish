#!/usr/bin/env fish

# Ensure Fisher is installed
if not functions -q fisher
    echo "Installing Fisher..."
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

# Install packages from fishfile
if test -f fishfile
    echo "Installing Fisher packages from fishfile..."
    fisher update
    fisher install < fishfile
else
    echo "fishfile not found!"
end


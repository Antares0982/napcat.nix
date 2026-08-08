if [ "$1" = "napcat" ]; then
    version=$(curl "https://api.github.com/repos/NapNeko/NapCatQQ/releases/latest" | jq -r '.tag_name')
    amd64_url="https://github.com/NapNeko/NapCatQQ/releases/download/$version/NapCat.Shell.zip"
    amd64_hash=$(nix-prefetch-url $amd64_url)

    # use friendlier hashes
    amd64_hash=$(nix hash convert --hash-algo sha256 "$amd64_hash")
    sed -i "s|# Last updated: .*\.|# Last updated: $(date +%F)\.|g" ./src/sources.nix
    sed -i "s|napcat_version = \".*\";|napcat_version = \"$version\";|g" ./src/sources.nix
    sed -i "s|napcat_url = \".*\";|napcat_url = \"$amd64_url\";|g" ./src/sources.nix
    sed -i "s|napcat_hash = \".*\";|napcat_hash = \"$amd64_hash\";|g" ./src/sources.nix
fi

# QQ is no longer pinned here, it follows nixpkgs' pkgs.qq. To move it, bump the
# nixpkgs input instead.

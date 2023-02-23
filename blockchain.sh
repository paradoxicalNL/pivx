#!/bin/bash

pivxbin=/location/to/pivx/bin

pivxbin/pivx-cli getblockchaininfo | grep -P "blocks|bestblock" | grep -oP "[0-9]{7}|[A-Za-z0-9]{64}" > getblockchaininfo
block=$(awk 'FNR == 1 {print}' getblockchaininfo)
hash=$(awk 'FNR == 2 {print}' getblockchaininfo)

echo "block: $block"
echo "hash $hash"

curl -L --compressed 'https://toolbox.pivx.org/en/forked/' -X POST -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: https://toolbox.pivx.org' -H 'Alt-Used: toolbox.pivx.org' -H 'Connection: keep-alive' -H 'Referer: https://toolbox.pivx.org/en/forked/' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-User: ?1' -H 'TE: trailers' --data-raw "blocks=$block&hash=$hash&note=&formid=ea3cb5c420089323ad4fdca87c14f7b9690675e6&submit=" --output result
result=$(cat result | grep -o "You are on the correct chain")

if [[ "$result" == "You are on the correct chain" ]]; then
echo "Chain OK"
else
echo "put your alert here"
fi

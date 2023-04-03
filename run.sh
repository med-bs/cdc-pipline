#!/bin/bash

status = $ (. / status.sh "$1")

if["$status" == "not found"]; then 
  $2
else
  docker restart "$1";
fi
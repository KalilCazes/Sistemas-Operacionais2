#!/bin/bash

echo -n "$( cat -s /etc/passwd | tr ":" "\t" | awk '{print $NF }' | uniq ) "

#!/bin/bash
# Author - Akshay Gupta
# Version - 1.0.0
# Description - Verifies if a mail id exists or not.

# Usage:
# 1. Required Parameters -
# bash mail_verifier.sh <FQDN> <Mail_from_id> <Rcpt_to_id>

# Example :
# bash mail_verifier.sh domain.com akshay@domain.com mail_id_to_verify@anotherdomain.com 

# 2. Optional -
# bash mail_verifier.sh <FQDN> <Mail_from_id> <Rcpt_to_id> <number_of_times>

# Example :
# bash mail_verifier.sh domain.com akshay@domain.com mail_id_to_verify@anotherdomain.com 10

# 3. For multiple emails -
# Just create a file with multiple emails provided in different lines
# bash mail_verifier.sh <FQDN> <Mail_from_id> <file_path>

# Example :
# bash mail_verifier.sh domain.com akshay@domain.com mail_ids.txt 

if [ -z $1 ]
then
    echo "Usage: mail_verifier.sh <FQDN>"
    echo "Example: mail_verifier.sh draup.com"
    exit
fi

if [ $1 == "gmail.com" ]
then
    echo "We currently do not support Gmail servers. Please try again."
    exit
fi

if [ -z $2 ]
then
    echo "Usage: mail_verifier.sh <FQDN> <Mail_from_id>"
    echo "Example: mail_verifier.sh draup.com akshay.gupta@draup.com"
    exit
fi

if [ -z $3 ]
then
    echo "Usage: mail_verifier.sh <FQDN> <Mail_from_id> <Rcpt_to_id>"
    echo "Example: mail_verifier.sh draup.com akshay.gupta@draup.com rajatthukral@zinnov.com"
    exit
fi

FQDN=$1
mail_from=$2
rcpt_to=$3
s=1
n=1

if [ -f $3 ]
then
    if [ ! -z $4 ]
    then
        echo "Either provide recepients file or number of connections, both are not allowed on the same time."
        exit
    fi
    rcpt_to=(`cat $3`)
fi

echo $rcpt_to
echo ${#rcpt_to[@]}

a=(`nslookup -q=mx $FQDN | grep mail | awk '{print $6}'`)

if [ ${#a[@]} != 1 ]
then

  for (( i=0; $i<${#a[@]}; i++ ))
  do
    echo "$((i+1)). ${a[$i]}"
  done
  
  echo "Choose Server (1, 2, 3, 4...):"
  read s
fi

for (( i=0; $i<${#rcpt_to[@]}; i++ ))
do
  echo "Verifying Mail Id - ${rcpt_to[$i]}"
  sh telnet_connector.sh ${a[$((s-1))]} $mail_from ${rcpt_to[$i]} | telnet
done

if [ ! -z $4 ]
then
n=$4
    echo "Number of connections - $n"
    for (( i=0; $i<$n; i++ ))
    do
        sh telnet_connector.sh ${a[$((s-1))]} ${mail_from[0]} $rcpt_to | telnet
    done
fi

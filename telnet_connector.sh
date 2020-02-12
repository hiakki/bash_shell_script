mail_server=$1
mail_from=$2
rcpt_to=$3

echo "open $mail_server 25"
sleep 2 
echo "helo hi"
echo "mail from: $mail_from"
echo "rcpt to: $rcpt_to"
sleep 2

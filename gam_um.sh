#!/bin/bash

#alias############################

gam() {
  "/Users/nick/bin/gam2/gam/gam" "$@"
}


###############################
#Distro Lists
################################


ALLUMTEAM=all.um.team@unitedmasters.com
NYC=nyc@unitedmasters.com
SF=sf@unitedmasters.com

##################################
#On-Boarding
##################################
cmd_groupadd(){
	declare EMAIL="$1" GROUP="$2"
	gam update group "$GROUP" add member "$EMAIL"

}

cmd_groupcreate(){
  declare EMAIL=$1 NAME="$2"
  gam create group "$EMAIL" name "$NAME"

}

cmd_cal_access(){
  declare EMAIL="$1" EMAIL2="$2"
  gam calendar "$EMAIL" add editor "$EMAIL2"
}

cmd_groupremove(){
	declare EMAIL="$1" GROUP="$2"
	gam update group "$GROUP" remove user "$EMAIL"
}

cmd_groupexport(){
  declare GROUP=$1
  gam print group-members group "$GROUP" membernames > ~/$GROUP.csv
  echo "$GROUP" has been exported to your home folder
  }

cmd_password(){
	declare EMAIL="$1" 
	gam update user "$EMAIL" password "Translation10jay" changepassword on 
}


cmd_termuser(){
declare EMAIL="$1"
array=$(gam info user "$EMAIL" | sed -ne '/Groups/,$ p' |cut -d "<" -f2 | cut -d ">" -f1 | grep -EiEio '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b')

for i in ${array[@]}; do
  gam update group "$i" remove user "$EMAIL"
done

gam update user "$EMAIL" password random
gam user "$EMAIL" deprovision

echo "Please login to admin.google.com and manually disable 2FA"

}

cmd_help(){
  printf "Available Commands:\ncreate-user <email> <firstname> <lastname>\ndelete-user <email>\npassword <email>\nbackupcodes <email>\nadd-group <email> <group>\nremove-group <email> <group>\npass-back <email> Changes password to default password and generates new backupcodes\ncreate-group <email> <group name> PUT GROUP NAME IN QUOTES\nexport-group <groupname>\ngit-invite <github username>\nterm-user <email>\ndrive-transfer <OLD USER EMAIL> <NEW USER EMAIL>\nhelp Shows this"
}


cmd_bulk-group-add(){
declare GROUP="$1"
echo "Enter Users Emails"
read -a userarray

for i in ${userarray[@]}
do 
gam update group "$GROUP" add member "$i"
done
}

cmd_bulk-group-remove(){
  declare GROUP="$1"
  echo "Enter Users Emails"
  read -a userarray

  for i in ${userarray[@]}
  do 
  gam update group "$GROUP" remove user "$i"
 done
}

cmd_delete_user(){
	declare EMAIL="$1"
	printf "Are you sure you want to delete the user $EMAIL? (y,n)"
	read deleteanswer
	if [[ $deleteanswer == y ]]; then
		gam delete user "$EMAIL"
	else
		printf "OK"
	fi
}

cmd_slack_invite(){
	declare EMAIL="$1"
curl -X POST \
  https://slack.com/api/users.admin.invite \
  -H "Authorization: Bearer $SLACKTOKEN" \
  -H 'Cache-Control: no-cache' \
  -F email="$EMAIL"
}


echoemail(){
  printf "Hi $FIRSTNAME, I have setup an @unitedmasters.com email for you, see below on how to get logged in\nGo to mail.google.com\nUsername: $EMAIL\nTemporary Password: Translation10jay\nYou will be prompted to change your password on first login"
}

echogroups(){
	gam info user "$EMAIL" | sed -ne '/Groups/,$ p'
}


cmd_create_user() {
  declare EMAIL="$1" FIRSTNAME="$2" LASTNAME="$3"
  gam create user "$EMAIL" firstname "$FIRSTNAME" lastname "$LASTNAME" password "Translation10jay" changepassword on
#stores backup codes in variable
#backupcodes=$(gam user "$EMAIL" update backupcodes)

#Standard Distro Additions
gam update group "$ALLUMTEAM" add member "$EMAIL"


#Location Based Distros
echo "Where is this users home office? (ny or sf)"

read office

if [[ $office == 'ny' ]]; then
	gam update group "$NYC" add member "$EMAIL"
elif [[ $office == 'sf' ]]; then
	gam update group "$SF" add member "$EMAIL"
else
	echo "OK"
fi

sleep 5

echo "Send a Slack Invite?"
read slackanswer

if [[ $slackanswer == 'y' ]]; then
	cmd_slack_invite
else
	echo "OK"
fi


#calendar access for Lauren 

 gam calendar "$EMAIL" add editor lauren@unitedmasters.com

echoemail

sleep 3

echogroups

}

cmd_data_transfer(){
	declare OLDEMAIL="$1" NEWEMAIL="$2"
	gam create datatransfer "$OLDEMAIL" gdrive "$NEWEMAIL" privacy_level shared,private
}

main() {
declare CMD="$1" EMAIL="$2"
shift 1

  [[ "$CMD" == "create-user" ]] && cmd_create_user "$@"
  [[ "$CMD" == "delete-user" ]] && cmd_delete_user "$@"
  [[ "$CMD" == "password"    ]] && cmd_password "$@"
  [[ "$CMD" == "backupcodes" ]] && cmd_backupcodes "$@"
  [[ "$CMD" == "add-group"   ]] &&  cmd_groupadd "$@"
  [[ "$CMD" == "remove-group" ]] &&  cmd_groupremove "$@"
  [[ "$CMD" == "create-group" ]] &&  cmd_groupcreate "$@"
  [[ "$CMD" == "export-group" ]] &&  cmd_groupexport "$@"
  [[ "$CMD" == "slack-invite" ]] &&  cmd_slack_invite "$@"
  [[ "$CMD" == "pass-back" ]] &&  cmd_pass_backupcodes "$@"
  [[ "$CMD" == "term-user"  ]] && cmd_termuser "$@"
  [[ "$CMD" == "help"       ]] && cmd_help "$@"
  [[ "$CMD" == "bulk-group-add" ]] && cmd_bulk-group-add "$@"
  [[ "$CMD" == "bulk-group-remove" ]] && cmd_bulk-group-remove "$@"
  [[ "$CMD" == "bulk-github" ]] && cmd_bulk-git-add-cx "$@"
  [[ "$CMD" == "copy-user" ]] && cmd_copyuser "$@"
  [[ "$CMD" == "response" ]] && cmd_echoemail "$@"
  [[ "$CMD" == "drive-transfer" ]] && cmd_data_transfer "$@"  
  [[ "$CMD" == "cal-access" ]] && cmd_cal_access "$@"  

}

main "$@"


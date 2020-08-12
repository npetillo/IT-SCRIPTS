#!/bin/bash

#alias############################

gam() {
  "/Users/nick/bin/gam/gam" "$@"
}

gamum() {
  "/Users/nick/bin/gam2/gam/gam" "$@"
}



cmd_pw_reset(){
	declare email="$1"
	gam update user "$email" password "translationUMT!" changepassword on 

	printf "Your password has been changed to translationUMT!" | pbcopy 
}

main(){
	declare CMD="$1" email="$2"
	shift 1

[[ "$CMD" == "p" ]] && cmd_pw_reset "$@"

}

main "$@"






#! /usr/bin/expect -f
 
set timeout 10
 
;# -- command line arguments into our scripts
set user [lindex $argv 0]
set password [lindex $argv 1]
set host [lindex $argv 2]
;# set guestpsk [lindex $argv 3]

;# CLI Prompt
set prompt ">"
 
;# -- You need to update the path to the text file that the expect script needs to open.
;# -- You also need to update the config syntax with in this procedure to match the WLAN name.
;# -- This has only been tested and is applicable to the CLI syntax for the Ruckus ZoneDirector.

;# -- I couldn't figure out how to pass this into the procedure via variable.  Know how?  I wanna know!

proc set_password {} {
	send -- "enable\r"
	send -- "config\r"
	send -- "wlan \"Wireless Guest\"\r"
	send -- "open wpa2 passphrase "
	send -- "[read -nonewline [open "/home/zonedirector/guestpsk.txt"]]"
	send -- " algorithm AES\r"
	send -- "end\r"
	send -- "end\r"
	return
}
 
;# script start running here
spawn /usr/bin/ssh $user@$host
 
;# loops forever until we get a shell prompt
 
while (1) {
 
   expect {
     ;# -- This is the prompt when you first use
     ;# -- ssh that says "Are you sure you want to continue ..."
 
     ")?" {
        send -- "yes\r"
     }
 
     ;# -- the prompt for username
     "Please login: " {
         send -- "$user\r"
     }
	 
      ;# -- the prompt for password
     "Password: " {
         send -- "$password\r"
     }
 
     ;# -- and finally we got a shell prompt
     "$prompt" {
        set_password
        break
     }
   }
 
}
 
;# -- exit
expect "#"
send -- "exit\r"
 
expect eof

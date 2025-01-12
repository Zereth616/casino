A simple but advanced slot machine resource for your qbcore server ! will work with qbcore and qbx but must be using ox inventory, and ox_target item for this is going to be 'casinochips' Your more then welcome to change it to whatever item casinochips are in your server. 
Config file to place the machine anywhere currently its setup to fill in the spot down in drusillas in the basement
if you don't have the mlo for drusillas I would suggest changing the config to suit where you want to place it
this is a first for me so if you have any issues let me know I have tested it in my own server with no issues 
esssentially it works by taking the amount of casinochips from your inventory and will verify you have enough to spin
which is 50 casinochips but can be adjusted how you like. bascally if the player doesn't have the minumum chips
you won't be able to play the machine 
the casinochips get taken out and updated in real time 
all winnings are stored in the winnings section until you decide to cashout in which case it will take your winnings and
cash them out for you and update the current casinochips to reflect 
no way to exploit the machine as it won't let you go negative and when you cashout it gets reset to zero.
since casinochips are counted from your inventory if you don't use all your chips you don't lose them! 
NEED TO MAKE A SEPERATE FOLDER FOR THE INDEX.HTML IN ORDER FOR THIS TO WORK. FIRST TIME USING GITHUB SO i COULDN'T FIGURE OUT HOW TO ADD A FULL FILE BUT THE FILE NAME IS GOING TO BE html so in the main casino file add in a new folder named html and add in the index.html above 
DEPENDENCYS 
ox_target
ox_inventory
qbcore/qbx

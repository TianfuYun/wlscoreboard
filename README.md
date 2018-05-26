This is a live scoreboard for OWLCMS2. It mirrors the main/results view to https://wlscoreboard.firebaseapp.com/

All you need to do is to replace the resultBoard-en.jsp (or resultBoard-se.jsp if you are using Swedish) file in your OWLCMS2 folder with the one in this folder. That's it! Now, everytime your main/results view is updated the scoreboard at https://wlscoreboard.firebaseapp.com/ will also be updated.


What if I run OWLCMS2 on a local network without internet access?

In this case you need to have a computer with access to both the local network and the internet. There are several ways to achieve this. I recommend the following:

1. Connect to the local network using a network cable.
2. Connect to the internet using wifi or a mobile internet USB modem.
3. We now need to change the IP settings for the local network (otherwise your computer will try to access internet through it).
  3.1 Hit the windows key + r, type cmd and hit enter. This will open a command window. Type ipconfig and hit enter. Note the IPv4 Address and the Subnet Mask for your Local Area Connection. These are usually similar to 192.168.0.11 and 255.255.255.0.
  3.2 Open the control panel and navigate to Network and Internet > Network and Sharing Center > Change adapter settings (might be slightly different depending on your version of Windows). Right click on Local Area Connection and click Properties. Double click Internet Protocol Version 4 (TCP/IPv4). This will open a new window. Check "Use the following IP address:" and fill in the IP address and Subnet mask from the previous step. Leave all other fields blank, this is important! You should now have access to both OWLCMS and the internet (try it).


How does it work?

The modified resultBoard-en.jsp file in this folder contains a script that uploads the group data to a Firebase realtime database. The app at https://wlscoreboard.firebaseapp.com/ simply displays the data from the database. If you want to modify the app, the source code is included here. It was developed using create-react-app. You'll also need to set up your own firebase project. Note that the app is merely a front-end UI and can be hosted anywhere.

Contact me at tianfu.yun@gmail.com if you have any questions.
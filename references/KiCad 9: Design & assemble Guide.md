---
title: "KiCad 9: Design & assemble an ESP32 IoT 4-layer PCB loaded with goodies **A Complete Guide**"
source: "https://www.youtube.com/watch?v=LO9AO0XTX3M"
author:
  - "[[Tech Explorations]]"
published: 2025-02-21
created: 2026-06-03
description: "In this comprehensive video, Peter from Tech Explorations takes you through the entire process of designing a custom IoT PCB using KiCad 9. From schematic cr..."
tags:
  - "clippings"
---
![](https://www.youtube.com/watch?v=LO9AO0XTX3M)

## Transcript

### Introduction

**0:00** · P here from Tech Explorations and welcome to this video where I'll guide you through the design of a custom PCP using Kad 9 I'll start by showing you what the final PCB of this work is going to look like and I um using the 3D

### Overview of the IoT PCB Design

**0:17** · viewer here in kick up 9 to show you I've already exported and sent this PCB out to next PCB uh the manufacturer that I've selected for this project who is also the sponsor of this video and I thank them for that so I'm expecting to get this manufactured PCB from next PCB

**0:36** · very soon so I can just do some Hands-On testing but until that happens I can show you what the 3D representation of this PCB looks like and just have a look at the various components that are on the PCB so let's say that this is a medium complexity PCB it's four layers in it it's got a bunch of integrated circuits on it it's powered by an ESP 32

**1:03** · uh C3 S2 as you can see up here the location of the components matters of course the location of things such as capacitors and connectors and so on is also important this is one of the things that I'll be going through in this video so this is what the PCB looks like eventually as you can see it's packed with a bunch of great features it's an iot development board designed from

**1:28** · scratch and I'm going to show you you how to design this from the very beginning which has to do for example with selecting appropriate components here's the bill of materials for the components a number of components here that are I guess non-trivial to include into a PCB like this we need to go through data sheets and figure out how to do the connections what kind of circuitry is required to provide Power grounding um this Thal concerns to look

**2:00** · into as well signal Integrity all those very interesting bits and pieces that are required to consider when you're designing a non-trivial PCB so we're going to do all that we're going to continue then with the schematic design going to go into a little bit more detail about what's happening here in the next segment of this video so there schematic design and then there is the layout here now one thing that I should

**2:26** · point out is that designing a board like this in real time takes time so I designed like this and assuming that I know what I'm doing but I don't have full knowledge of all the components that I'm working with some of those components I might be working for the first time ever meaning that I would have to do a bit of research about them read the data sheet understand how they work and then make them work with the rest of the components I'd say would take about 1 to two days for an experienced engineer of course don't

**2:56** · worry because in this video I have com pressed the entire process to make it fastpaced and engaging for you without skipping though any of the important steps that matter for learning how to design a medium complexity PCB like this one another thing to point out is that I am recording this video in kiab 9 rc1 so

**3:19** · that's release candidate one that became available in early January 2025 I'm expecting to see Ki out Version 9 the version published sometime in late February to early March but I don't expect any significant or even small changes really between the uh final version of kick at 9 the release version and the release candidate that I'm using

**3:47** · for this recording so you don't have to worry about any differences or changes between what you see in this video and what you will be seeing in kickout 9 okay so having said that let's have a look at at what this board contains just to get an idea of the complexity that's involved so I'll start from the right side and then move to the left so on the right side you see here the esp32 C3 S2

### Component Placement and Design Challenges

**4:13** · system on a chip just below it I've got an SD card this is remember an iot development board so you may want to use an SD card to do things such as data logging then I've got a flash memory also that can be used to store data from the various environmental measurements up here I've got the BME 280 environment

**4:37** · sensor you can use the sensor to capture temperature humidity and atmospheric pressure right here is an ambient light sensor so you can capture information about the light intensity up here there's a microphone for capturing sound

**4:58** · intensity right here I've got a USBC connector we'll be using this USBC connector for power and for data there's a couple of buttons on the right side enable and boot just to operate with the esp32 I've got integrated circuits here for the serial Communications so this chip here helps to manage the USB and the serial Communications of the board in this block here I've Got The Power regulator circuitry down here I've got

**5:29** · the battery management circuitry this a battery connector for a lipo battery plus its integrated circuit for managing charging of the battery and then finally I've got a couple of headers here you can connect those headers to things such as an O LED display or external components so this is a four layer PCB again kind of have a look inside see what's going on in the 3D representation

**6:00** · so four layer PCB I'm going to talk more about the details of the design of the PCB in the next segment of this video will cover everything from the design guidelines and the parts selection to creating the schematic routing the PCB and preparing it for manufacturing and I'll also show you how to order your board and get it assembled through next BCB who as I said earlier is the PCB

### Design Guidelines and Workflow Overview

**6:24** · manufacturer and assembler that are partnered with for this project and again I want to thank them for sponsoring this video now the goal here is to show you the complete workflow in a way that's both educational and fun and by the end of this video you'll have a better understanding of how to design your own intermediate level pcbs using

**6:45** · kick at 9 and then how to bring your designs to life with a manufacturer so grab your coffee or other beverage of choice fire up your copy of kiad and let's get started let's take a closer look at the I to develop a board with a better design I want to give you a sense of the high level design challenges and the decisions I've made along the way to ensure that this board meets its performance goals and is ready for manufacturing as you already know the board is powered by an esp32

### Operational Requirements and Component Selection

**7:17** · c302 system on a chip right here and of course there's a bunch of other components around it such as sensors and power circuitry Etc all these have to work together so one of the key decisions involved is signal conditioning to ensure clean and stable signals AED things such as decoupling capacitors as you can see right here this is one example at the input a power

**7:43** · input of the esp32 we place those capacitors near the power pins of each integrated circuit and these capacitors help to filter out noise and stabilized power supply additionally there are things such as pull up and pull down is this let me just find an example I'm just going to go to let's go to sensors where I know that

**8:07** · I had to use one of those yep so here's the um sensor for the BME 280 integrated circuit and there's a couple of pullup resistors for the and the SDA lines the I quid C interface so these ensure reliable communication and startup Behavior as well I've also included multiple capacitor sizes of course uh again the Capac sizes here's one example

**8:32** · here's another example this is for the SD card module there's a variation of values and we'll find the actual values in data sheets for the various devices but these capacitors both ceramic and talom are used to handle high frequency noise as well as low frequency fluctuations and the placement of these capacitors is critical especially near components like the esp32 uh an example

**8:59** · of this just going to make some room show you the two windows side by side you can see here is the capacitor just clicked on this is C8 which is very very close to the esp32 right on top of it

**9:16** · pretty much because that's what the specification and the data sheet requires and the role of this capacitor requires its position to be this close to the esp32 another thing that is important is finding appropriate components and just to manage my project

**9:35** · better I've sourced most of the components through Snap magic so here's one example for the buttons that I use and here's another example for the USBC connector so to save time and maintain accuracy even though some of those components are available from the KY out Library I decided at least for the most important ones not so much for the simple components such as the resistance but for the most important ones I decided to have a look at snap magic or

**10:06** · some other online distributor of Parts because the point here is not simply to design the board but also to ensure that it can be manufactured by a manufacturer such as next PCB so I've done my research mostly in snap magic and you can see here that this particular component that I've chosen is in stock which means that next PCB or your own manufacturer of choice will be able to also find it and include it in the bom you can see that in my bom this is

**10:39** · component let's go back to okay so here is the USB component you can see it's a click on it Kat uh PCB editor focuses to on the component and here is the component this is component J1 I go back to the bill of materials you can see the J1 is right here this is the information that I have included for the manufacturer and I also include information about the sourcing

**11:12** · of that material so that they can find it and order it and assemble the board although this is not strictly required I also decided to include reasonably representative 3D models for all of the components on the board and usually I can get those 3D models from the same

**11:30** · place where I Source my parts from again in this case is snap magic but there's many other places as well so for example when I look at the J1 USBC receptable which is this one here you can see if I double click on it I just need to actually get the filter to allow me to select a component you can see in the 3D models I've set the 3D model for this particular component to this so that when I bring up the 3D representation or

**12:03** · the model of the PCB that particular component is model I can see how it's placed on the board so aside from the satisfaction of visualizing and aesthetically pleasing PCB I can also visually confirm that there are no physical fit issues so now let's have a

**12:25** · look at some of the other details that I want to show you is just as we getting warmed up up for this project the first thing is in the schematic editor I've got a multi-page design approach because there quite a lot of components that are involved I didn't want to put them in the same page they would end up the project having a gigantic single page that would be very difficult to follow so I opted for a multi-page approach so

**12:53** · I've got the root page here uh which contains power management and battery charging circuits then I've got the second page down which contains the esp32 and uh SD card module USB module here in the flash memory another page is dedicated to the sensors and then finally the user interface where I've got things such as the OLED display connector break out for

**13:21** · a few unused gpios just so they not wasted I can connect them to external devices if I want to and then the reset and the boot buttons that's pretty much what you have in in this last user interface page when it comes to the layout let's have a look at the layout editor here I've opted for a four layer

**13:43** · PCB so you can see I've got four copper layers the top copper layer is used for signals so most of the signals and the signal routes are routed on the top side you can see additional signal routes in the bottom and then the first inner copper layer I've used it mostly for ground so I've got a a large ground Zone

**14:06** · you can see it here this border line you can see going around the board represents a ground Zone just going to double click on it so you can take a closer look so this one is ground and then I've got a bunch of other zones in the second inner copper layer which is uh the 3.3 volt layer I've got a actually in here you can see this one is 3.3 but Ki 9 also has a Zone

**14:38** · Manager which allows you to quickly inspect the various zones that have been created and you can see where they are as well in the various layers and you can quickly edit the

**14:53** · various characteristics and even give them a name so you can search for them later so I'll show you how to do all that as well last thing to comment before we move on to the next segment is that another thing that I've taken a lot of care to do is to select the appropriate widths for the various tracks and the V and those decisions are governed by the use of that particular track so for example you can see here this track uh is quite wide because it

**15:22** · conveys power essentially it feeds power to the entire board where other traces like this one here much smaller because they convey signals not power so they don't need to be as wide and something similar happens with things such as vs and also the decision to create things such as copper zones like this one here for example in order to enable better power transfer and improve the thermal

**15:51** · aspects of the design so that's an overview of the project and some of the key decisions that went into the design and it's really worth the time spent at the start of the project to plan and choose appropriate and available components reading the data sheets to

**16:07** · understand the signal conditioning and placement requirements and other requirements and managing the layout with proper use of layers and copper zones and all this will help to build a high quality PCB that will be economical to manufacture and of course fit for purpose designing an iot board involves balancing technical capabilities with real world constraint so in this segment of the video I'll talk a little bit about the operational requirements that guided the development of this custom esp32 board these are the things that I want to achieve by designing the board

**16:40** · and influence me in the various decisions that I had to make so after that I'll show you some of the sources that are used for things such as data sheets the actual physical components that will end up on the manufactured board and sources for the symbols Footprints and 3D models because I like to do all that as much as possible for

**16:59** · starting the actual design work in kiat there are two plus one top level requirements at gued my decision- making process the first one is that I wanted to create a board that would give me the opportunity to record this video the topic of the video as you know is to demonstrate the use of K at 9 in the design of a medium complexity PCB with

**17:21** · that in mind the second top level requirement was that this board should contain a modern microcontroller with wireless capabilities and lots of processing power that is connected to a reasonably complete array of components that would require the employment of at least four layers on this particular PCB

**17:44** · and the use of typical design techniques for epcp of this complexity and capabilities and the plus one top level requirement following the previous two is that at the end of the process I'd be able to manufacture this board in a modern manufacturing facility and in my

### Researching and Sourcing Components

**18:02** · case that's next PCP who is also sponsoring the video and you can see that the PCB right now is being manufactured so I should have it maybe in one or two weeks we'll see how that goes and I'll report on that later in this video with all that in mind you already know that the PCB that uh I'm designing in this video is built around the esp32 and I selected this MCU due to

**18:27** · its high processing power and integrated wireless communication it's got a dual core architecture and this ensures lots of available data processing power making it suitable for handling multiple sensor inputs and Performing realtime data analysis and I I also want to use this board once it's ready and manufactured to play around with esp32

**18:52** · artificial intelligence capabilities of course being familiar with his MCU is an added bonus this is hardware that I am familiar with I also wanted this board to be a fully fidget iot board Internet of Things board which would be a good PCB design example for this video so I've added a bunch of sensors as you already know there is the BME 280

**19:16** · there's a microphone sensor and there is a light sensor as well and these sensors are supported by their own dedicated support circuitry the board also has power management so I've designed the board to support two power sources one is directly through the usb3 port and another one is through a battery that can connect via this connector here and they both have their own supporting circuitry then since this is an iot board I wanted to offer a couple of

**19:50** · different ways for recording data the first one is through the SD card right here so the SD card RM module is uh used for local data storage and it allows a system to log large amounts of data independently without the need for the esp32 to be connected to the cloud and

**20:10** · this is particularly useful in remote or offline scenarios so when you want to use the data stored on the SD card simply remove it from the module and copy the files on the computer and to complement the SD card module this board also includes a flash memory integral

**20:28** · circuit right here it's onboard flash memory chip which provides fast nonvolatile storage for data and firmware and that ensures that any important data remains intact even after a power cycle the flash memory can store

**20:44** · things such as configuration files and sensor calibration data and even firmware updates where the SD card can store data from the sensors that you may want to be able to quickly copy across to a computer uh so that the two are complementary of each other the other thing to mention here has to do with the

**21:04** · dimensions and the layout of the PCB so designed the layout to keep the board compact while ensuring that any recommendations from the component manufacturers are adhere to so the most important component on the board is the esp32 Chip And that's mostly because of

**21:20** · the integrated antenna and essentially I started the design of the project as you'll see later when we get to the layout part of the video around this component especially if have a look at the documentation for the data sheet you see that what I'm looking at here is the data sheet for the esp32 from Express if systems you can see that the data sheet offers a few positioning ideas or

**21:47** · locations that are approved and correct by the manufacturer so I studied this document and I concluded that probably the best way to put the as32 on the board would be to combine something like

**22:03** · this so position number three in this positioning example with something like this so I ended up with a design that combines the two I didn't like the idea of having the antenna poking out too much because I didn't want it to be damaged I envisioned this PCB eventually

**22:21** · going inside a project box I didn't want this antenna to be out too far but I also needed to make sure that any components around that would not interfere with the radio capabilities of the board so I looked at the documentation and came up with this positioning again I'm going to talk more about this later on in this video when we start working on the layout aside from the esp32 my positioning uh choices

**22:48** · had to do with the user interface requirements so you can see for example the buttons here the connectors tend to be around the edges of the board and another consideration would be to keep components that are part of the same group together so you can see the components that have to do with the enable and the boot Button are together close in proximity the components that are used to implement the flash memory and it supporting bits and pieces are all together and so on again we'll talk

**23:20** · more about all these later in this video as much as possible I tried to collect all the bits and pieces that I need for the project ahead of time so that my actual design work is as smooth as possible what that means is that I do

**23:38** · quite a bit of research and spend a bit of time on this to find the components that I need and then collect all these components both the sources of the actual physical components that will end up on the board plus information such as data sheets and the library that I will need to import into kard having said

**23:59** · that there's always times where I make a decision of a particular component that ends up being the wrong decision and then I have to just fix the problem on the Fly that happened in a couple of times with the USB connector uh I'm made

**24:14** · choices about the USB connector a couple of times prior to settling to this particular connector that after going through with a design pretty much completing the board I realized that the original decisions were incorrect for whatever reason usually it has to do with things such as the availability of the components of being out of stock or some other technical issue like for example making it fit on the board alongside the other components so these are a few things to keep in mind so what

**24:45** · I want to show you here in this segment are some of the sources that I used to do my research to find the components that are needed so again I started with the main comp component the esp32 and then I worked my way down to other components such as integrated circuits connectors USB plugs buttons the SD card

**25:10** · module and things of that sort and I used online resources such as snap magic and snap.com most of the components that I found come from snap magic and I also used snap magic to collect the majority of the footprints symbols and 3D models

**25:33** · I'm going to show you more about this in a moment aside from snap magic there's also lots of other places and just as an indication just for your information I'll just mention component search engine right here I used that for a few of the components there is uh ket.com dig key bu views usb.

**25:51** · RG I use this site to better understand how the USB module Works uh there's on semi for some of the components spark fun Texas Instruments silicon labs std.com and a few more as I'm going through this research I always make sure that I record everything in

**26:18** · Kad itself because I see kiad as the center of my project so in kads schematic editor you can go to simple Fields table and you can see here that each one of the components have made some notes so for example I'm just going to move over so you can see here for example I've just enabled comments so you can see that I've made a note of the

**26:46** · source of the particular component here so this would be the LED so you can see I click on it in the fields table the item in the schematic diagram

**27:02** · appears so here's a fuse for example you can see that I got this fuse from this particular location so I can always go back and I can also share this information with manufacturer so that they have my notes it just improves Communications so that's one example going ahead ahead of time of course because obviously I have completed this project but most of the work that you see here in the files that I have included in the project directory I've

**27:31** · done all that as well before I actually started the design process so I didn't have all of these symbols but I had most of the symbols collected ahead of time um as I went through the project I realized that I've made a few mistakes or a few things were missing so I went back to resources such as snapa to fill

**27:53** · in the missing bits and pieces another thing that I also collected in parall are the data sheets much of the work that goes into designing a PCB has to do with reading data sheets because the manufacturers provides information on how to do the wiring for this particular component so as long as you understand what you're seeing here you you can literally copy the recommendation from the manufacturer into the design so the

**28:21** · design that you see here in the data sheet is basically what I have followed I'm just going to show you really quickly let's go to the root is what I followed right here so the component that you see here the laaa integrated circuit which is U1 is this component here and I simply followed the recommendation from the manufacturer so spend a bit of time both collecting the

**28:45** · data sheets for the components that you'll be using and also looking at them and reading them and understanding how to do the wiring as per the recommendations of the manufacturer again most of the work for doing that I did in uh snapa so if I go back to snapa

**29:04** · I'm just going to show you really quickly let's say that I'm looking for one of those components this is the bomb EXO shade that I'll be sharing as well let's have a look so here's one see Napa this is the USB receptable so I'm just going to search for this connector just going to go for the package actually search for this in snapa and here it is

**29:32** · Click through and here snap magic gives you both a data sheet PDF which I always save that in the project directory so that everything is together so I store that file on my computer and keep it in the project

**29:52** · directory I do the exact same thing then for the symbol in the footprint so I go go for kick at 6 or later so allow the download so here are the three files that uh I just downloaded and I've already stored them so here's a 3D model here is the footprint and here is the symbol I'm going to show you later how to import these symbols into kiad uh

**30:21** · so that we can use them for now I'm just storing them into my project directory so I do all that and once I'm confident that I've got prettyy much everything that I need or at least most of what I need I begin with the project what I've got here is kick at 9 I've got the release candidate version I just up updated this morning the latest available version and I'm just going to show you where I got it from I'm running my Coos so this is the location where I downloaded this particular file here and

### Setting Up KiCad 9 for the Project

**30:55** · then installed it and on my computer I'm just going to show you one more thing I'm running two versions of Kad this one is Kad 8 which is the official version stable version that it's available at the time I'm recording this video and of course in parallel I'm running kickout 9 for the requirements of this particular video recording you can run these two versions or as many versions as you like really in parallel no problem at all as

**31:20** · to how you organize your kick it instances all right so as we've learned already in the previous few segments of this video I've already taken a bit of time through research and uh preparation for this project and worked out my bill

**31:38** · of materials and in a realistic situation where you're just starting fresh with a new project this bom is probably not going to be the final one you'll be working through the details as you're working through the project but in my case uh since I've already rehearsed this video and of pretty much completed the entire process a couple of times prior to actually recording this video I have a pretty good idea of the

**32:05** · components that are going to be in it and so I've got the benefit of the build of material being pretty much finalized just keep in mind in real life if you were working on this project for the very first time just like I did when I went through it for the very first time I only had a partial set of components here I had the major components such as of course the integrated circuits and the microcontroller unit the esp32 had a good idea of the rest of the

**32:34** · components such as the the diodes and the buttons and then I went with more generic options for things such as the resistors and the capacitors in previous segments of the video I explained that as part of my preparation I went ahead used various online resources mostly

**32:54** · snapa but a few other resources that are also available aailable in order to find download and make available especially the footprints and the symbols but also the data sheets I've spent a lot of time reading through data sheets before I even started drawing anything in kiat

**33:11** · and that's Again part of your preparation I estimate that when I add all the time that I put in to prepare for the project the total amount of time spent would be about five to six good working hours to collect all of these files okay so let's get started with Kad

**33:29** · I've already started the application and I'm going to go into a new project and I'm going to save this new project in this directory that I've already started and because the directory already exists I'm just going to uncheck this option to create yet a new folder so I just want Kat to store all of its files in the directory that I've just selected so I give it a name Kat 9 esp32 demo project

**33:56** · and save yeah the selected folder is not empty I'm fully aware that there's content in this directory and yes I want to continue so there the new files just created as part of this new project the next thing I want to do is to do some basic setup I'll do that under Key Cat

**34:15** · settings there a few things I want to check things such as the high quality analizing just makes everything look better in the schematic and the drawings going to jump into the schematic editor and have a look at a few things here such as the display options I tend to go with the defaults there now and the grids there's a couple of things I want to double check as well I've got the 150 25 and 10 ms which is good and then for the fast switching I've got 50 Ms and 25

**34:48** · Ms for that and all the grid overrides as well look good all right so that's okay again all this is really personal preference tends to work better for me and I'm going to go to the editing options and have a look inside here all this looks okay annotation options also

**35:11** · look good just going to skip the rest I'm just going to accept the defaults for everything else and go into the PCB editor and have a look around here all this again looks fine as it is and just notice I'm going for four window crosshairs makes it easier to align things together when I'm using full window crosshairs and the same thing happens with the schematic editor then for the grids these are the grids that I've already selected and created your

**35:38** · list of grids is probably going to be much smaller if your Ki installation is new uh but in my case I've Ed a few additional grids and these are my grid overrides origin access and editing options defaults work fine click okay

**35:54** · next up have a look at the plugins I'm just going to go into the plugins and content manager by the button here just want to show you the plugins that I've got installed so in this project I'm only going to be using a couple of these plug I have a new Fresh installation of kard I tend to install these plugins

**36:14** · which I tend to use from time to time so there's interactive HTML bomb PCB action tools round tracks works really nice free routing and the HQ dfm which I'll be using at the very end of this project to test my board before submitting it for manufacturing and I've got a few other plugins here as well out of this entire list I recommend that you install at the very least the free routing plug-in and the HQ dfm so next up let's go into

**36:44** · preferences and install the symbol and the footprint libraries remember that I've already collected those libraries here and stored inside the same project directory so I'll start with the footprints notice that I've got an option here to import those libraries

**37:01** · globally so for all future projects or for the project specifically and I like to have a better control of the libraries for each project then I tend to go for the Project Specific libraries option unless there is a library that I'm installing that I know I'll be using across multiple projects in this case

**37:21** · most of the components I'll be using will be specific to this project so I'm opting for the Project Specific libraries here so then I'm going to use this option here to select a kick at folder with kick at mod files so click on this button then I'm already in the

**37:37** · project folder go into libraries select Footprints just set the folder level and click on open and that's it just going to change the name here I'm going to call that esp32 project libraries this nickname will make it easier for me to recognize that I'm selecting a footprint from inside this particular project Footprints library and click okay let's

### Creating the Schematic

**38:05** · do the same for the symbols so I for the same reason I'm going to go for the Project Specific libraries click on the folder button and then go into symbols unfortunately I can't select all of the library files in this directory I have to select them either one by one and click on open or do a multi select that's what I'll do so I select the first item in the list hold the shift button on my keyboard and scroll down

**38:38** · and while I'm holding the shift key click on the last item to highlight everything and then click on open and you can see that now all of these symbols and the symbol libraries have been selected and they are under the Project Specific libraries and click okay and now I'm ready to get started with the schematic here's the blank schematic editor and the plan here is that I'm going to have a total of four pages in the first page I'll have the

**39:09** · USB and power related components then in the second page I'll have the esp32 the module plus the usbt converter and a couple of LEDs then I'm going to have another page for the sensors and finally uh another page for the user interface so I'll be creating these Pages as I go and then providing Connections in between the pages let's start dropping some components start with the uh sheet

**39:38** · page settings I just want to uh add my date here I give it a the title so this going to be ESP 32 sensor board you can add more details there as you wish all right so you can see that information that text appears down the bottom let's begin with the USB receptacle so I'm just going to either click on this button right here on the top right toolbar Place symbols or use the a hot key to bring up the symbol Chooser so

**40:10** · remember that here I'm using or I want to use the SS 52400 receptable that I downloaded earlier from snap magic so I'm just going to search for that SS there you go came up that's the one that I want I can either double click on the item or just click on okay and I'll place that around here going to rearrange my symbols a bit later the next major component is the lipo charger

**40:40** · and I'm looking at my bill of materials and the item that I'm looking for is this one here the mCP 7387 the AK to bring up the Chooser and I'm now going to search for MC

**40:57** · P \[Music\] 7387 and it's this component here so click okay and I'll place it around there next up I've got the voltage regulator so again click anywhere in the sheet and looking at my bomb the regulator is this item right here the lm1117 so search for that

**41:22** · lm1117 click okay and I'll place it around here so I'm already starting to create areas where all related components will be going together so this part here is going to be where all the USBC related components are going to be this area here is going to be where all the ball charger components will be here is the

**41:46** · regulator move that up a little and I also have the battery connector so I'm going to add that as well so the battery connector that I want to use is the jst T connector looks like that click okay and place that right there for each one of those components I need of course the supporting components for the circuitry I'm going to drop all the resistors that I need on this sheet and then I'll continue with capacitors and LEDs so

**42:14** · let's start with the resistors I'm going to hit the a key on my keyboard here in the Chooser I'll select R already done it but I'll select R double click on it and I'm going to start with say here I'm going to draw this resistor right there where it's going to be eventually connected and then double click on it to change its value so this going to be a 10 kilm resistor this going to be a pull down resistor I need one more of them so

**42:43** · I'm going to type command D on my keyboard to create a duplicate and I'll drop it right here and just I'm going to move the designator and the value a little just so that there's no overlap in this one is also going to be 10 kohms so that's fine as it is so next up let's have a look at the resistance array on J1 so I'm just going to type a bring up

**43:07** · this resistor I'm going to place it around here this going to be another pull down for the C2 line and the value for this resistor is 5.1k I'm Mark it down as 5k1 I could have done it something like this for example 5.1 K but I find that the dot

**43:30** · sometimes is not easy to see and therefore can be misread whereas if I do something like 5k1 it's much easier to get the information correctly that this is a 5.1 kiloohm resistor also if you're

**43:46** · wondering where I get the value for the particular resistor I'm just going to connect it right now just to make it a bit more clear so this supp pull down resistor for the CC two line then the answer is the USB data sheet and I'm going to have another similar resistor on the other side for CC1 is just going to be another 5.1k resistor that will go right there course to draw a line which represents a wire I simply click on the pin and the

**44:18** · drawing tool will automatically start drawing a wire to stop drawing and just double click or if you want to cancel the drawing operation just hit the Escape key all right I haven't finished the wiring here I'm going to add the ground symbols a bit later so also if

**44:35** · you want to move things around you can just place your cursor on the thing that you want to move and then just type the m key on the keyboard or you can just click with your mouse and drag notice that when you do that the wire that I've already drawn it

**44:51** · gets interrupted and then I have to redraw it alternatively you can see if you do a right click to bring up the context menu there is the drag option which you can use the G shortcut to activate and that ensures that any wiring you've already done is not being cut or removed and then click again to finish the drawing okay so I've got R1 R2 R3 R4 going to go back to my U1

**45:19** · component so I'm going to add a couple of additional pull down resistors so just the a key again the r it's going to be one here and I'm just going to duplicate this one here another one they've got different values so the R5 will be 2K and the R6 is going to be

**45:44** · 20ks and while I'm at it I'm just going to do the drawing as well here's a yre for Te negative and the THM and these two we'll go to ground I'll do the ground now so don't forget so for some reason my Chooser power symbol Chooser is not coming up properly formatted and this pen on the side is just folded anyway it's not hard to expanded so here I'm

**46:14** · going to pick up the ground I can just search for gnd this is just another symbol but he could provides a separate menu item here on the side to make it easier to find so there a ground and all draw a line to connect it to R1 and R2 so these two are pull down resistors and I've got the same thing down the bottom for R5 and R six duplicate that ground

**46:41** · symbol connect the two resists together and finish the connection like that and the R5 goes to prog one and R six goes to prog three now if you're wondering again how I know how to do the wiring here again the answer is the data shade so this is the mCP 73871 and you can see in the data sheet

**47:12** · there are example typical applications and I'm simply following the example that's given to me by the manufacturer nothing fancy here and I'm not making things these up this is what the manufacturer suggests on the other side of of this U1 component I've got some indicator LEDs so I'll bring up a few more resistors first to protect the LEDs from overcurrents so this going to be our seven and this is going to be

**47:43** · 470 ohms so duplicate it a couple of times R8 and R9 and these go to these three pins so R9 will go to PG r R8 will go to SDA 1 and R7 will go to SDA 2 these

**48:06** · indicate that the battery is either charging or it is already charged for the LEDs I found the computer I want to use from snapa and as per my bomb you can see I've got three different types I've got our red a green and a blue I've already imported those to kard so I'm just going to sech search first for the red one which is the ltst red this one right here so import

**48:35** · that into my schematic Orient appropriately and that's done I want one more I'm not going to duplicate this because the next one I want is a green one so back to the Chooser and this one is a green okay like that just going to make a little bit of room between those and I've got one more this the last one is going to be the

**49:06** · blue right there I can type the m key on my keyboard to move things around all right and then finish with the connections one goes there there and there the bottoms of the LEDs

**49:22** · or the anodes of the LEDs are connected to the same place which doesn't yet exist is that's a net that I'm going to call 5V USB which doesn't exist yet as I said I'm going to connect it in a minute so I'm just going to leave these wires unconnected for the time being I'm just going to add a couple of grounds I'm just going to duplicate this ground and move it over here and finish this wiring

**49:48** · here do one more and finish that wiring right there a couple of other grounds that I'll connect while I'm at it is is this so gnd D just duplicate and connect a12 which is gnd D A2 to ground there's also one more ground I'm just going to go straight there instead of introducing new symbols so these two pins also go to ground this one will ground up \[Music\] here like that move that down a bit and

**50:22** · of course one more on the other side right there done I'll continue my work with the USB connector before I move to the other components I think at this point I've got enough already set up here to allow me to complete one part

**50:38** · of the schematic before I move to the other parts I'm just going to make a little bit of room to the part of the schematic that I'll be working for the next few minutes and that is the connector on the connector I also want to include a couple of things especially the polyfuse to help protect my board from over current so that polyfuse is connected right there on the vbus B1 pin

**51:02** · I've already selected the fuse to use so it's this one right here so I'm just going to search for B fuse and the component should already be available there search for B fuse yes it's right here so that's the one I want to use so click okay I'll place it right here I want to have a straight line so I'm just going to make a little change going to remove that line actually I'm going to remove all of this and move the ground a little bit closer to the pin and connect

**51:33** · it in like that now for the fuse that gets connected to this pin right there that's where power goes into from the USB bus and then on the other side again that's the USB bus that comes from the power ciruit next I'm going to add a capacitor that will act as an input filtering capacitor add a new component

**51:59** · it's going to be a just a regular capacitor nothing fancy I'm going to place that say around here where there is space and the value for this capacitor is 0.1 U or micro farat I use G to move

**52:19** · that a little more okay here is a good place to connect it to the polyfuse just like that and going going to duplicate the ground symbol and connect it right there just going to make a little bit of room select all these together type G and move everything a little bit to the right so I think that's it with J1 and

**52:40** · wirings I'm going to connect the remaining pins to particular Nets or I will mark them as unconnected to Mark a pin as unconnected I'm going to use this button here uh place no connect flags and that allows me to just click on a pen that I want to tell Kik that it's not going to be connected to anything so that that will suppress any error messages later on like that so sb1 will

**53:07** · also be unconnected and then up the top got these two that will be left unconnected on the other side is B2 and B3 B9 sorry B8 and then B10 and 11 so let's save at this point speaking of save if you go to kick at setting have a look at this area here in common project backup automatically backup projects so actually I want to make sure that I don't lose any work so I'm going to have

**53:40** · lots of backups let's say 10 per day every 5 minutes you don't want to lose any work and since I'm working with a release candidate version of Ky out I'd rather be safe than sorry I've got my J1 almost finished the next thing that I want to do is to start creating some Nets so I'm I'm going to use the net label tool right here you can use the L shortcut for label and with that you can

**54:05** · start creating labels I'm going to have a net named bus just type the I key to rotate it and Orient it appropriately and this going to be vbus dp1 and N D1 uh so DP for positive

**54:22** · n for negative this is going to be a differential pair for the data pinch of the USB connector so click here to bring up the label properties and this going to be USB DP or data positive so it goes in here and I'm just going to duplicate that hit Escape select the label I want to duplicate and type command or control b d click that to connect it to A7 and

**54:52** · then double click again to bring up the properties and make that P and n for negative so I've got DP and DN then the letters here at the very end of the two labels is important because p and N indicate to kick it that this is a differential pair and we are going to use this feature to do the wiring later on in the layout there is also one more

**55:17** · VBS I'm just going to duplicate that and connect another vbus wire right there so vbus A2 and vbus A1 connected to the same net on the other side I've got two more differential pairs for data these are short circuited they're physically connected in the connector so that's why the part of the same net so I'm going to duplicate DP flip it over on that side and it's going to be a p right there and then the

**55:46** · N or the negative of the differential pair right there another vbus label right there duplicate done this is going to be vbus 2 and finally I need to mark this wire as a

**56:06** · member of the vbus net so this going to be vbus B1 there's one more net to create just going to use the L key for that and this is going to be the plus 5V USB net which goes

**56:23** · there using the G key to move move everything a little bit further in okay that's it this is the USB connector I'm going to do another check a little later but I think for now that's enough works I'm just going to draw a little box around it and give it a label just to make it easy to see when I'm quickly looking at the schematic diagram that this is a block of components that

**56:47** · belong together and they play a particular role so this is a USB connector like that going to continue now with this part of the first page of the schematic now that I have the vbus 5 Vol vbus I'm just going to duplicate it and finish up the wiring of the LEDs so these go like that and just going to mark that here as the V bus now I'm going to continue to

**57:15** · implement the wiring for the lipo charger integrated ciruit just by following the recommendations of the data sheet from microchip technology the manufacturer of this particular integrated circuit so I'm just going to continue essentially copying what I see in the data sheet so I've got one more 5 Vol USB pin PR two I need to bring that up to 5 Vols for vibat sense just going

**57:42** · to short that with vbat and then Mark this net with a name so type the L key and this is going to be the vbat net mark it like that or out this is the reason for the existence of this particular chip is whatever comes out of this pin and I'm going to create a new named net with the name + 5 volts so

**58:12** · that's what comes out of this particular chip so on vsss I'm going to connect this to ground you can see that's what the data sheet is telling us to do so this is going to go to ground just going to duplicate ground symbol oriented like

**58:30** · that and Mark it like this now one thing to keep in mind I'm just going to bring up the symbol and have a look having a look at the vsss you can see that that is marked as a power input so if I leave my schematic like this so vsss directly connected to gnd D I'm going to get an error message from Kad later on want to do the ERC check so to prevent that from happening I'm going to go back to the power symbol Chooser and search for a

**59:04** · flag this power flag here and attach this flag to V SS and that will suppress that error message from kard and indicate to kard that yes I do know that this is a Power Pin and I've already taken care of that don't worry about it let's go down to the bottom pin 18 is in and that's where where we apply the 5V USB power it's coming out of here the PCC that's connected right there and

**59:37** · going to copy the flag and plug that into here so basically pin two and pin 18 are connected to the 5V USB input power here I also need the filter capacitor so I'm just going to bring another capacitor and drop it in there this one is going to be just one U and

**59:59** · I'm going to change the reference to C6 just to keep in sync with my notes Here CU I'm going to have a few other capacitors with different IDs I want to be a little bit more in control of the designators so normally I will allow kyat to come up with whichever designator it wants for new components that I'm dropping on the schematic shade but in this case I want to have a little bit more control as I said so I'm going to go ahead and rename this AA 2 C6 then

**1:00:28** · we'll connect that to ground done with that let's have a look anything else I've got yep I've got C up here which also needs to go to 5 Vols USB I think this part of the schematic is done so hit Escape select the whole thing and move it down a little and then put a box around it to indicate to the reader or

**1:00:52** · myself in this case and you that this is a set of components that belong together and I'm going to put a label here as well and this is going to be the lipo charger done the next thing is the low Dropout voltage regulator I'm going to follow the instructions from the data sheet and in particular I'll Implement A variation of this recommendation here for a fixed output regulator on the the inside I need two capacitors one of them

**1:01:22** · is going to be ceramic and the other one is going to be talum so so this one is the ceramic capacitor I'll place it right there double click to get its properties and this is going to be a 0.1 U capacitor and this is C2 that's

**1:01:40** · correct again just sking in sync with my notes I also need a talum capacitor so a key again talum is basically an electrolytic capacitor I'm just going to search for C and this a polarized I'm going to use this polarized capacitor symbol for tandum and place it right

**1:02:01** · there double click change the value to 10 microfarads like that and I'll have the exact same thing on the other side as well so I'm going to select these two and duplicate them and move the group of

**1:02:18** · the two capacitors to the other side just going to change the names I want this to be C5 and this to be C4 so I'm going to have C5 which is going to be 0.1 just going move it on the other side just keep a note here the placing of the capacitors is important so I just flipped the ceramic with the electrolytic capacitor because I want the electrolytic capacitor tandum in my case to be closer to the pins on the

**1:02:49** · integrated circuit that it will be connected to in this case is going to be the 2v out pins in other words the proximity of components to other components is important in the schematic just as it is in the layout when I see that C4 is close to V out 2 and V out 4

**1:03:09** · I know that I need to place C4 very close to those two pin in the layout as well VN goes there so I've got the two filters and I've got the ground just going to duplicate the ground symbol place it

**1:03:28** · right there and finish the connection on that side and then there's a label I'm going to place this label is going to be plus 5 Vol so 5 Vols goes into this regulator and 3.3 Vol comes out on the

**1:03:46** · other side I'm going to use a power symbol for the output so on the output I have 3.3 volts and there is a symbol for that so I'm going to use that instead of creating my own custom label so it's going to be this symbol right there all right so V out 2 and V out 4 go to the same place we've got 3.3 volts coming out of this voltage regulator and for the filtering part we also have these two capacitors as I said C4

**1:04:20** · I'll be connecting it very close to those two pin to improve the performance of the filtering and just like I did up here with a power flag I'm going to use the same power flag here to tell Kat that I'm aware

**1:04:36** · that this particular component we have a look if you have a look in the simple editor you'll see these two pins are power inputs I'm telling kard that I know about that fact and it doesn't need to worry about bringing up an error message when I do the ERC check later on because it's been taken care of and I've got the ground component as well for

**1:05:01** · these capacitors and there's one more ground I'm just going to give this one its own ground actually just duplicate just for clarity I could have connected this ground pin straight here and share the same ground symbol as the capacitors but I want it to be a little bit independent in this case I think it looks better as well so I'm just going to leave it like that now one thing I'm going to improve here is I just realized that I've got a 5V label here and a 3.3

**1:05:29** · Vol symbol label on the other side just want to be consistent so I'm going to remove that manual or custom label and replace it with an actual 5V label from Kad actually I'm going to use one of those so 5 V I'm going to use this label

**1:05:50** · like that just rotate it okay that's better select all these type G just to move things in a bit and I think this block of components is now complete just going to move it all up a little like that and put a box around it this going to be the low Dropout or ldo insured

**1:06:13** · voltage regulator uh I also have the battery connector that's going to be quick to connect and I'm also going to add a power indicator LED in a moment so let's have a look at this component the battery connector I'm going to rotate that so that the pins face inwards and on one side I want to add a vbat label

**1:06:38** · same label that I used here in the little battery charge integrated circuit so I'm just going to copy that duplicate it and connect it there and the other one of course is going to be the ground level done so let's put that in the Box

**1:06:55** · and give it a name next up I want a indicator for power so I'm going to grab a copy of the red LED and its current limiting resistor I'm just going to duplicate these two rotate like that and place it say around here and the idea here is that when there is power then 3.3 volts is going to come out of the regulator into this LED and then of course into ground and the LED will let us know that

**1:07:29** · power has been applied to the Circuit at a label here even though this is not really necessary but Power LED I'm just going to give it a named net so I can see this particular net in the layout easier later on so done with that first page is pretty much done the only next thing that I want to do is to add a hierarchical shade symbol so that I can

**1:08:00** · then connect this shade to the next one up in the hierarchy so I'll select this tool click on it and then just draw a little box here do that again yep like that I'm going to give this sheet a name and what this sheet is going to contain is the esp32 and related Hardware so I'm just going to put in here esp32

**1:08:25** · \[Music\] c302 that's the main component that's going to be in that sheet and I'm going to change the name for the sheet file as well ESP 32 C3 02 so I'll be able to see

**1:08:40** · that file in the file system in a moment and I know what it is about so save then have a look you can see I go back one level I've got my new sheet just right there along the rest of the sheets that make up the project you skip a couple of times to exit the tool so now I've got the second shade you can see that it also appeared here the second sheade is blank before I go over to work on the esp32 sheet I just notice a couple of things are to fix that has to do with the LEDs and the colors of the LEDs and

**1:09:11** · the pins to which each of these is connected to and I also want to introduce a couple of labels as well just to make it easier to see and understand the role of each of these wires when I'm working on the layout editor first thing to do is just notice that this red LED is connected to stat 2 stat 2 is the pin that indicates charging however I want the red LED to

**1:09:38** · indicate that charging power is good I can either do that by rearranging those wires or just moving the LEDs around actually that's what I'll do I'm just going to remove those wires to release the LEDs and move those around so I want the blue LED to be connected to stat 2 and stat 2 indicates charging of the battery so blue LED means charging the green LED indicates charged

**1:10:11** · and it's connected to Stat one so that is fine as it is should not have removed those wires so let's place that here and rewire everything now the other thing that I want to do is I said earlier is to use use labels to Mark the functionality of these wires and that makes it easier later on in the layout to know what wire I'm dealing with so this one is going to be charging power good I'm just going to

**1:10:40** · double click because a is missing all right second one is going to be charged and the last one is going to be charging so that's done as well now I've got one more label that is missing this one here actually just noticed this should be 5 Vols I'm just going to copy that duplicate it and that is going to be a 5V label and I just notied one more

### Designing the ESP32 Circuitry

**1:11:09** · thing I don't have a value for R6 so let's do that now so R6 should be 20K I'm pretty confident that this is correct now I haven't forgotten anything so we can continue now with the second sheet let's continue with the second sheet which will contain the various circuitry relating to the es32 and

**1:11:30** · things such as the USB module flash memory in the SD card module I'll put all those in the second sheet so you can get to the second sheet either by clicking here in the schematic herc just a second sheet you can reveal that window by clicking on this button here in the left toolbar HC Navigator or you can double click on the hierarchy symbol in the first sheet just double click and all get you there and another thing that you can do that I always like to do is to go into the symbols property and just

**1:12:03** · change the fill color so that it's a little bit easier to see I'm just going to make it something like this with a bit of opacity so kind of look a little bit like this a bit more interesting and and striking later on you'll see that I'm going to attach labels to this box

**1:12:21** · in order to enable Communications between the two sheets so let's go ahead second sheet and just like before I'm going to start by dropping the major components onto the sheet and to make it a little bit easier for us to know what those components are I've gone to the bomb and I have highlighted with yellow the main components that are part of this sheet so we have the memory card connector it's the SD card connector the esp32 chip the

**1:12:51** · cp2102 which is a usb2 uart bridge got another chip that acts as an ESD suppressor that will be working alongside the USB to UI Bridge I'll talk a little bit more about this in a moment and finally the flash memory chip uh let's start with the USB module I'll hit the a key and I'll search for GSD

**1:13:15** · 0900 and there it is I'll place that somewhere here I'll continue just you can see what I'm doing I'll continue with the the next item in my list which is the esp32 u3 component so I'm just going to search for that see3 the one that I want is this one okay and drop that there next up in my list I've got the USB to U bridge

**1:13:46** · cp2102 and I'm looking for the G qfn 20 package so I'd go 20 this one here place that here one more is the flash memory so that is this item down here

**1:14:06** · actually sorry I skipped one u5 that's the ESD suppressor so let's look for that first I've got a few options there the one that I want is this one right there the differences have to do with the packaging not with the schematic itself you can see the first two have got six pins out it's just the packaging is slightly different so the one that I'm going to go for is the 2s C6 and then finally I've got the U6

**1:14:36** · component which is The Flash SBI flash chip so that's W2 5 q this one here there's a few options but that's the one that I'm looking for double click and I'll place it say here before I continue I'm going to review the designators for the components just to make sure that they match with the ones I'm using in my notes because if I don't there's a high chance I'm going to make mistakes later on so the USD

**1:15:05** · suppressor chip I'm going to rename that to u5 the USB to serial bridge that is going to be u4 the ESP 32 Chip is going to be

**1:15:20** · u3 the SD card module is j3 that's correct and then finally the flash memory that is going to be U6 I suggest you do that as well if you want to keep track of what I'm doing because I'll be referring to these components by the designators and all I'm trying to do here is to make sure that the notes and the designators in my notes with the various components match with what I have in the actual schematic so that's all I'm doing here now let's talk a little bit about these components

**1:15:52** · this integrated circuit you 4 is a usb2 uard bridge and it enables Communications between a computer and the esp32 C3 module via a USB connection so it converts USB signals to serial U signals making it possible to program and debug the esp32 C3 directly from the computer while handling USB power delivery to the board so that's the purpose of this chip now alongside this chip is our smaller chip this u5 USB

**1:16:23** · lc6 and this is is a ESD suppressor chip this chip here protects the bridge the USB serial Bridge from electrostatic discharge events which can occur during handling or when plugging in USB connections so it clamps high voltage spikes to safe levels preventing damage to the chip while maintaining signal Integrity for Reliable data communication so I'm also going to follow the information in the data

**1:16:52** · sheets for all of the wiring that you're about to see so for example I've got the documentation for the esp32 chip I showed you some of this a little earlier actually a better place to look for that information is the development kit schematic diagram so for example here you can see how expressive themselves have wired the esp32 module to power and

**1:17:17** · to ground and I'll be following this example as well in particular be implementing the reset and boot Button functionality following this exact schematic so that's one place to look for another thing to show you is the cp2102 chip this is the USB 2 serial

**1:17:40** · bridge and there's a lot of information here on how to do the wiring I'm not going to go through it because it's a lot of detail it will take a while but if you are interested in learning the details and understanding why I did what I did the way I did it have a look at these data sheets as well here's a data sheet for the SD card module this is

**1:18:01** · mostly mechanical there's not much else going on so I've looked at this just to get a better understanding of the mechanical attributes of this connector and finally I've got here the data sheet for the flush memory this is NBI interface flush memory it doesn't have specific information on how to do their wiring but I'm using conventions for

**1:18:21** · wiring integrated circuits that communicate with with a host using High data rates and high frequencies let's begin I'm going to start with the top left side of my schematic and work my way to the other components so since I've got the ESD protective circuit I'm

**1:18:40** · just going to move these two bits to the side for the time being at least okay I'm just going to reorient this component to make wiring easier pin two goes to ground I'm just going to grab a ground pin from here \[Music\] place that there so that's going to be ground going to leave pin five alone for a second because I need a couple of resistors for that it's a voltage ladder next three just going to flip this

**1:19:11** · component across so select it and just click on this button up here to mirror vertically because I want pin three to be up on the top side just makes wiring easier so pin 3 will go to to pin 4 on the USB to serial bridge and pin one will go to Five pins four and six

**1:19:36** · need to be connected to pins in the root page so to do that I'm going to use this button here to create hierarchical labels so the first label is USB DN so USB DN and for negative I do have flexibility on to where to connect it but I'm going to connect that to six to pin six to begin with and I'm going to create a duplicate of this

**1:20:06** · label double click on the duplicate and change this end to P for the positive side of this differential pair so I've got USB DP connected to pin 4 and USB DN

**1:20:22** · connected to pin 6 now in the root page I'm going to use the place sheet pins tool to expose their two uh sheet labels I just created in the rout so click on that click here and you can see some clicking and then click again to commit um bringing across the two labels the two hierarchical labels that are created in the second sheet so these two and now

**1:20:49** · exposed to the first sheet right here and I can actually finish the connection of those two sheets by connecting you can see there's pins here that I can connect to something else so I'm going to grab the two labels that I've already created these two create a duplicate then bring them down here to finish the connection so I've got the DN that needs to go right there I'm just going to use Y is for that and DP that goes there use

**1:21:19** · wires to finish the connection the two pages now the two sheets are now able to communicate let's go back to the second sheet and I'm going to finish this work for this particular component by adding the two resistors to form a resistor ladder so there's the first one just R there's one here and another one here it's going to be R12 and the value for R12 is 22.1

**1:21:54** · K or I'm going to call it 22 K1 the second one its designator is 13 and its value 47.5 KMS these two form a voltage ladder for VBS like this just move it down a bit and then the other side of r13 goes to

**1:22:21** · ground like that on the top side we've got vbus so vbus of course is coming into this shade from the rude shade so I'm going to create one more hierarchical label called vbus and connect that here and go back to the rout and expose it like that and from here I need to find a vbus label to bring across

**1:22:56** · done back to the second sheet one thing to notice is that these labels have got shapes so depending on what shape you use you can see that the shape of the label itself changes as well these are really just visual so I'm going to keep them as inputs here and the VB is also an input next I'm going to take a wire from pin five and connect it to vbus so

**1:23:22** · that's how this chip is being powered or if you don't like the label you can just use vbus I'll do that actually just to minimize the number of wires that I'm using all right now while I'm at it I'm going to create a few local and named nits so the first one is going to be USB data plus so I'm going to connect that to the P right there and the other

**1:23:52** · one is going to be the minus again this is going to be a differential pair so I'm using plus and minus so that later on when I go to the layout editor and I start doing the drawing of the tracers Kart will be able to tell that these two wires belong to the same differential pair because they've got the minus and the plus signs in their net names now as

**1:24:17** · per the specifications for this device in the data sheet I also need a capacitor just a regular capacitor will do going to place it here connect the other side to ground just move that a bit further down like this and that goes up here and this capacitor is going to be C11 and its value is going to be 1 micro

**1:24:47** · farad and let's continue going to have one more ground down \[Music\] here and up on the top side actually I need to move everything down a bit because I have a few components to connect up on the top side so I'm going to start with a resistor oriented like this this resistor will be R11 and it's going to be

**1:25:20** · 1K that will be connected between the reset pin and pin seven which is the voltage regulation in and I'm going to connect vdd in there as well to the same pin then I've got two bypass capacitors one of them is going to be a regular capacitor and the other one is going to be electrolytic or

**1:25:49** · polarized oriented like that let's set the values so the one in the bottom is going to be C10 and its value 0.1 microfarads and the polarized one is going to be C9 and its value is

**1:26:11** · 4.7 U it goes there and then these two go to ground

**1:26:26** · like that and on the top side I'm going to have a 3.3 volt symbol so that side is done uh on the right side I'm just going to Mark a few pins that I won't be using first do not connect that and that and the suspend

**1:26:50** · pins we don't need wake up either after that that I want to have two LEDs to indicate traffic so you can see txt and RTX so I'll connect two pins here to show when there is traffic so I'm going to copy this block of components blue and a red LED along with the resistors

**1:27:14** · so command C go back to the working shet and paste those here this saves time just Orient like that so I'm going to put the uh green LED day actually on the top side again this is totally arbitrary of

**1:27:31** · course but in order to do myself the courtesy of not making a mistake and diverging from my notes I'm just uh making sure that what I'm drawing here reflects what I have in my notes all right and these two then will go to the 3.3 volt just going to copy this symbol and place it right here here I've got txt rxt and the RTS and CTS and

**1:28:03** · instead of wiring them using actual wires I'm just going to use labels here so this one the first one is going to be TX RX and that goes here and the second one duplicate is going to be rxtx goes there next

**1:28:26** · RTS and finally we have I'll call this one DTS okay I think this is complete so I'm going to put this in a box move it down a little and give it a name this is the USB module okay looks okay I'm going to have another look at it later on before I commit let's work on the ESP 32 module

**1:28:53** · so I'm going to laser in here because I'm going to have more components on the right side I just noticed that this resistor should be 18 R 18 so let's begin here I'm going to start by dropping a new resistor place it here next to I6 and this is a small 50 Ohm

**1:29:21** · resistor all right so that goes to I6 and on the other side we'll connect the to S CK net after that I've got several net labels to create and attach to these pins right here and down the bottom right there so start with the ones that I've already created so I can just duplicate them so first I'm just going to copy these two create duplicates and move them over to this side and rotate and just connect them to

**1:29:55** · pins 12 and 11 and that's good next up I've got a bunch of net labels to create so I'm going to use the L key for that so the first one for up here pin two this is going to be en n for enable done next one it's going to be cscore SD that's going to go to

**1:30:19** · io0 so they're all for all those pins just by the way if if you are a little bit confused right now we'll find all that information in the data sheet right here so there is a table here right here that tells you about the roles of each one of the pins so that you know what label to create in order to connect that pain to a particular net so next up is io1 which is going to be connected to

**1:30:48** · the sensor I've connected that to the photo sensor so this is a purpose Pinn you can do whatever you want with it of course but I've decided to connect this particular one to the photo sensor next I've got the SBI interface so I'll create a a new label called misso do for data output and that goes to io2 then there is SC for the I squid C

**1:31:17** · interface and SDA and for I5 there another general purpose input output uh and I've connected it to the microphone so I'm using the MC out net to convey signal

**1:31:34** · from the microphone or from the sound sensor so the left side is done let's go over to the other side now I'll continue with some more labels since I've started that process this going to be uh gp19 so that goes there I'm going to connect this particular net to one of the headers that's gp18 next one up is going to be CS or chip select for the SBI interface and

**1:32:05** · that's going to be Boot and gp8 this one is going to be connected to the boot Button just like uh this one here goes to the enable button three pins remaining I'm going to duplicate the ground symbol so that I can connect it to the ground pin right there then I've got io7 for io7 I

**1:32:29** · need a resistor so add a resistor oriented like this so This resistor is 50 ohms and it goes to Mossy so there's another label start a input for the SP interface this is going to be R15 this R15 and I need to correct this one here this is R 20 and finally the power for this esp32

**1:33:03** · module as per the specifications I'm going to connect this power to 3.3 volts that but I also need a couple of capacitors for bypass and for or just signal conditioning so I'm going to have

**1:33:22** · two capacitors there one polarized and one unpolarized or ceramic so there's the ceramic one and let's put one more polarized I'll place that there like this I'm just going to switch the names so C7 should really be C8 to remain consistent with my notes that's going to be 0.1 U or 0.1 microfarads

**1:33:54** · okay and the other one is going to be C7 and its value is 10 microfarads connect these to ground and on the top side just going to use the W key to start drawing just going to draw it like that actually I think makes more sense if I draw it like this yeah I'm going to move all this down a bit so because just to CH the number of angles that appear

**1:34:27** · so like this G key just to make it look a little nicer I think this is good as it is put a box around it and give it a name done let's continue with the SD card module so this is a SBI device so

**1:34:45** · it it communicates with the esp32 using SPI so start with connecting the SPI and then uh there's a couple of capacitors in resistance as well for Signal conditioning I'm going to grab the mossy and miso and clock there's clock and the

**1:35:04** · select I just noticed a mistake actually I'll unclick everything this is the select signal for the SD card so it should be SC for select SD for SD card all right so let's try again so that that clock and that duplicate them and bring them all say around here so I can attach them to the SD card reader module so Mossy goes on this side

**1:35:35** · here clock goes here the chip select goes here but I will need to add a

**1:35:52** · resistor this is just a pull up resistor I'll just place it here and set it up so this is r19 and the value of this resistor is \[Music\] 10K and as I said this is a pull up resistor so I'll just draw it like this pulls up to 3.3

**1:36:17** · volts I can just make this a little bit more economical with space and just connect it straight like that G to make it look better okay and then finally I've got the Miso and that eventually goes here just going to move this out of the way for a moment okay that goes to that zero pin but I need a

**1:36:40** · resistor a small resistor again signal conditioning right there that is going to be R16 and just 50 ohms make sure because I hit Escape so it didn't commit so R16 50 ohms and that goes there are done just move these two out a bit using the G key that one and Dot two along with the

**1:37:14** · pins down here all go to ground so I'm just going to get a ground component place it there rearrange a few things actually I don't really need this long wire I'm just going to move this simple databit rotate and connect straight like that all right next I've got that one

**1:37:39** · goes to ground that two goes to ground move these two labels up there and also I've got actually I'll be yeah I'll be economical with space and yse I'm just going to do one more ground there and all these go to ground

**1:37:59** · then I'm going to Mark these pins on the left as do not connect and then I've got one pin remaining which is the power input for this module so for that I need a couple of capacitors uh just like with the other examples earlier and it's so happens that these capacitors are the same values as those are used up here in

**1:38:23** · the 32 so I'm just going to copy those and duplicate and I've got C12 is meant to be the electrolytic so I'm just going to change the designations so this is going to be 12 at 10 microfarads and this is going to be 13 at 0.1 and that goes right there and

**1:38:45** · finally I've got the 3.3 volt to power the module I'll bring the grounds down here so that kind of the at the same level looks a bit better and that is it with a module

**1:39:03** · for the SD card put it in a box give it a name one more thing to mention here is that the dot 2 pin on the micro SD card is typically used in 4bit SD mode as one of the four data lines we've got data line 0 1 2 and

**1:39:23** · three four data lines in total however in SPI mode which is commonly used in microcontroller applications like the ones that we are building here the dot two pin is not required and it can be left floating or better connected to ground which is what we're doing here so in SPI mode which is the mode that we are again using here only the following pins are actively used we've got data zero you see I've connected that to miso data out CMD which is connected to miso

**1:39:58** · data in clock right here and CS right here the cheap select and then againt 2 and one are not used in SBI mode one more thing to do and that's to connect and wire up the flash memory so the flash memory is also using the SBI interface so I'm going to duplicate some

**1:40:22** · of the relevant pins so these four going to move them over here there is one more for the chip select I'm using this one here duplicate that and move it over across to this side let's do the wiring so CS goes here clock goes here

**1:40:44** · Mossy goes here data input di di miso data output goes there do okay data out put actually I need to do conditioning here so let's just remove that out of the way and I need another small resistor just going to copy the one from here this one duplicate it and move it over this side so this is 50 ohms and this should be

**1:41:13** · R22 actually I'll move all that a little bit to the left because I need to do something with pin number three right there so pin three along with hold will go to 3.3 volts so we're going to be holding those high at a high level that goes there and that goes there better

**1:41:37** · and on the other side I need just a single capacitor so bypass capacitor to connect ground to ground and on the other side VCC will go

**1:41:52** · to 3.3 volts it's going to be c14 and 0.1 micro farads is sufficient so move that a bit closer and we're done all right let's put this in a box and this is going to be the flash memory almost done with this page from this page that contains the esp32 we are going to Branch out to two other pages

**1:42:22** · one is going to contain the hardware for the sensors and the other one for the user interface so just like earlier I'm going to create the hierarchical sheets for those two additional pages and I'll start with the shade for the sensus I'll call that sensus and the shade file will

**1:42:45** · be sensus and I'll give it a color let's make it sign in and the second one is going to be for the user interface so that's user interface and for the sheet name I'll just a user interface and I'll use uh Fu color I'm going to make that orange okay let's try again with a sensors let's go to the

**1:43:21** · properties I clicked on the B water instead of the fuel s in all right that's better okay so we're going to add bits and pieces in those boxes later when we uh start work on the sensors and the user interface so save just going to do one last cross check before I leave this sheet alone for now

**1:43:46** · oh yeah one thing that I haven't done was to fill the the data in the legend down here so let's do that so this is going to the esp32 C3 USB and um flash

**1:44:03** · memory okay that's good save just going to take a moment to check everything here's one thing that I forget I'm just going to do it now before we continue what I want to do is to have a few test points in the final PCB so these are pads on the board that I'll be able to attach test instruments just to check on

**1:44:26** · the operation of the board without having to tap onto pins so I'm going to add a few test points here to do that I'm going to move these two blocks a bit to the right just to make a bit of room and I'm going to add the test points right here so tap the a key search for test points you can see there's a test Point here I'm going to go for the just simple test point looks like this Orient them like this or like this doesn't

**1:44:58** · really matter so this first one is going to be Mossy just going to duplicate them I want to have five of those I want to be able to test the SP interface so 1 2 3 4 One More five so I want to have

**1:45:18** · Mossy miso clock and the two select p duplicate those just put them up here for now so the first test point is going to be Mossy place that right there second one is going to be misso then I'll have the clock and then I'll have the chip select signals so for the SD card and for the flash memory I

**1:45:44** · change the name so this going to be test I use lowcase test Mossy test miso test s k o clock test CS SD and

**1:46:07** · finally test CS give a bit of space before I move to the next sheet just notice one thing here I'd really like to have this capacitor on the left side so that it's closer to vdd so the way to do this really quickly and easily is to just select the two and then use this button up here mirror horizontally or just type X and it will flip it across and I use G just move the bundle

**1:46:40** · of components together to the one side do the same thing again down here so that everything is nice and symmetrical so I'm going to save and then continue with the next sheet which is the sensus shet let's continue with the next shet in line which is the sensus shet so in here I am going to create a circuitry for these main components the microphone preamplifier the BME 280 environment

**1:47:11** · sensor it's the ambient light sensor and the microphone already collected of course the data sheets for these components you can see here is's a data sheet for the um microphone preamplifier fairly straightforward I'll be implementing this circuitry right here

**1:47:29** · here is the ambient light sensor fairly straightforward to implement the microphone that works with the preamplifier and the data sheet for the bme280 also fairly straightforward to implement there's nothing to it really uses the r s c interface and we can just follow the general gu lines for any i s c interface device to connected as always I'm going to start by dropping the main components onto my designer that's the BME 280 start with that next I'll add the

**1:48:03** · microphone and the preamplifier CMC 50 that's one I downloaded from snapa a bit earlier so that goes there and I also need to get the preamplifier which is model number Max 446 6 exk that one right there so place that

**1:48:27** · right here and uh then there's also the photo sensor so I'll put that up the top so there's going to be T Mt right there I'm just making use of my previous research here so that I can search by the various model numbers or other keywords obviously I don't remember those things by heart I'm going to start with the BME 280 and um set up

**1:48:53** · the supporting circuitry it's pretty simple so this is just an i s c device so I only need a couple of resistors for the pullup for the two lines for the clock and for the data line so add a resistor here this is going to be a 4.7 KMS resistor 4. 7K or better 4K 7 and

**1:49:22** · I'm going to call this r24 and I need two of those because I've got two lines that I need to pull up so there going to be the same value but it's going to be r25 okay done and I'm going to get a 3.3

### Adding Sensors and User Interface Components

**1:49:38** · volt symbol which I have used recently I'm just going to place that there move these down a bit so csb will go to 3.3 volts just going do move that here so that csb will connect straight to that level and then I'll have the two resistors to also connect \[Music\] there and the other side of the resistors one will go to SC

**1:50:13** · K I'm extending a little bit because I'm going to connect the net to that extended wire in a moment and then this SDI going to extend for the same reason done and then I will have two

**1:50:35** · hierarchical labels one is going to be SC right there and the other one is going to be SDA just going to improve the layout a bit move that up a bit using the G K to move and see if I can get those two

**1:50:57** · wires up a little more yeah of course fix all this there's no connection there as much as possible I try to prevent having too many angles that can move in a little more like that now sdo will go to

**1:51:18** · ground so what I'm implementing here is an address so with sdo being grounded the address for this device is 076 heximal on the other side I'll have again the 3.3 volt symbol and I'll connect both V ddio and vdd to the same level then I'll have a

**1:51:46** · capacitor just a simple ceramic capacitor this is C50 St and its value 0.1 U and that will go to

**1:52:01** · ground like that and that implements the BME 280 so I'll put a box around it it's done let's continue with the ambient light sensor this is just an analog device so all we need here is a resistor to pull it up so this going to be our 23 let's make it 10K and that gets pulled up to 3.3 volts

**1:52:36** · since that is our supply voltage that goes there and uh then we also need a hierarchical label that will connect the output of this circuit to photo C that

**1:52:52** · is the net that we will connect to one of the pins in the esp32 and of course on the other side we've got ground one thing I'll do here is I'm going to change the symbol of this shade

**1:53:10** · label to be an output let's put a box around this block next is the microphone and the preamplifier there's a little bit more circuitry involved here start with the preamplifier on the other side on the right side I'll have the power supply so it goes straight there I need a small

**1:53:34** · capacitor so it's the same value as C15 so I'm just going to duplicate that that's going to be c18 one side is connected to 3.3 Vol the other side to ground let's grab a ground

**1:53:54** · place it right here like that now here's the output so for the output I'll take a hierarchical label it's going to be mik out and uh that is also an output so that will go there connect this to like that and I need a feedback line

**1:54:19** · to go back into in one right so from here here just going to type the W key to start drawing and got towards the back I'm going to stop here because I need to include a resistor for line conditioning so here's a resistor that's 100K and that's

**1:54:45** · r31 so from out that signal goes into the resist and from there it goes to the input there's also a capacitor here place that there that's C20 and it values again 0.1 so that's fine as it is and connect it to the signal then from in I need one more

**1:55:19** · resistor which is going to be r29 with a value of 1 Mega ohm that goes between that and ground now sorry this one is

**1:55:38** · R30 and it's not 1 Mega ohm it's 10 kiloohms it's a pull down resistor I do have a huge 1 Mega Ohm resistor coming up for a voltage divider move that a bit to the left and continue with the Positive uh in so I need two resistors for that just going to copy one of them here so this is going to be R 29 and

**1:56:05** · that is 1 Mega ohm it's part of a voltage divider and it goes to ground and on the other side is r27 which is also 1 MGA and it comes out of N1

**1:56:24** · like that just going to move both of them up a little like that just using again the G key to move things around without breaking connections and from here in the middle of that divider I'll connect the output of the microphone and of course the ground goes

**1:56:48** · to ground on the top side of that voltage divider connect the 3.3 volt power There's One More Voltage divider just going to copy this resistor a couple of times the first one is 2K and

**1:57:06** · r26 and the second one is also TK so I'm just going to duplicate uh 26 this is 28 yep correct connect that here that comes out of the output from the microphone so move the microphone symbol to to the left move that bit

**1:57:25** · closer and connect the output to the bottom of the voltage ladder the top one goes to 3.3 volts so I'm just going to move that here and connect it like that and then on the left side of the voltage ladder I've got one more capacitor that looks like this and it is C 16 and the capacitance is correct and from

**1:57:58** · there connect one side to the middle of the voltage divider and the other side will go the ground and I think that the circuit for the microphone and in amplifier is also correct so I'm going to put it in a box so now I need to connect the two shades so the senses shade you can see there a few few hierarchical labels there's one 2 3 and four there's no need

**1:58:28** · to bring those hierarchical labels from the sensus page to the esp32 page so here is the box that connects it to together and I'm going to use this button here Place shade pin to bring those labels across so the first one is here I just do that click again bring the next one click again bring the next one and click again bring the next one and that's it we're done let's go back and finish up with the connections go to the esp32 and grab SDA

**1:59:03** · SC photo C and mic out duplicate bring them across rotate and then just connect them with a small wire H1 so here is SDA I can connect them straight away like this but I just prefer to have a small wire in between just to separate the box from the text soal photo and mic done let save and let's continue

**1:59:36** · with the last sheet which is the user interface let's work on the remaining sheet which is the user interface so double click on the user interface and let's begin with the components in yellow background I've got the main components for this shade there j4 and j6 just notice there's no J5 and that is okay so j4 j6 the two connectors I've

**2:00:00** · got two transistors for the boot and enable buttons and there's two buttons there as well switch one and switch two and there's a few other smaller components like resistors Let's uh get started I'm going to add the two connectors first the first

**2:00:17** · connector let's make it Con we need a connector for the dis lay which uses the ice quit C interface and therefore it requires four pin so there going to be one row with four pens I've got an option here of what kind of connector to use I'm going to just go with a simple straight connector so this one here and I can always change later so there's the first connector for the second breakout

**2:00:48** · uh which is the one that I use to just break out any remaining pins I'm going to need in total five pins so there's three gpios that I want to break out plus power and ground so let's do that I'm going to do something similar but instead of 04 I'm going to look for 05 and I'm just going to use the pin connector just for Symmetry and

**2:01:14** · simplicity so this one up here is going to be for the OED display if you'd like to connect to it otherwise you just have a breakout for the i squ c interface and this is for the gpio on the right side I'm going to break out a couple of buttons first let's see I think I've imported us lpt buttons yeah two of those so I need two of those one and two so one is going to be Boot and the other one is going to be enable switch one switch two and then I also need the two

**2:01:48** · transistors and for this particular job I'm using the BC 817 npn transistors is using the sort or S 23 package and Q3 right there I'm going to

**2:02:05** · work on the connectors first because they are really easy I just need to add a few labels and they're done and then we'll go to the reset and boot buttons so for the all LED display I'll start with power so 3.3

**2:02:24** · volts I'd like to have this around the other side so just move to the side so the pins can be connected on the left I also want to flip it over so I'm just going to flip there you go flip that over so that

**2:02:42** · number one pin is on top because I'd like just for the sake of consistency I'd like pin number one to be power and in this case like that and it's just that ground for pin

**2:03:03** · 4 and then I'll have SDA and SC I'm just checking to make sure that the configuration of the pins as to which one is SDA and which one is SC matches my actual LED display let's grab a hierarchical pin iCal label I should say and this one is SDA it actually should be B

**2:03:32** · directional so let's change that to B directional goes there this is s also be directional uh I'm just going to put a boook you can always use it to connect a second I squ C or more if you want it doesn't have to be connected to an all LED display let's continue with J5 so

**2:03:58** · I'm going to do the same thing flip it across and then vertically as well so the number one is on top going to duplicate these two and connect number one pin to 3.3 volts number five to ground and the rest are going to be GP ios's I'll use the H key the first one is going to be GP io8 bad directional

**2:04:23** · I'm just going to copy this a couple of times to save a bit of time duplicate I should say second one is going to be gpio 18 and the third one gpio 19 and finish with the connections okay that's done then let's go to the main part of this schematic I've got the two switches and down here I'm going to create a circuit to manage

**2:04:51** · the signals for boot and enable what you're looking at here is a schematic from Espress if for the es32 S3 dev kit 1 what I'm going to do is just to implement the circuit down here that manages the the boot up process of the esp32 if you want to learn more about this have a look at this documentation

**2:05:16** · page on the express if website that explains how the boot operation in the boot ler mode works in the esp32 I've got a link to this document in the description below so I'm simply going to essentially copy this schematic here let's start with the two transistors I've got Q2 and Q3 here

**2:05:40** · going to start with a bit that I always get wrong because I've got to cross some wires first I need a couple of resistors for the base place that there they both 10 KS actually one thing that I I should have been doing since the beginning of this uh work here is instead of just doing what I'm used to be doing and double clicking on a symbol to bring up its properties I can simply look at the

**2:06:07** · properties on this side by here just click on this button to reveal the properties for whichever symbol you have selected so you don't really need to double click anymore and go into the properties window you can do most of what you need to do in the properties window that appears on the side here's the fields reference and the value so I'm just going to add it directly in here this is going to be r33 and the value is 10 kiloohms and

**2:06:37** · I'll duplicate that resistor place it here and uh get the name right here this should be uh 34 which it is in 10 case next connect the resistors to the base and continue with the drawing of the wires for the two

**2:06:59** · transistors it goes like this just going to move that out a bit so it's not too close so that's one thing then I need a couple of hierarchical sheet labels one here this is going to be uh DT right there and that gets connected

**2:07:22** · like this and the second one is going to be RTS that gets connected \[Music\] here I should move that further down actually there I think of it all right now there's two more hierarchical labels that I need to add the first one is en n

**2:07:43** · and that is an input that goes there I can just connect it right there and and the second one is Boot and there is also an input and it goes in like

**2:08:03** · that let just be more specific these are going to be outputs and same thing with this one so signal comes from buttons as an input to the transistors and then provides an output to the esp32 all right so that goes there we're good with that let's continue with the buttons now I've got the button signal

**2:08:27** · coming into the button S1 like this and I'm going to put a dip bouncing capacitor in there as well see like that this is going to be

**2:08:44** · c21 and its value is 0.1 bit closer connect to the boot signal and the other side would go to ground so let's grab a ground symbol so it goes there from the other side pin four of the button goes back and gets connected to pin three pin one and pin two together get connected to

**2:09:17** · ground I'm not sure if I like this line going up over the component or can simply have a ground on the other side but it's aesthetic I'm just going to leave it like this so this is the boot Button I'm just going to use bit of text here to mark it as such this is boot another thing you can do here is to select this button and for the reference or actually for the value better replace that uh text with the text Boot and I'll

**2:09:46** · just delete that label all right same thing for S2 I'm just going to place that with this actual R this is reset so let's set it up just add a bit of space between the two buttons the first thing to do is to add a pullup resistor on pin three so I'm just going to duplicate r33 and flip it over like this the only

**2:10:11** · thing I'm going to change is its reference designator 232 the value is correct as it is and connect it to three then I'm going to duplicate the label en n and connect that to pin three going to add a ground on the other side so that pins one and two are connected to ground and then another capacitor this is correctly c22

**2:10:45** · but as per the specifications the capacitance should be one microfarad and the goes here and pin number four also gets connected to the capacitor get another ground and connect it to the other side of the capacitor now one thing that I'll add here is an image of the truth table we have implemented here with the two transistors move that down a little and there's a button here that allows me to import images so click on that button I've taken a snapshot of

**2:11:18** · this truth table a bit earlier saved it as a PNG image so go to the project folder actually I think I put it in libraries uh sorry data sheets yeah I'll put it in here and here it is and there's the truth table it's just a an easy reminder for me to remember where this information came from you can even add a bit of additional text using this text box something such as to learn more

**2:11:48** · about the ESP 32 boot mode go to and I've got a short link here T explore 4/ espb 32

**2:12:03** · Boot and that looks like this and I think it's handed to add content like this in order to make it easier for you to communicate with anyone else who might be looking at your schematic and I'm going to actually do that as well once I finished with all the drawing I will add some annotation just to make it easier for anyone who's looking at this schematic to understand what's going on

**2:12:29** · one thing that's missing here is of course 3.3 Volts for the pull-up resistor let's grab that place that here okay anything else no I think it's okay so I just need to link the sheet now with esp32 page

**2:12:47** · two and I think we'll be done let's go back here as you can see the user interface box is empty right now going to grab this tool and start adding the pins that are missing like that that's better I also think that this color is probably a bit destructive so I'm just going to make it a little lighter reduce the opacity let's finish up with the connections so um seal SDA n

**2:13:14** · boot gpios three gpios just duplicate those for now and bring them down here and there's also the RTS and DTS then it's just a simple matter of attaching them to the correct place so RTS goes here okay so I've just noticed a mistake here this is DD where this is DTS the correct name for this particular pin is DTR so let's fix that this is

**2:13:48** · going to be DTR and I'm just going to search for DTS bring up the search panel down here search for DTS in labels and you can see that there is one right here so I'm going to change that to

**2:14:10** · DDR and of course I could have done that on this side panel right here as well continue little fixes here and there as required so connect DD hierarchical sheet label to the local label then go for gp8 gpio 18 GP io19 on the other side I've got boot so I rotate that enable and then SC and SDA

**2:14:42** · I'll copy those or move those together done all right so this work is complete on the schematic I'm going to add some annotations but I'm going to do that offline and before we move on to the next step which is to work in the layout I'm going to show you the annotations and the final schematic before I continue so thanks for following so far and we'll continue in just a few seconds I've completed the schematic but there's a couple of things that I need to do before moving on to the layout editor the first thing is to

**2:15:12** · do the associations between symbols and Footprints so symbols are everything that you see here in the schematic editor and Footprints are the representations physical representations of these symbols that I'll be using in the layout editor the second thing is to do the validation and error checking I'll be using the schematic editor

### Validating the Schematic and Assigning Footprints

**2:15:33** · electrical rules Checker to do that so let's continue with the symbol and footprint associations there's a specialized tool for that which is this one right here assign Footprints so let's have a look at what we have so okay just say okay to these Legacy entries notifications so some components already have associations you can see here that F1 has an association it's the fuse the connector J1 also has an

**2:16:03** · association and so on but many other components like these capacitors for example don't have an association so let's go ahead and add those now for Passive components like the capacitors and there's a bunch of resistors down here as well I am standardizing those components for the 0805 SMD versions of

**2:16:27** · these resistors there's many different sizes of course and I can go for through hole components and I can go for tiny SMD components as well for this particular design where I am trying to balance the size and the cost I'm going to go for a more general purpose size

**2:16:46** · such as the 0805 I could go much smaller than that but that would increase the assembly and Manufacturing cost I'm going to start with the first one and actually what you can do in ki it you can even select all of them actually I'll do that because all of those are the same I think there are a couple of footprints here that I'll be using tandum capacitors such as this one right here the C3 a second yeah C3 here and C4 those

**2:17:18** · are going to be Tander capacitors so I'm going to leave this aside for this multi select I'm going to go for all the small ones I'm selecting them all using the shift key and my mouse and then using the command key or control in Windows I will unselect all those capacitors that I will be assigning to tunder room components so the 10 use also the 4.7

**2:17:45** · use I'll exclude those to and I'm just looking at my notes now believe yeah everything else is okay to go with a 0805 2012 metric footprint all right so having those selected then I'm going to go to the footprint libraries on the left side and look for capacitor SMD and

**2:18:08** · on the other side you can see my filters here as well are such that when I click on a library on the left side only the components that are part of that Library appear on the right side if I un select this filter can see that the options

**2:18:25** · available uh multiply because everything now is available so play around with those filters so that you can reduce the number of items that are showing in the right side just to make it easier to find what you're looking for just a little Annoying that it's just not very easy to see when a filter is selected there is a faint blue border around it

**2:18:47** · to indicate that it is selected okay so now I'm looking for all 805 you can see there's much smaller ones like o201 and so on so I've selected the capacitors that I want to apply the association and I've selected the footprint that I want to associate these capacitors with the 0805 2012 metric and I'm just going to

**2:19:09** · double click and you can see that they've been assigned you can also not going to do it now because uh my release cited one uh version of my kick at 9 instance crashes when I do that but if you want to see exactly what you're assigning to you can select the footprint and then click on this button right here to view the selected footprint and that will actually bring it up in a small editor window let's now do a multi select for the tandum capacitors and uh for this I'm going to

**2:19:42** · go into capacitor tandum SMD I'm going to search using the filter here because I've have installed a specific capacitor footprint that I found and that's the T4 91a and I believe that the capacitor is

**2:20:00** · somewhere down here right in here so this is the footprints that I imported and you can see in my library's Footprints the footprint that I've just selected is this one right here double click on that and assign it and I am done with the capacitors next let's do the resistors resistors

**2:20:24** · things are a little bit easier because I'm going to be using the same footprint for all of them so do a multi select across all of the resistors and then go to resistors SMD remove that from the filter and I'm looking for 0805 again metric this one double click

**2:20:46** · and I've done the multi- assign okay let's see what else remains to be assigned I've got the two connectors here the four and the five pin connector for the four pin connector I will go into kets connector pin header Library just going to go for the standard 2.54 mm pitch so that it works with standard connectors and this is going to be a just going to search in here just to use the filter 1X 04 so that narrows

**2:21:19** · down the options that I have have and I can choose any of those but I'm going to go for the regular 1 by 04 2.

**2:21:27** · 2.54 mm vertical double click done and I'll do the same for the 05 so the one with the 5 pin and I'll go for vertical as well right done with the connectors next up we've got the test points here the test points are just pads essentially so I'm going to go to test

**2:21:50** · point library right here remove the text from the filter and let's see lots of options here I am going to go for a reasonable option which is say a 1 mm pad just going to search for 1.0 mm and

**2:22:08** · all of those have got a 1.0 mm in the name just going to go for this one all of those are going to have the same pads so double click on that single pad and I'm done and I think that that is it with the associations it looks like all of the symbols have Associated

**2:22:27** · Footprints I'm just going to do a visual inspection just to make sure that I have all of the footprints that I want if I make a mistake of course I can always come back if I see in the actual La out editor that I don't like a particular Associated footprint I can always change it the process is very quick and easy in in modern versions of Kad it's not hassle like it used to be in earlier versions it all looks good so I'm going to click down here on Save schematic and

**2:22:57** · continue and click okay and we're done you can see down here that I've got a Search tool enabled which you can show or hide from The View panels menu right there and you can see the associations here as well and you can click around the schematic head double pan to the

**2:23:17** · appropriate location to show you the symbol that you've just select and let's continue with the validation and error checking and to do that we'll use the ERC which you can invoke by clicking this button right up here on the toolbar electrical rules check you can see down here that we've got errors warnings and exclusions there's a few ignored uh Che tests that you can see

**2:23:42** · right here and these are the defaults I haven't changed anything let's see what comes up I'm going to run the ERC you can see I've got four errors and a few warnings here and there's a few ignored tests as well I'm going to ignore the warnings for now and have a look at the errors just unchecked warnings just to clean up my list of violations and

**2:24:07** · errors you can see the effect I want to deal with those first and then I'll see if there's anything that actually need to do with the warnings going to click on the first one and see what comes up right so you can see as I'm clicking on on items in the list the schematic editor pans across to the location of the issue so the first thing has to do with uh J1 it says pin A4 is a power pin

**2:24:33** · that is not driven by any output power pins Okay click on the component double click on it actually and go to pin functions you can see that pin A4 this pin right here is marked as power input I've connected it to the vbus net but that doesn't really tell Kat anything about what kind of net that is and because Kad expects due to the

**2:25:05** · electrical type of this particular pin that this is going to be a Power Pin and need somehow to tell Kat that I've taken care of that situation and vbus is actually a net that conveys power I did it in one of the other that's I'm just going to show you here right here VSS I had the same issue and I actually preempted this error message from Kad by

**2:25:28** · including the power flag but I forgot to do it in this instance here so what I'm going to do is to Simply duplicate the power flag symbol command D or control D and I am going to connect it say around here place it there and then connect it to the vbus net and rerun the ERC and

**2:25:49** · that should yep take care of that so three errors remaining next one that's a big one actually I totally forgot to wire pin three in U1 that goes the ground so I'm going to reposition this label I'm just going to place it here right on the junction all right and then for sale this needs to be grounded so I'm just going to copy the ground symbol place it here and wire pin three to

**2:26:18** · ground r thec one error remaining and you can probably figure out how I'm going to fix this as well it's the same situation as the first error that I fixed earlier so I'm just going to again duplicate power flag

**2:26:38** · symbol and flip it and I'm just going to place it here aroundc okay good no more violations let's have a quick look at the warnings so there's a bunch of issues with libraries what K is complaining is that this J2 component for example is using a footprint library

**2:27:04** · with this name that is not included in the current configuration the error message just going to put the window up there so we can see it uh is for footprint B2B pH Etc this one right here the jst connector so that's in here so this library that Kik is complaining about is inside this file but it's still

**2:27:27** · complaining so I know that it's working so I'm just going to ignore it for now and see what happens once I get to the layout editor okay the next one says that the copy of the symbol that I'm using here doesn't match the original

**2:27:45** · Library I don't remember if I've done any changes to it but you can see this is the reference for the symbol have a look inside that symbol using the editor and what I suspect may have happened is

**2:28:00** · that I opened at some point a symbol editor and I did something like maybe moved one of those labels around and then saved it and that caused that discrepancy between the symbol that is now present in the project versus the one in the library and that's why it's complain that there's no match anymore which is fine for me I I don't really

**2:28:22** · care too much about that particular issue so I'm going to ignore it then there's another carrying configuration doesn't include the footprint Library just like the first one next got this issue here of pins of type by B directional and power output are connected it says that pin 8 and pin one are connected so if you look at this ground symbol it's got one pin which is of type power and then dot one andt two

**2:28:56** · can double click you can see that this is pin n and 8 Pin 9 and 8 of type B directional and there's a mismatch that Kik had to warn me about but looking at it after inspecting those pins and how I've connected them I'm happy that there's no issue here so again I am going going to ignore this warning same thing happens

**2:29:23** · here and I'm not going to go through all of them because you can see that the same type of warnings are repeated across the entire list so at this point I can either just ignore click on close and continue with the layout editor or it can also do things such as right click on one of those warnings and Market is excluded you can exclude with comments each time I exclude this violation and choose this command it affects only the a single violation that

**2:29:51** · I've highlighted but if I want to exclude all of the violations of the same type then I can right click and then choose ignore all and that will take care of all of them again I'm not going to do that if you want to reinstate the warnings that you've excluded just go into the exclusion so show them and then you can just remove the exclusion from this violation like

**2:30:18** · this and that will bring it back okay let's close it window and I'm going to save my project and we are now ready to continue with the layout in the layout editor let's continue with the layout editor there's a couple of ways to get there we can go via the project window or we can just click on the same button in the tool in the schematic editor all right here's the totally blank layout editor before I draw the

### Setting Up the PCB Layout Editor

**2:30:47** · footprints from the schematic editor to layout I want to do a little bit of setup first thing to do is to go into the board editor layers and have a look at this as you can see right now by default the project is set up to have two layers but because of the complexity in the size and the number of components on this board it's not going to be impossible but it's going to be very difficult and tedious to make all that fit in a TW layer PCB so what we'll do

**2:31:17** · is make that a four layer PCB via the physical stack up you can see copy layers and now four and then let's go back to the board editor layers and have a look at the settings here in the board layout layers here I can tell kick out the roles of each one of those layers you can see that for most of them the roles are fixed but for some of them the copper layers in particular I can choose a particular role now my plan as you know is to have a four layer PCB where

**2:31:46** · in the first layer I'll be placing the actual components so components will be only on the top copper layer and on the top copper layer I'm also going to have the tracing for the signals I'm going to use the bottom copper layer also for routing signals for the first inner layer I plan to use that as a power

**2:32:06** · plane but to specifically contain a large copper zone for ground so having a dedicated ground plane helps to reduce noise and provides a low impendence return path for signals it also acts as a shield between the top and bottom signal layers and that helps to minimize electromagnetic interference and cross talk for the second inner copper layer

**2:32:32** · this one right here I'm also going to mark it here as power plane and that is going to have a variety of voltage levels above zero so I'm going to have for example a 5vt copper Zone there's going to be a couple of 5vt copper zones and there's also going to be a large 3.3

**2:32:51** · volt copper Zone that will provide power to the various components that operate at 3.3 volts and just like the first in a coupple layer the second one also acts as a shield between the top and bottom single layers so that's good the way it is then physical Stack Up You' already seen what I've done here the only change that I made was to change a couple layers to 4 I'll be using F4 dialectric

**2:33:17** · material for the various layers so the rest are fine as they are for Board finish I'm not going to make any changes same thing with so the mask and paste or good let's continue with other details now this is very important the design rules and their constraints it's important because this actually relates to the reality at the manufacturing

**2:33:41** · floor since I'll be using next PCB to manufacture this board next PCB publishes its capabilities in this page right here you need to make sure that any numbers that appear in the board setup constraints is equal or larger to the relevant Row in your manufacturer's

**2:34:02** · capabilities so I give you an example let's have a look at the minimum track width you can see that here by default it's zero which means that you can according to kard you can have a track that has a width of 0 mm obviously that

**2:34:19** · doesn't make sense so we will need to put a reasonable number in this box but what is a reasonable number so we got to next pcb's PCB capabilities have a look at where this information might be so there's minimum Trace width and spacing that looks what we need there's the number that I was looking for the typical copper weight is this much here for the inner layers and this much for the outer layers my plan for this PCB

**2:34:50** · and the final manufacturing is to have a good balance between the performance and that includes things such as the size for example weight Etc and the cost as much as possible I'll be choosing standard settings for the PCB so you can see here in the PCB quote page I scroll

**2:35:13** · down to around say here you can see outer copper weights the default is one o but you've got other weights as well for let's say Bia boards but the standard is one o the rest will be more expensive so if I go for 1.5 o you'll see that the price goes up and the total

**2:35:34** · would be $70 I got back to one o which is the standard weight for the copper look at the difference in price here a significant difference so I'll be going for one o now for one o the minimum Trace width is 0 .08 mm so that's as slow as you can go and of course if you put that number in here there's a trace width the lower you go the more expensive your board gets so

**2:36:03** · the smaller the width the higher the cost in my case here I'm going to configure the PCB Editor to use a minimum Trace width slightly higher than the absolute minimum that the manufacturer is capable of I'm going to put in 0.2 mm I've done similar type of

**2:36:23** · research to fill the rest of the numbers and to save a bit of time I'm just going to go ahead and finish up with this work just going to okay so this is fine as it is next continue with the pretty fine sizes going to add a few tracks vs and differential pair sizes that that I'll be working with frequently so just click on the plus button here to add the sizes so only need to type in the number and the millimeters is in so I'll be using 0.2 0.254 I'll be standardizing most likely

**2:36:56** · around 0.2 and 0.54 mm so the rest are just extras that I'm probably not going to use for the vs and finally for the differential pairs I'm going to have a couple okay so that's it with the board setup teardrops I'm going to leave it as it is for the length chaining patterns I'm going to make a small change here because of the sizes of the tracks that we'll be using I'm just going to make that amplitude a little bit smaller or half to be more

**2:37:27** · specific and for the spacing also half same thing for the differential pairs can make it one 0.15 and one the last and most important item

**2:37:43** · to look at in the board setup is the net classes as you can see right now it's empty and if I try to add net classes it's not going to work because I haven't imported anything from the schematic editor into the layout editor so the kick layout editor right now has no clue as to what the various Nets are got a couple of ways to deal with this issue the first way is to just cancel out of

**2:38:09** · the setup window and then go into the layout editor and import the footprints and everything else that's associated including tracks and Nets from the schematic editor and then I'll be able to go back in here and continue with my net classes and net class assignments setup but the other way that's actually my preference is to go back to the schematic editor go into the setup and set up the net classes here and then when I do the import of the schematic

**2:38:40** · data into the layout editor all that information within the classes is going to come across as well and then on the layout editor the only thing that I'll have to do is to set up the various sizes as you can see here for each one of the net classes and the advantage of doing that is then when I start to design any tracks that belong to each of these net classes they various geometries for that

**2:39:06** · track will be inherited from whatever I've set up in the net class right here so that's a right way to do it in my opinion so I'm going to go and do that now the first thing to do is to set up the net classes up on the top side and then assign Nets to the net classes I'm going to have a lot of net classes set up here I'm going to fast forward this bit so you don't have to bear through all of my

**2:39:40** · typing so I've completed the setup of the net classes so you can see I've got net classes such as 3.3 Vol and 5V USB and ground that have to do with power and there's others that have to do with signals such as SPI sensor data gpio Etc

**2:39:57** · because I like what my schematic looks like just got these new net classes to inherit whatever settings such as wire thickness bus thickness the color and the line style of the default net class so I'm going to move down to the bottom part of this window and do the assignments of Nets to net classes the assignment operation uses regular expression like Expressions say that I want to set up the net class assignments so that this net the plus 3.3 volt net

**2:40:29** · belongs to the 3.3 volt net class the way I do it would be to be literal and just say plus 3.3 volt and you see that there's a match here that belongs to the 3.3 Vol net class another one would be the 5 Vols got a couple of 5 volts actually got the plus 5V net here and there's also the 5V bus this one right

**2:40:56** · here this plus 5V net will be a member of the 5V USB all right so I've got all the net class assignments that means Nets to net classes and now that I have the net classes I'll be able to go into the layout editor and set up the net classes there in terms of the geometry of the track after I import the data from the schematic to the layout editor let's go

**2:41:26** · ahead and import the schematic into the layout editor so in the layout editor I'm just going to click on this button up here in the top two bar update PCP from schematic and let's see it says it's found most of the components

**2:41:43** · but he hasn't been able to find a few Footprints here wonder if this is a issue related with what the ERC showed in the schematic editor okay I may need to reassociate these components but I'm

**2:41:59** · just going to ignore it for now and drop all the components here because I want to just finish up with a setup so I'm here in the board setup net classes you can see that all the classes that I set up in the schematic editor are now available in the board setup in the layout editor here's the assignment ments and the classes up on top and what

**2:42:22** · I want to do now is to populate this table with actual numbers so each one of these classes will have its own setup for clearance track withd vsis and Etc once I do that I'm going to go back to the schematic editor and sort out the issue with the missing Footprints here in the board setup I'm just going to populate these numbers start with a 3.3 volt and work my way up

**2:43:12** · here I've completed the setup of the net classes and the main thing to notice here is that I've spent some time figuring out what the appropriate especially truck widths and the sizes and holes should be the clearance is also important in order to avoid things such as cross talk now the they might be wondering why I came up with these numbers there's there's two things in play here one is I know that any track

**2:43:38** · that conveys power requires a larger truck width than tracks that convey signals because there's a lot more current passing through a power power track versus a signal track so you can see here that the 3.3 volt track width is 0.5 mm versus for example an SBI track which is 0.3 or USB data at

**2:44:03** · 0.25 mm and actually when I am drawing the tracks in the editor you'll see that in particular for the 5V USB track I'm actually going to make it much bigger manually than what I've got in the net CL here depending on how much space I

**2:44:22** · have around the track kindly try and design it so that the 5V USB track is as large as possible another thing to notice here is that I've set those numbers especially for the for the width from experience now if you want to be more precise in how you set up your

**2:44:42** · tracks you can use the calculator so go to the calculator tools and one of the tools here you can see is the track width and you can sum up the the maximum Cent draw from all of the components on your board let's say that it is say 1.5 amps and then let's say the conductor length would be say about let's make it 15 mm and let's say that for a let's say 5 mil thickness track

**2:45:16** · the track width should be 0 14 mm this number relates to external layer tracks remember that most of my power tracks are going to be internal so if I apply the same numbers to an internal track then you see that the track width for the numbers that I've selected goes to 9 mm my estimate is that this board would draw a maximum of around 450 milliamps

**2:45:48** · so that number here would be 0 point let's make it 0.500 amps and that would be the draw when the esp32 is its maximum performance the BM 280 doesn't really draw much the max 4466 would draw about 0.6 milliamps and

**2:46:08** · so on and let's say that the LEDs are also working all together at the same time so that that would get the board Carro to about half an amp so for for that half an amp the track width would be 0 mm for an internal layer okay so I

**2:46:26** · keep that in mind when I do my drawing and also one important reason for using an entire layer in my case the second layer of the PCB for power purposes is to be able to provide enough power to any part of the board that's needed without the use of tracks we'll be using entire copper stones to provide Power but anyway if if you are curious and you want to know how to precisely calculate

**2:46:56** · the width of particular truck that is used for a particular purpose then you can come and use a calculator here okay so we've got the net classes all set up now the next thing that I need to do is to try and figure out what's happening with those missing Footprints remember

**2:47:15** · there are a bunch of footprints here that kick out was unable to find so what I'll do is go back to the schematic editor and relink those missing Footprints in my previous attempt to import the schematic data into the layout had partially succeeded got a bunch of footprints here but several Footprints they important ones actually are note here if you remember when I did the import and I'm just going to go ahead and do it again you can see that I've got errors down here there's a few

**2:47:46** · inputs that kit cat cannot find paint the footprint for and I spent a bit of time trying to figure out what that means and why and I think I have figured it out I have exported the report from

**2:48:01** · the import tool in text so that I can have it handy so let's go back to the schematic I'm just going to put the report here and let's have a look at the associations tool I didn't realize it at the time but I do now and maybe that's just a new feature and at n that I haven't seen before or maybe it didn't click as I was doing the recording but see how these items are highlighted with the different color background these are pretty much the errors so for example here one cannot add MK1 because this

**2:48:35** · particular footprint is not found you can see that MK1 is highlighted and so is q1 right here there's q1 and so on so I incorrectly assumed that these Footprints were already associated with symbols correctly and that is true

**2:48:54** · because when I downloaded the symbols and Footprints from snapa the associations were already set but the way that the associations were set and the paths with set in The Originals was that symbols and Footprints would be in the same directory but what I've done in my project directory is that I've got them separated here are the footprints all in the same footprint directory and

**2:49:20** · here are the symbols all in their own symbols directory and of course these pre-existing associations broke down let me become a little bit more specific let's go into MK1 I'm just going to search for that so view panels search search for symbol MK1 click on it and

**2:49:42** · that's a microphone K will take us straight there I double click on this symbol to bring up its properties actually I won't do that I'm just going to use a side panel here all right so you can see in the side panel that there is a library link going to this place here which I can't edit but I also want to have a look at the footprints which is not showing in the side panel so here is a footprint the problem is that this footprint is not correct okay it's changed so I will need to re link the

**2:50:14** · symbols with the footprints and there's a couple of ways to do that the first way to do is to do it manually for each of these components so since I have my MK1 opened just going to click on the library button here and that will take me to the footprint Chooser and in here going to go into esp32 project Footprints which I configured at the beginning of the project and I'm looking for cui CMC this

**2:50:40** · footprint right here click okay and now I have the correct Association click okay save and let's go back to the layout editor and import the entire schematic and see what happens with the specific component MK1 all right so MK1

**2:51:01** · has now been eded see updated right there I've got to do the rest I'm just going to leave it here all right let's continue and do the rest now but instead of doing them one at a time I'm just going to go into the symol Chooser and from the left side here I'm just going to s select the projects Footprints so right here is32 project Footprints and let's go and do this substitution one by one so first SS 5240 that double click edit next is the

**2:51:33** · B2B pH sm4 TB double click to commit it next is gstd 090 this one right here double click this set it next to EMT trans T EMT

**2:51:49** · that continue that's the two buttons switch us lpt to of those for both buttons next is the bme280 and the package is PS n65 this one next is the esp32 module this one next is the

**2:52:09** · Silicon Labs qfn 20 I'm going to come back to the qfn 20 in a moment because I'm going to use one of the Kat inbuilt libraries for that next up is uh this one here is so 127 that next sort

**2:52:27** · 65 and finally the um regulator it's this one MPX 3.3 all right the last item in the list is the serial T USB interface chip so that package dfn for this I'm actually going to go into the kiat light liaries and relink it there so that's package dfn let's see dfn qn

**2:52:55** · let's enable these filters as well the one that I'm looking for is the qfn 21 ep3 by3 and making sure that the dimensions are correct 0.5x 1.8x 1.8 mm that's the one so

**2:53:14** · double click to link it now all of them are properly linked so apply save and continue and click on K save the project and go back to the layout editor and let's repeat the process once again and that's it I've got everything

**2:53:35** · imported so close and there's my additional components I'm just going to put them here for the time being now that I have all of the components imported into the layout editor I'm just going to to do the placement and after

**2:53:51** · that I'll continue with the routing all of the components are now in the layout editor so the first thing to do is to work out a way to combine these components together in a way that resembles the final layout of those components on the Ford now what I'm going to do here is to follow some guidelines that just press if proposes

**2:54:13** · for the esp32 module that I'll be using which is uh this component here with the integrated antenna and then I'll be following some more General guidelines as to how to place other components in association with the esp32 which is going to be a central component everything is going to depend on the esp32 and its position aside from those two items the third guiding principle

**2:54:38** · that I'll be using here is the placement of the various components that the user will be interacting with such as this component here which is the SD card module obviously you want it to be at a location on the board that makes it straight forward for the user to insert and remove SD cards so you don't want to

**2:55:01** · put it right in the middle of the board and there's a couple of buttons right here you want them somewhere on the board that makes it relatively simple and easy to press them with your thumb or your index finger there is a USB

**2:55:16** · module you want to play place that component somewhere that makes it easy for you to insert the USB cable and attach it to the board and there's a few other components that I would call them as user interface components including things such the LEDs you want the LEDs to go somewhere that it makes sense so you put the Power LEDs for example near

**2:55:37** · the USB connector so that it's easy to see that the power has been applied when you insert a USB cable so these are the general principles that I'll be following to uh guide me through the component placement process in the next few minutes I'm going to drag the components and place them on the board in the

**2:55:59** · generally final positions I may do some fine tuning a little later but as far as the location of each component pretty much where I drop it is where the component is going to stay one more thing I should mention before I start dragging the components uh and start the placement process is that I've already had sever runs of this each time that I did a draft placement I just improved on

**2:56:25** · the previous one so what you're going to see is the final configuration of the PCB which I find quite good and meets all of the three criteria that I mentioned earlier I'm just saying that so that you know that it's okay to iterate through versions of placement before you start doing the routing of the tracks so take your time here because it's very important to get this right especially if you start with the

**2:56:52** · routing and then you realize that placement is not good you are going to have to undo a lot of work whereas if you take your time to go through a series of versions for the placement of the component until you reach a final version that you are happy with it's going to make the routing much easier and it's going to decrease the risk of having to undo and redo a lot of work

**2:57:18** · now I want to show you a couple of sources of information that guided me with the placement process one of the data sheets that I've got here is this one here from Espress if it talks about the physical dimensions of the module the module that I'm using is this one here there's another version that doesn't have the PCB antenna instead it's got a connector here that has fewer requirements so when it comes to the placement but since I'm using this one here the one with the built-in PCB on

**2:57:48** · antenna I need to pay attention to what expressive recommends down here there's another interesting section uh section 11 that talks about the PCB layout recommendations and there is a link here module placement for PCB design there is a reference to this online resource that

**2:58:08** · is this page right here and here you'll see PCB layout design click on that and you'll see recommendations from espresso I I incorrectly applied a few of those variations so for example my very first version of the PCB was something like this like a rectangular PCB with the esp32 right in the middle top Edge and my thinking about that was that this way there will be a lot of space around the two sides of the module to Route tracks

**2:58:40** · in and out however as you can see the tick mark is on position three So the antenna is away from other components and that puts a bit of restriction on the pads on the right side of the module another approved position is position number four so the other corner there's another couple of options here if a feed is pointed on the left side then positions one and five are approved I

**2:59:05** · kind of didn't like any of those options because the PCB antenna part of the module was sticking out too far and I was worried that it's going to break or interfere perhaps with the Project Box that I'm planning to design as well luckily there's another recommendation that is press F offers and that is this one here so there is a cut out of the board and then you can put the esp32 kind of in the middle of the board

**2:59:34** · and the interference is avoided because of the space that is allowed on either side of the antenna and you've got the dimensions there as well so that was a bit better what I decided to do eventually was to go for a combination of the two both having the module on one of the edges I chose the top right Edge as well as having the cut out especially the space here between the board and the

**3:00:04** · left edge of the antenna that you can see right here and that would give me the best of both worlds having the module on the right side and enough space from the PCB itself to diminish any potential IND experience so that's what I went for now what you see here is the final version of my PCB layout the

**3:00:26** · one that I'm about to start designing here and it's also the one that is being manufactured right now and you can see the other elements that I mentioned earlier you've got the microcontroller on the top right side then you've got other components with which this microcontoller unit needs to interact at a relatively high speed so I've got the flash memory and the SD card very near

**3:00:50** · the MCU just to minimize the length of the tracks for the high-speed signals there's space around all of these devices for the various capacitors and resistors that are needed for Signal conditioning then I've got the user interface components along the edges so you can see SD card right there easy to access the USB port the buttons the charging port and the gpios All In the

**3:01:18** · periphery makes it easy to interact with those components and there's the LEDs here quite easy to see I've Got The Power LED you can see right here in the regulator area and then the sensors are all together you can see the sensors here I've got three sensors on this board there a microphone the environment sensor and the light sensor having said all that let's continue with the placement most of the time I'll be working with both editors side by side so the schematic and the PCP editor so

**3:01:48** · that there's some clicking on components I'll be able to see what's happening with the relevant component that I clicked on on the schematic editor but now since I'm just doing the placement and I kind of know what these components are I'm going to use as much available space as I can in the layout editor and before I start I just want to check the grid for the PCB editor these are the grids that I'm using you can see for the footprints I'm using 0.025 or 0.98 Ms precision I'll be using

**3:02:18** · the grid overwrites for this so this gives me a lot of control this is a very small grid so I think it's going to be okay for the size and amount of components that I'm going to work with so the grid is enabled let's begin I'm going to start with the ESP sp32 component I'm just going to put it there continue with the SD card place that

**3:02:41** · there you can see that another thing that I can do here actually going to have the two windows side by side because I'm going to show you a really nice trick that you can do when you're doing the placement so you can see that when I click on the component on the one side the same component on the other side is highlighted and vice versa if I click on this component here on the schematic editor you can see that it is highlighted in the layout editor so I'm

**3:03:10** · going to take advantage of this feature it's very neat so what I'll do here is I'm going to select all of the components in the esp32 group so that they are highlighted in the layout editor and that way I can pick them apart and put them

**3:03:29** · together this is particularly important to minimize tracks of course but also in this case it's because for the purpos of signal conditioning and I need to know which capacitors actually belong to the circuitry that supports the esp32 so I put all those together I'm going to not worry about the final placement of those smaller components now but the fact that they are next to the esp32 is all I need

**3:03:56** · for now and I'm going to do the same thing for the SD card highlight the SD card components in the schematic editor that picks them apart in the layout editor so now I can put them all together just put them side by side and I know that it will be easy to figure out which component goes where when I start focusing on these

**3:04:23** · components and this smaller bits and pieces in their vicinity all right so that's done let's go for the flash memory because the flash memory circuitry as I mentioned earlier is going to be going for a placement near the esp32 so these parts make up the flash memory circuit Tre just uh put them together that I'll place it here next I'm going to go for the USB

**3:05:15** · module so now that I have the approx location of the components I'm going to draw a box that will start resembling what the outline of the final board is going to look like let's go to Edge cuts and because I'm going to have a cut out here I'm not going to use the box of selected Edge Cuts here normally I would just take a box and enclose the components in the box like this but the Box doesn't allow me to have that cut off here so instead in I'm just going to use a line tool so I'm going to start

**3:05:48** · down the bottom just making sure that there's enough space on the side of the esp32 to be able to draw tracks a little later on you can see my grid size is 0.05 I'm actually might actually make a little larger 0.1 mm and disable the

### Component Placement and Board Outline Refinement

**3:06:08** · override so that I can actually draw at that size let's pick up the line tool and start drawing actually going to go less I'm going to go for 0.25 mm because it's very difficult to draw straight lines on very small grid I'm using my side to side cursors

**3:06:32** · here to help me with the drawing actually before I start drawing I just want to remind you what I'm trying to do so I'm going to make sure that there is no PCB below the antenna and that there is a minimum of 50 15 mm on the left side of the antenna start drawing here straight line up to this point then I'm going to click right

**3:07:01** · here and to make sure that I've got 15 mm clearance I'm going to hit this space bar on my keyboard to zero the numbers down the bottom you can see DX and Dy and from here I'm going to go for another 15 mm you can can see that the cursor also tells me how far from the previous click I've gone so that's now 15 mm I'll give it a little more let's make it 16 that's it and then I'm going to go

**3:07:36** · up and then continue towards the left I'm going to go up to here because I've got a lot of empty space in this board so I'll be able to make the board a little smaller I'm not going to commit to anything though but I'm just going to stop the drawing say at 90 mm and

**3:07:56** · continue drawing down I want to make sure that I don't go too far down so I'll zoom out a bit make sure that I go up to the point that I started the drawing at the bottom right corner of the SD card so around here that's it and zoom in to close the line you can see that ker tells me that I've got a close line because it puts a circle around the point where the two

**3:08:26** · lines meet now I've got a board I'm not going to spend any time here to refine it I like boards with circular edges look modern and pretty you know attention the detail but I'm going to worry about rounding the corners later once I've committed with the placement of the components and and I know that that's where the components are going to be sitting permanently just going to make sure that everything fits by moving a few things

**3:09:00** · around and just drag that to the left like that and I have to do the same with this line I'm going to bring this set of components inside as well do the same here make sure that everything is inside and then I'm going to start with the refinement okay so that is the first

**3:09:28** · pass of the component placement I have set the main components in the approximate locations where they're going to end up being anyway and then all of the other smaller components especially the resistors and the capacitors are nearby the components

**3:09:44** · that they support but I'm going to be fine-tuning them later with their actual positions and I'm going to be doing that next so my objective is primarily to make sure that any signal conditioning component and that is resistors and capacitors are in the appropriate locations for the main component that they support and only after I do that I'll be able to finalize the board layout and then I'll start with the rating so now that I've placed the components where they are most likely

**3:10:16** · going to end up on the board and I've got the rough outline of the board I'm going to concentrate on the smaller components and specifically the capacitors and the resistors which play a significant role to what's called signal conditioning signal conditioning involves the preparation of the output from the various components such as the BME 280 the sound sensor or even the

**3:10:40** · esp32 microcontroller itself to ensure that these signals are suitable for usage by other components so for example signals coming out of the esp32 to the SD card radar need to be conditioned to make sure that the SD card radar is receiving actual correct

**3:10:58** · signals this preparation might include things such as amplifying weak sensor signals for example coming out of the sound sensor to match the input range of the esp32s ADC the analog digital converter or filtering out noise to

**3:11:13** · improve signal Clarity and converting signals to compa voltage levels in our project most of the signal conditioning that we do has to do with filtering out noise but also we'll be doing amplification in the case of the analog sensors before I start manipulating any of the components on the board and just putting them in most likely their final positions on the board I just want to talk a little bit about the work that

**3:11:42** · I'll be doing and why I'll be doing it things that I'm about to briefly talk about and not things that you'll find in a component data sheet so I'm going to start with the capacitors first you can see there's plenty of them and here's a few examples here that relate to the esp32 these capacitors serve several key

**3:12:01** · functions in single conditioning we've got decoupling capacitors which mitigate power supply Noise by providing a local source of current for integrated circuits and here's one example this particular capacitor here and its counterpart right here we are going to place those as close as possible to the power pins of the integrated circuit to minimize Trace length and inductance smaller capacitor values such as 0.1

**3:12:30** · microfarads should be placed closer to the Power Pin than larger ones this Arrangement effectively handles high frequency noise and switching transients we also have bypass capacitors which offer a low impendence path to ground for ac6 signal and those filter noise and prevent interference with sensitive circuitry and we position those near the

**3:12:54** · component that requires protection on the signal path side ensuring clean signals so I'm going to talk more about those in a moment there's also bulk capacitors that act as charge reservoirs stabilizing the power supply by smoothing out voltage fluctuations and we locate those near the board power supply so you'll see a

**3:13:16** · couple of book capacitors down here we've got the USB C connector and the battery connector there's also resistors we use pull up or pull down resistors to establish defined logic levels on Signal lines when they're not actively driven and we place those near the input pin of the associated integrated circuit connected directly to the appropriate voltage Rail and we use such resistors

**3:13:43** · in this circuit in the I qu C interface lines there's also filter resistors which work in conjunction with capacitors to form low pass or high pass filters and the precise placement is crucial for the filter's Effectiveness and requires careful consideration within the filter circuit design and of course you probably know about this there's also current limiting resistors to protect components such as LEDs by

**3:14:08** · restricting current flow in each one of the LEDs here have a current limiting resistor now I just want to be a little bit more specific about how I use those components especially the resistors and the capacitors in this circuit just want to show you a couple of examples let's go to the esp32 module and right here if I search for C8 you'll see there's a C8 capacitor

**3:14:37** · right here this is this smaller device right here so this is a decoupling capacitor we're going to position this capacitor very close close or as close as possible to the 3.3 Vol pin yes as close as I can and then later on we're going to draw a track that connects pin one of the capacitor to pin one of the esp32 module you can see how close it is right there in addition to the C8 capacitor there also the C7 just

**3:15:09** · going to rotate that and place that as as close as possible to C8 and that's there to further reduce high frequency noise so the combination of these two capacitor values and the close proximity to the esp32s pin one which is where the 3.3 volt goes ensures effective decoupling across awide frequency range now let's have a look at another example here is u4 this is the USB to serial

**3:15:40** · bridge and it also requires a decoupling capacitor so here in the schematic you can see C11 is a decoupling capacitor that is connected directly to the vbus pin and it's this capacitor here if I move it just to see where the rut nests

**3:15:59** · go you can see it's going to zoom in here's vbus here is the vbus net as well I'm going to place that as close as I can this positions are subject to change as well a little later because one of my other concerns is to minimize the length of of routes and to minimize wires Crossing each other so may need to rotate the main components as well like in this case the USB Bridge or u4 like

**3:16:29** · this so depending on which final orientation the USB bridge and other chips have on the board I'm going to have to adjust the location of the smaller components but let's say this is the PIN 8 right here I'm just going to rotate this a little more so that it has this orientation so there is pin 8 vbus and let's say that this would be the final position for u4 I would Place C11

**3:16:57** · like this so then it would be just small track to connect pin 8 of u4 to pin one of C11 so that's another example of how I would do placement here another example worth mentioning here are the input and output capacitors for the lipo charger so the lightboard charge um

**3:17:19** · search for U1 so here's U1 you can see the schematic as well there's a couple of capacitors here or there is one capacitor to be more exact there is the input capacitor C6 which I've just clicked on and it appears here as well and you can see that there is a + 5 Vol

**3:17:41** · USB net which is supposed to connect to pin 18 right there you can see the r Nest as well so to make that easier to Route I'd rotate the main component like this and the capacitor like this and now you can see this there's multiple USB pads on U1

**3:18:05** · but I would take one of those and connect it as close as I can to the capacitor C6 like that that would minimize the length of the traces the next thing I want to show you are a couple of resistors these are the pullup resistors for the SD card the SD card is

**3:18:27** · right here clicking on that brings the schematic or Focus the schematic on the SD card and you can see there is an example of a pull-up resistor this is r19 and it's this one right here and it goes in between the cssd pin which is

**3:18:46** · pin number one on the SD card module and the 3.3 volt I would connect that play set like this very close to pin one of the SD card now another thing that is important

**3:19:04** · to consider that has got to do with routing not with positioning of components has to do with routing for SBI signals in particular so the SBI signals that are connecting the esp32 to the flash memory and the SD card need to be routed using bus topology in such

**3:19:25** · topology a single continuous Trace connects all devices so having said all that I'm going to now start moving things around and positioning the especially the passive components to the Final locations around the main components and then once I do that and have all that fixed I will remove all m

**3:19:46** · dis Space by tucking components closer to each other if you are curious about some more specifics about highspeed layout guidelines that cover things such as transmission lines and cross talk and return current and loop areas Etc have a

**3:20:02** · look at this guidelines document from Texas Instruments that covers a lot of the topics I find very interesting these are things that you don't find in other data sheets and you don't find in most books actually or tutorials find it having a quick look at this document at least will give you some Basics or some basic understanding broad guidelines on how to do all of the above that are mentioned especially for high speed

**3:20:28** · designs much of what is in this document is a bit of an nooc kill for the board that I'm designing here but many other bits and pieces such as for example how to draw traces vs actually are very relevant so look for a link to this document in the description below the video video let's begin with the refinement I'm going to start from the right of the board and work my way towards the left first with the esp32 I'm going to use this dual Window mode

**3:20:59** · so that I can see what I'm working on and the components that relate to the main component that I've clicked on here I've clicked on the esp32 module and you can see the components that are around it I'm going to be starting with the capacitors to position them and then with the resistors so I'm going to place C8 right there right next to the

**3:21:23** · 3.3 volt pin and actually one thing that I want to do is to make the rats nest a little bit more pronounced because I think they're very thin and it's just barely visible so let's go into kick it settings the rat nest's align thickness to let's make it one and see what that looks like a little better I'm just going to make it a little bigger because of so many it really helps having ratest e to see and I'm

**3:21:51** · also going to change that to curved lines I'll make it a bit thicker let's go to Callis and look for rist I think this color kind of Blends in the dark background so I'm going to make it green striking all right there you go now this can't be missed all right so this is a good good spot for C8 C7 I'm just going

**3:22:20** · to move it here then I'm going to go for our 15 move that out of the way so this is R 20 just move that here for a second R15 I'll oriented like this you can see that goes near pin six and then R2 that

**3:22:40** · can kill it right there or yeah I want to a little bit of symmetry as well so I'm going to make it like this another thing that I've done just now is to click on this rut Nest button

**3:22:56** · and enable a mode where only the rut nests of the component that I've selected appear and that just reduces clutter significantly and then one last thing that I do as I go is I'm going to move the labels oron so they're not overlapping let's change the filter for this can select text and now that I've got text I can move these values appropriately what I'll do as well just to reduce clutter

**3:23:27** · is I'm going to make all these disappear so here you can see that the value appears the value uh text 50 yeah I'm going to make those disappear as well but I'm going to do that across all of the components so that the values don't appear at all going to double click to see which layer this comes on so the value appears on and on the ffab layer

**3:23:50** · so what I'll do I will click on F Fab and make the disappear all right that's better now 20 this is in the front silk screen so I'm just going to change the color of the front silk screen so that it's easier to see I'm just going to make it kind of yellowish like this that's it

**3:24:14** · with the esp32 let's continue with the SD card now so click on the SD card module and see what we have I'll start with the capacitors as always so I've got C12 and C13 C12

**3:24:31** · just going to move R6 out of the way for the time being and so C13 so I've selected local rust Nest by clicking on this button right here so again that allows me to see the r nists for the selected components here's a r nist for C13 place that very close to

**3:24:54** · pinch 4 and three of the SD card that's great and let's go for 12 flip that and I'm going to place like that right next to C13 and move its label up there the plan here is eventually even though the r nests are directing my attention elsewhere so you can see that there's pain 2 on C12 and pin 6 on the SD card

**3:25:20** · module what I've got to do is to connect those two together and this R Nest line will be satisfied so I've got these two capacitors sorted then let's do the r19 pullup resistor which actually I've done it already so that's done and then let's go for R16 so R16 I'm going to connect

**3:25:41** · that or place it probably here place it here like this you can see here that the missile line starts right there on the esp32 module and then it goes to this resistor and then it continues to travel elsewhere remember I'm going to be using a bust appology for the SPI now that I have sorted out the peripheral components for u3 and j3 what I can do is to remove

**3:26:12** · this empty space by dragging the SD card and its components slightly up higher and that would release that space down here I didn't want to move the u3 component down because I've already taken a bit of time to do the drawing here for the cut out of the board so I'm actually going to select this bundle of components and lock it in place and I'm going to do the same for the SD card I'm

**3:26:44** · going to lock this in place because I'm pretty happy with this configuration all right now I can move this line up a little this L can go up to here and that's starting to define the final shape of the board next I'll continue with the flush

**3:27:05** · memory and I'm also going to move the test points out of the way as well I'm going to do those last because the specific location of the test points is not really important I'm going to put the test points in appropriate locations once everything else has been positioned let's continue with U6 which is the memory so U6 has got a capacitor here which is c14 the orientation of U6 is fine as it

**3:27:33** · is so no problems there just going to move that out of the way just going to place the U6 component a bit closer to the board just to minimize the track length c14 you can see is uh the coupling capacitor for U6 I'll place it near pins 3 and four so you can see the traces will be minimal here even a little closer would be good so down with c14 then I've got R22 which is

**3:28:04** · missile so R22 will be connected to pin two so rotate and I'll position it here so from here I line will go there and then this positioning it would be minimal distance to travel to pin 16 So the plan here is

**3:28:24** · that from pin 16 I'm going to do the routing so that the signal reaches the SD card module first since this is closer and then it will travel to the flash memory so this position for R2 is good and that's it with these two components so I will select them and tuck them a little bit closer to the other two two components say around here and I'm leaving enough space up here for tracks to travel from the left side of the board to the esp32 I'm not going to

**3:28:57** · lock this component in place but instead I am going to group it together so now if I want to do something with it if I need to move it for example just by a little to make room for traces I can move the entire group of components together instead of one component at a time I can always ungroup it if I need four whatever reason let's continue with the environment

**3:29:40** · sensor I think I've just noticed an error found this resistor R30 that both pads are connected to ground and on closer inspection yes that is true you can see R30 goes from ground then up

**3:29:55** · here towards pin three and then there's another wire here taking it down to ground again which is obviously not correct this is something that I didn't notice earlier and the ESC of course didn't notice it it can't make inferences like this maybe later with artificial intelligence plugins to kick it will be able to point out that this

**3:30:15** · doesn't make sense so this obviously a drawing issue that I didn't notice earlier so let me just fix it really quickly this is a good example of what can happened during a live design session what's happened here is that okay this is correct however this line here is not correct I'm going to delete it and move this

**3:30:36** · ground right there actually move it a little bit further just to make it look a little nicer now I've got the ground of the microphone going to ground I've got the second pin of r29 going to ground and I've got R30 10K also going to ground but one

**3:30:55** · thing that I don't have is an extra capacitor here a need capacitor in between R30 and ground which I also totally forgot so let's do that there's going to be a one U capacitor going to add a new one so capacitor just a regular capacitor I'm just going to put it here change its name this is going to be c19 and its value will be one

**3:31:25** · microfarads and let's put it in place move that save and now I need to import c19 into the layout editor so save and then import updated PCB okay no foodprint assigned of course so let's set a footprint let's go to the associations editor and here's a footprint that is missing you can see I went to C8 then to 20 it just missed one

**3:31:51** · capacitor it's going to be the same type capacitor as the rest for the footprint so capacitor SMD just going to search for 0805 metric like the rest all right save

**3:32:08** · go back to the layout editor and update the PCB cool and here's the capacitor was missing well this is uh very unusual but it does happen and it did happen during my recording which is great because I was able to show you how to fix a forgotten component like this very easy as you can see in Kick at 9 got R30 here

**3:32:32** · and c19 these two work together and because there's a capacitor involved I'm going to give it a bit more space and bring it a bit closer to the active component the amplifier move that up a little all right so now I've got let's check the RS yeah okay I've got this did together so it's that's in series I've got that going to pin three then from pin

**3:33:06** · two hold on a second I just noticed one more capacitor missing so this supposed to be another capacitor right here and it's another filtering capacitor on the output of the microphone let's fix that I am going to bring up a new capacitor and just put it here for now let's edit its properties so this is going to be C 17 and its value is uh 10

**3:33:37** · nanofarads and that's supposed to go right here in between these two Junctions and let's bring it across to the layout and pretty sure that this is the last Omission let's go to layout editor and import this new part okay no footprint assigned of course I forgot that as well so this is also going to be a capacitor SMD or 805 metric all right save and

**3:34:08** · let's bring it into the layout editor done all right so c17 let's place it here for now so I'm just going to do a bit of work now to tidy up the locations for this network

**3:35:12** · \[Music\] just \[Music\]

**3:35:39** · this is slightly different to my original design where I had the connectors for the gpio on the left Edge but I think that is okay the way it is now it does give us a smaller board in most cases smaller is better but in this case I don't think that we are actually losing anything from the board by moving the connectors on the top side from the left to the top just going to consider one more possibility here cuz I'm

**3:36:11** · looking at the microphone and the mic out is on pin four of this integrated circuit so I'm thinking that another option that I have here is to flip this entire group like this so now the output

**3:36:29** · of this group of components to the esp32 will be out of this pin here you can see it right there so that will make routing a bit easier and it will also allow us to have the microphone which is a relatively large component towards the outside of the board and again you can imagine if this is in a box then you can have the box with an opening on the side here just to allow for sound waves to be captured by the microphone without other components

**3:37:02** · interfering there's still room for changes so I'm just going to save a little bit more space while a minute and I'm going to further refine the outline a little later with rounded corners but for now this is fine as is

**3:37:21** · save that's what the board looks like at the moment all right so the next thing to do is to start working on the routes so I'm going to start drawing routes and copper zones I've got the placement all done so I'm about to start with the routing but before I do that I want to take a few minutes to refine the outline because I think now this is going to stay like this I don't think I'm going to need to make any changes in the future refining the outline simply means in this case to

**3:37:51** · replace these sharp Corners with nice rounded corners and kick at n can do that really really quickly as you're about to see another thing I'm going to do is to add a few mounting points I'm going to use up all available space that I have and let's select the edge Cuts

**3:38:09** · layer what I need to do I'm going to show you a really nice trick uh this process of rounding Corners us to be very tedious in the past but now it isn't so I've selected Graphics right here I've selected Edge Cuts okay so I've got graphics selected I'm in Edge Cuts layer so I'm going to type command a or control a to select all of the edges and you can see down here I've got six selected items these are the straight lines that form the outline of the board and I'm just going to right click on one of them go to shape

**3:38:42** · modification and select shampa lines and from here let's say 2 mm you can go like this I guess uh that's that's okay or let's try one of the other shapes shape modification let's try the fillet I go for 2 mm again

**3:39:04** · that's pretty nice actually I think maybe reduce the rounding a little so undo try again shap modification make it uh fill it and make that a 1 mm fillet yeah that's much

**3:39:19** · better that's pretty nice actually I'm inspecting for any issues with overlapping edges or lines and components and looks fine one that didn't work is this type M override look and just move it a little bit to the left this is why this corner was not

**3:39:42** · modified was because it was selected to be locked going to type the L key to unlock it now you can see it's no longer locked so I'm going to select this and this Edge and right click and shape modification fill it make it one mm all right there you go so this would have been done automatically by Kick along with all the rest if this particular line wasn't set to lock but

**3:40:12** · it's fine so that part is done the mounting hole holes I'm going to select mounting holes from my footprints Library I'll make it 2 and A2 mm in size which is a nice size not too big not too small over right lock move that in a little and create a duplicate and put one here as

**3:40:36** · well and then I'll Place one more mounting hole that's enough let's continue with routing now when I say routing I don't just simply mean creating the copper tracks that convey signals and power but also things such as copper zones and then also making a distinction between critical signals and non-critical signals plan is to start by

### Routing and Copper Zones

**3:41:03** · creating the copper zones for the ground then the copper zones for power uh the various voltages that we'll be using including 3.3 volts 5 volts and there's a few other net for example the three bus Nets that I create copper zones for

**3:41:19** · after that I'll focus on the differential pairs then I'll go for clock and highs speeded signals so that means the SBI interface and the I squid C interface and anything that is connected to those interfaces and then I'm going to work on power traces so anything that conveys power that is not already connected to a copper Zone and

**3:41:42** · finally the various other signals that are left I finish all that work I will be doing an optimization one thing that people often do at this point is to use the auto router to take care of the routing in literally just a few minutes but for a board like this I find that the auto router produces of course Resorts that validate through the error Checker but they're not optimal and that

**3:42:05** · can lead to problems with signal conditioning or than you having to spend time to fix what the auto router has done instead of doing the work from the beginning on your own and producing a much higher quality result so I'm going

**3:42:22** · to skip the autorouter and I'm going to go straight into manual routing the first thing that I'll do is to create some copper zones and I will start with the simplest one which is the copper zone for the ground level I've decided to place that in the second inner copper layer so I've selected into. cuu or in Copper from the appearance layers menu and I'm

**3:42:50** · going to now go ahead and use this tool draw field zones and I'm going to draw an outline in a moment so I've got in I need to configure it first I want to connect this Zone to the ground level

**3:43:06** · and I'm going to call it gnd so zones now can have names the rest of the items here look fine as they are and uh is going to be a solid fi I find solid Fields perform better than the option here is a hatch pattern so go for solid fi click okay and then continue to draw

**3:43:26** · and your drawing doesn't need to be that detailed in this case all you've got to do is to enclose the area of the board where you want the copper Zone to be filled then because of the board outline kicker is going to ensure that the zone is fully paint within the board so I'm just going to save that and I'm going to fill the Zone just right click Zone F

**3:43:54** · and now you can see it designed and pretty much implemented so this isn't the inner second copper layer let's continue with the first inner copper layer now just going to click on this button to make the filling disappear so that the board is still readable I just notice actually this I'm going to lock this group like that now if you're wondering just before I continue uh it's okay for these test

**3:44:22** · points to be out here because as I said I don't know exactly where I'm going to put them yet until I start doing the routing so that's why I've got them out here for the time being so I'm now working the first inner copper layer going to start with the biggest 3.3 volt copper Zone which is the one that supplies power everything it encloses the connectors up here the sensors the es32 itself and the 3.3 Vol regulator

**3:44:51** · and also part of the USB circuitry like here I'm going to draw the 3.3 volt copper Zone to enclose these components there's two more zones down here there's one around here for the battery which is going to be the plus 5 USB copper Zone

**3:45:12** · and one more around here which is the vbus copper zone so those are going to be much smaller so I'm going to start with the 3.3 volt First grab the tool for the Zone start designing so around here this is inner one copper layer and

**3:45:28** · 3.3 volt connector to so I'm going to name this 3.3 volts and the rest are fine as they are right so now it need to be a little bit more careful about how to draw this so I'm going to go up to around

**3:45:46** · \[Music\] here continue this includes this area here it includes the buttons and it includes the R32 so I'm going to go inwards like that towards left and after that I'm just going to move in a bit broader terms to finish the drawing because everything else at that point is going to be 3.3 volts let's fill all zones take a

**3:46:21** · look and click on that button to be able to see it going to uncheck everything else I'm going to uncheck into copper zone so we can see the 3.3 volt Zone that I just created right looks good now I'm going to focus here because I'm going to have a 5 volt for the USB right

**3:46:44** · there dedicated and then a smaller one around here for the VB let's do the vs first so I want the vs Zone to convey the VBS level from

**3:46:59** · these pins is B4 A9 A4 and those pens up here number five pen number one Etc and number one from the fuse so this is going to look like this let's pick up the tool again start here there going to be vbus I'm just going to use a filter for this so vbus also going to call that

**3:47:25** · VBS and start drawing and see part of the polyfuse is under VBS and the other part is not let's go like that going to go up this way because I don't want C1 to be enclosed

**3:47:47** · and close it right there and as I was doing that I just noticed that this actually C1 needs to be flipped around because I need to connect pin one of C1 to A9 so I'm going to ungroup and then unlock this specific component and then rotate it like this group these two together again

**3:48:18** · and lock it all right so let's fill this Zone and have a look all right so that's what it looks like and the final Zone that I want to create here is in the battery circuitry

**3:48:37** · and this is going to be the 5V USB bus so take the copper tool this is going to enclose everything just going to create a out of this this is 5V USB and I'm going to call it plus 5 V

**3:48:56** · USB and the drawing as a big box and I want to enclose this part of the polyfuse because as you can see that's on the 5vt net okay let's

**3:49:22** · refill you can just type B to do the refill all right cool that's done I'm going to continue on the front copper layer now because there's a few zones that I'd like to create here these also some tricks that you can use in order to connect pads that are in the front

**3:49:45** · copper layer with zones or tracks that are in a different layer so for example notice this pad here this bus is very important because this is the bus that provides power from the battery to power all of the components in the circuit so you need to make sure that there's plenty of copper to provide enough capacity for whatever current is needed to flow through so I could do this in a couple of ways one way would be to just have a single wire and and then put a VR

**3:50:16** · here and then connect it as you can see to the 5vt layer and K it did that automatically because it knows what net I'm using and where this Nets need needs to connect to so it connected it automatically to the 5 volt USB net in a copper layer but now you only have like a a small tiny essentially copper track and this track it's only 25 mm it's

**3:50:42** · probably barely enough to convey the enough current to power the entire circuit another way to do this is to use copper zones so here's what I'll do instead now let me show you how we can connect a pad on the top copper layer

**3:50:57** · with a copper Zone in one of the other inner layers in this case I've got a poly fuse and I've got an inner layer that I want to connect to you can see that the green zone is the one I want to connect to I'm going to start with the vs going to use vs to do the actual connection so I'm going to start with the vs and then create a Zone to enclose those vs on the top layer uh one thing to do is because we're talking about power here I have selected a larger vs

**3:51:27** · size 0.5 diameter and 0.3 mimet for the hole let's pick the vs tool first and let's drop the first VR here one more here and one more here so I'm going for three vs in this case and each one is going to do its bit to convey power I'll move all three up a little for symmetry like that I can even go a little bit closer next I'm going to pick the Zone tool and start drawing so

**3:51:57** · around here I'll connect that to the 5vt USB net and give it a name so it's going to be 5 Vol bus top there maybe more of these but I'll use numericals then instead of thermal reliefs I'm just going to go for solid and start drawing here and close the pad completely and

**3:52:21** · close type the b key and fill it up and now you can see that there is a really nice connection between this pad and the 5V USB Zone in the inner one copper layer I'm going to continue and do the same thing on the other side for vbus done next up I am going to work with

**3:52:43** · copper Z zones around here to connect the ground pad of ace of J2 to the ground Zone in the second in a copper layer and then I'm going to create a couple of copper zones for U1 one is going to be for vbat and the other one is going to be for ground again so let's start with the ground pad for J2 and I'm

**3:53:07** · going to use the same technique first I'm going to select the front copper layer because that's where I'm going to create these new zones and continue with the pads first pad again I'm going to go for 0.5 and 0.3 because uh I want these

**3:53:23** · to be quite beefy all right if in in your case the vs that you create are not connected to the appropriate Zone all you have to do is to select them and then through the properties connected to the appropriate net Zone like that so now that I've got that done I'm going to create a zone so let's let's start say around here this

**3:53:47** · going to go to ground and I'll call it gnd D J2 solid pad connection and just enclose part of the pad and the ground vs all right b key to redraw looks good

**3:54:10** · okay next I'm going to create a new zone right right here that zone will enclose pads 15 and 16 it's because I want to then use a large track to connect vbat which is pin 2 on S2 with the zone that combin pads 15 and 16 of U1 because

**3:54:33** · there's going to be a lot of current flowing through this single track to power all of the components on the board so I'm going to make it very big as big as I can let's go and do that I'm still in the front copper layer take the zone and start drawing here I want this to be connected to vbat and I call it vbat top one solid feel make it big

**3:55:00** · yeah so that's the Zone created and just so to show you what I mean by connecting this pad to this zone I'm going to go ahead and do that now I'm going to type the X key and start

**3:55:17** · drawing and connect it like this so front copper layer for some okay I need to type the b key to make sure that the connection does apply and have a look at the Zone all right just notice that I've got pad 14 as well that needs to be connected so I'm going to Simply extend the zone to include pad 14 I can select again so

**3:55:44** · let's go to the search \[Music\] panel vat all right so I want to extend that a little higher to include 14 and 16 all right let's

**3:56:02** · \[Music\] redraw right for some reason Pat 16 is not included and I'm thinking this has to do with the clearances I'm going to make the clearance a little smaller 0.2 and see if that helps oh yeah it did okay so that was a problem here all right so I'm going to um

**3:56:29** · repeat the drawing just to finish it up properly this time so XK to connect done all right and one thing that I'm going to to double check as well again one more time is to make sure that this zone is

**3:56:51** · assigned to the correct Place yeah vad all right let's continue so I'm going to create one more Zone to enclose or to combine these two pads together the two ground pads that's ground and I'm going to use a VR to connect that pad with

**3:57:18** · ground so it goes to the ground net done draw just notice there's one more Zone to connect here and that's the 5 volt again two pads to combine together and I'm going to have a track coming out of that let's view it yeah this better one thing that thing I've forgot to do was to give this Zone a name or did I yeah I

**3:57:46** · don't think I did this should be g&amp; D top one right g&amp; d top one

**3:58:01** · yes okay I'm going to move up there's a ground copper Zone in the regulator set of components that I want to to create so here's a regulator you can see there's 1 2 3 and four ground

**3:58:22** · pads that need to be all connected through to the ground Zone in the you know two cober layer so let's do that front copper layer let's pick the Zone tool so let's start drawing I'm going to create a zone that encompasses these pads it's going to be connected to the g&amp; net and I'm going to call that top two all right so start drawing like

**3:58:56** · this done and now to make the connection to the Copper Zone in the second inner copper layer I'm just going to use a bunch of vs problem I can now select them all and change the net to gnd D

**3:59:15** · all right so draw they look a little ugly so I'm just going to align them better together that's enough let's save don't lose any work next copper Zone to create is this one here so that's pad four of VR1 and I must create a copper Zone to provide a low impendence path to the 3.3

**3:59:40** · volt copper Zone in the inner one copper layer remind you this one here so let's create uh actually before creating the zone I'm just going to drop the vs let's put a bunch of vs here like this and all of them should be connected to the 3.3

**3:59:57** · volt zone I'll align them to top and I will distribute them nicely horizontally with even gaps and now let's switch to the zone I'll start from up here and that's going to be 3.3 volt I'll call it 3.3 volt top one and and

**4:00:23** · close them done and I think that's it with the zones so you can see the zones that I've created down here in the search panel under the zones Tab and I think that's it I'm I may need to of course create one or two more as needed as I'm doing the actual routing but I think for now it's good enough so I can then continue

### Differential Pairs and High-Speed Signal Routing

**4:00:50** · with the differential pairs followed by the clock and high speeed signal traces let's continue with the differential pairs on this board there are two differential pairs to Route the first one is down here you can see I've got USB DP and USB DN those pads up here need to be connected to this and this pad right there and then a little further up I have USB D plus and USB D

**4:01:22** · minus right here two pads and the other two pads down here let's get started with that I'm going to select the differential pair tool from here the problem that I'm having here is I'm clicking revealing the menu I'm trying to select differential pairs but it won't let me so I'm going to try by using the keyboard shortcut which is six

**4:01:43** · and start from the bottom so again with a six to start the pair now it's going to probably work maybe not again so the problem here maybe it's positioning but also you can see that there is a clearance the pads up there are very close to each other so the clearance may be a problem the first thing I'll do though is to move u4 a little bit to the

**4:02:07** · left so that it's properly aligned I'm going to unlock it and just move it a little bit to the LIF then try again with a differential pair now this is still not helping very much I'm going to try again with a smaller track and clearance so let's try

**4:02:26** · that six shortcut \[Music\] and yes this time it did work it's not very nice though so I'm just going to move youu for a little bit to the left J

**4:02:43** · just a little more and clear these tracks attempt once again so six instead effect X start drawing yeah and now they look better so that that differential pay is done let's try the other side now so I've got DP and DN down here start

**4:03:06** · drawing here I've already got the appropriate tool selected but you can see I can't get through because of the vbus pad in the middle so I'm going to try from the other side top to bottom one thing that I'll do is to see

**4:03:22** · if I can move these two components a little higher so I'm going to unlock and move up a \[Music\] little and that should not affect the differential pair drawings up the top end of this component now that I've got a bit more space between the two pairs of pads that I'm trying to connect I'm going to start again typing six on my keyboard starting to draw going to go up to about here and then finish yeah and that worked problem

**4:03:51** · here is that the VBS pad will need to be connected to the VBS net I prefer to do it around here using a VR instead of some other way passing tracks in between those pads so what I'll do is I'm going to drag and redraw those lines that I already Drew using the differential pair tool so I'm going to use the D key the D key allows me to drag in 45° mode so D

**4:04:19** · and let's move things like this here and like that and just fix that bit down here little more to have symmetry yeah that looks good one more thing I'm going to fix is these two segments so that's it with the differential pairs next up I'll work on

**4:04:43** · the tracks for the two highspeed interfaces especially the SBI and then I'm going to work on the ice quit c as well I'm going to continue drawing the tracks for the ice quit C interface and those tracks include the SE and the SDA lines the good news about this is that ice quid C typically operates at speeds of up to 400 khz in standard mode and

**4:05:08** · we're not going beyond that in this example application in this PCB it can go up to 1 MHz though in fast mode and at these frequencies minor differences in track lengths won cause significant skew or timing issues also perfect matching of Trace lengths is not critical for i s c still I'm going to try and keep the lengths of those two tracks as close as possible I need to pass those tracks through the BME sensor

**4:05:38** · and from there it will also travel to the header for the display another thing to to remember about ice quit see is that you want to keep those traces away from highp speed signals and other potential sources of interference the good thing about the layout of this design is that the SPI components are down here on the board and there's one of course here I'm going to move it a little bit further down and that leaves the traces for the I quid see quite isolated on the top end of the board okay so let's do that now um as I said

**4:06:09** · I'm just going to move U6 a little bit to the bottom or towards the bottom of the board lock it up again I'm just going to pick the normal drawing tool I can just type X on my keyboard and start drawing is on the top side of the

**4:06:28** · board click there then I'm going to connect SDA as well like this just improve traces as I \[Music\] go minimize wasted space after that I'm going to connect the two seal traces together

**4:06:54** · and I'm going to go in between the the pads and connect that to pad two so I don't have to switch Layer like that from here let's continue going to continue with SC across the

**4:07:32** · corner that goes all the way to pad 15 so at this point I will switch to the bottom copper layer use a V for that continue up to about here then go back to the surface via and connect to sccl let's do the same thing for SDA start drawing at the top copper

**4:08:03** · layer going fix those ugly traces in a moment here switch to the bottom continue up to around here and that oh actually the SDA is all the way back here so let's retrace I'm going to move this via since I've already drawn it I'll move it here and then from here go to the top layer and with X continue to

**4:08:36** · SDA so let's fix quality of this drawing okay that looks much better now one thing to notice of course is that SC the clock is much longer than SDA I would actually like to improve that and get them as close as possible to do that I'm going to start by checking out to see exactly how long these lines are you can see down the bottom that the routed length for the SE line is 68. 29 mm the number for SDA is

**4:09:14** · 52.3 going to do two things if possible I will reduce the length of se but I don't really think it is possible looking at how it's configured I don't think it's possible to reduce it therefore the other thing that I can do is to increase the length of the SDA

**4:09:33** · line there's a couple of ways to do that uh one simple way would be to just waste a bit of space here well not waste really but use the available space under the esp32 to try and improve the length you can see as I'm doing that the total length for the SDA line is increasing and it's now at 59 it's getting closer another thing that I can do is to use a tool that K provides for length tuning so up

**4:10:02** · at the route menu you see there's an option here using this seven shortcut key to attune the length of a single track so let's try this tool out so like that I want to change the length of this particular track you can see right now it's 41 mm if I start clicking and drawing to the left so I clicked held and then started drawing you can see that that length goes up so you still need to go up more so I can

**4:10:35** · continue Elsewhere on the track so now it's at 54 57 yeah I just reached 50 9 so now they are very close to each other I'm going to hit escape and check to see what the length is and you can see it's now 77 so the whole thing is actually bigger than it should have been I can then continue to fine tune so let's say I will make this smaller just click somewhere else to see what it is like now 67 yeah actually I'm pretty close now one thing that I don't quite like is

**4:11:09** · this area here just going to make this a little smaller like this make that a little smaller like that and let's see now 66 yep I do a little more fine tuning and now I've got uh 68.9 yep that's that's actually pretty good 68.9 versus 68.

### Power Traces and Signal Routing

**4:11:41** · 29 that is well within the tolerances some last Define tuning 68.85 yeah I'm going to live it at that I'm pretty happy with this result so that's i squ c i squ c is now fully connected and I'll continue with the SBI interface down here let's continue with the SPI interface the S spr interface has pads

**4:12:09** · on the right side of the esp32 there's missile and there's other involved pads on the left side as well and those routes have to go through to the SD card module clock Mossy

**4:12:25** · cssd and this pad here as well for miso and there's also the flash memory here I'm going to move this module a little bit higher select it first in the filter then unlock it so that I can move it and I'm actually going to move that a little higher and the module with its

**4:12:48** · components a little lower and place that mounting hole there my change position again later but for now that's okay lock it again in place and I'm going to start drawing from here let's say furthest away and there also pad 18 that I need to route I'm also going to place the

**4:13:12** · test points to the Final locations I'm going to do that once I know where the SPI tracks go I'm going to start with miso and start the track on the top layer like

**4:13:31** · this I'm going to Route it under the SD card you can see that that is going first to R16 but I want to Route it to the flash interface right there to begin with now this is a good place for tppp2

**4:13:50** · which is misso so let's grab that and I'm going to place it right there right on top of that track so I don't have to do any more work for tp2 done next I'm going to connect cssd so

**4:14:06** · that's the select signal for the SD card that needs to go right right here so I'm going to start from the front copper Type X I'm going to need a v here to the bottom and continue down this

**4:14:29** · path around here and resurface and connect it to cssd and that is also the pullup resistor and while I'm at it I'm going to take TP four and connected right there on the line one thing I need to fix here is that this line as you can see is 90° which is a bad idea so let's see if we can fix that yeah that's better 45° is

**4:15:04** · much better okay let's go back to the memory now the flash memory from here I let enable the rat nests so I can see what else is happening so you can see there's a connection from miso to R16 that's R22 to R16 so let's draw that like that and from R16 straight down to pad

**4:15:33** · 7 from the other side of 522 let's finish up with the interface see misso signal to U6 now let's work ony and then we'll work on the clock you can see this Mossy pad from

**4:15:57** · U6 there it goes right here on R15 and actually I'll do the clock while I made it and that is a good location for the tp3 test point for clock

**4:16:14** · just PL that right there as clock yeah move it up a little just improve the clearance done R15 the other side goes right there to pad six and for R20 the other side goes to pad five

**4:16:37** · there's also a connection between pad two of the SD card to pad two of R15 so I'll do that now should be able to Route all that on the top layer just going to go this way and

**4:16:53** · connect it there just notice that I made an error here with the way that I connected the mostly pads together and the error is that I connected those together in a radial topology it's better for SB components to be connected to the microcontroller in a bus topology so what I'll do is remove this track here so get rid of this track you can now see that Mossy is going via pad 6

**4:17:23** · through R15 first to pad two of the SD card and then from here I'll connect it to pad five of

**4:17:41** · U6 I've got a couple couple of options here as to how to cross that line here I can go to the bottom layer but that is not optimal because of the high speed in the face I'd rather keep as much as possible everything on the top layer but I'm looking at this resistor here the gap between the pads of R16 is big enough for the track to go through so

**4:18:05** · what I'm thinking is I can use that as kind of bridge I'm going to move R16 here and use it as a bridge so that the mosy track can pass through the two pads without having to go to the bottom layer that will require a little bit of moving things around so that means let's override this lock let's move this up there and delete those

**4:18:33** · tracks here and as a result I'll be able to easily connect mosy

**4:18:49** · this done was easy H let's continue going to remove this bit here go a bit closer and then from here straight up restore the broken connections all right I think that's much better let's continue with the clock started the clock here then the next connection for the clock is to go to the clock pad of the SD

**4:19:22** · card just going to go in between pads 7 and six and finish the connection there there's also the chip select goes

**4:19:38** · to going to move Tippy five here and let's see chip select for the flash memory goes down here all right so that's going to be a long Trace so let's go from here to here and then I will need to switch to

**4:20:00** · the bottom layer I'll do that here continue until around here and switch to the top layer to finish up the last thing to look at is the lengths the most important track here is the clock so we want the clock to be as short as possible and therefore let's

**4:20:28** · measure it the total length for the clock is 26 mm the total of miso is 63.3 MM and MOSI 51 the main thing here

**4:20:43** · is that the difference between miso and MOSI is not big for the total size and the frequency of operation for the spbi interface and the good news as well is that the clock is much much smaller than the two which is the more important

**4:21:03** · consideration here the clock line is the most critical in terms of timing so this is the shortest and it's actually a fairly clean path so I'm pretty happy with that the other two traces mostly in Miss are bigger compared to the clock but I'll see if I can make them any smaller but before I do that I'm just going to move tp1 to let's say maybe what would be a reasonable spot for it I think here would be a good spot there is a conflict so I'm going to move tp1 a

**4:21:37** · little bit to the left so I can accommodate tp1 with their conflict so having done that the next thing I'll try to do is to minimize the length of those lines as much as

**4:21:53** · possible they're not bad the way they are now but I think um at least see missile can be somewhat smaller I don't want to make missile flip to the bottom side there so I'm going to continue working like this make that a little bit smaller like that so we are now at at 62 yep so we Sav 1 mm with the work

**4:22:17** · I've done so far another thing I can do is increase the size of mosy by a little so like that just to make it a bit closer to miso it's now 52 yeah not a big deal the interactive router did something crazy here and it rerouted a nice clean route that I had to this weird shape so I'm going to hit undo a few times to undo this work that's

**4:22:41** · better yeah I'm going to leave it at that and if needed I'm going to come back later and see if I can make any further improvements that's it okay I'm going to stop here and then I'll continue with the power Tracer so anything that's got a voltage or ground I'll be routing it and completing it let's continue with the power traces this includes connecting pads such as the ground pads here the 5vt USB pads right here there's

**4:23:11** · another 5V vbu there's also a lot of 3.3 volt pads and all those will be connected using vs to the appropriate copper Zone in the inner layers and I'm going to do that in segments so I'm going to start from the bottom left corner of the board and then work my way up and then to the right and so on until all of those pads are connected to the appropriate copper Zone and Nets so I've

**4:23:42** · got a ground pad here and the 5V USB pad the technique is the same regardless of what pad it is I'll create a trace to connect this pad to this pad here and move it to the side a little and then this pad will go to the

**4:24:04** · appropriate copper Zone using a v you can see that that's connected I'll use the same technique for the other pads as well so for the ground I'm simply going to use a V for this done in the center of this IC there's a big ground pad and or connected to pad three and to Pad

**4:24:26** · 10 and from here pad three I just break it out to a VR like that going to come back to the 5vt pad and Zone here I've got two more USB pads here so I'm going to Simply break them out using vs like this of course I could connect it to this pad here but I prefer this method here as well so I'm going to add one more like that there two more USB 5V

**4:24:58** · pads so continue with the same technique break them out using vs done all right this looks okay remember that I'm not working with signals now just with anything that relates to power there is a large track that I'm about to create that will connect the 5vt pads and Zone to this set of pads so for that remember

**4:25:32** · this is important because this is the track that supplies power to the entire board so I'm going to use a large track like this one here this is a 1 mm track but I need to pass it through the polyfuse so may need to make a bit of room to get it through so I may need to actually move this component a little bit to the left so let's choose it and

**4:25:59** · I'm aware that there are two copper zones here as well so I'm going to unlock this component and make sure that I can select everything on it and move that slow slly to one

**4:26:15** · side and up to make sure that there is enough space here for the big track that I'm about to draw to go past uh before I continue I just want to make sure that I didn't break anything and I can see that the connections are still fine as they are yeah all right so from here I'm going to

**4:26:40** · draw let's switch that to 0.8 I'm going to use I'm going to create one more track size that's going to be one millimet so they don't have to make a change later so go for 1 millimet and draw this huge track

**4:27:13** · oops Yeah it hasn't picked up the fact that this belongs to the 5V net because I didn't touch it to one of those pads select the entire track and assign that to the five volt

**4:27:31** · net should now be able to connect it not sure why didn't pick it up automatically but it's okay we can fix this through the properties all right that should be it it's done yep so that part is complete let's

**4:27:51** · continue with those ground pads this will be easy I'm just going to go back to use net class widths and connect those together like this and see if there's enough space for vs in between yeah we do that that's fine I use use a similar technique for these so

**4:28:20** · X and vs done these ground pads are already connected to the ground copper net and let's work on the 3.3 volt Nets I'm going to use vs for this so X to draw a short trace and then V to go down to the 3.3 volt copper net same

**4:28:52** · thing V connect these two together that's ground so break it down these two go together one of the benefits of using this technique is so that you don't draw long wires that may make it harder later on to draw other wires past them so

**4:29:19** · they're not blocking the space between different parts of the board because these are so short they don't abstract R 11 done I've got C1

**4:29:40** · ground and uh the V bus that needs to go in here do need to choose a smaller trace for that and there's a v bus there as well right so let's see this is too big unfortunately I'm going to have to override the net class with with something smaller let's see if that works and then VR yes that did work and then VBS from here to C1 great another

**4:30:09** · vbus from here to to right there done ground connect those ground pads these are through hole pads connect them \[Music\]

**4:30:34** · together the proximity between those pads is convenient so I can just create the connections using short white is on the other side I've got ground ground oh there you go something that I forgot to do earlier is I've got the

**4:30:53** · differential pairs for the USB these are the alternate USB through holes on the USB connector so I've got DN and DP and you can see here DP and DN but I also need to connect those and to terminate them right here as well so I'm not sure if I can do this as a differential pair I should be able to do it so I'll give it a go so I'm going to stop up working on the power nets for a moment and do this differential pair before I forget I'm going to start with B7 type A6 on my

**4:31:26** · keyboard and start drawing no that's not going to work all right I'm going to start with a bottom copper layer and try again six on my keyboard ah yeah okay so that's what the problem was right so let's go around here and then maybe let's see I'm going to need to break to the top layer now I've got a better idea this not going to work so what I'll do is because I want to minimize how many vs I use and as you

**4:31:58** · can see it's pretty busy area here what I'll do is I'm going to use the two inner layers to help me with this situation what I'll do is I'm going to break out these two tracks on different layers so B7 I'll put that on the bottom Couer layer and then B6 in in a one Couer layer so that way they're not going to be conflicting it's going to look like this so I'm going to go for the back CER layer so select that and then start

**4:32:32** · drawing like this and here use a v to break to the top Couer layer and finish the connection for DP I'm going to do the opposite I've selected in a one copper layer start drawing here towards the other side just going to cross \[Music\] here and type V switch to the top cou of

**4:33:00** · layer and finish the connection there okay just enabled all layers so we can see them and you can see that here's USB in and here is USB DP they

**4:33:16** · overlapping I'm just going to just change the geometry a little bit move this V out of the way because the differential pair wires are more important and I want to minimize any discrepancies between the two signals so I want to have the two traces be as similar as possible

**4:33:49** · in terms of shape and length move that down a bit substracting yeah okay I think this is actually pretty good just move that down remove the segment it's redundant okay so there you go that's taken care of all right I can continue now with the power pads right so I've got

**4:34:58** · okay I think that's it I need to correct the widths of some of the 3.3 volt tracks you can see I've got them at 5 mm but I'm not sure if all of them are I think some of the 3.3 volt tracks are not at least 0.5 mm you can see this one here for example it is smaller and the same thing goes with the vs so what I'll do is I'll go to edit and then edit

**4:35:27** · track and Via properties I want to make sure that all of the items that belong to the 3.3 volt net will have a track width of 0.5 mm and the vs size is with a diameter of 0.5 mm and a hole of 0.3

**4:35:48** · mm so that's going to take care of all of those right it's done I'm going to double check to make sure that I haven't broken something there are two even more important tracks that I need to change even that setting so you can see here that this particular track here supplies power to the entire esp3 too so I'm going to make it even bigger I'm going to select the entire

**4:36:19** · track so select that track and I want to yeah bring up its properties so I want to change its width to make it 0.8 mm that's better so yes change all of

**4:36:37** · those okay so big get is better and also need to change the size of the via here and I'll do that I'm just going to click up his properties actually so I'll be able to select one of the predefined sizes I've created here and that is um

**4:36:55** · make it 0.804 like that okay that's better I could have done it with the side panel but the side panel doesn't give me access to the predefined sizes that I wanted to use okay I think that's all I need to do with the power related pads Nets and vs so I'm going to

**4:37:15** · continue next with the signals or anything that's now got a green line means it's not connected I'll go ahead and connect it I'll try to stick to the front Couer lay as much as possible but uh every now and then I will need to switch to at least the bottom coule layer going to switch back to use net class width and hit X and start connecting at least the easiest tracks

**4:37:47** · this one is not going to be easy I'm probably going to have to go from the top side because there's just too many thr holes here so let's see um around the back

**4:38:12** · nope it's a bit too tight still

**4:38:37** · no yes okay success it wasn't that easy it's a bit tired so I had to change the shape of the differential pairs as well

**4:39:28** · the previous change that I made here you can see that it actually had some uh an consequences and I've got like a huge track that is interfering with the pads so I need to reduce that so so let's select these 3.3 volt tracks and bring up properties let's see if I can actually actually now do it from here going to make this

**4:39:58** · 0.5 I go a bit lower actually I'll go for 0.24 254 this is the sensor it doesn't really require that much power so that is not a problem at all I'll do the same thing for consistency for this

**4:40:26** · track okay that's better let's look for more signals going to connect all these together using tracks

**4:40:41** · okay I think I've done all the signals I don't think there's anything outstanding actually there are because I've been hiding those additional Nets so let's enable everything that I disabled earlier so I can finish those routes there we go I was wondering I knew there were

**4:41:05** · more it's going to be a tight fit yeah I'm going to need some more space up the top side but let's see if I can move this VI NY tied here so I will need to move these resistors a little higher this is this enough space for the routes on top of U1 so let's fix this up

**4:42:10** · this so then it goes all the way to the esp32 right so let's go from here keep it simple switch to the bottom layer continue up

**4:42:44** · from here switch to top layer and finish from here I've got enable do something similar

**4:43:14** · switch the \[Music\] bottom there's this one here that is blocking my way so what I'll do it's going to

**4:43:33** · move going to move this over here so that these can continue in the bottom layer until around \[Music\] here similar with this this is

**4:44:00** · ground back room this can move over here then continue up this way until it reaches the surface right there

**4:44:47** · okay continuing um I've got DTR and RTS so this will have to go under right away and until reg around

**4:45:28** · here same thing with \[Music\] DTR and

**4:46:09** · for for

**4:47:09** · okay for

**4:47:30** · \[Music\]

**4:47:54** · I only noticed that like a moment ago is I finished the signal routing I was so concentrated on doing the signals that I didn't realize that somehow somewhere I managed to delete the copper Zone in the

**4:48:09** · inner two copper layer that is for the grounds so that's why you see all these rut nests indicating that the ground pads and holes and uh Nets are not connected not sure exactly how it happened I'm going to go back to the video review and see how I managed to do that but see I also ran a design rules Checker and these errors that you seeing mostly at least about the missing ground Zone let me just um quickly fix

**4:48:42** · it before I do anything else except for this thing here I've got to fix that ra so it's it was just too close to those V all right well let's go back and and fix that missing ground pane it's just weird how it happened all right in a coule layer one is where the ground Zone should be selecting a layer one for

**4:49:02** · copper is bring up the zones tool and I'm just going to make a big zone for ground and finish it there all right that should be good now so I'm going to type the b key it should be it should fix that issue save now if I look at the search panel so I can have a look at the

**4:49:31** · zones H okay I figured out what the problem was at some point I managed to misconfigure the ground and it's 3.3 volt copper zones and I had set both copper zones in one copper layer so to fix the problem I simply switched the 3.3 volt copper Zone to be in the in

**4:49:54** · Copper layer as I originally intented again I'm not sure how the problem occurred where I made the change and that left the ground copper Zone by itself in the in one copper layer I'm just going to fix the name here as was experimenting I change the name to and in one all right so then after refreshing the zones everything is now as it should be and there's a couple of things still to fix I notice that

**4:50:25** · here the 3.3 volt pads here are not this pad here is not exposed to the other two so I'm just going to create a new Zone just to fix that issue so let's start go for a finer grid and let's start here all right so that's going to be 3.3 volt like that solid and everything is good so let's

**4:50:51** · place that over here all these are 3.3 volt 2.54 yeah that would do connect them all together and that takes care of that issue now notice there's a couple of other issues here again it seems like H there's no ground I think that's because in the in one copper layer only ground should appear not VBS so VBS should be in in2 so let's fix that sorry that should be in

**4:51:25** · in2 and anything else in one yeah 5 Vol USB that should also be in the second inner copper layer all right so redraw done that was a tricky bug I confused in1 with in2 as I was

**4:51:45** · assigning the copper zones to the different layers and hence the problem occurred uh thankfully the rut Nest lines and then the design rules check make it easy to find the problem and fixing it is just very easy next up a design rules check make sure I haven't missed anything else big and then continue to finalize the board my board is about 90% ready to send to the

**4:52:11** · manufacturer that's that's my estimate I know there's a few things that I need to fix and just looking at this board reduce a bit of the Clutter I can see that somehow I forgot to connect a couple of items together and there's a few tracks that I can definitely improve remove unnecessary turns and remove some 90° turns as well such as this one here

**4:52:36** · but I'm sure that there's also other issues that I can't see right now just one more thing that I'll do to remove clatter is to uncheck the highlights or the shadows for the lock items there's also additional work that we need to do in the silk screen layer on the top side just to add more text in order to make my board a bit more professional so for

**4:52:59** · example descriptions for the various pens here in the headers and other things of that sort just to help with a final design but before I do all that I am going to run the design rules check just to reveal issues that I can't see

**4:53:17** · so here's the redesign rule Checker I just clicked on this button right here and I'm going to run it just to get an idea of how much work is remaining to be done got a couple of unconnected items at as I suspected quite a lot of warnings and errors don't worry too much about this I don't think that the situation is that dramatic and many of the servers are be able to just review them and then most likely put them aside not going to have to fix much let's do the unconnected items first obviously

**4:53:48** · I'm just going to do this one here this is the easiest front copper layer tapping X on my keyboard just to finish with this connection and that's done and the other one is down here so for this to work better I will need to make a bit of room here and here so that I can then create a VR and pass the line underneath

**4:54:19** · the board right here and then back to the surface and I'm just going to improve the wiring like this okay run again nothing unconnected so let's go to

**4:54:34** · the errors now so this error says that this particular via and most likely the other one here as well has got an anular width that is zero so essentially that means that the hole is equal to the diameter of the VR obviously this is not a good idea and it violates the constraint that I've got here of 1 mm so

**4:54:55** · this is easy to fix I've got two vs to fix here the first way to fix it is to just double click on the VR bring up its properties and then go for one of the predefined sizes and I think because this is a regular signal VR I can go for 0.5 0.3 and that would fix it but going to show you another way to do this that is a little faster especially when you have multiple vs to fix in this way so go to edit then go to track and Via properties and then select out of the filter a filter or filter combination

**4:55:29** · that captures all of the items on which you want to make the change in this case I've got the net q3b so select that out of the drop- down and then I'm going to go for vsi 0.5 0.3 that's it so both are now

**4:55:45** · changed together if I run the DRC you see that that is sorted there's other issues to fix but this one is sorted other issues to fix here have to do with the ground again similar situation and you can see there there's a couple of those ground items that need to be

**4:56:05** · changed uh that's that has to do with vs I'm going to follow the same process and go to edit truck and Via properties this one is going to be for the ground and I'm going to change this to 0.5 0.3 again like that run

**4:56:27** · DRC then I've got this set of Errors you can see there's multiple and they all have to do with the vs in the ESP 32 footprint now the thing about this footprint I'm just going to save as I go is that I'm just going to show you I got to the footprint editor and you see

**4:56:50** · here that these vs are part of the original work whoever created the footprint for the esp32 set the vs here to this size I don't really want to change it and I've also checked with next PCB and they don't have a problem manufacturing the board with this particular geometry here for the vs and the pads so what I'll do instead of trying to fix this I am simply going to ignore it like

**4:57:21** · this so that takes care of that I'm ignoring this particular violation because I understand its implications and I know that it does not affect adversely the outcome of the board that I'm building so that's sorted let's continue I've got the few violations here the net class G and clearance 2.

**4:57:45** · 0.2 01649 now the issue here you can see it's J1 and uh B1 and B2 are too close to each other B1 and B2 are too close and unfortunately again there's nothing that I can do about this because that is the footprint of the USB connector so again I'm going to ignore all of these

**4:58:10** · next I've got some complaints about thermal reliefs you can see this copper area here connects G1 to the ground copper field and it's just a single thermal relief same thing happens here just a single thermal relief kicker would rather have two spokes for the connection between the copper Zone and the pad unfortunately we can't fit more than one spook so I'm going to ignore

**4:58:43** · that as well next more issues that I really can't do anything about this one here is about the solder mask apiture you can see that this pad here has got a solder mask that touches the pad adjacent to it this is what this complaint is about so again I'm not going to do anything about this because I can't really do anything about it and I will ignore it

**4:59:11** · and that takes care of all of those violations next I've got a bunch of warnings What's Happening Here is that I have a 3.3 volt VR connected to this track here however this VR is not connected to anything else that is 3.3 volt so it's that's why VR is not connected so what happened is that the

**4:59:34** · Zone above the V Let's select the zones as well I need track and yep that's good so this Zone here is the 3.3 volt Zone this one right here however when I created this V I kind of

**4:59:52** · missed the Target so I need to move this V so that it can make contact with the 3.3 volt copper Zone this can be fixed simply by dragging this V and I'll place it here just to fix this line and also this area here because it's our

**5:00:15** · 90° turn which is not a good idea all right so that's it just going to type the b key to refill the zone and we've got 100 warnings now if I run the DC again it should be one less yeah then I've got an issue with the clip of the

**5:00:33** · edge Cuts so u3 which is the esp32 has got this line which belongs to the silk screen it's actually cutting through the edge cuts and that's a violation it's not dangerous of course and the there is no problem with the manufacturing but again it's part of the design of the esp32 footprint so once again I am going

**5:00:57** · to select this specific violation to be excluded and there are two of them I believe three yeah so exclude this one as well there's a few others there now let's see here footprint does not match

**5:01:14** · yeah okay so this particular footprint for the button does not match the one that is stored in the library this is not a problem for me because what I'm looking at is correct so it doesn't really matter to me exactly what the difference is between this version and whichever version is stored in the library so I'm going to exclude both of

**5:01:35** · these violations next up same issue with esp32 C3 I'm going to exclude this I'm going to exclude this as well same issue now I've got a lot of violations relating to the size of the text I saw really a bunch of them so what happened here is that I made this text too small and I can have

**5:02:00** · a look at the capabilities of the manufacturer when it comes to text all right so according to this the minimum line width is 5 m that's a minimum so that's 0.12 mm and the maximum text height is

**5:02:19** · 0.76 mm if I look at what I've said the constraints to be for the silk screen I've set it for 0.8 the minimum text height which is correct and the thickness set it too small so this should be 0.12 having fixed that in my constraints

**5:02:40** · and now I need to fix all of the text so I need to fix all the reference text labels so let's go to edit edit text and Graphics properties and everything that is on the front Sil screen there is a reference designator I'm going to change the text width to be

**5:03:02** · 0.8 the height to also be 0.8 and the thickness as small as I can make it with think that capabilities is 0.12 so I'm going to apply this to all of them and they're close so that made

**5:03:19** · all the text bigger and I'm going to have to make it fit properly but at least it removes all those violations and I know that it will be properly printed by the manufacturer now I've got a bunch of other things again probably because of what I've just done and you can see here one example silk screen clipped by S The Mask so now I've got silk screen on the S mask and on the pad so I need to move things around so I'm going to

**5:03:47** · remove the groups so I can move things around and start moving all the text off the so mask or

**5:04:08** · the okay I think I got got the all let's repeat the check to see if I missed any three warnings oh I missed one here let's move that out here actually move LED there and C3 here all right there's a couple of items that requires me to ungroup so

**5:04:31** · that I can grab C1 and I'll place it here there's one more thing at this one silk screen C by sold the mask so you can see this dot here this dot actually belongs to the ESP 32 footprint now to fix it I'm going to have to actually edit the footprint right click on the footprint click on open in footprint editor I will need to move this dot

**5:05:01** · somewhere else just going to change the grid and pick that item and move it say right there save go back and see if that resolves the issue yeah I think that would do it so let's do one last check run DSC all right that's fine as we know

### Design Rule Check and Final Refinements

**5:05:26** · I've just made a change to the esp32 module and that is okay to exclude it cool so you can see all the ignor tests in here so you can add them and then and ignore them if you you want to the DRC shows no other issues that I need to deal with so that means that I can do the last minute improvements

**5:05:49** · enhancements before going ahead with the design for manufacturing checks design for manufacturing checks are all those checks that I will be doing using the next PCB analytics tools that will give me some insights as to whether I've done something that would make manufacturing of the board harder these are not tests that tell me anything about whether the board itself is functional or not but

**5:06:15** · whether it actually can be built so before I do that there's a few little improvements that I will need to do things such as 90° angles this is something that would also be picked by the design for manufacturing Analytics tool but it is so obvious that I'm going to fix it now and other things such as

**5:06:36** · uh removing any issues like this one here redundant segments of tracks and turns that are not really necessary and anything else it might pop up actually here might even try to reduce the length of some of the longer tracks as I go so I'm going to start with this is quite obvious so make sure that I can select tracks and vs sometimes it's just easier to

**5:07:06** · redraw a track \[Music\] and I'll draw it with a much thicker track the same thing here okay there's a redundant that can go straight in like

**5:07:38** · this for

### Design for Manufacturing (DFM) Checks

**5:08:13** · okay yeah I think that is good I'm going to save next up I'm going to do design for manufacturing checks these are the checks that help make sure that the board is fit for manufacturing and there's no issues in it that may delay

**5:08:30** · or maybe even make impossible manufacturing PCB design itself is fine as far as the electrical design rules checks are concern concerned however that doesn't mean that it can be manufactured that's where the dfm check comes in for the dfm check I'm going to use a free tool that is available from next PCB that you can use it both online or as a Windows application next BCB has

**5:08:57** · a version of the dfm Checker as a plug-in that I've installed and you can see it right here but the problem is that this plugin doesn't seem to be working properly with the release candidate 2 version of kick at 9 it

**5:09:13** · doesn't actually work so I'm not going to bother with it at all I'm just going to do all of the dfm checks using the Windows application the thing to remember is that the Windows application is more capable compared to the kiat plug-in but the nice thing about the Ki plugin once it's back online for KI at 9 once Ki 9 is actually released and the plug-in works is that it's embedded in the kiat environment and you'll be able to do any required changes on the fly

**5:09:43** · without having to go back and forth between the windows dfm tool and kiad before I get started just also wanted to show you that you can download your copy of the HQ dfm tool from this page here on the next PCB website to make this

**5:10:00** · work before I go to my Windows Virtual Machine where I have installed the analysis tool you need to export the Gerber files from kiad there's the plotter button that allows you to export Gerber files or you can do this via file fabrication outputs and G files so I'm going to create a output directory I'm just going to call it ESP 32 project gers the layers included are

**5:10:30** · fine as they are here I'm only going to set Proto file name extensions and click on the blue plot file and refill here the other thing is to generate the drill files for any holes of years click generate again and close

**5:10:51** · and here is the project directory and you can see my Gerber files right here so next up let's go to Windows I am going to copy the directory across so that I can import it into the analysis tool here it is and there's the gab files so start the analysis tool and I'm going to drop all of these

**5:11:17** · files in the layers Tab and that does the analysis very quickly all done it's quite an interesting piece of software actually if you want to spend a bit of time exploring it I do have a Blog on the

**5:11:32** · tech Expressions website that talks about this in a little bit more detail that includes a video shows you things about the reports that can come out of this but let's go straight in it to see what it does there's a 3D view as well which actually is quite

**5:11:54** · nice nice work all right so here you can see the results anything that's green obviously nothing to worry about uh anything that is orange maybe have a look a closer look at it but definitely things that are red you need to check for example let's go for the anular ring

**5:12:12** · size click on the red button to check it and the tool will pan exactly where the problem is now this is focusing on the esp32 ground pads and pins and there's

**5:12:27** · nothing that we can do about this because this is just what the esp32 ground pins are like so there's nothing I can fix here so what the tool is saying here is that in this particular instance there is a V with an anular ring that is 1 95 Ms in size and

**5:12:50** · it's telling me that it should be over 5 Ms if I look at the actual one which is this one right here clicking on it text me to these properties and the diameter is 0.5 Ms the hole is 0.3 mm the

**5:13:05** · difference is 0.2 so 0.2 two is actually sufficient because the 5 Ms which is a thousandth of an inch is equal to 0.127 mm which means that this anular

**5:13:20** · ring is actually bigger than the minimum based on that I'm not going to do anything about this I'm just going to leave it as it is and moving on to the pth anal Rings again here there's one that is belonging to the USB port it's

**5:13:36** · this one here and again this is design geometry of the USB port and I'm not going to do anything about it next is the Dual to Copper these are actually all things I can fix quite easily so there's these and there's a so to trace and N pth so let's do these first so I've got the V to trace outer you can see this uh right here this V is to

**5:14:03** · close to this track here so I'm just going to move it down a bit just like that and that will take care of that issue next one is this one here with this V right there so I'm simply going to move it a little bit to the

**5:14:28** · left and that will sort it out okay next one this one is this so this is easy to fix again just add a bit of

**5:14:46** · space like this away from the V that's done and one more think yeah this one here right here so move that out a bit towards the

**5:15:04** · left and that will sort it done moving on N PD H I think this is fine so I'm going to leave this alone drill to Copper done moving on copper to board Edge so this is the the edges a bit too close to the board so the copper fills are apparently

**5:15:26** · too close to the edge in the inner copper layers so this may be able to fix quite quickly by looking at the zone select all of those and change the clearance according to the tool the clearance common 0.2 mm so let's put a 0.2 mm here okay 0.2 mm and refill

**5:16:00** · everything okay now that Gap is bigger okay let's continue next one up is the drill spacing and okay these are again issues that have to do with the geometry of the USB

**5:16:16** · connector there's nothing really that I can do about but I've checked with next PCB and this is not a problem for them to manufacture this is it with the dfm check next up in my to-do list is to continue working on the silk screen so the silk screen will contain text and some graphics to improve the usability of the board by providing information to the user for things such as what each

**5:16:42** · one of these pins are or what kind of component is this to help with assembly information about the version of the board perhaps website URL for information on software and example applications and so on so anything that is useful can go on the silk screen I'm

**5:17:01** · going to be working predominantly on the top S screen but remember that there's a lot of space on the bottom side of the S screen that you can put more text or Graphics by the end of this process I'm going to have something like this an example of what the end result of my

**5:17:18** · silk screen work will look like you can see in this case I actually removed couple of mounting holes to make space for the text and for the graphics in essence what I did was to add explanatory text like up here for the ru of each of the pins I used lines to

**5:17:37** · create borders around components that belong together so for example all of those components belong to the sound sensor I've got some information about the role of the LEDs here what each one of those LEDs does so that you know what it is when you look at it and that's pretty much it that's a couple of logos here as well I'm going to go ahead and do that work now I've decided to remove

**5:18:01** · those mounting points because I think that the silk screen is more important than those mounting points so let's go to the front silk screen I'm going to remove this and this mounting holse

**5:18:18** · because I need this space to provide some information about the LEDs another thing that I'm going to do before I fast forward this part of the video is that I'm going to select these text items and hide them because I'm going to replace them with new text items that describe the use of the LEDs so these are I'm

**5:18:39** · going to make them disappear so these are not visible anymore going to do the same thing with there's two more LEDs so there's also this and this led text items to make invisible I'm also going to remove the ref that's not going to be visible either no need for that to be visible and that's pretty much it so the first thing is I'm going to start with the borders I like especially because this is a practice board like an educ ational board I like the idea of

**5:19:12** · creating borders around the functional components that belong together and Implement a particular function on the board so anyone who is learning about PCB design and using this board as an example will able to look at it and know immediately what the various subcircuits on this board do I will pick the line tool and create a border around the

**5:19:35** · components that belong together I'm going to go for Z point 1 mm just to make it easier to draw okay start here up to here and up and close that box take text box and put that and name this box charger I'll place it in here I

**5:19:57** · can actually give it a 45° angle actually should be minus 45° you can play around with the angle to make it fit nicely with the line next I'll create labels for those LEDs here so the first one is for charging power to indicate that charging power is okay the other one here is that the battery

### Adding Silkscreen and Final Touches

**5:20:22** · is charged and the third one is that the battery is charging that's why I made some room up here by removing the mounting hole so again pick up the text tool and the first one is going to be charging power okay and it's always a challenge to make this fit so let's make this 90° so that

**5:20:45** · I can mount it in like this and it's done and I'll continue with the rest for example I'm going to go up here and add some text for the roll of these pens I use the same geometry for the text so

**5:21:03** · this first one is going to be G and D I'm going I'm going to continue along the same way but to save us all bit of time and especially you I'm not going to record this whole process and I'm going to come back in your time in just a few seconds and my time is going to be probably around 30 to 40 minutes when I would have completed the sil screen and

**5:21:26** · that's it with the silk screen let's have a look I'm going to disable some of these layers take a better look at the sil screen layer so I've got all the borders between the different top circuits got a couple of logos as well there's always room for the tech Expos logo and the kyat in the back silk screen layer can also have a look at the 3D View and there's our board actually

**5:21:55** · looks quite nice like this which brings me to the next item in my list of items to do and that is to populate the missing components here for a full three 3D render of this board so let's get into it now in the current 3D model you

**5:22:14** · can see that there's a few components that are missing the most important ones actually es32 is missing the SD card reader the USB module all these things are missing it's not going to take long to add them remember that when I set up this project I already collected the 3D

**5:22:32** · models for these important components and for other components such as the polyus here the LEDs some of the capacitors as well and even the microphone I'll be using components that come with kicker so I'll be looking K's own 3D model libraries let's start with

**5:22:51** · doing this work the first thing to do is to set up all the components that don't have a 3D model whose model is in kad's own librar that will save me the trouble having to code to to different places back and forth and I'm going to leave the 3D viewer open so that it gets updated as I configure each of the components with its 3D model let's begin with the microphone so double click on the microphone bring up its 3D model so for the 3D model of the microphone I'm

**5:23:24** · going to go to kad's own libraries you can see I'm working in Kat 9 RC and in here there's 3D models and look for sensor of course when you do this for the first time you need to spend a bit of time to explore it's unlikely that you'll be able to find what you're looking for immediately there's no search function so you really have to browse to find what you need so I've already done that of course so I know where to go sensor audio and I'm looking for

**5:23:53** · pom there's two versions of the same model one is Step the other one is wrl I just go with step there's that and then I need to rotate it a little so I'm just going to lift it off first I'm going to add to the offset going to put it up for the time being and then do a rotate because I want to be able to see its pins as I'm rotating like actually other the side yeah I need to go like this all right and then let's fix its pins okay let's

**5:24:25** · go to the offset now and go down and then a little bit this way and that's it and finish up with this a offset done and there's the microphone cool let's

**5:24:49** · continue I'll do the LEDs next because there's a few of them the first one is power for the power LED and for all the LEDs actually I'm going to use the same model for Simplicity there's no need to change here so here in this list there will be an LED SMD this one here and

**5:25:08** · there's a few options you can see what they look like you can have a look at them and play around I'm going to be pretty brief with this exploration and just go for the 1206 that seems to be the right size 1206 here there's the casted version but I'm just going to go with the simple one this one here looks good so okay that looks nice and for the others instead of having to browse I'm just going to copy the path to the the step file so just uh click and copy and

**5:25:43** · go to the other LEDs you can search for Led in the footprints here so one by one add those LEDs in here remove whatever may be in the 3D models list and then just click on the plus button to bring up the field and then copy paste and hit okay continue with the next one double click and repeat the same

**5:26:16** · process and there's our LEDs I'll do the polyfuse next it's a large component right here remove whatever might be there and let's go through the list here so we're looking for the fuse 32 2 25 yep that's

**5:26:40** · one it fits nicely hit okay another things you can do if you want to know what's remaining to be fixed click on this button here missing 3D models and that will have a look to see what models are missing and you can see it picked up 61 missing models and it created a file

**5:27:00** · so you can use that file to quickly in here you see missing 3D models I'm going to open it up with the text edor and there's the models that are missing so there's quite a lot of models missing but again don't let that scare you in this particular case what's happened is because I'm working with kick at 9 and kick at 8 at the same time I've got this path that doesn't exist in kickout 9 release candidate but somehow it found its way in this file so I'm going to

**5:27:32** · show you a way to fix this problem really quickly and easily because the thing is that once I fix this variable then the path is correct and kicker will be able to grab the missing 3D models all right so to fix that go back to the

**5:27:48** · main kickout window and under preferences go to configure paths in here you see that I've got a few environmental variables but one that is not in here is the one that I actually need for this particular case now if you're working in kick up 9 the the final version and you're not kick at 8 and kick at n like I am you're not going to have to worry about this but I'm showing you this because it's an opportunity to show you what you can do with the paths configuration window here

**5:28:19** · to fix this very specific problem so here I'm going to add a new row add the variable that I want to add and I am going to click on this path copy it and paste it because I know that this actually exists this is what I'm picking up all of the component and the 3D models that I showed you so far so essentially I'm going to have these two variables that are pointing to the same place and that is going to fix the issue with these missing 3D models all right

**5:28:51** · so now let's do the check again only six missing perfect so we fixed most of them and the ones that I need to fix I'm just going to reopen this file have to do with legitimately missing 3D models not sure why the format didn't work out this time around but but uh let me just do this one more time just going to delete it going to delete these two and do the check again okay six never mind it's fine so what's missing is C4 C3 C9 there's u4

**5:29:24** · there C7 C12 so these are the tandum capacitors first is C4 I'm just going to search for that so C4 double click on it and and this capacitor is in the building 3D models

**5:29:44** · go for capacitor SMD capacitor tandum actually that's what I need go in here look for cpia the size is 3216 32168 Kemet this one right here I'll go for this step model done and you can remove the other one there so now I'm going to copy this hit okay and let's look for the others so the next one is

**5:30:14** · C3 just like what I did with the LED so I'm going to repeat the process here there you go should probably put a slightly larger capacitor there for the tunder but it's okay then it's

**5:30:35** · C9 then it say s and that's it with the capacitors all right so all the capacitors are there C4 C7 and so on it's not that these are

**5:30:55** · missing it's that they're not configured correctly that's why they're coming up there's other components that do have missing 3D models but they're not listed in this list because it just haven't been configured and next one is u4 that is also misconfigured so let's look for that u4 this one here and for this I'm going

**5:31:16** · to look in the built-in libraries I'm going for the package dfn and then in here I'm looking for qfn 16 it's one of those over here 1 EP 3x3 0.5 mm 1.8x 1.8

**5:31:34** · this one right here step yep okay done and it's properly aligned as well if I do another check you'll see that there's one missing u4 thought I just edit that didn't I oh yeah it's because I didn't delete the original so let's delete that hit okay save and let's check again model is

**5:32:01** · missing zero however if we have a look at the 3D viewer you'll see there's actually some models that don't have configuration so let's add them so these are all the models that I have collected at the beginning of the project and now I'm going to actually assign them to the footprints let's start with a connector down here this one the model is in the

**5:32:25** · project directory so let's navigate to The Working project directory and in here is the libraries 3D models and then what I'm looking for is the B2 pH smm4 let oriented so rotate back and forth there's a bit of playing around with this until I get the right one that's the one next I'll do the USB

**5:32:50** · port so this one is the SS \[Music\] 5240 okay perfect let's take a look at what the port looks like now all right yeah making progress let's continue with the two buttons the model is us lpt this one right here that's a models

**5:33:16** · it won't fit exactly though so I'm going to need to fine tune it and I'm going to copy this because I've got another button so I'm just going to copy that and assign it to the other button and set the same Transformations okay next up is the SD card so the model for that is the GSD 0

**5:33:39** · model in this directory GSD 0 yeah that's it and that happens to fit perfectly and I'm going to go up and sort out the model for the esp32 and the model for this is this

**5:33:56** · one done let's take a pause and have a look yeah this is looking really nice not much more to go so the U6 Q 1 and VR1 left to do and the B me 280 up here

**5:34:13** · You2 so the light sensor that is the tem t6000 you can see the pad configuration in the bottom now you just need to make sure that these pads are correctly aligned this orientation is good so I just need to flip it on the xais by 90° and that's it yeah it's okay next of course the

**5:34:38** · regulator lm117 3.3 so 90° flip done and I think it was youu to as well this is bme280 step we need to be bit

**5:34:56** · mindful of pin one marked with this dot there against this dot so you can see where the dot is so I really need to flip it I think on the x-axis actually before the x-axis let's go back to where it was because I want to be able to see that dot let's go Z axis 90 Dees yep so that's aligned there so then X to make it close that's it and you can see that dot against that dot there

**5:35:27** · let's have a look at what the motor looks like now have I missed anything oh yep I've missed U6 but I think everything else is now correct so let's uh finish with the flash memory the flash memory is model ID w25 Q32 okay and simply a 90° on the x-axis

**5:35:47** · would do all right so let's have a look at the final result of all this work there's the board it looks amazing in my opinion this gives you a really good idea of where things are what the final result is going to look like if the user interface is reasonable

**5:36:15** · and workable even if the test points are where they should be there is room to make changes here and even at this point those changes are not necessarily painful you will be able to make oh you just noticed one more the amplifier here one more component is missing let's do that the amplifier from memory let's see the is the max 4466 exk flip that on the X AIS yep and

**5:36:45** · that's it have a look one last time and there's the amplifier and I think yeah now everything is where it's supposed to be the PCB is now ready to export from Kut and import into your manufacturer of choice in my case I'm going to go ahead with the order and the assembly through next PCB let's have a look at what that

### 3D Model Configuration and Visualization

**5:37:08** · looks like on the next PCB website let's go back to the homepage just to make this easy to follow as possible when you go to the next PCB website you've got a couple of options you see under PCB service the first one is to get a quote for a PCB only without any components assembled on it and the other one is to go for the full assembly if you go for the quote all you've got to do is to upload the Gerber files if you go for a

**5:37:37** · a assembly though things are a little bit more involved because you've got to upload the G files plus there's a bunch of files for the assembly part of it I'm going to go through the PB assembly quote process very quickly with you now first thing to do of course is to start with the Gerber files and since I've made a few changes to the PCB since last

**5:37:58** · time I exported my gers so I'm going to go and do that again so click on the plot file everything is already selected just going to use the same output folder and the new files here that I'm about to generate will overwrite the old files and that's okay so click on plot so yep refill the zones that's done with the

**5:38:21** · layers and then the drill files same thing generate and that's done then let's go to the project directory and uh here is the Gerber files and I'm going to create a zip file from the G because

**5:38:37** · that's how next PCB and actually in this case most manufacturers want the G files to be bundled inside a zip file now let's head over to the website so here I just need to drop the Gerber files see if I can do a drag and drop that you work yes it did I'm using Safari here and I've also done this with Firefox and chrome it all works the back end next p

**5:39:03** · be the website will analyze the files and giv me a view I can have a look at the view or I can also go to the G viewer the online tool that they have here analyzing the files I didn't have to re-upload them it's very convenient and then it gives you one more chance to have a look around and make sure that nothing has been missed have a look at the layers this is what next PCB is

**5:39:32** · going to work on they remember they don't have access to KY card they only have access to the gber files that You' just sent them I've already done a lot of checking so I'm not going to do anymore going to go back to the first step of the process here select the various parameters next PCB already detected that I've got four layers which is correct it's detected the dimensions

**5:39:57** · I can choose here how many copies of the PCB I'd like to have any other parameters color PCB thickness I just go with the standard whatever is standard here I go with that anything else you check here will have an increase in price and let's say that you're happy with this next step is step two which is the assembly so now two additional files are needed the first one is the croid

**5:40:23** · file the croid file is a data file used in electronics manufacturing to provide precise information about the placement of components on our PCB it's also known as a pick and place file or XY data file you need to first export it from kard before you can upload it to next PCB so let me show you how to do that you got to file in the PCB editor then fabrication outputs look for component placement POS or gbr file click on that

**5:40:56** · I'm just going to leave the output directory as this this is the home of the project directory and nothing else is needed just generate the position file that's it 81 components information so I can close this and then have a look at the new file that was just generated let's see it's this one right here one for the bottom and one for the top the one for the bottom doesn't have any information in it because there's no components on the bottom side but the top side has components so this data in

**5:41:26** · here it looks like this so the components it's reference it's value the package and the exact position whether it's rotated or not you can see it's all top side so I'm going to take this file and upload it to next PCB it says that I need to zip this file up even though it's a single file I'm going to do so just compressing it into zip and upload it it's done so how many

**5:41:57** · copies would I like let's say five then they need the bomb file the build of materials file here is my build of materials there's a lot of information in here but it's actually not that difficult and time consuming to put this file together you can get all the information that you need from E schema so in E schema click on this button here to bring up the symbol Fields table and from here you can select all the columns that you want to export in the bomb if you look at the next PCB instructions

**5:42:29** · they need a number for the row designator quantity manufacturer part number procurement type and customer note and you can download a template as well so make sure that all of these columns exist in your table and you can

**5:42:47** · enable or disable these columns by clicking on these boxes then go to the export Tab and you can export it from here so I've already done this and this is the bomb file that I've already actually sent them it's got the information that they need plus more information especially the description is very important because I can include things such as the source of a particular part you can see here I've got snaper where I sourced and verified

**5:43:17** · that this particular component is in stock and I've done this with other components as well let's go back to the website and upload the file here and the thing to remember as well I know there's a lot of things to remember but one more thing to remember it's okay I can just continue with whatever I have uploaded is that there are people on the back end

**5:43:36** · that are going to look at these files and provide you with feedback and then of course ask questions my order is ready to go this doesn't mean that this order is actually going to go through the production Engineers will be looking at the G files the centroid file and the bomb to make sure that they can actually produce this PCB for example with a bomb file they will ensure that all the

**5:44:02** · components needed to go on the board for the assembly are on hand and if they not on hand in the warehouse they'll have to order them and if they're having trouble sourcing any of those components they'll get back to you to let you know so you can decide of whether you can Source those components yourself or maybe you need to find Alternatives but there's a lot of back and forth communication between you and the production Engineers throughout the process that that may take one or two weeks for the production to actually get started my production

**5:44:34** · status is now complete and and the assembled boards have been sent but you can see here there's a dashboard that shows where in the process your PCB is if there's any questions from the engineering team you'll receive an email with the questions uh there are going to be photographs as well if there's a problem with a particular component maybe the fit is not appropriate you'll get a photograph to indicate the problem

**5:45:02** · and to find ways to fix it and you can see here some of the communications in stad changes uh over the last couple of weeks as this PCB was being manufactured I also want to show you here the engineering questions page on my next PCB account just for you to have a better understanding of what happens once you submit your assembly job once the engineers on the next PCB production floor get a hold of your project files

**5:45:30** · and they evaluate them most likely they will have questions so they will use this page here to Comm Comm unicate with you and you get email notifications as well to which you can reply or you can just go in here in this page have a look at each one of the messages and then use the the form provided to respond so of

**5:45:49** · course my project is complete you can see all of the messages that appear in this list so you can see how long the process took about 10 days from when the first message came to when it was completed and you can see the first message looks like this start down the bottom this is the whole history history here but you can see the first one was just to show that you know they've done a bit of work and they found something that needs to be fixed in this case here they attached an Excel sheet they identified three issues that needed my

**5:46:19** · attentions the first one had to do with two resistors and the connector and it says can't be soldered sometimes you just need to read in between the lines here so they have identified the components in the bomb that I provided there's a screenshot here and I like how they use screenshots to just pinpoint where the issue is so

**5:46:39** · you don't have to wonderand and there's a suggestion that's very helpful added to the pick and place file after looking at this I realized that there's actually no J5 component so what happened here was that there used to be a J5 component which are then deleted so there's no J5 that caused the confusion I just mentioned there a bit of History here that J5 was removed of the bom was submitted my mistake here that they picked up and the same thing applies for R17 and r 21 so things like that happen

**5:47:08** · here's another example that they picked up J1 switch one and switch 2 the issue here is that they don't have a specific part number they couldn't find the appropriate part number from their bom that I've sent them so I was a little

**5:47:24** · confused about this to be totally Frank so I asked a follow-up question I understood that they needed me to provide a part number but I also wanted to double check if there was something in the footprint that I provided that would cause them difficulties with soldering the response that I got from this was that no the footprints and you the geometry of the Pats here was not a problem that just didn't have the part number so I provided a new bomb with the

**5:47:52** · part numbers for those two components so the other thing was a bit of confusion as to the cathodes and the anodes of the capacitors and the dodes because of the symbols used to denote cathodes so this case I simply confirmed that where you see a dot in a capacitor footprint or this bracket silk screen drawing that

**5:48:15** · indicates the anode for the capacitors so dot is the anode not the cathode so there was a problem CAU early because they asked the right question and then for the diodes this symbol here the blue bracket graphic indicates the cathode so that was sorted out and it was fairly smooth sailing from then onward here's the next one asking me for confirmation

**5:48:40** · that the assembled PCB as I see it in these images is correct and then I had a very close look took my time to have a look around here so that was all pretty good the only thing that I did here was to ask for this particular header to be replaced just to put in something smaller like the one in j6 instead of this much ler one because this would make it harder for me to try out different devices on

**5:49:10** · this I squ C header CU I don't have a plug like this they were happy to make the switch of this specific header and then they came back to me just a little while later a couple of days later to let me know the song completed and just to confirm that there's no other changes i' like to the board but didn't have any additional requests so that was the end of this process after that at the beginning of the video I said I was planning to show you the final manuf factured PCB after receiving it from the

**5:49:39** · manufacturer next PCB however due to shipping delays and just knowe that it's Chinese New Year at the moment plus we had a public H in Australia so all that caused a delay with the delivery so having received the board yet but I am on a hectic schedule I just want to complete this video and not wait for the actual piece of be so there's that but once I do receive it I record a follow-up video where I'll unpack and

### Preparing Files for Manufacturing

**5:50:06** · show you what the real board looks like and I'm also be going to be doing a bit of testing I'll share my impressions of the final product walk you through the testing process I've have no idea if it will actually work I hope it will I've

**5:50:22** · spent a lot of time testing crosschecking and verifying the design just to make sure that I haven't missed anything big so I'm pretty confident that it will work but of course testing is required I do have high confidence that it will work but that remains to be be seen to make sure you don't miss that upcoming video please do subscribe to the tech expression Channel right now if you haven't done so already to quickly recap this very long video we covered

**5:50:50** · everything here from creating the schematic to managing libraries to designing the PCB layout routing performing the various design checks along the way I shared my experiences with Kat 9 I've been using for this video video K 9 release candidate 1 the beginning and a little bit later RC 2 when it came out and I was able to take advantage of the numerous improvements in kiat 9 along the way you saw firsthand what it is like to use kiat 9

**5:51:21** · to build a PCB like this one a four layer realistic iot PCB by the time that you watch this kick at 9.0 will be out and as a community I believe that we'll have gained an even better open-source PCB design tool so thank you for watching this unusually long video I truly appreciate your time and interest in this project and I hope that this video has been helpful in demonstrating the process from setting up the schematic and selecting components to laying out the PB and preparing it for

**5:51:55** · manufacturing if you found this content valuable please consider subscribing to the channel and to stay updated on future videos including as I said the follow up with the manufactured board don't forget to like this video and share it with others who might find it useful your support and feedback do mean a lot to me so feel free to leave a comment below with your thoughts questions or suggestions and I look forward to hearing from you
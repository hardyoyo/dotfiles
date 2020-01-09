#!/usr/bin/env python3

import socket, getpass, platform, psutil, time, calendar 
from cpuinfo import cpuinfo
from colored import fg, bg, attr


#Colors! Use the ANCI codes found here https://github.com/dslackw/colored

FontColor = 166 
AtColor = 15
TitleColor = 15

#ubuntu
DarkColor = 1
MedColor = 166
LightColor = 11


#You shouldn't need to touch anything bellow here!

cpu = cpuinfo.get_cpu_info()

RAM = psutil.virtual_memory()

Disk = psutil.disk_usage('/')

DiskTotal = round(Disk[0] / 1000000000,2)
DiskTaken = round(Disk[1] / 1000000000,2)
DiskFree = round(Disk[2] / 1000000000,2)
DiskPercent = Disk[3] 


RamTotal = round(RAM[0] / 1000000000,2)
RamTaken = round(RAM[5] / 1000000000,2)
RamFree = round(RAM[1] / 1000000000,2)
RamPercent = RAM[2] 

BootTime =  psutil.boot_time()
NowTime = calendar.timegm(time.gmtime())

UpTime = NowTime - BootTime




intervals = (
    ('W', 604800),  # 60 * 60 * 24 * 7
    ('D', 86400),    # 60 * 60 * 24
    ('H', 3600),    # 60 * 60
    ('M', 60),
    ('S', 1),
    )

def display_time(seconds, granularity=4444):
    result = []

    for name, count in intervals:
        value = seconds // count
        if value:
            seconds -= value * count
            if value == 1:
                name = name.rstrip('s')
            result.append("{} {}".format(int(value), name))
    return ', '.join(result[:granularity])


FormedTime =  display_time(UpTime)

HostName = socket.gethostname()
UserName = getpass.getuser()
Ver = platform.release()
Sys = platform.system()
Bit = platform.processor()
OS = platform.linux_distribution()

print("{}                          ./+o+-".format(fg(DarkColor)))
print("{}                  yyyyy-{} -yyyyyy+".format(fg(MedColor), fg(DarkColor)))
print("{}               ://+//////{}-yyyyyyo       {}{}{}@{}{}".format(fg(MedColor), fg(DarkColor), fg(FontColor), UserName, fg(AtColor), fg(FontColor), HostName))
print("{}           .++{} .:/++++++/-.{}+sss/`       {}OS:{} {} {} {}".format(fg(LightColor), fg(MedColor), fg(DarkColor),fg(TitleColor),fg(FontColor), OS[0], OS[1], OS[2]))
print("{}         .:++o:{}  /++++++++/:--:/-       {}Kernel:{} {} {} {}".format(fg(LightColor), fg(MedColor),fg(TitleColor),fg(FontColor), Bit, Sys, Ver))
print("{}        o:+o+:++.{}`..```.-/oo+++++/      {}Disk:{} {}\{} GB - {}%".format(fg(LightColor), fg(MedColor),fg(TitleColor), fg(FontColor), DiskFree, DiskTotal, DiskPercent ))
print("{}       .:+o:+o/.          {}`+sssoo+/     {}Uptime:{} {}".format(fg(LightColor), fg(MedColor), fg(TitleColor), fg(FontColor), FormedTime))
print("{}  .++/+:{}+oo+o:`            {} /sssooo.    {}CPU: {}{}".format(fg(MedColor), fg(LightColor), fg(MedColor), fg(TitleColor), fg(FontColor), cpu['brand']))
print("{} /+++//+:{}`oo+o              {} /::--:.    {}RAM: {}{}\{} GB - {}%".format(fg(MedColor), fg(LightColor), fg(MedColor), fg(TitleColor), fg(FontColor), RamTaken, RamTotal, RamPercent))
print("{} \+/+o+++{}`o++o              {} ++////.".format(fg(MedColor), fg(LightColor), fg(DarkColor)))
print("{}  .++.o+{}++oo+:`            {} /dddhhh.".format(fg(MedColor), fg(LightColor), fg(DarkColor)))
print("{}       .+.o+oo:.         {} `oddhhhh+".format(fg(LightColor), fg(DarkColor)))
print("{}        \+.++o+o`{}`-````.:ohdhhhhh+".format(fg(LightColor), fg(DarkColor)))
print("{}         `:o+++ {}`ohhhhhhhhyo++os:".format(fg(LightColor), fg(DarkColor)))
print("{}           .o:`{}.syhhhhhhh/{}.oo++o`".format(fg(LightColor), fg(DarkColor), fg(LightColor)))
print("{}               /osyyyyyyo{}++ooo+++/".format(fg(DarkColor), fg(LightColor)))
print("{}                   ````` {}+oo+++o\:".format(fg(DarkColor), fg(LightColor)))
print("{}                          `oo++.".format(fg(LightColor)))




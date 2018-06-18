#!/usr/bin/python
__author__ = 'iwateam'

import os,sys

def main():

  #value of the file that stores current version
  fname = "../pas.version"
  #value of the file where will be saved the new version
  versionfile = "version.properties"
  #default value for increment the version
  increment = "NoInc"
  #default value for the level to increment
  level = "NoLev"
  #var for the new version
  version=0
  #current value for fix level in the current version
  currfix=0
  #current value for minor level in the current version
  currmin=0
  #current value for major level in the current version
  currmaj=0

  parameterincre=False
  parameterlevel=False

  for o in sys.argv[1:]:
    if o == "-h" or o == "--help":
      usage()
      sys.exit()
    elif o == "-i" or o == "--increment":
      parameterincre=True
    elif parameterincre:
      increment=o
      parameterincre=False
    elif o == "-l" or o == "--level":
      parameterlevel=True
    elif parameterlevel:
      level=o
      parameterlevel=False
    else:
      print(o+" is not a valid input");
      usage()
      sys.exit()
  
  if os.path.isfile(fname):
    f = open(fname,'r')
    out = f.readlines()
    for line in out:
      version=line
  else:
    f = open(fname,'w')
    version='1.0.0'
    f.write(version)
    increment="NoInc"

  verlist=version.split('.')

  currfix=int(verlist[2])
  currmin=int(verlist[1])
  currmaj=int(verlist[0])
  
  if increment=="true":
    if level == 'Fix':
      currfix+=1
      version=verlist[0]+'.'+verlist[1]+'.'+str(currfix)
    elif level == 'Minor':
      currfix=0
      currmin+=1
      version=verlist[0]+'.'+str(currmin)+'.'+str(currfix)
    elif level == 'Major':
      currfix=0
      currmin=0
      currmaj+=1
      version=str(currmaj)+'.'+str(currmin)+'.'+str(currfix)
 
  # saving environment variable PAS_VERSION in a file
  f2 = open(versionfile,'w')
  f2.write("PAS_VERSION = "+version+"\n")
  f2.write("PAS_VERSION_FILE = "+fname)

def usage():
  print "Execute version_manager.py script. Run `python version_manager.py -option [value]`"
  print  "Options:"
  print  "-i, --increment increse in 1 the version of the App depends on the parameter level (true/false)"
  print  "-l, --level which level of the version increment (Fix/Minor/Major)"
  print  "-h, --help This help system"

if __name__ == "__main__":
  main()

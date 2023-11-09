#!/usr/bin/env python3

import sys, re, os, mimetypes, argparse, requests

  # NEEDED FOR A2
  # -f <name of file> translates and assembles file
  # -txl transform gcc output to x86prime
  # -asm assemble x86prime into byte stream
  # -list list (transformed and/or assembled) program
  # -show show each simulation step (requires -run)
  # -tracefile <name of file> create a trace file for later verification (requires -run)
  # -run <name of function> starts simulation at indicated function (requires -asm)

  # NEEDED FOR A3
  # -ooo enable out-of-order scheduling
  # -pipe simple/super/ooo select A3 pipeline configuration
  # -mem magic/real select A3 memory configuration

  # EXTRA STUFF THAT WILL BE IMPLEMENTED LATER
  # -bp_type t/nt/btfnt/oracle/local/gshare select type of branch predictor
  # -bp_size <size> select number of bits used to index branch predictor
  # -rp_size <size> select number of entries in return predictor
  # -mem_lat <clks> number of clock cycles to read from main memory
  # -d_assoc <assoc> associativity of L1 D-cache
  # -d_lat <latency> latency of L1 D-cache read
  # -d_idx_sz <size> number of bits used for indexing L1 D-cache
  # -d_blk_sz <size> number of bits used to address byte in block of L1 D-cache
  # -i_assoc <assoc> associativity of L1 I-cache
  # -i_lat <latency> latency of L1 I-cache read
  # -i_idx_sz <size> number of bits used for indexing L1 I-cache
  # -i_blk_sz <size> number of bits used to address byte in block of L1 I-cache
  # -l2_assoc <assoc> associativity of L2 cache
  # -l2_lat <latency> latency of L2 cache read
  # -l2_idx_sz <size> number of bits used for indexing L2 cache
  # -l2_blk_sz <size> number of bits used to address byte in block of L2 cache
  # -dec_lat <latency> latency of decode stages
  # -pipe_width <width> max number of insn fetched/clk
  # -print_config print detailed performance model configuration
  # -help  Display this list of options
  # --help  Display this list of options

parser = argparse.ArgumentParser(description='Transform gcc output to x86\', assemble and simulate.')
parser.add_argument('-f', dest='file',
                    help='translates and assembles file')
parser.add_argument('-asm', dest='asm', action='store_const',
                    const=True, default=False,
                    help='assemble x86prime into byte stream')
parser.add_argument('-txl', dest='txl', action='store_const',
                    const=True, default=False,
                    help='transform gcc output to x86prime')
parser.add_argument('-list', dest='list', action='store_const',
                    const=True, default=False,
                    help='list (transformed and/or assembled) program')
parser.add_argument('-show', dest='show', action='store_const',
                    const=True, default=False,
                    help='show each simulation step (requires -run)')
parser.add_argument('-tracefile', dest='tracefile',
                    help='create a trace file for later verification (requires -run)')
parser.add_argument('-ooo', dest='ooo', action='store_const',
                    const=True, default=False,
                    help='enable out-of-order scheduling')
parser.add_argument('-pipe', dest='pipe', type=str, choices=["simple","super","ooo"],
                    default="",
                    help='select A3 pipeline configuration')
parser.add_argument('-mem', dest='mem', type=str, choices=["magic","real"],
                    default="",
                    help='select A3 memory configuration')
parser.add_argument('-run', dest='procedure',
                    help='starts simulation at indicated procedure (requires -asm)')
parser.add_argument('-input', dest='input',
                    help='starts simulation at indicated procedure (requires -asm)')


args = parser.parse_args()

if args.file==None :
  print("Program needs an input file.\n")
  parser.print_help()
  exit()

extensions = args.file.split(".")
fileextension = extensions[-1]

# if fileextension != "s":
#   print("The input is expected to be a assembler program; fileextension 's'.\n")
#   exit()

if args.file==None :
  print("Program needs an input file.\n")
  parser.print_help()
  exit()

if not os.path.isfile(args.file):
  print("Input file does not exist: "+args.file+"\n")
  exit()

file = open(args.file, 'r')
args.fileCont = file.read()
file.close()

args.inputCont=""
if args.input != None:
  if not os.path.isfile(args.input):
    print("Input file (-input) does not exist: "+args.file+"\n")
    exit()
  file = open(args.input, 'r')
  args.inputCont = file.read()
  file.close()

# x86prime Online location
URL = "http://topps.diku.dk/compsys/x86prime.php"
# defining a params dict for the parameters to be sent to the API
DATA = {'file':args.fileCont, 'txl':args.txl, 'asm':args.asm, 'list':args.list, 'show':args.show, 'tracefile':args.tracefile, 'procedure':args.procedure, 'ooo':args.ooo, 'mem':args.mem, 'pipe':args.pipe, 'input':args.inputCont}
# sending get request and saving the response as response object
r = requests.post(url = URL, data = DATA)

URLDIR = "http://topps.diku.dk/compsys/x86prime_runs/"
# extracting data in json format
runid = r.text

error = requests.get(url = URLDIR+runid+".error")
output = requests.get(url = URLDIR+runid+".out")

if error.text != "":
  print(error.text)
  exit()
else:
  output = requests.get(url = URLDIR+runid+".out")
  print(output.text)

if args.tracefile != None:
  trace = requests.get(url = URLDIR+runid+".trace")
  file = open(args.tracefile, 'w')
  args.fileCont = file.write(trace.text)
  file.close()


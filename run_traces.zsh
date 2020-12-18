#!/usr/bin/env zsh
# Quick and dirty script to run trace commands and store output in relevant file

# Load module for shell native datetime handling
zmodload zsh/datetime

# Some constants
readonly TRACE_DIR="Tracer"
readonly ROCKS_VERSION="6.15.0"
readonly OUTPUT_DIR="$TRACE_DIR/bpft_outputs"
readonly OUTPUT_TIME_FMT="%Y%m%d-%H%M%S.%N" 
readonly TIMESTAMP="$(strftime $OUTPUT_TIME_FMT $EPOCREALTIME)"

# Ensure output dir exists
mkdir -pv $OUTPUT_DIR

# Decide which trace
trace=$(
  case $1 in
    (s*) echo "simple";;
    (f*) echo "pt_lock_time";;
    (m*) echo "all_mutex";;
    (p*) echo "mutex_ptc";;
  esac
)
shift

# Default executable
executable="examples/simple_example_traced"

# Set additional opts.
opts=""
while (( $# )); do
  case $1 in
    -e) executable=$2; shift;;
    -v) opts="-v $opts";;
    -o) opts="-o$OUTPUT_DIR/$trace_$TIMESTAMP.out $opts";;
    *)  echo "Unknown \"$*\""; break;;
  esac
  shift
done

sudo bpftrace $TRACE_DIR/bpft-$trace.lib_v$ROCKS_VERSION.bt -c "build/$executable" "$opts[1,$#opts - 1]"

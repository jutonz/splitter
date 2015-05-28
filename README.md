# Splitter

Splits mp3 files using their associated cuefiles. Also applies album ReplayGain to each split file's tag. 

## Usage

`splitter split great.mp3` Assumes a file called great.cue exists in the same directory

`splitter split good.mp3 --using even_better.cue` Specify a custom cuefile

`splitter split a_state_of_trance_714.mp3` Splits to a folder `714 (21 May 2015)`. 

`splitter split --force a_state_of_trance_714.mp3` Overwrites the output of the previous command.

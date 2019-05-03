library(tidyverse)

#pulses <- read.csv("testing_output2.txt", header=FALSE,
pulses <- read.csv("testing_output_after_exercise.txt", header=FALSE,
                   col.names = "pulse", stringsAsFactors = FALSE) %>% 
  as_tibble()

pulse_window <- 10 # window to use, in seconds

# remove first pulse, create a new column with new zero time
# create periods. 

pulses[-1,] %>% mutate(pulse0 = pulse - pulse[1]) %>%
  filter(pulse0 <= 180000) %>% 
  mutate(pulse_period = cut_width(pulse0, pulse_window*1000, boundary = 0)) %>% 
  group_by(pulse_period) %>%  count() %>% 
  mutate(bpm = n*60/pulse_window) -> tmp_after

pulses[-1,] %>% mutate(pulse0 = pulse - pulse[1]) %>%
  filter(pulse0 <= 180000) %>% 
  mutate(pulse_diff = pulse0 - lag(pulse0)) %>%
  mutate(bpm = 60000/pulse_diff) -> tmp_after

#####################

pulses <- read.csv("testing_output_music.txt", header=FALSE,
                   col.names = "pulse", stringsAsFactors = FALSE) %>% 
  as_tibble()

pulse_window <- 10 # window to use, in seconds

# remove first pulse, create a new column with new zero time
# create periods. 

pulses[-1,] %>% mutate(pulse0 = pulse - pulse[1]) %>%
  filter(pulse0 <= 180000) %>% 
  mutate(pulse_period = cut_width(pulse0, pulse_window*1000, boundary = 0)) %>% 
  group_by(pulse_period) %>%  count() %>% 
  mutate(bpm = n*60/pulse_window) -> tmp_after

pulses[-1,] %>% mutate(pulse0 = pulse - pulse[1]) %>%
  filter(pulse0 <= 180000) %>% 
  mutate(pulse_diff = pulse0 - lag(pulse0)) %>%
  mutate(bpm = 60000/pulse_diff) -> tmp_music

#!/bin/bash
mkdir -p app/data
cd app/data
uv run gdown https://drive.google.com/uc?id=1n29y5hr8JK2tGEdYNLtIXO8hWw7DkdJ1; # download ssw_esd.zip (wavs, txt, TextGrids)
uv run gdown https://drive.google.com/uc?id=1F-_o_6x43IuL-81QHozAab7l3PPG2DNE; # download val_ids.txt
uv run gdown https://drive.google.com/uc?id=1VgvuU1p79GLPikwGl3lO6lanDdneHZud; # download test_ids.txt
uv run gdown https://drive.google.com/uc?id=1KqPK3A8JpB57pzy5dEgkX9RRRkkPZS7S; # download vocoder_checkpoint
uv run gdown https://drive.google.com/uc?id=1loIzPv4BGoXVYgDtBu_BXbKytiQoAjmW; # download EmoSpeech checkpoint
uv run gdown https://drive.google.com/uc?id=1_g23gaPC7K1hO-kWJk9JOPJZR8olimxw; # download phones.json
unzip -qq ssw_esd.zip

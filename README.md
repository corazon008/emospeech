# EmoSpeech: Guiding FastSpeech2 Towards Emotional Text to Speech

[![arXiv](https://img.shields.io/badge/arXiv-2307.00024-brightgreen.svg?style=flat-square)](https://arxiv.org/abs/2307.00024) [![githubio](https://img.shields.io/badge/GitHub.io-Audio_Samples-blue?logo=Github&style=flat-square)](https://dariadiatlova.github.io/emospeech)

## How to run

### Build env

You can build an environment with `Docker` or `uv`.

#### To set up environment with Docker

If you don't have Docker installed, please follow the links to find installation instructions for [Ubuntu](https://docs.docker.com/desktop/install/linux-install/), [Mac](https://docs.docker.com/desktop/install/mac-install/) or [Windows](https://docs.docker.com/desktop/install/windows-install/).

Build docker image:

```
docker build -t emospeech .
```

Run docker image:

```
bash run_docker.sh
```

#### To set up environment with uv

If you don't have uv installed, please find the installation instructions for your OS [here](https://docs.astral.sh/uv/getting-started/installation/).

`uv` will create a virtual environment and install all dependencies specified in `pyproject.toml`. To build env with `uv` run:

```
uv sync
```

### Download and preprocess data

We used data of 10 English Speakers from [ESD dataset](https://github.com/HLTSingapore/Emotional-Speech-Data). To download all `.wav`, `.txt` files along with `.TextGrid` files created using [MFA](https://github.com/MontrealCorpusTools/mfa-models):

```
uv run download_data.py
```

To train a model we need precomputed durations, energy, pitch and eGeMap features. From `src` directory run:

```
uv run -m src.preprocess.preprocess
```

This is how your `app` folder should look like:

```
.
└── data
    ├── data
    │   └── ssw_esd
    ├── emospeech.ckpt
    ├── g_01800000
    ├── phones.json
    ├── preprocessed
    │   ├── duration
    │   ├── egemap
    │   ├── energy
    │   ├── mel
    │   ├── phones.json
    │   ├── pitch
    │   ├── stats.json
    │   ├── test.txt
    │   ├── train.txt
    │   ├── trimmed_wav
    │   └── val.txt
    ├── ssw_esd.zip
    ├── test_ids.txt
    └── val_ids.txt
```

### Training

1. Configure arguments in `config/config.py`.
2. Run `uv run -m src.scripts.train`.

### Testing

Testing is implemented on testing subset of ESD dataset. To synthesize audio and compute neural MOS (NISQA TTS):

1. Configure arguments in `config/config.py` under `Inference` section.
2. Run `uv run -m src.scripts.test`.

You can find NISQA TTS for original, reconstructed and generated audio in `test.log`.

### Inference

EmoSpeech is trained on phoneme sequences. Supported phones can be found in `data/preprocessed/phones.json`. This repositroy is created for academic research and doesn't support automatic grapheme-to-phoneme conversion. However, if you would like to synthesize arbitrary sentence with emotion conditioning you can:

1. Generate phoneme sequence from graphemes with [MFA](https://github.com/MontrealCorpusTools/mfa-models).

   1.1 Follow the [installation guide](https://montreal-forced-aligner.readthedocs.io/en/latest/installation.html)

   1.2 Download english g2p model: `mfa model download g2p english_us_arpa`

   1.3 Generate phoneme.txt from graphemes.txt: `mfa g2p graphemes.txt english_us_arpa phoneme.txt`

2. Run `uv run -m src.scripts.inference`, specifying arguments:

| **Аrgument** | **Meaning**                          | **Possible Values**                                                 | **Default value**                    |
| ------------ | ------------------------------------ | ------------------------------------------------------------------- | ------------------------------------ |
| `-sq`        | Phoneme sequence to synthesisze      | Find in `data/phones.json`.                                         | **Not set, required argument.**      |
| `-emo`       | Id of desired voice emotion          | 0: neutral, 1: angry, 2: happy, 3: sad, 4: surprise.                | 1                                    |
| `-sp`        | Id of speaker voice                  | From 1 to 10, correspond to 0011 ... 0020 in original ESD notation. | 5                                    |
| `-p`         | Path where to save synthesised audio | Any with `.wav` extension.                                          | generation_from_phoneme_sequence.wav |

For example

```
uv run -m src.scripts.inference --sq "S P IY2 K ER1 F AY1 V  T AO1 K IH0 NG W IH0 TH AE1 NG G R IY0 IH0 M OW0 SH AH0 N"
```

If result file is not synthesied, check `inference.log` for OOV phones.

## References

1. [FastSpeech 2 - PyTorch Implementation](https://github.com/ming024/FastSpeech2)
2. [iSTFTNet : Fast and Lightweight Mel-spectrogram Vocoder Incorporating Inverse Short-time Fourier Transform](https://github.com/rishikksh20/iSTFTNet-pytorch)
3. [Publicly Available Emotional Speech Dataset (ESD) for Speech Synthesis and Voice Conversion](https://github.com/HLTSingapore/Emotional-Speech-Data)
4. [NISQA: Speech Quality and Naturalness Assessment](https://github.com/gabrielmittag/NISQA)
5. [Montreal Forced Aligner Models](https://github.com/MontrealCorpusTools/mfa-models)
6. [Modified VocGAN](https://github.com/rishikksh20/VocGAN/tree/master)
7. [AdaSpeech](https://github.com/tuanh123789/AdaSpeech)

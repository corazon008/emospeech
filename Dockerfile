FROM mmcauliffe/montreal-forced-aligner:latest


RUN mfa model download g2p english_us_arpa

RUN echo 'alias get_seq="mfa g2p /data/graphemes.txt english_us_arpa /data/phoneme.txt"' >> ~/.bashrc

ENTRYPOINT [ "bash" ]

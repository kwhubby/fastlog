mylog.pl:

modified to accept direct entry from hand written shorthand notes, taken from 12 hour pacific time. Old commands work, just no need to specify any commands, just write the QSO information and it auto parses.
```
example entry:
1/11/2017 12am 3799 ea1dlu 33 33
qso: 2017-01-11T00:00:00 ea1dlu 80m SSB 33 33    
g3amn 33 33
qso: 2017-01-11T00:00:00 g3amn 80m SSB 33 33    
g3uck 33 33
qso: 2017-01-11T00:00:00 g3uck 80m SSB 33 33    
7157 py5ww 12:53am "jim" 'curitiba Brazil' c"ic7600 1kw e3l" 59 59
qso: 2017-01-11T00:53:00 py5ww 40m SSB 59 59  curitiba Brazil  jim
3795 44 py5ww
qso: 2017-01-11T00:53:00 py5ww 80m SSB 44     
1/15/2017 12:52pm ad0gw c"" "jim" CO
qso: 2017-01-15T12:52:00 ad0gw 80m SSB 59  CO   jim
w8kra "steve" 'appalacians' WV
qso: 2017-01-15T12:52:00 w8kra 80m SSB 59  WV appalacians  steve
kc7zz "bill" 'tucson' AZ
qso: 2017-01-15T12:52:00 kc7zz 80m SSB 59  AZ tucson  bill
5:50pm 7185 ki6wox 56 59 c"omiss"            
qso: 2017-01-15T17:50:00 ki6wox 40m SSB 56 59   omiss 
w5mev 56 56 
qso: 2017-01-15T17:50:00 w5mev 40m SSB 56 56   omiss 
kf5gtx 59 59
qso: 2017-01-15T17:50:00 kf5gtx 40m SSB 59 59   omiss 
w5paa 58
qso: 2017-01-15T17:50:00 w5paa 40m SSB 58    omiss 
ka2ffp 44
qso: 2017-01-15T17:50:00 ka2ffp 40m SSB 44    omiss 
kd2dmr 55 55
qso: 2017-01-15T17:50:00 kd2dmr 40m SSB 55 55   omiss 
k3uhu 22
qso: 2017-01-15T17:50:00 k3uhu 40m SSB 22    omiss 
w5meu 58
qso: 2017-01-15T17:50:00 w5meu 40m SSB 58    omiss 
6:45pm n2lu 54 55
qso: 2017-01-15T18:45:00 n2lu 40m SSB 54 55   omiss 
n5bfi MI 33 33
qso: 2017-01-15T18:45:00 n5bfi 40m SSB 33 33 MI  omiss 
ac2mt 44 44
qso: 2017-01-15T18:45:00 ac2mt 40m SSB 44 44   omiss 
...
```

fastlog
=======

A quick and dirty ham radio log transcription program, inspired by DL3CB's
"FLE": http://df3cb.com/fle/

## syntax

```
date YYYY-MM-DD
```
Sets the QSO date for new entries.  Note that this is ISO date format (this
differs from DL3CB's FLE syntax).

```
band <wavelength>
```
Sets the band for new entries.  Accepted bands: 630m, 160m, 80m, 60m, 40m, 30m,
20m, 17m, 15m, 12m, 10m, 6m, 4m, 2m, 70cm.  Note that the 'm' can be omitted, except
for 70cm.

```
mode <mode>
```
Sets the mode for new entries.  Accepted modes: SSB, CW, RTTY, PSK31, AM,
PHONE, DATA.  Case insensitive.  Note that the use of the "mode" keyword
differs from DL3CB's FLE syntax.

```
delete
drop
error
```

Removes the last qso logged.

```
[time fragment] <callsign> [sent rst] [@received rst] [#comment]
```
Adds a QSO entry to the log.  Time fragment adjusts the rightmost bits of the
timestamp first.  For example, if the last time entered was 2311, and the user
enters "3 W1AW", the timestamp will be updated to "2313" for the W1AW qso.

If a RST is omitted, "599" is used as a default, or "59" if the qso is for SSB
mode.

## execution

The script accepts a -q or --quiet option.  It can be run interactively or
reading a file.

```
$ ./fastlog.pl -q sampleinput.txt
Log file transcribed by fastlog. https://github.com/cruvolo/fastlog
<ADIF_VER:4>1.00
<EOH>
<QSO_DATE:8>20101130 <TIME_ON:4>2347 <CALL:5>DF3CB <BAND:3>20M <MODE:2>CW <RST_SENT:3>599
<EOR>
<QSO_DATE:8>20101130 <TIME_ON:4>2348 <CALL:6>DL6RAI <BAND:3>20M <MODE:2>CW <RST_SENT:3>599
<EOR>
<QSO_DATE:8>20101130 <TIME_ON:4>2348 <CALL:5>DJ2MX <BAND:3>20M <MODE:2>CW <RST_SENT:3>599
<EOR>
<QSO_DATE:8>20101130 <TIME_ON:4>2351 <CALL:6>DL4MCF <BAND:3>20M <MODE:2>CW <RST_SENT:3>579 <RST_RCVD:3>559 <COMMENT:12>Good contact
<EOR>
<QSO_DATE:8>20101201 <TIME_ON:4>0005 <CALL:5>DH1TW <BAND:3>15M <MODE:3>SSB <RST_SENT:2>59
<EOR>
```

```
$ ./fastlog.pl sampleinput.txt
date set: 2010-11-30
band set: 20m
mode set: cw
qso: 2010-11-30 2347 df3cb 20m cw 599
qso: 2010-11-30 2348 dl6rai 20m cw 599
qso: 2010-11-30 2348 dj2mx 20m cw 599
qso: 2010-11-30 2351 dl4mcf 20m cw 579 559 Good contact
date set: 2010-12-01
band set: 15m
mode set: ssb
qso: 2010-12-01 0005 dh1tw 15m ssb 59
qso: 2010-12-01 0007 w1aw 15m ssb 59
deleted qso: 2010-12-01 0007 w1aw 15m ssb
Log file transcribed by fastlog. https://github.com/cruvolo/fastlog
<ADIF_VER:4>1.00
<EOH>
<QSO_DATE:8>20101130 <TIME_ON:4>2347 <CALL:5>DF3CB <BAND:3>20M <MODE:2>CW <RST_SENT:3>599
<EOR>
<QSO_DATE:8>20101130 <TIME_ON:4>2348 <CALL:6>DL6RAI <BAND:3>20M <MODE:2>CW <RST_SENT:3>599
<EOR>
<QSO_DATE:8>20101130 <TIME_ON:4>2348 <CALL:5>DJ2MX <BAND:3>20M <MODE:2>CW <RST_SENT:3>599
<EOR>
<QSO_DATE:8>20101130 <TIME_ON:4>2351 <CALL:6>DL4MCF <BAND:3>20M <MODE:2>CW <RST_SENT:3>579 <RST_RCVD:3>559 <COMMENT:12>Good contact
<EOR>
<QSO_DATE:8>20101201 <TIME_ON:4>0005 <CALL:5>DH1TW <BAND:3>15M <MODE:3>SSB <RST_SENT:2>59
<EOR>
```

Interactive sessions can also work:

```
$ ./fastlog.pl > output.txt
date 2010-11-30
date set: 2010-11-30
band 20m
band set: 20m
mode cw
mode set: cw
1204 w1aw 579
qso: 2010-11-30 1204 w1aw 20m cw 579
$ cat output.txt
Log file transcribed by fastlog. https://github.com/cruvolo/fastlog
<ADIF_VER:4>1.00
<EOH>
<QSO_DATE:8>20101130 <TIME_ON:4>1204 <CALL:4>W1AW <BAND:3>20M <MODE:2>CW <RST_SENT:3>579
<EOR>
```

## known issues

* very little error checking / validity testing


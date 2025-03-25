# My NixOS Config

This is my NixOS config. The backbone (nix/home-manager) is based heavily on
Ampersand's "Reborn" config. I've taken that config, and blended it with my old
dots from my Gentoo days. This setup is made for a Lonovo Legion 5 Pro 16ARH7H,
but with some tinkering it should work on most systems. Plenty of credit due to
my good fiends, [wyatt](www.wyatt.wtf) and
[molecule31](https://molecule31.co.ua/) for helping me through the learning
process. This repository will be somewhat active as long as I'm using this
system--I go back and forwards between this and a old Thinkpad running Gentoo,
which I have no intention of moving over to Nix.

The RICE is based off of Ampersands, though I intend to change it quite a bit
once the system is mostly stable. Still plenty to be done! Expect actually
pictures here when it no longer looks exactly like ampersands.

![screenshot](./screenshots/cover1.png)

## Notice

While this config should work mostly out of the box, there are a few
applications which will require some tinkering, namely
[**Cider**](https://cider.sh/). This is a paid app, and you'll need to download
an AppImage you've bought from them. The particular version of Cider you buy
matters--Stable is typically behind by a few months. I don't like being on the
unstable branch, so I've opted to use an overlay for this particular app. I try
to keep pace with latest, but you may have to update it yourself, sorry.

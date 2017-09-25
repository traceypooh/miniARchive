# miniARchive
Augmented Reality app to recognize "mini me" statues inside Internet Archive HQ using ARKit Edit

# The Scheme
- User taps screen
- image is sent to backend
  - compares against pictures of statues using imagemagick `compare`.
    - for now, just 4 from 9/23/2017 (brewster, ted nelson, jason scott, tracey) 
  - returns person's name of the "best match"
- adds new ARAnchor (2d SpriteKit) to hover over where picture was taken
- Anchchor (text label) will remain "flat" and always facing mobile camera

## Just now "tapped" my (actual) photo and it identified me from the lineup!

_[the interesting code is here](miniARchive/Scene.swift)_

# Created app via
- began with SpriteKit (xCode 9)
- modified to get current picture from camera upon 'tap'
- mods to send picture and receive answer from server
- mods to change the default SpriteKit marker to text (name reply from server)

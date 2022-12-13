# Project 8 - Swifty Words

This project includes solutions to the challenges.

*Note: This project includes a challenge from [project 9](../Project-09-GrandCentralDispatch). The loading and parsing of a level now takes place in the background.*

## Challenges

1. Use the techniques you learned in project 2 to draw a thin gray line around the buttons view, to make it stand out from the rest of the UI.
2. If the user enters an incorrect guess, show an alert telling them they are wrong. You’ll need to extend the `submitTapped()` method so that if `firstIndex(of:)` failed to find the guess you show the alert.
3. Try making the game also deduct points if the player makes an incorrect guess. Think about how you can move to the next level – we can’t use a simple division remainder on the player’s `score` any more, because they might have lost some points.

## Additional Challenges

* [Project 9](Project-09-GrandCentralDispatch) - Modify project 8 so that loading and parsing a level takes place in the background. Once you’re done, make sure you update the UI on the main thread!

## Screenshots

### Light Mode

<div>
  <img src="Screenshots/Light/Light_01.png" width="350">
  <img src="Screenshots/Light/Light_02.png" width="500">
  <img src="Screenshots/Light/Light_03.png" width="500">
  <img src="Screenshots/Light/Light_04.png" width="500">
</div>

### Dark Mode

<div>
  <img src="Screenshots/Dark/Dark_01.png" width="350">
  <img src="Screenshots/Dark/Dark_02.png" width="500">
  <img src="Screenshots/Dark/Dark_03.png" width="500">
  <img src="Screenshots/Dark/Dark_04.png" width="500">
</div>

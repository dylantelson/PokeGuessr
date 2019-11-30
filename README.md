# PokeGuessr
Guess that Pokémon! In this app, you are given a few traits of a Pokémon and must use that information to decipher its name. Project developed by Dylan Telson and Paul Maino for CS441 Project 5.

The traits you are given are:
- Type(s)
- Generation
- One possible ability
- Height

The faster you answer, the higher your score!

Sign up and test your knowledge!

![Screenshot 1](https://i.imgur.com/9sCrG6E.png)

---

Progress:
- Oct 31: First commit, added initial elements.
- Nov 1: Added images, did some bookkeeping on the repo.
- Nov 2: Implemented basic functionality using PokeAPI. A random Pokémon is selected from a list and a few of its traits are given to the user as hints.
- Nov 3:  The current Pokemon's name is parsed into a list of characters mixed with random characters which the user must rearrange to get the right answer. Implemented answer checking.
- Nov 4: Added logo, fixed formatting, updated some buttons' functionality.
- Nov 5: Implemented Firebase for a basic implementation of account creation and login. Added screens for startup, login, and signup.
- Nov 6: Synced some misc. work between Dylan and Paul's workspaces, added second type to guess view.
- Nov 7: Reformatted text, now doesn't have strange leftover capitalization and dashes from API. More formatting work.
- Nov 8: Added label hints to each trait. Generation replaced Move in the guess view.
- Nov 9: Fixed constraints, removed "Swipe to Dismiss" feature, added "question mark" picture while the player is guessing.
- Nov 10: Changed design and colors, changed the navbar look, and updated Signup page to look better.
- Nov 12: Updated signup page.
- Nov 15: Score functionality added, score updates with time spent on guess.
- Nov 20: Fixed transitions, Firebase database implemented.
- Nov 21: Started work on scaling for multiple screen sizes, fixed timer score issue.
- Nov 22: Added anonymous signup.
- Nov 24: Fixed timer bug.
- Nov 25: Fixed cell overwrite bug.

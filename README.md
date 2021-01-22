# 100r theme editor

Create and edit 100r themes using this simple web app.


## Instructions

- Drag and drop themes into the window (or click the import button)
to view and edit them.
- Click on the different color names in the middle section to edit them
with the selection below.
- All changes are immediate, and you can see the accessibility
score of your theme in real time.
- Drag the theme picture on the top section out to save your theme
(or click the export button).


### How accessibility scores work

The scores next to each combination in the grid is the contrast ratio. It's a number that's a ratio against 1, so '15.9' is 15.9:1. The minimum is 1 and the max is 21.

These scores also have grades attached to them, these are the thresholds:

- 3 and under is 'X', which here means that it didn't make a grade.
- 3 - 4.5 is 'A' (minimum contrast for people with regular vision)
- 4.5 - 7 is 'AA'
- 7 and above is 'AAA'.


At the top of the theme, you'll see the overall grade for the theme, which is the score and grade of the least contrasting colour combination in your theme.

There are no real wrong answers with contrast accessibility when it comes to making themes for yourself - some people absolutely need things that are contrasted enough, but some people much prefer lower contrast. These scores are just a tool to help you make informed design choices.


---

## Accessibility

- This has not been built with screenreaders in mind, I will look into it in the future if people ask for it.
- All measurements are in rems, so it will scale with text size.
- Internet is required for building but works offline once built.

---

## Building

Building requires the following:

- Elm 0.19.1 (can be installed via `npm install elm`)
- terser (can be installed via `npm install terser`)

Building the web app involves the `make all` command.

An internet connection is required for the initial build, but
the app will work offline once built.

---

## License

This software is licensed CNPL v5.
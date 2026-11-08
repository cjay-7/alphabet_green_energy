---
name: Alphabet Green Energy
description: Clean, high-contrast field-work app with a single lime-green accent.
colors:
  primary: "#FFFFFF"
  secondary: "#272727"
  accent: "#99CA3C"
  on-accent: "#000000"
  card-bg: "#F7F6F1"
  success: "#4CAF50"
  text: "#212121"
typography:
  headline-lg:
    fontFamily: Montserrat
    fontSize: 30px
    fontWeight: 900
  headline-md:
    fontFamily: Montserrat
    fontSize: 26px
    fontWeight: 800
  headline-sm:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: 700
  title-lg:
    fontFamily: Poppins
    fontSize: 24px
    fontWeight: 500
  title-md:
    fontFamily: Poppins
    fontSize: 20px
    fontWeight: 500
  title-sm:
    fontFamily: Poppins
    fontSize: 18px
    fontWeight: 500
  body-lg:
    fontFamily: Montserrat
    fontSize: 18px
    fontWeight: 400
  body-md:
    fontFamily: Montserrat
    fontSize: 16px
    fontWeight: 400
  body-sm:
    fontFamily: Montserrat
    fontSize: 12px
    fontWeight: 400
rounded:
  md: 5px
spacing:
  xs: 8px
  sm: 10px
  md: 16px
  lg: 20px
  xl: 30px
components:
  button-primary:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.on-accent}"
    rounded: "{rounded.md}"
    padding: 15px
  button-outlined:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.secondary}"
    rounded: "{rounded.md}"
    padding: 15px
  card:
    backgroundColor: "{colors.card-bg}"
    textColor: "{colors.text}"
    rounded: "{rounded.md}"
    padding: 10px
---

## Overview

A practical, uncluttered interface for field staff and beneficiaries. White surfaces and near-black text carry the content; one lime-green accent marks the main action on each screen.

## Colors

- **Primary (#FFFFFF):** Page and surface background.
- **Secondary (#272727):** Charcoal for outlines, dark-theme surfaces and secondary actions.
- **Accent (#99CA3C):** Lime green, reserved for primary buttons and key highlights.
- **On-accent (#000000):** Text on accent fills.
- **Card-bg (#F7F6F1):** Warm off-white for dashboard cards.
- **Success (#4CAF50):** Confirmation states only.

## Typography

Montserrat for headlines and body, Poppins for titles. Headlines are heavy (700–900); body text stays at regular weight.

## Layout

Screens use 20px dashboard padding, 16px form padding and 8px between fields and buttons. Cards use 10px inner padding.

## Elevation & Depth

Flat. Buttons have zero elevation; separation comes from borders and the card background tint.

## Shapes

All buttons use a 5px corner radius.

## Components

- **Primary button:** Accent fill, black text, accent border, 15px vertical padding.
- **Outlined button:** White fill, charcoal text and border (inverted in dark theme).
- **Card:** Warm off-white background with dark text.

## Do's and Don'ts

- Do use the accent for one primary action per screen.
- Do keep text dark on light surfaces and on the accent.
- Don't use white text on the lime accent; contrast is too low.
- Don't add shadows; keep surfaces flat.

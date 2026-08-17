# Portrait Bezel V1 — source and provenance

- Runtime asset: `addon/BirdieSophieUI/Media/portrait-bezel.tga`
- Editable source: `design-assets/portrait-bezel-v1-source.png`
- Source SHA-256: `3b46ccbd2dabf9ad8016977d61d94a5ec20c63e1dd4ccb35dc969b09164cc593`
- Runtime SHA-256: `e1ef8cadc84958483b968fcb8b5d443f8bf09eb05747a675f66cfa4898ba1b8c`
- Generation mode: built-in image generation, transparent RGBA output
- Runtime conversion: 256 × 256, 32-bit RGBA, RLE TGA

## Final generation prompt

> Use case: ui-mockup
> Asset type: transparent raster ornament for a World of Warcraft Classic addon
> Input images: Image 1 is the current in-game implementation; Image 2 is the desired Birdie & Breakfast boutique Clubhouse design reference.
> Primary request: Create one square portrait-bezel ornament that can be overlaid around a 3D player or target portrait. It should make a rectangular WoW portrait read as a premium Night-Elf Clubhouse instrument.
> Style: restrained art-nouveau botanical frame, dark forest enamel, warm aged brass, tiny moon-violet accents, elegant leaf forms, subtle golf-scorecard precision.
> Composition: centered square opening occupying about 72% of the canvas, thin ornamental rim and slightly stronger corners; perfectly front-facing and symmetrical.
> Background: genuinely transparent outside the ornament and through the central portrait opening.
> Constraints: no portrait, no character, no words, no letters, no logo, no golf ball, no UI screenshot, no black rectangular background, no drop shadow outside the canvas, no watermark. High contrast edges readable at 100 pixels.

## Use notes

The bezel is original project media. Test at 104, 116 and 132 logical pixels before locking the final scale. It must frame the portrait rather than cover health, power, aura or target information.

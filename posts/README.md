# Adding a blog post

1. Copy `_template` to a new folder inside `posts`, such as `posts/my-next-post`, then edit its `index.qmd`.
2. Edit `index.qmd`: set the title, description, and date, then write the post in Markdown.
3. Keep `draft: true` while writing. Drafts are omitted from the rendered site.
4. Set `draft: false` when the post is ready. Run `quarto render` from the site root to rebuild the blog and all pages.

Published posts appear automatically, newest first. The `_template` folder is excluded from the site.

Run `quarto preview --profile preview --render all` from the site root to view the site locally. Pushing to `main` triggers the existing GitHub Pages publishing workflow.

## Photo essays

The Greenland draft is in `greenland/index.qmd`. Put original photographs in
`greenland/images/`, then add an image link on its own line between paragraphs.
Add a publication date before publishing. Do not set `draft: false` until the
photos and writing are ready.

- Put a blank line before and after every photograph. Write each note as a separate paragraph immediately above its photograph; without blank lines, wide photos can push the text to the side.
- Use `.column-page` on photographs to display them wider than the text, and `body-classes: photo-essay` in the post header for the photo essay styling.
- Blog images open in a lightbox when clicked. Use the same `group` value on a sequence to browse those photographs together.
- Captions go between `![...]`; `fig-alt` describes the visible image for accessibility.
- Keep the first photograph eager-loading and use `loading="lazy"` for later photographs.
- Quarto copies the referenced image files without recompressing them. Use original JPEG or PNG files rather than screenshots or messaging-app copies. HEIC or RAW photographs need browser-compatible exports; keep the camera originals separately.
- Photographs retain their aspect ratio and are not cropped. A `View original image` link can also open the original file directly for closer inspection.

For a large collection, smaller display copies can be added later for faster
loading while retaining full-resolution originals for enlarged viewing.

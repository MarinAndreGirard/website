# Adding a blog post

1. Start with `first-post/index.qmd`, or copy its folder to a new folder inside `posts`, such as `posts/my-next-post`.
2. Edit `index.qmd`: set the title, description, date, and categories, then write the post in Markdown.
3. Keep `draft: true` while writing. Drafts are omitted from the rendered site.
4. Set `draft: false` when the post is ready. Run `quarto render` from the site root to rebuild the blog and all pages.

Published posts appear automatically, newest first. Categories become topic filters on the blog page; use any topics you like. The starter post is a draft and stays hidden until you set `draft: false`.

Run `quarto preview` from the site root to view the site locally. Pushing to `main` triggers the existing GitHub Pages publishing workflow.

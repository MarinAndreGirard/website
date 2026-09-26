# Private website statistics

Sign in at https://maringirard.goatcounter.com to see visits over time, popular
pages, referring websites, and approximate visitor countries.

The tracker is configured in `_includes/analytics.html` and included on every
page by `_quarto.yml`. Render and publish the site as usual. No counter or
dashboard link appears on the public website. In GoatCounter Settings, keep
“Dashboard viewable by” restricted to logged-in users.

The count endpoint is public; never put a password, API token, or dashboard
access token in this repository. Hiding a link is not access control.

Local previews do not collect visits. The integration sends page paths without
query strings or fragments. GoatCounter uses cookie-free analytics.

Statistics start after deployment; earlier visits cannot be recovered this way.
Ad blockers can prevent counting, and some visits have no referral information.
To exclude your own visits on the live website, append `#toggle-goatcounter` to
its URL and reload; GoatCounter will show a confirmation for that browser.

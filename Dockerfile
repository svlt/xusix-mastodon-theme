FROM tootsuite/mastodon:v4.1.2

# Add theme files
COPY --chown=mastodon:mastodon app/javascript/ /opt/mastodon/app/javascript/
COPY --chown=mastodon:mastodon public/ /opt/mastodon/public/
RUN echo 'xusix: styles/xusix.scss' >> /opt/mastodon/config/themes.yml

# Recompile assets
RUN OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder rails assets:precompile branding:generate

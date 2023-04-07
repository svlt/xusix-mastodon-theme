FROM tootsuite/mastodon:v4.1.2

# Add theme files
COPY --chown=mastodon:mastodon app/javascript/styles/xusix/*.scss /opt/mastodon/app/javascript/styles/xusix/
COPY --chown=mastodon:mastodon app/javascript/styles/xusix.scss /opt/mastodon/app/javascript/styles/
RUN echo 'xusix: styles/xusix.scss' >> /opt/mastodon/config/themes.yml

# Recompile assets
RUN OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder rails assets:precompile

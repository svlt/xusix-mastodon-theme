FROM tootsuite/mastodon:v4.1.0

# Add theme files
COPY --chown=mastodon:mastodon app/javascript/styles/xusix/*.scss /opt/mastodon/app/javascript/styles/xusix/
COPY --chown=mastodon:mastodon app/javascript/styles/xusix.scss /opt/mastodon/app/javascript/styles/
RUN echo 'xusix: styles/xusix.scss' >> /opt/mastodon/config/themes.yml

# RUN ls -R /opt/mastodon/app/javascript/styles/ && exit 1

# Recompile assets
RUN OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder rails assets:precompile

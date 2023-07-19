FROM icr.io/appcafe/open-liberty:kernel-slim-java17-openj9-ubi

# Add a Liberty server configuration that includes all necessary features
COPY --chown=1001:0  server.xml /config/

# This script adds the requested XML snippets to enable Liberty features and grow the image to be fit-for-purpose.
# This option is available only in the 'kernel-slim' image type. The 'full' and 'beta' tags already include all features.
RUN features.sh

# Add interim fixes (optional)
COPY --chown=1001:0  interim-fixes /opt/ol/fixes/

# Add an application
COPY --chown=1001:0  Sample1.war /config/dropins/

# This script adds the requested server configuration, applies any interim fixes, and populates caches to optimize the runtime.
RUN configure.sh

# This script performs an InstantOn checkpoint of the application.
# The application can use beforeAppStart or afterAppStart to do the checkpoint.
# The default is beforeAppStart when not specified
RUN checkpoint.sh afterAppStart

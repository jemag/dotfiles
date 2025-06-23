 #!/usr/bin/env bash

JAR="$HOME/dev/jdtls-1.7.0/plugins/org.eclipse.equinox.launcher_*.jar"
java \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.protocol=true \
  -Dlog.level=ALL \
  -Xms1g \
  -Xmx2G \
  -javaagent:/home/jemag/.config/nvim/dependencies/lombok.jar \
  -Xbootclasspath/a:/home/jemag/.config/nvim/dependencies/lombok.jar \
  -jar $(echo "$JAR") \
  -configuration "$HOME/dev/jdtls-1.7.0/config_linux" \
  -data "$1" \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED

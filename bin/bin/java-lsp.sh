 #!/bin/bash

JAR="$HOME/dev/eclipse/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_*.jar"
export GRADLE_HOME=/usr/bin/gradle
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
  -configuration "$HOME/dev/eclipse/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux" \
  -data "$HOME/dev/eclipse/workspace" \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED

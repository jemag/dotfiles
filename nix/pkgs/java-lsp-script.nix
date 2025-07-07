{ pkgs }:

pkgs.writeShellScriptBin "javaLspScript" ''
    set -ev
    JDTLS_CONFIG_DIR=~/jdtls-config
    mkdir -p $JDTLS_CONFIG_DIR
    cp -r ${pkgs.jdt-language-server}/share/java/jdtls/config_linux/* $JDTLS_CONFIG_DIR/
    chmod -R 755 $JDTLS_CONFIG_DIR

    java \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.protocol=true \
    -Dlog.level=ALL \
    -javaagent:"${pkgs.lombok}/share/java/lombok.jar" \
    -Xms1g \
    --add-modules=ALL-SYSTEM \
    --add-opens \
    java.base/java.util=ALL-UNNAMED \
    --add-opens \
    java.base/java.lang=ALL-UNNAMED \
    -jar ${pkgs.jdt-language-server}/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration $JDTLS_CONFIG_DIR \
    -data \
    ~/workspace/
  ''


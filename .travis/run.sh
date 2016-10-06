
# http://d.defold.com/archive/5ca3dd134cc960c35ecefe12f6dc81a48f212d40/engine/linux/dmengine_headless
# http://d.defold.com/archive/5ca3dd134cc960c35ecefe12f6dc81a48f212d40/bob/bob.jar

SHA1=$(curl -s http://d.defold.com/stable/info.json | sed -n 's/\"sha1\": \"(.*)/\1/p')
curl -o dmengine_headless 'http://d.defold.com/archive/${SHA1}/engine/linux/dmengine_headless'
curl -o bob.jar 'http://d.defold.com/archive/${SHA1}/bob/bob.jar'
java -jar bob.jar --debug build
dmengine_headless
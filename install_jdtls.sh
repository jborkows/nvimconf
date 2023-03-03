#!/bin/bash
java_bin_dir=~/.local/bin/java
mkdir -p ${java_bin_dir}
echo Fetchnig java sdks
echo java 11
curl  https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz -o /tmp/jdk11.tar.gz
tar xvf /tmp/jdk11.tar.gz -C ${java_bin_dir}


echo java 17
curl https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_linux-x64_bin.tar.gz -o /tmp/jdk17.tar.gz
tar xvf /tmp/jdk17.tar.gz -C ${java_bin_dir}
echo java 19
curl  https://download.java.net/java/GA/jdk19/877d6127e982470ba2a7faa31cc93d04/36/GPL/openjdk-19_linux-x64_bin.tar.gz -o /tmp/jdk19.tar.gz
tar xvf /tmp/jdk19.tar.gz -C ${java_bin_dir}

echo jdltls 1.9
curl -L https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.9.0/jdt-language-server-1.9.0-202203031534.tar.gz -o /tmp/jdtls1_9.tar.gz 
mkdir  ${java_bin_dir}/jdtls1_9
tar xvf /tmp/jdtls1_9.tar.gz -C ${java_bin_dir}/jdtls1_9

echo google format
curl https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml -o ${java_bin_dir}/eclipse-java-google-style.xml
echo lombok
curl https://projectlombok.org/downloads/lombok.jar -o ${java_bin_dir}/lombok.jar 


echo building debuggers
export JAVA_HOME=${java_bin_dir}/jdk-17.0.1

pushd ${java_bin_dir}
# git clone --depth 1 https://github.com/microsoft/java-debug # till fix in microsoft
git clone --depth 1 https://github.com/rgrunber/java-debug -b fix-ftbfs java-debug #temporal fix
pushd java-debug
chmod u+x mvnw
./mvnw package
popd 


git clone --depth 1 https://github.com/microsoft/vscode-java-test 
pushd vscode-java-test
npm install
npm run build-plugin
popd 
popd 

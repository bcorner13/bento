for file in `find builds -type f -name *.box `
do
  # Format: builds/centos-6.9.virtualbox.box 
  vagrantBoxName=`echo $file|cut -d/ -f2`
echo vagrantBoxName:$vagrantBoxName

  name=`basename $vagrantBoxName .box|cut -d\. -f1,2`
echo name:$name

  version=`basename $vagrantBoxName .box|cut -d\- -f2|cut -d. -f 1,2`
echo version:$version

  provider=`basename $vagrantBoxName .box|cut -d\/ -f2|cut -d\. -f3`
echo provider:$provider

  curl --progress-bar -ubcorner:APNJTYcyv4J8NBvH8MwuAo5gFu -T $file "http://repo.fanatics.corp/artifactory/vagrant_box/${vagrantBoxName};box_name=${name};box_provider=${provider};box_version=${version}"
done

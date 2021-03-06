Write-Host "Checking docker daemon..."
If ((Get-Process | Select-String docker) -ne $null) {
    Write-Host "Docker is up and running"
}
Else {
    $Host.UI.WriteErrorLine("Please start Docker service. https://docs.docker.com/docker-for-windows/")
    return
}

If ((docker images | Select-String kylin-sandbox) -ne $null) {
    Write-Host "Found kylin-sandbox image"
}
Else {
    $Host.UI.WriteErrorLine("Please Build the Kylin Sandbox Image. https://github.com/codeyu/kylin-sandbox")
    return
}

If ((docker ps -a | Select-String kylin-sandbox) -ne $null) {
    Write-Host "kylin-sandbox container already exists"
}
Else {
    Write-Host "Running kylin-sandbox for the first time..."
    docker run -v hadoop:/hadoop --name kylin-sandbox --hostname "sandbox.hortonworks.com" --privileged -d `
    -p 1111:111 `
    -p 1000:1000 `
    -p 1100:1100 `
    -p 1220:1220 `
    -p 1988:1988 `
    -p 2049:2049 `
    -p 2100:2100 `
    -p 2181:2181 `
    -p 3000:3000 `
    -p 4040:4040 `
    -p 4200:4200 `
    -p 4242:4242 `
    -p 5007:5007 `
    -p 5011:5011 `
    -p 6001:6001 `
    -p 6003:6003 `
    -p 6008:6008 `
    -p 6080:6080 `
    -p 6188:6188 `
    -p 7070:7070 `
    -p 8000:8000 `
    -p 8005:8005 `
    -p 8020:8020 `
    -p 8032:8032 `
    -p 8040:8040 `
    -p 8042:8042 `
    -p 8080:8080 `
    -p 8082:8082 `
    -p 8086:8086 `
    -p 8088:8088 `
    -p 8090:8090 `
    -p 8091:8091 `
    -p 8188:8188 `
    -p 8443:8443 `
    -p 8744:8744 `
    -p 8765:8765 `
    -p 8886:8886 `
    -p 8888:8888 `
    -p 8889:8889 `
    -p 8983:8983 `
    -p 8993:8993 `
    -p 9000:9000 `
    -p 9090:9090 `
    -p 9995:9995 `
    -p 9996:9996 `
    -p 10000:10000 `
    -p 10001:10001 `
    -p 10015:10015 `
    -p 10016:10016 `
    -p 10500:10500 `
    -p 10502:10502 `
    -p 11000:11000 `
    -p 15000:15000 `
    -p 15002:15002 `
    -p 16000:16000 `
    -p 16010:16010 `
    -p 16020:16020 `
    -p 16030:16030 `
    -p 18080:18080 `
    -p 18081:18081 `
    -p 19888:19888 `
    -p 21000:21000 `
    -p 33553:33553 `
    -p 39419:39419 `
    -p 42111:42111 `
    -p 50070:50070 `
    -p 50075:50075 `
    -p 50079:50079 `
    -p 50095:50095 `
    -p 50111:50111 `
    -p 60000:60000 `
    -p 60080:60080 `
    -p 15500:15500 `
    -p 15501:15501 `
    -p 15502:15502 `
    -p 15503:15503 `
    -p 15504:15504 `
    -p 15505:15505 `
    -p 2222:22 kylin-sandbox /usr/sbin/sshd -D | Out-Null
}

If ((docker ps | Select-String kylin-sandbox) -ne $null) {
    Write-Host "kylin-sandbox started"
}
Else {
    Write-Host "Starting kylin-sandbox..."
    docker start kylin-sandbox | Out-Host
}

Write-Host "Starting processes on the kylin-sandbox..."

docker exec -d kylin-sandbox make --makefile /usr/lib/hue/tools/start_scripts/start_deps.mf  -B Startup -j -i | Out-Host
docker exec -d kylin-sandbox nohup su - hue -c '/bin/bash /usr/lib/tutorials/tutorials_app/run/run.sh' |  Out-Host
docker exec -d kylin-sandbox touch /usr/hdp/current/oozie-server/oozie-server/work/Catalina/localhost/oozie/SESSIONS.ser | Out-Host
docker exec -d kylin-sandbox chown oozie:hadoop /usr/hdp/current/oozie-server/oozie-server/work/Catalina/localhost/oozie/SESSIONS.ser | Out-Host
docker exec -d kylin-sandbox /etc/init.d/tutorials start | Out-Host
docker exec -d kylin-sandbox /etc/init.d/splash | Out-Host
docker exec -d kylin-sandbox /etc/init.d/shellinaboxd start | Out-Host

Write-Host "Waiting until Hadoop service is started..."
Start-sleep -s 60

Write-Host "Starting HBase"
docker exec -t kylin-sandbox su hbase - -c "/usr/hdp/2.5.0.0-1245/hbase/bin/hbase-daemon.sh --config /etc/hbase/conf start master; sleep 20" | Out-Host
docker exec -t kylin-sandbox su hbase - -c "/usr/hdp/2.5.0.0-1245/hbase/bin/hbase-daemon.sh --config /etc/hbase/conf start regionserver" | Out-Host

Write-Host "Starting Kylin"
docker exec kylin-sandbox su hdfs -l -c 'hdfs dfsadmin -safemode leave' | Out-Host
docker exec kylin-sandbox /usr/local/kylin/bin/kylin.sh start | Out-Host

Write-Host "Loading sample data..."
docker exec kylin-sandbox /usr/local/kylin/bin/sample.sh | Out-Host

Write-Host "kylin-sandbox is good to do.  Press any key to continue..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

return

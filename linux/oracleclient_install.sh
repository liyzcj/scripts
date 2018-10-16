mkdir -p /oracle/oraadm
unzip -o p13390677_112040_Linux-x86-64_4of7.zip -d /oracle/oraadm
groupadd -g 201 oinstall
groupadd -g 200 dba
useradd -u 300 -g oinstall -G dba -s /bin/bash -d /oracle -m oracle -p Oracle_1
mkdir -p /oracle/oraInventory
chown -R oracle:oinstall /oracle/oraInventory
chmod 775  /oracle/oraInventory

cat << EOF > /oracle/.bash_profile
export ORACLE_BASE=/oracle/app
export ORACLE_HOME=\$ORACLE_BASE/product/11gR2/db
export NLS_LANG=AMERICAN_AMERICA.AL32UTF8
export PATH=\$ORACLE_HOME/bin:/usr/sbin:\$PATH:/usr/local/bin
EOF

chown oracle:oinstall /oracle/.bash_profile

cat << EOF > /etc/oraInst.loc
inventory_loc=/oracle/oraInventory
inst_group=oinstall
EOF

chown oracle:oinstall /etc/oraInst.loc
chmod 664 /etc/oraInst.loc
chown -R oracle:oinstall /oracle

ORACLE_IP=`uname -n`
sed "s#@PR12@#$ORACLE_IP#g" ./Oclient.rsp > /tmp/Oclient.rsp
su - oracle -c "cd /oracle/oraadm/client;./runInstaller -silent -responseFile /tmp/Oclient.rsp"

    sleep 5
    while true; do
        sleep 1
        pid_count=`ps -fu oracle | grep -c OraInstall`
        if [ $pid_count -gt 0 ]; then
            echo -n "."
        else
            echo
            break
        fi
    done

    sleep 1
    if [ ! -f /oracle/app/product/11gR2/db/root.sh ]; then
        echo "===`date`==Install oracle11g failed,cannt find root.sh file."
        exit -1
    fi
    /oracle/app/product/11gR2/db/root.sh

cp ./tnsnames.ora /oracle/app/product/11gR2/db/network/admin
chown oracle:oinstall /oracle/app/product/11gR2/db/network/admin/tnsnames.ora
rm -rf /oracle/oraadm
rm /tmp/Oclient.rsp

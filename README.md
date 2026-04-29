# Slackware

1. Установка в QEMU с эмуляцией UEFI:  
   1.1 Создание файла куда будем ставить систему  
       qemu-img create -f qcow2 name-of-image.qcow2 num-of-gigabytes (20G for example)  
  
   1.2 Поиск файла OVMF.fd, его копирование и снятие органичений с него  
       find /usr -name "OVMF*.fd" 2>/dev/null  
       sudo cp path-to-OVMF.fd /home/username/  
       sudo chmod 666 /home/username/OVMF.fd  
  
   1.3 Запуск виртуальной машины с нужными параметрами  
       qemu-system-x86_64 -drive if=pflash,format=raw,file=/path-to-OVMF.fd -enable-kvm -machine accel=kvm -m 4G -hda /path-to-qcow2-image -cdrom /path-to-iso -boot order=d -cpu host -smp cores=2 -vga std -display gtk  
       Дальше просто установка системы.  
       Если на выбраном файле OVMF.fd уже запускалась виртуалка, то его надо удалить и перекопировать.  
  
   1.4 Когда система уже установлена, её запуск производится командой  
       qemu-system-x86_64 -drive if=pflash,format=raw,file=/path-to-OVMF.fd -enable-kvm -machine accel=kvm -m 4G -hda /path-to-qcow2-image -boot order=d -cpu host -smp cores=2 -vga std -display gtk  
  
  
2. Настройка системы после установки  
   2.1 Подключаем интернет  
       В виртуалке dhcpcd eth0. На реальной системе пока не знаю. Подключение проверяем ping slackware.com  
  
   2.2 Настраиваем зеркала  
       nano /etc/slackpkg/mirrors  
       Раскоментируем нужное зеркало  
  
   2.3 Блокируем пакеты ядра  
       nano /etc/slackpkg/blacklist  
       Раскоментируем пакеты ядра  
  
   2.4 Обновляемся (https://docs.slackware.com/slackware:slackpkg + https://docs.slackware.com/howtos:slackware_admin:systemupgrade)  
       slackpkg update gpg  
       slackpkg update  
       slackpkg upgrade slackpkg  
       slackpkg new-config  
       slackpkg upgrade aaa_glibc-solibs  
       slackpkg install-new  
       slackpkg upgrade-all  
       slackpkg clean-system  


3. Создание iso со своими tagfile  
   3.1 Выбираем зеркало на https://mirrors.slackware.com/mirrorlist/  
   3.2 Качаем файлы  
       rsync -avPH --delete rsync:chosen-mirror /where-to-download/slackware-iso/  
   3.3 Меняем tagfiles на свои  
       for series in ~/Загрузки/edited-tagfiles/*; do  
         name=$(basename "$series")  
         sudo cp "$series/tagfile" /mnt/myslack/slackware64/$name/tagfile  
       done  
   3.4 Собираем ISO
       Пеереходим в /where-to-download/slackware/ и выполняем
       xorriso -as mkisofs -iso-level 3 -full-iso9660-filenames -R -J -A "Slackware Install" -hide-rr-moved -v -d -N -eltorito-boot isolinux/isolinux.bin -eltorito-catalog isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -eltorito-alt-boot -e isolinux/efiboot.img -no-emul-boot -isohybrid-gpt-basdat -volid "SlackDVD" -output ~/WHERE-TO-SAVE/name-of-iso.iso .  





   

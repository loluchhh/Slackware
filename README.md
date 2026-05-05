[README.md](https://github.com/user-attachments/files/27198914/README.md)
# Slackware — установка и настройка

## 1. Установка в QEMU с эмуляцией UEFI

### 1.1 Создание образа диска

```bash
qemu-img create -f qcow2 name-of-image.qcow2 20G
```

### 1.2 Подготовка OVMF

```bash
# Найти файл
find /usr -name "OVMF*.fd" 2>/dev/null

# Скопировать и снять ограничения
cp /path/to/OVMF.fd ~/OVMF.fd
chmod 666 ~/OVMF.fd
```

> Если на файле OVMF.fd уже запускалась виртуалка — удали его и перекопируй заново.

### 1.3 Запуск установки

```bash
qemu-system-x86_64 \
  -drive if=pflash,format=raw,file=/path/to/OVMF.fd \
  -enable-kvm \
  -machine accel=kvm \
  -m 4G \
  -hda /path/to/image.qcow2 \
  -cdrom /path/to/slackware.iso \
  -boot order=d \
  -cpu host \
  -smp cores=2 \
  -vga std \
  -display gtk
```

Дальше стандартная установка системы.  
После завершения установки не перезагружаясь выходим из установщика в терминал и устанавливаем загрузчик GRUB  

```bash
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
mount --bind /dev /mnt/dev
mount --bind /sys/firmware/efi/efivars /mnt/sys/firmware/efi/efivars
chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Slackware
grub-mkconfig -o /boot/grub/grub.cfg
```

### 1.4 Запуск установленной системы

```bash
qemu-system-x86_64 \
  -drive if=pflash,format=raw,file=/path/to/OVMF.fd \
  -enable-kvm \
  -machine accel=kvm \
  -m 4G \
  -hda /path/to/image.qcow2 \
  -cpu host \
  -smp cores=2 \
  -vga std \
  -display gtk
```

---

## 2. Настройка системы после установки

### 2.1 Подключение к интернету

```bash
# В виртуалке
dhcpcd eth0

# Проверка
ping slackware.com
```

> На реальном железе — через `wpa_supplicant` + `dhcpcd`.

### 2.2 Настройка зеркала

```bash
nano /etc/slackpkg/mirrors
# Раскомментировать нужное зеркало
```

### 2.3 Блокировка пакетов ядра

```bash
nano /etc/slackpkg/blacklist
# Раскомментировать пакеты ядра
```

### 2.4 Обновление системы

Документация: [slackpkg](https://docs.slackware.com/slackware:slackpkg) · [systemupgrade](https://docs.slackware.com/howtos:slackware_admin:systemupgrade)

```bash
slackpkg update gpg
slackpkg update
slackpkg upgrade slackpkg
slackpkg new-config
slackpkg upgrade aaa_glibc-solibs
slackpkg install-new попробовать не делать, докачивает тонну хлама
slackpkg upgrade-all
slackpkg clean-system
```

---

## 3. Создание ISO со своими tagfile

### 3.1 Выбор зеркала

Выбрать зеркало на [mirrors.slackware.com](https://mirrors.slackware.com/mirrorlist/).

### 3.2 Скачивание дерева Slackware

```bash
rsync -avPH --delete rsync://chosen-mirror /where-to-download/slackware-iso/
```

### 3.3 Замена tagfile

```bash
for series in ~/path/to/edited-tagfiles/*; do
  name=$(basename "$series")
  cp "$series/tagfile" /path/to/slackware64/$name/tagfile
done
```

### 3.4 Сборка ISO

Перейти в директорию с деревом Slackware и выполнить:

```bash
xorriso -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -R -J -A "Slackware Install" \
  -hide-rr-moved \
  -v -d -N \
  -eltorito-boot isolinux/isolinux.bin \
  -eltorito-catalog isolinux/boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -eltorito-alt-boot \
  -e isolinux/efiboot.img \
  -no-emul-boot \
  -isohybrid-gpt-basdat \
  -volid "SlackDVD" \
  -output ~/path/to/output.iso \
  .
```

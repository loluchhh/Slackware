# Делаем кастомное iso со своими тегфайлами

Создаём отдельную папку для iso

```bash
mkdir isofolder
```

Клонируем всю мою репу

```bash
git clone https://github.com/loluchhh/slackware
```

Выбираем зеркало на mirrors.slackware.com и скачиваем актуальные файлы Slackware для iso

```bash
# Ссылка без https
rsync -avPH --delete rsync://chosen-mirror isofolder/
```

Меняем тегфайлы на мои

```bash
for series in slackware/tagfiles/*; do
  name=$(basename "$series")
  cp "$series/tagfile" isofolder/slackware64/$name/tagfile
done
```

Переходим в папку с файлами для iso и собираем его

```bash
cd isofolder

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
  -output slackware.iso \
  .
```

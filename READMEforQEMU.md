**Установка и конфигурация Slackware**

Пакеты в tagfile's заточены конкретно под ноут Alienware m18 r1 (r9 7945hx + radeon rx 7900m)

# Создание модифицированного iso

```bash
git clone https://github.com/loluchh/Slackware
cd Slackware/tagfiles
```

Далее сборка самого iso

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


Todo:

- [ ] Описать установку Niri

- [ ] Описать установку EWW

- [ ] Описать установку slackpkg+

- [ ] Описать установку sbopkg

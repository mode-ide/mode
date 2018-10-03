out = _build
outapp = _build/mode.app
icon_size = 1024 512 256 128 64 32 16

clean::
	rm -rf _build

build:: $(out)/mode.icns
	./build/build-app
	mv $(out)/mode.icns $(outapp)/Contents/Resources/kitty.icns

# icon rendering

$(out)/mode.icns: $(out)/mode.iconset
	@echo "creating mode.icns"
	@mkdir -p $(@D)
	@iconutil -c icns $(<) $(@)

$(out)/mode.iconset: \
	$(foreach size,$(icon_size),$(out)/mode.iconset/icon_$(size)x$(size).png)
	@echo "creating mode.iconset"

define rendericon

$(out)/mode.iconset/icon_$(1)x$(1).png: logo/mode.svg
	@echo "creating mode.iconset/icon_$(1)x$(1).png"
	@mkdir -p $(out)/mode.iconset
	@rsvg-convert \
		-w $(1) -h $(1) \
		-o $(out)/mode.iconset/icon_$(1)x$(1).png \
		logo/mode.svg
	@optipng -quiet -o7 -strip all $(out)/mode.iconset/icon_$(1)x$(1).png

endef

$(foreach \
	size,\
	$(icon_size),\
	$(eval $(call rendericon,$(size))))

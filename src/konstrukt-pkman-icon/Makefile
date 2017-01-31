RESOLUTIONS = 16 24 32 48 64 128

define gen_icon_pngs
$(foreach resolution,$(RESOLUTIONS),$(1)$(resolution).png)
endef

define resolution_rules
%$(1).png: %.svg
	inkscape --file=$$< \
	         --export-png=$$@ \
	         --export-width=$(1) \
	         --export-height=$(1)
endef

$(foreach resolution,$(RESOLUTIONS),$(eval $(call resolution_rules,$(resolution))))

%.ico: $(call gen_icon_pngs,%)
	icotool --create -o $@ $^

all: icon.ico $(call gen_icon_pngs,icon)

clean:
	rm icon.ico $(call gen_icon_pngs,icon)

.PHONY: all clean

#!/usr/bin/env python3

import sys
from PIL import Image, ImageColor, ImageDraw

def main():
    alpha = 0.75
    colors = []
    path = sys.argv[1]
############### Make Swatch #############################
    with open('column.txt') as color_file:
        raw_colors = color_file.read().splitlines()
        color_file.close()

        for raw_clr in raw_colors:
            if raw_clr:
                colors.append(raw_clr)

    im = Image.new("RGB", (864, 32))

    draw = ImageDraw.Draw(im)
    pos = 0

    for clr in colors:
        parsed_clr = ImageColor.getrgb(clr)
        draw.rectangle([pos, 0, pos+48, 32], parsed_clr)
        pos += 48
    im.save("./swatch.jpg")

################ Make Preview ##########################
    size = 1280, 720
    try:
        wallpaper = Image.open("./wallpaper")
        wallpaper.thumbnail(size, Image.BICUBIC)
        wallpaper.save("./wallpaper-preview.jpg", "JPEG")
    except IOError:
        print( "cannot create thumbnail. Remaking configs?")

################ Termite config ########################

    termite = "" 
    with open(path + '/termite-header') as stub:
        termite = stub.read()

    fore = ImageColor.getrgb(colors[1])
    back = ImageColor.getrgb(colors[0])
    afore = "rgba({}, {}, {}, {})".format(fore[0], fore[1], fore[2], alpha)
    aback = "rgba({}, {}, {}, {})".format(back[0], back[1], back[2], alpha)
    abackt = "rgba({}, {}, {}, {})".format(back[0], back[1], back[2], alpha + 0.15)


    with open('termite-config', 'w') as tconf:
        tconf.write(termite)
        tconf.write("[colors]\n")
        tconf.write("background = {}\n".format(abackt))
        tconf.write("foreground = {}\n".format(colors[1]))        
        tconf.write("cursor = {}\n".format(colors[1]))
        
        for zx in range(0, 16):
            tconf.write("color{} = {}\n".format(zx, colors[zx+2]))
################ Waybar config #########################
    template = ""
    with open(path + '/waybar-base.css') as tm:
        template = tm.read()

    with open('waybar.css', 'w') as css:
        template = template.replace("<alpha-background>", aback)
        template = template.replace("<alpha-foreground>", afore)
        template = template.replace("<background>", colors[0])
        template = template.replace("<foreground>", colors[1])

        tags = ["black", "red", "green", "orange", "blue", "purple", "cyan", "grey"]
        for x in range(0, 16):
            if x < 8:
                template = template.replace("<{}>".format(tags[x]), colors[x+2])
            else:
                template = template.replace("<light-{}>".format(tags[x-8]), colors[x+2])
        css.write(template)

################ Sway config ##########################

    with open('sway-colors', 'w') as sconf:
        sconf.write("# This loads colors based on the theme\n")
        ## class, border, background, text, indicator
        sconf.write("client.focused {} {} {} {} {}\n".format(colors[7], colors[7], colors[17], colors[0], colors[0]))
        sconf.write("client.unfocused {} {} {} {} {}\n".format(colors[9], colors[9], colors[10], colors[17], colors[17]))
        sconf.write("client.focused_inactive {} {} {} {} {}\n".format(colors[8], colors[8], colors[17], colors[17], colors[17]))
        sconf.write("client.urgent {} {} {} {} {}\n".format(colors[5], colors[5], colors[17], colors[0], colors[0]))


if __name__ == "__main__":
    main()

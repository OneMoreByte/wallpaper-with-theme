#!/usr/env python3

from PIL import Image, ImageColor, ImageDraw

def main():
    # name=NAME
    # 18 colors
    #
    colors = []

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

if __name__ == "__main__":
    main()

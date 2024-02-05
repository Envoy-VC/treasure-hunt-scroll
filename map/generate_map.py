from PIL import Image

def convert_image_to_array(image_path):
    # Open the image
    image = Image.open(image_path)
    grayscale_image = image.convert("L")
    resized_image = grayscale_image.resize((32, 32))
    pixels = list(resized_image.getdata())

    terrain_array = []
    for pixel_value in pixels:
        if pixel_value < 100:
            terrain_array.append("O")  # Ocean
        elif 100 <= pixel_value < 200:
            terrain_array.append("L")  # Land
        else:
            terrain_array.append("S")  # Sand

    terrain_2d_array = [terrain_array[i:i + 32] for i in range(0, len(terrain_array), 32)]

    return terrain_2d_array


image_path = "./map/world.png"
terrain_array = convert_image_to_array(image_path)


for row in terrain_array:
    print("".join(row), end="")
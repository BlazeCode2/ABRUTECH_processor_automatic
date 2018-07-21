import numpy as np
import cv2

im_name = "sample.bmp"
im_mat = cv2.imread(im_name)

hex_name = "imhex.hex"
hex_file = open(hex_name, 'wb')

for i in range(100):
    print im_mat[0][i]

im_file.close()

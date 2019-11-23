import cv2
import numpy as np
import imageio

MAX_MOVE = 4
LEVEL = 5
FRAME = 6

origin_image = cv2.imread("E:/PyCharm/depth23D/Disparity/bear1L.jpg")
depth_image = cv2.imread("E:/PyCharm/depth23D/bear1depth1.jpg")
depth_image = cv2.cvtColor(depth_image, cv2.COLOR_RGB2GRAY)

HEIGHT = origin_image.shape[0]
WIDTH = origin_image.shape[1]
DEPTH = origin_image.shape[2]
DATA_TYPE = origin_image.dtype
origin_image = origin_image.astype("uint16")

threshold = 255 / (LEVEL - 1)
new_image = np.ndarray(shape=[LEVEL, HEIGHT, WIDTH, DEPTH], dtype="uint16")
final_image = np.ndarray(shape=[FRAME, HEIGHT, WIDTH - (MAX_MOVE + 1) * round(FRAME / 2), DEPTH], dtype=DATA_TYPE)


def overlap(org_img, feature_img, step):
    step = round(step + 4)
    # domain = feature_img != 256
    # org_img[domain] = feature_img[domain]
    # trans = np.zeros(shape=[2, 3], dtype=float)
    # trans[0][0] = 1
    # trans[0][2] = step / 10
    # trans[1][1] = 1
    # org_img = cv2.warpAffine(org_img, trans, (org_img.shape[1], org_img.shape[0]))
    for h in range(HEIGHT):
        for w in range(WIDTH):
            if feature_img[h, w] != 256:
                if 0 <= w + step < WIDTH:
                    org_img[h, w + step] = feature_img[h, w]
    return org_img


for i in range(1, LEVEL + 1):
    b, g, r = cv2.split(origin_image)
    if i == 1:
        domain1 = depth_image > i * threshold
        domain2 = depth_image < (i - 1) * threshold
    else:
        domain1 = depth_image > i * threshold
        domain2 = depth_image <= (i - 1) * threshold
    b[domain1] = 256
    b[domain2] = 256
    g[domain1] = 256
    g[domain2] = 256
    r[domain1] = 256
    r[domain2] = 256
    new_image[i - 1, :, :, 0] = r
    new_image[i - 1, :, :, 1] = g
    new_image[i - 1, :, :, 2] = b

for i in range(1, FRAME + 1):
    emtImg = np.zeros((HEIGHT, WIDTH, DEPTH), dtype="uint16")
    for j in range(1, LEVEL + 1):
        # temp = np.zeros((emtImg.shape[0], emtImg.shape[1]), dtype=DATA_TYPE)
        emtImg[:, :, 0] = overlap(emtImg[:, :, 0], new_image[j - 1, :, :, 0],
                                  MAX_MOVE / LEVEL * j * (i - round(FRAME / 2)))
        # mask = emtImg[:, :, 0] == 0
        # temp[mask] = 255
        # emtImg[:, :, 0] = cv2.inpaint(emtImg[:, :, 0], temp, 3, cv2.INPAINT_NS)
        emtImg[:, :, 1] = overlap(emtImg[:, :, 1], new_image[j - 1, :, :, 1],
                                  MAX_MOVE / LEVEL * j * (i - round(FRAME / 2)))
        # mask = emtImg[:, :, 1] == 0
        # temp[mask] = 255
        # emtImg[:, :, 1] = cv2.inpaint(emtImg[:, :, 1], temp, 3, cv2.INPAINT_NS)
        emtImg[:, :, 2] = overlap(emtImg[:, :, 2], new_image[j - 1, :, :, 2],
                                  MAX_MOVE / LEVEL * j * (i - round(FRAME / 2)))
        # mask = emtImg[:, :, 2] == 0
        # temp[mask] = 255
        # emtImg[:, :, 2] = cv2.inpaint(emtImg[:, :, 2], temp, 3, cv2.INPAINT_NS)
    emtImg = cv2.merge([emtImg[:, :, 0], emtImg[:, :, 1], emtImg[:, :, 2]])
    final_image[i - 1, :, :, :] = emtImg[:, MAX_MOVE * round(FRAME / 2):WIDTH - round(FRAME / 2), :]

for i in range(FRAME):
    temp = np.zeros((final_image.shape[1], final_image.shape[2]), dtype=DATA_TYPE)
    mask = final_image[i, :, :, 0] == 0
    temp[mask] = 255
    final_image[i] = cv2.inpaint(final_image[i], temp, 3, cv2.INPAINT_NS)

frames = []
for i in range(FRAME):
    frames.append(final_image[i])
for i in range(FRAME):
    frames.append(final_image[FRAME - i - 1])
imageio.mimsave("E:/PyCharm/depth23D/gif1.gif", frames, 'GIF', duration=0.05)

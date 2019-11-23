import numpy as np
import cv2

imgl = cv2.imread("E:/PyCharm/depth23D/Disparity/bear1L.jpg")
imgr = cv2.imread("E:/PyCharm/depth23D/Disparity/bear1R.jpg")
imgl = cv2.cvtColor(imgl, cv2.COLOR_RGB2GRAY)
imgr = cv2.cvtColor(imgr, cv2.COLOR_RGB2GRAY)

stereo = cv2.StereoSGBM_create(preFilterCap=15, numDisparities=16, blockSize=5, minDisparity=0,
                               uniquenessRatio=10, speckleWindowSize=100, speckleRange=2, disp12MaxDiff=1,
                               P1=8 * 5, P2=32 * 5)
disparity = stereo.compute(imgl, imgr)
# disparity = disparity / 16
disp = cv2.normalize(disparity, disparity, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_8U)
temp = np.zeros((disp.shape[0], disp.shape[1]), dtype=disp.dtype)
mask = np.where(disp == 0)
temp[mask] = 255
disp = cv2.inpaint(disp, temp, 3, cv2.INPAINT_NS)
cv2.imwrite("E:/Pycharm/depth23D/bear1depth.jpg", disp)
cv2.imshow("disparity", disp)
cv2.waitKey(0)
cv2.destroyAllWindows()

import numpy as np

def linear_regression_predict(t_obw, observing_window_data, predict_frame):
    # t_obw is the duration of observation window
    # observing_window_data is the tiles requests in a observation window
    # predict_frame is the centering tile of the predicted FoV
    ob_wd_X_axis  = np.zeros(t_obw) # width direction
    ob_wd_Y_axis  = np.zeros(t_obw) # height direction

    for i in range(0, t_obw):
        ob_wd_X_axis[i] = observing_window_data[i + 1, 0]
        ob_wd_Y_axis[i] = observing_window_data[i + 1, 1]

    t_ob_wd = np.arange(1, t_obw + 1, 1)

    # get x regression
    temp1 = np.dot(ob_wd_X_axis,t_ob_wd - np.mean(t_ob_wd))

    temp = np.zeros(t_obw)
    for i in range(0, t_obw):
        temp[i] = t_ob_wd[i]**2 - 1/(i+1)*sum(t_ob_wd)**2

    wx = temp1/(sum(temp))

    bx = 1 / t_obw * sum(ob_wd_X_axis - wx * t_ob_wd)

    # get y regression
    temp1 = np.dot(ob_wd_Y_axis,t_ob_wd - np.mean(t_ob_wd))

    temp = np.zeros(t_obw)
    for i in range(0, t_obw):
        temp[i] = t_ob_wd[i]**2 - 1/(i+1)*sum(t_ob_wd)**2

    wy = temp1/(sum(temp))

    by = 1 / t_obw * sum(ob_wd_Y_axis - wx * t_ob_wd)


    predict_x = round(wx*predict_frame + bx)
    predict_y = round(wy*predict_frame + by)

    return predict_x, predict_y

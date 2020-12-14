import numpy as np

from gererate_representative_tile import get_representative_tiles_requests
from Linear_Regression_predictor import linear_regression_predict
from generate_tile_requests import generate_2_tile_requests

def LR_prediction_results(T_ob_wd,path):

    No_video = 10
    No_user = 50
    DoO_LR = np.zeros((No_video,No_user))

    video_sequence = ['coaster','coaster2','diving','drive','game','landscape','pacman','panel','ride','sport']
    Height = 10
    Width = 20
    No_tile = Height * Width
    No_frame = 1800
    No_user = 50
    No_segment = 60

    segment_duration = 30
    T_cc = int(segment_duration - T_ob_wd)

    for video_variable in range(0,No_video):

        video_seq_variable = video_sequence[video_variable]

        FoV_represent_indicator_user,_ = get_representative_tiles_requests(path,video_seq_variable)

        tile_request_index_per_seg,_ = generate_2_tile_requests(T_ob_wd,video_seq_variable,path)

        LR_tile_centering = np.zeros((No_user,No_segment,2))
        LR_tile_temp = np.zeros((No_user,No_segment,Height,Width))


        # Mapping the representative tiles to all the tiles within FoV.
        for user in range(0,No_user):
            FoV_represent_indicator = FoV_represent_indicator_user[user]
            for seg_index in range(0,No_segment):
                observingwindow = FoV_represent_indicator[seg_index*segment_duration:seg_index*segment_duration+(T_ob_wd+1)]
                predict_frame_LR = T_cc+1
                LR_tile_centering[user,seg_index] = linear_regression_predict(T_ob_wd,observingwindow,predict_frame_LR)
                predict_x = LR_tile_centering[user,seg_index,0]
                predict_y = LR_tile_centering[user,seg_index,1]
                if int(predict_x) - 3 < 0:
                    if int(predict_y) - 3 < 0:
                        LR_tile_temp[user, seg_index] = np.ones((Height,Width))
                        LR_tile_temp[user, seg_index,:,int(predict_y) + 3:int(predict_y)+3 + 20 -7  + 1] = np.zeros((Height, 14))
                        LR_tile_temp[user, seg_index,int(predict_x)+3:int(predict_x)+3 + 10 -7, :] = np.zeros((3, Width))
                    elif int(predict_y) + 3 > 19:
                        LR_tile_temp[user, seg_index] = np.ones((Height, Width))
                        LR_tile_temp[user, seg_index, :, int(predict_y) - 3 - 14:int(predict_y) - 3] = np.zeros(
                            (Height, 14))
                        LR_tile_temp[user, seg_index, int(predict_x) + 3: int(predict_x) + 3 + 10 - 7, :] = np.zeros(
                            (3, Width))
                    else:
                        LR_tile_temp[user, seg_index,0:int(predict_x) + 3, int(predict_y)-3:int(predict_y) + 3 + 1] = np.ones((int(predict_x) + 3,7))
                        LR_tile_temp[user, seg_index, ( 9 -  (7 - (int(predict_x) + 3) ) ) + 1 : (9 + 1),int(predict_y) - 3:int(predict_y) + 3 + 1] = np.ones((7 - (int(predict_x) + 3) , 7))

                elif int(predict_x)+3 > 9:
                    if int(predict_y)-3 < 0:
                        LR_tile_temp[user, seg_index] = np.ones((Height,Width))
                        LR_tile_temp[user, seg_index, :, int(predict_y) + 3 : int(predict_y) + 3 + 20 - 7 + 1] = np.zeros(
                            (Height, 14))
                        LR_tile_temp[user, seg_index, int(predict_x) - 3 - ( 10 - 7 ):int(predict_x) - 3 , :] = np.zeros(
                            (3, Width))
                    elif int(predict_y)+3+1 >19:
                        LR_tile_temp[user, seg_index] = np.ones((Height,Width))
                        LR_tile_temp[user, seg_index, :,int(predict_y) - 3 - 14: int(predict_y) - 3 + 1] = np.zeros(
                            (Height, 14))
                        LR_tile_temp[user, seg_index, int(predict_x) - 3 - (10 - 7):int(predict_x) - 3 + 1, :] = np.zeros(
                            (3, Width))
                    else:
                        LR_tile_temp[user, seg_index, int(predict_x) - 3 :9,
                        int(predict_y) - 3:int(predict_y) + 3 + 1] = np.ones(( 9 -  (int(predict_x) - 3 ) , 7))
                        LR_tile_temp[user, seg_index, 0: 7 - (9 -  (int(predict_x) - 3)),
                        int(predict_y) - 3:int(predict_y) + 3 + 1] = np.ones((7 - (9 -  (int(predict_x) - 3)), 7))
                else:
                    if int(predict_y) - 3 < 0:
                        LR_tile_temp[user, seg_index,int(predict_x) - 3:int(predict_x) + 3 + 1,:] = np.ones((7, Width))
                        #print(int(predict_y))
                        LR_tile_temp[user, seg_index, int(predict_x) - 3:int(predict_x) + 3 + 1,max(int(predict_y) +3,0):max(int(predict_y) +3,0) +14] = np.zeros((7, 14))

                    elif int(predict_y) + 3 > 19:
                        LR_tile_temp[user, seg_index,int(predict_x) - 3:int(predict_x) + 3 + 1] = np.ones((7, Width))
                        LR_tile_temp[user, seg_index, int(predict_x) - 3:int(predict_x) + 3 + 1,int(predict_y) - 3 -14:int(predict_y) -3] = np.zeros((7, 14))
                    else:
                        LR_tile_temp[user, seg_index, int(predict_x) - 3:int(predict_x) + 3 + 1,
                        int(predict_y) - 3:int(predict_y) + 3 + 1] = np.ones((7, 7))

                # Simplify the FoV as the 7*7 tiles rectangle, predicted_FoV is the centering of the rectangle

        # obtain the predicted tiles
        LR_predicted_tile = np.zeros((No_user,No_segment,No_tile))

        for user in range(0,No_user):
            for seg_index in range(0,No_segment):
                for tile in range(0,No_tile):
                    LR_predicted_tile[user,seg_index,tile] = LR_tile_temp[user,seg_index,tile//Width,tile%Width]


        # obtain the prediction performance, DoO
        temp_reward = np.zeros((No_user,No_segment))
        total_reward = np.zeros((No_user))
        for user in range(0,No_user):
            for seg_index in range(3,No_segment):
                temp_reward[user,seg_index] = sum(LR_predicted_tile[user,seg_index]*tile_request_index_per_seg[user,seg_index])/sum(tile_request_index_per_seg[user,seg_index])
        total_reward = np.sum(temp_reward,axis=1)/(No_segment-3)
        DoO_LR[video_variable,:] = total_reward.copy()
        print('     prediction of Video', video_variable + 1, 'is finished!')

    return DoO_LR


if __name__ == '__main__':
    No_video = 10
    No_user = 50
    segment_duration = 30 # 1s
    minimal_obser_wind = 3 # 0.1 s
    No_sample_point = segment_duration - minimal_obser_wind + 1
    duration_interval = np.linspace(minimal_obser_wind,segment_duration,No_sample_point)
    DoO_performance_LR = np.zeros([No_sample_point,No_video,No_user])
    obervation_duration = duration_interval / 30

    absolute_path = input("Please input the absolute path of the tile folder:")
    for i in range(0,No_sample_point-2):
        print("When the duration of observation window is %F second" % obervation_duration[i])
        DoO_performance_LR[i,:,:] = LR_prediction_results(int(duration_interval[i]),absolute_path)

    import scipy.io
    scipy.io.savemat('average_DoO_LR', mdict={'average_DoO_LR': DoO_performance_LR})
import numpy as np
from generate_tile_requests import generate_2_tile_requests


def LINUCB_prediction(obser_wind_duration, path):
    No_video = 10
    No_user = 50
    No_segment = 60
    Width = 20
    Height = 10
    No_tile = Width * Height

    DoO_on_all_videos = np.zeros((No_video,No_user))

    video_sequence = ['coaster','coaster2','diving','drive','game','landscape','pacman','panel','ride','sport']

    # hyper-parameters for LinUCB, which is identical for all videos
    alpha = 0.8
    lambda_ = 0.5
    d = 2

    for video_variable in range(0,No_video):
        video_seq_variable = video_sequence[video_variable]

        arm_value = [-1,1]
        No_arm = 2

        A = [lambda_*np.identity(d),lambda_*np.identity(d)]
        A_ = [np.linalg.inv(A[0]),np.linalg.inv(A[1])]
        b = [np.zeros((d)),np.zeros((d))]
        state = np.zeros((No_segment,No_arm))
        feature_vector = np.zeros((No_segment,No_arm,d))
        arm_vector = np.zeros((No_segment))
        reward_vector = np.zeros((No_segment,No_tile))

        tile_request_index,observed_tile_request_index = generate_2_tile_requests(obser_wind_duration,video_seq_variable,path)

        # set the state of non-request tile as -1, for speeding up learning
        observed_tile_state = observed_tile_request_index.copy()
        observed_tile_state[observed_tile_state==0] = -1

        tile_request_index_copy = tile_request_index.copy()

        predicted_tile = np.zeros((No_user,No_segment,No_tile))

        for user in range(0,No_user):
            for tile in range(0,No_tile):
                tile_state1 = observed_tile_state[user,:,tile]
                theta = np.zeros((No_segment, No_arm, d)) # decouple the correlation between tiles
                for t in range(0,No_segment):
                    if t == 0:
                        predicted_tile[user, t, tile] = 0
                    else:
                        theta[t,int(arm_vector[t])] = np.dot(A_[int(arm_vector[t])],b[int(arm_vector[t])])

                        for arm in range(0,No_arm):
                            feature_vector[t,arm] = [tile_state1[t-1], arm_value[arm]]
                            state[t,arm] = np.dot(feature_vector[t,arm].T,theta[t,arm]) + alpha*np.sqrt(np.dot(np.dot(feature_vector[t,arm].T,A_[arm]),feature_vector[t,arm]))
                        arm_vector[t] = np.argmax(state[t])

                        if tile_request_index_copy[user,t,tile] == arm_vector[t]:
                            reward_vector[t,tile] = 30
                        else:
                            reward_vector[t,tile] = -30
                    A[int(arm_vector[t])] += np.dot(feature_vector[t,int(arm_vector[t])],feature_vector[t,int(arm_vector[t])].T)
                    b[int(arm_vector[t])] += reward_vector[t,tile]*feature_vector[t,int(arm_vector[t])].T
                    A_[int(arm_vector[t])] = np.linalg.inv(A[int(arm_vector[t])])
                    predicted_tile[user,t,tile] = arm_vector[t].copy()

        DoO_per_video = np.zeros((No_user,No_segment))
        for user in range(0,No_user):
            for seg in range(1,No_segment):
                DoO_per_video[user,seg] = sum(predicted_tile[user,seg]*tile_request_index[user,seg])/sum(tile_request_index[user,seg])
        DoO_on_all_videos[video_variable,:] = np.sum(DoO_per_video,axis=1)/((No_segment-1))
        print('     prediction of Video', video_variable+1, 'is finished!')

    return DoO_on_all_videos

if __name__ == '__main__':
    No_video = 10
    No_user = 50
    segment_duration = 30  # 1s
    minimal_obser_wind = 3 # 0.1s
    No_sample_point = segment_duration - minimal_obser_wind + 1

    duration_interval = np.linspace(minimal_obser_wind,segment_duration,No_sample_point)
    DoO_all = np.zeros([No_sample_point, No_video, No_user])
    obervation_duration = duration_interval/30

    absolute_path = input("Please input the absolute path of the tile folder:")
    for i in range(0,No_sample_point):
        print("When the duration of observation window is %F second" %obervation_duration[i] )
        DoO_all[i, :, :] = LINUCB_prediction(int(duration_interval[i]), absolute_path)


    # import scipy.io
    # scipy.io.savemat('average_DoO_CB', mdict={'average_DoO_CB':DoO_all})



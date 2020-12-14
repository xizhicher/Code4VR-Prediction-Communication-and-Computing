import numpy as np
import math
import csv

"This function is used to generate: "
"(1) Tile requests per frame "
"(2) Representative tile of a FoV"


def get_representative_tiles_requests(path,video_seq_name):

    Height = 10
    Width = 20
    No_frame = 1800
    No_user = 50

    representive_tile_per_frame_user = np.zeros((No_user,No_frame,2))
    tile_request_per_frame = np.zeros((No_user,No_frame, Height, Width))

    for user_index in range(1,50+1):
        if user_index <= 9:
            csv_file = csv.reader(open(path + video_seq_name + '_user0%s_tile.csv'%user_index, 'r'))
        elif user_index > 9:
            csv_file = csv.reader(open(path + video_seq_name + '_user%s_tile.csv' %user_index, 'r'))


        tile_per_frame_index = []
        for stu in csv_file:
            tile_per_frame_index.append(stu)

        for frame in range(1,len(tile_per_frame_index)):
            for j in range(1,len(tile_per_frame_index[frame])):
                tile_request_per_frame[user_index-1,frame-1,int(tile_per_frame_index[frame][j])//Width -1 ,int(tile_per_frame_index[frame][j])%Width-1] = 1

    for user_index in range(0,No_user):
        FoV_represent_indicator = np.zeros((No_frame,2))

        FoV_temp = np.zeros((No_frame,1))

        for i in range(0,No_frame):
            FoV_temp[i] = len(np.where(tile_request_per_frame[user_index,i]==1)[0])
            # find the number of request tiles

            middle_number_index = math.ceil(FoV_temp[i]/2)
            FoV_represent_indicator[i,0] = np.nonzero(tile_request_per_frame[user_index,i])[0][middle_number_index]
            FoV_represent_indicator[i,1] = np.nonzero(tile_request_per_frame[user_index,i])[1][middle_number_index]
            # find the representative tiles. Note that any request tile of a FoV with fixed relative location dertermines the FoV.
            # For simplify, we use the tiles at No.tile/2  as the representative tiles, where No.Tile is number of request tiles in a FoV/frame.

        representive_tile_per_frame_user[user_index] = FoV_represent_indicator

    return representive_tile_per_frame_user, tile_request_per_frame

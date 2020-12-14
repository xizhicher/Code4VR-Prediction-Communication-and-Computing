import numpy as np

"This function is used to generate: "
"(1) Tile Requests in a segment, given the segment duration"
"(2) observed Tile Request in the observation window, given the observation window duration"


def generate_2_tile_requests(observing_window_duration,video_seq_name,path):
    # The height, width, and number of frames of the 360 videos are according to the dataset[1]
    # [1] "360° Video Viewing Dataset in Head - Mounted Virtual Reality", MMsys'17
    Height = 10
    Width = 20
    No_tile_per_seg = Height * Width
    No_frame = 1800
    No_user = 50
    segment_duration = 30 # 1s
    No_segment = int(No_frame/segment_duration)

    tile_request = np.zeros((No_user, No_frame, Height, Width))


    tile_request_per_seg = np.zeros((No_user, No_segment, Height, Width))
    tile_request_index_per_seg = np.zeros((No_user, No_segment, No_tile_per_seg))

    observed_tile_request = np.zeros((No_user, No_segment, Height, Width))
    observed_tile_request_index = np.zeros((No_user, No_segment, No_tile_per_seg))

    # import the sensory data
    import csv
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
                tile_request[user_index - 1, frame - 1, int(tile_per_frame_index[frame][j]) // Width - 1 , int(tile_per_frame_index[frame][j]) % Width - 1] = 1

        for tile_index in range(0, No_segment):
            for frame in range(0 + tile_index*segment_duration,segment_duration + tile_index*segment_duration):
                tile_request_per_seg[user_index - 1, tile_index] += tile_request[user_index - 1, frame]
            tile_request_per_seg[user_index - 1, tile_index][tile_request_per_seg[user_index - 1, tile_index] >= 1] = 1
            # For a segment, if a tile is requested more than once, then the tile is requested in the segment

            for frame in range(0 + tile_index*segment_duration,observing_window_duration + tile_index*segment_duration):
                observed_tile_request[user_index - 1, tile_index] += tile_request[user_index - 1, frame]
            observed_tile_request[user_index - 1, tile_index][observed_tile_request[user_index - 1, tile_index] >= 1] = 1

            for i in range(0, Height):
                for j in range(0, Width):
                    tile_request_index_per_seg[user_index - 1, tile_index, i * Width + j] = tile_request_per_seg[user_index - 1, tile_index, i, j]
                    observed_tile_request_index[user_index - 1, tile_index, i * Width + j] = observed_tile_request[user_index - 1, tile_index, i, j]

    return  tile_request_index_per_seg, observed_tile_request_index

# Test whether the function works
if __name__ == "__main__":
    tile_request_index_per_seg, observed_tile_request_index = generate_2_tile_requests(5,'panel')

    # No_user = 50
    # No_segment = 60
    # overlap_part_total_segment = np.zeros((No_user, No_segment))
    # for i in range(0,No_user):
    #     for j in range(0,No_segment):
    #         overlap_part_total_segment[i,j] = sum(sum(tile_indicator[i,j]*tile_observing_indicator[i,j]))/(sum(sum(tile_indicator[i,j])))
    #
    # print(sum(sum(overlap_part_total_segment))/(No_user*No_segment))





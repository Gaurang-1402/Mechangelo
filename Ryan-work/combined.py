def process_chunk(chunk:str):
    ans=chunk
    ans=ans.replace('G1','')
    ans=ans.replace('X','')
    ans=ans.replace('Y','')
    ans=line_split(ans)
    ans=[x.split() for x in ans]
    ans=[list(map(int,x)) for x in ans]
    ans=as_points_array(ans)
    return ans
def process_gcode(gcode):
    chunks=gcode.split('G0')
    chunks=[x.strip() for x in chunks]
    chunks=[printed(x) for x in chunks if x]
    chunks=[printed(process_chunk(x)) for x in chunks]
    return chunks
    
@memoized
def image_to_contours(image):
    image_to_gcode_dir='/Users/ryan/CleanCode/Github/image-to-gcode'
    assert is_image(image) or isinstance(image,str)
    if isinstance(image,str):
        image=load_image(image,use_cache=False)
        return image_to_contours(image)
    image=resize_image_to_fit(image,width=150)
    with SetCurrentDirectoryTemporarily(image_to_gcode_dir):    
        input_file='input.png'
        output_file='out.gcode'
        save_image(image,input_file)
        os.system('python3 image_to_gcode.py -i %s -o %s'%(input_file,output_file))
        gcode=text_file_to_string(output_file)
    contours=process_gcode(gcode)
    return normalize_contours(contours)
def contours_bounds(contours):
    big_contour=np.concatenate(contours)
def normalize_contours(contours):
    #Put contours in bounds from 0 to 1 by scaling them. It doesn't stretch it. Right now they're not centered.
    combined_contours=np.concatenate(contours)
    bounds=combined_contours.min(0),combined_contours.max(0)
    ranges=[a-b for a,b in bounds]
    normalized_contours=[contour-bounds[0] for contour in contours]
    #print([x.min(0) for x in normalized_contours])
    normalized_contours=[contour/max(ranges) for contour in normalized_contours]
    #print([x.min(0) for x in normalized_contours])
    for i in range(len(normalized_contours)):
        normalized_contours[i][:,1]=1-normalized_contours[i][:,1]
    return normalized_contours

def display_contours(contours):
    #Assumes the contours are normalized    
    display_image(contours_to_image(contours,scale=1000))

def fix_errors():
    arm.clean_warn()
    arm.clean_error()
    arm.motion_enable(True)
    arm.set_mode(0)
    arm.set_state(0)
def add_joint_angle(joint,angle,speed=None):
    angle+=arm.angles[joint]
    set_joint_angle(joint,angle)
def set_angles(angles,speed=None):
    if speed is None:
        speed=globals()['speed']
    arm.set_servo_angle(angle=angles, speed=speed, radius=20, wait=True,mvacc=acc)

def set_joint_angle(joint,angle,speed=None):
    angles=arm.angles
    angles[joint]=angle
    set_angles(angles,speed=speed)
        
def set_suction(mode:bool):
    assert isinstance(mode,bool)
    arm.set_suction_cup(mode, False)

def do_the_square_dance():
    for x in  [0,1]:
        for y in [0,1]:
            for z in [0,1]:
                set_pos_in_bounds(x,y,z)
def set_pos_in_bounds(x,y,z,wait=False):
    robot_bounds=[[200,380],[-170,170],[80,420]]
    x=blend(*robot_bounds[0],x)
    y=blend(*robot_bounds[1],y)
    z=blend(*robot_bounds[2],z)
    arm.set_position(x,y,z,wait=wait,mvacc=10000,radius=5)#,speed=10000)
def set_xy(x,y,wait=False):
    assert 0<=x<=1
    assert 0<=y<=1
    set_pos_in_bounds(.5,x,y,wait=wait)
def connect_robot():
    # 2023-04-01 01:50:30.597759
    import os
    import sys
    import time
    import math
    global arm
    
    from xarm.wrapper import XArmAPI
    
    
        
    
    if 'arm' in dir():
        #arm.reset(wait=True)
        arm.disconnect()
    
    ip='192.168.1.162'
    
    arm = XArmAPI(ip)
    
    arm.motion_enable(enable=True)
    arm.set_mode(0)
    arm.set_state(state=0)
    
    #arm.reset(wait=True)
    
    speed = 500
    acc=240
    
    arm.set_reduced_max_joint_speed(50)

def get_position():
    return arm.get_position()[1][:3]
def go_home():
    arm.move_gohome()
def draw_robot_contours(contours):
    #assume contour is normalized 0-to-1 [[x,y],[x,y]...]
    for contour in contours:
        for x,y in contour[:-1]:
            set_xy(x,y,wait=False)
        set_xy(*contour[-1],wait=True)

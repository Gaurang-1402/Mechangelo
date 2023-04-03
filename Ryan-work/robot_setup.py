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
    arm.set_position(x,y,z,wait=wait,mvacc=10000,radius=5)
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
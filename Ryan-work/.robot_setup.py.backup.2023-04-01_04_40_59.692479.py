# 2023-04-01 01:50:30.597759
import os
import sys
import time
import math

from xarm.wrapper import XArmAPI


def tall_pose():
    #Pose really tall like a tower    
    set_angles(angles=[357, 0, 0, 180, 0, 0, 357])
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
def go_to_main_pose():
    set_angles([0,0,-90,90,0,0,0])
def do_flippy():
    for _ in range(1000):
        speed=1000
        set_joint_angle(6,0,speed=speed)
        sleep(3)
        set_joint_angle(6,180,speed=speed)
        sleep(3)
        
def set_suction(mode:bool):
    assert isinstance(mode,bool)
    arm.set_suction_cup(mode, False)

def do_the_thing():
    if not input_yes_no('IS THE ROBOT CLEAR OF ALL OBSTACLES 360??? MOVE THE TABLE!!!'):
        print('ABORTING!')
        return
    for _ in range(10000) :
        try:
            go_to_main_pose()
            sleep(5)
            do_flippy()
        except KeyboardInterrupt:
            tall_pose()
            return
    

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
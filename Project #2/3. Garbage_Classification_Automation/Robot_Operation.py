from indy_utils import indydcp_client as client
from indy_utils.indy_program_maker import JsonProgramComponent
from time import sleep

WAIT            = 0
GO_HOME         = 1
GO_GARBAGE_GRIP  = 2
GO_GARBAGE_MID_1 = 3
GO_GARBAGE_MID_2 = 4
GO_GARBAGE_MID_3 = 5
GO_GARBAGE_DOWN  = 6

def get_target_pos(garb_type):
    if garb_type == "cardboard":
        t_pos_abs = [0.255, 0.664, 0.418, 0, 153, 68.7]
    elif  garb_type == "metal":
        t_pos_abs = [0.031, 0.682, 0.377, 0, 157, 87.1]
    elif garb_type == "plastic":
        t_pos_abs = [-0.201, 0.685, 0.364, 0, 157, 105.3]

    return t_pos_abs


# gripper -> 8, 9
# vaccum head -> 10, 11
def grip_up():
    indy.set_do(10, 1)
    indy.set_do(11, 0)
    sleep(0.4)

def grip_down():
    indy.set_do(10, 0)
    indy.set_do(11, 1)
    sleep(0.4)

home_pos = [0.725, 0.089, 0.655, -1.4, 159.5, 6.4]
grip_pos = [0.797, 0.099, 0.433, -1.3, 173.2, 6.6]
mid_pos1 = home_pos
mid_pos2 = [0.001, 0.627, 0.651, -1.3, 164.4, 90.1]
mid_pos3 = mid_pos2

mode = GO_HOME

robot_ip = "192.168.0.6"  # Robot (Indy) IP
robot_name = "NRMK-Indy10"  # Robot name (Indy7)indy

# Create class object
indy = client.IndyDCPClient(robot_ip, robot_name)

indy.connect()

indy.set_collision_level(5)
indy.set_joint_vel_level(7)
indy.set_task_vel_level(7)
indy.set_joint_blend_radius(20)
indy.set_task_blend_radius(0.2)

j_pos = indy.get_joint_pos()
t_pos = indy.get_task_pos()

key = []
status = indy.get_robot_status()
for value in status.keys():
    key.append(value)
    
# ------------- main Program ----------- #
while(1):
    
    if mode == GO_HOME:
        
        indy.task_move_to(home_pos)

        while True:
            status = indy.get_robot_status()
            sleep(0.2)
            if status[key[5]]==1 :
                break

        f_robot = open("robot_state.txt", "w")
        f_robot.write("0")
        f_robot.close()
        mode = WAIT

    elif mode == WAIT:
        
        f_garb = open('garbage_type.txt', 'r')
        garb_type = f_garb.readline()
        f_garb.close()

        if garb_type != '':

            f_garb = open('garbage_type.txt', 'w')
            f_garb.write('')
            f_garb.close()

            f_robot = open("robot_state.txt", "w")
            f_robot.write("1")
            f_robot.close()

            mode = GO_GARBAGE_GRIP
    
    elif mode == GO_GARBAGE_GRIP:
        
        indy.task_move_to(grip_pos)
        
        while True:
            status = indy.get_robot_status()
            sleep(0.2)
            if status[key[5]]==1 :
                break
        
        grip_up()
        mode = GO_GARBAGE_MID_1


    elif mode == GO_GARBAGE_MID_1:

        indy.task_move_to(mid_pos1)
        
        while True:
            status = indy.get_robot_status()
            sleep(0.2)
            if status[key[5]]==1 :
                break
        
        mode = GO_GARBAGE_MID_2

    elif mode == GO_GARBAGE_MID_2:

        indy.task_move_to(mid_pos2)
        
        while True:
            status = indy.get_robot_status()
            sleep(0.2)
            if status[key[5]]==1 :
                break
        
        mode = GO_GARBAGE_DOWN

    elif mode == GO_GARBAGE_DOWN:

        t_pos_abs = get_target_pos(garb_type)
        indy.task_move_to(t_pos_abs)

        while True:
            status = indy.get_robot_status()
            sleep(0.2)
            if status[key[5]]==1 :
                break
        grip_down()
        mode = GO_GARBAGE_MID_3

    elif mode == GO_GARBAGE_MID_3:

        indy.task_move_to(mid_pos3)
        
        while True:
            status = indy.get_robot_status()
            sleep(0.2)
            if status[key[5]]==1 :
                break
        
        mode = GO_HOME

indy.disconnect()
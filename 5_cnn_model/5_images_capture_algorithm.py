import os
import sys
import optparse
import xlsxwriter

# python modules from the $SUMO_HOME/tools directory
if 'SUMO_HOME' in os.environ:
    tools = os.path.join(os.environ['SUMO_HOME'], 'tools')
    sys.path.append(tools)
else:
    sys.exit("please declare environment variable 'SUMO_HOME'")


from sumolib import checkBinary  # Checks for the binary in environ vars
import traci


def get_options():
    opt_parser = optparse.OptionParser()
    opt_parser.add_option("--nogui", action="store_true",
                         default=False, help="run the commandline version ofexp(0.032) sumo")
    options, args = opt_parser.parse_args()
    return options



# TraCI control loop
def run():

    workbook = xlsxwriter.Workbook('data21.xlsx')
    worksheet = workbook.add_worksheet()

    step = 0
    i = 1
    condition_status = 0
    row, col = 0, 0
    row1, col1 = 0, 0

    while step < 86400:
        
        traci.simulationStep()
        match  condition_status:
            case 0:
                if step == i:
                    N1_4 = traci.lanearea.getJamLengthVehicle("e2det_N1_4")
                    S1_4 = traci.lanearea.getJamLengthVehicle("e2det_S1_4")
                    phase0_detection = [N1_4, S1_4]

                    if max(phase0_detection) <= 2:
                        
                        i += 18+3+1
                        
                    elif 3<= max(phase0_detection) <= 4:
                        
                        i += 18+3+1
                        
                    elif 5<= max(phase0_detection) <= 6:
                        
                        i += 18+3+1
                        
                    elif max(phase0_detection) >= 7:
                        
                        i += 18+3+1
                        
                    condition_status = 3
            
            case 3:
                if step == i:
                    N1_2 = traci.lanearea.getJamLengthVehicle("e2det_N1_2")
                    N1_3 = traci.lanearea.getJamLengthVehicle("e2det_N1_3")
                    S1_2 = traci.lanearea.getJamLengthVehicle("e2det_S1_2")
                    S1_3 = traci.lanearea.getJamLengthVehicle("e2det_S1_3")
                    N1_0 = traci.lanearea.getJamLengthVehicle("e2det_N1_0")
                    S1_0 = traci.lanearea.getJamLengthVehicle("e2det_S1_0")
                    phase3_detection = [N1_0, S1_0]
                    no_of_ped = max(phase3_detection)

                    if max(phase3_detection) <= 2:
                        
                        i += 6
                        
                        

                    elif 3 <= max(phase3_detection) <= 4:
                        
                        i += 6
                        
                        

                    elif 5 <= max(phase3_detection) <= 6:
                        
                        i += 6
                        
                        

                    elif max(phase3_detection) >= 7:
                        
                        i += 6
                    
                    
                    condition_status = 4
                    
            
            case 4:
                if step == i:
                    phase4_detection = [N1_2, N1_3, S1_2, S1_3]
                    no_of_veh = max(phase4_detection)

                    if max(phase4_detection) <= 2:
                        
                        
                        i += 21+3+1
                        
                    
                    elif 3 <= max(phase4_detection) <= 4:
                        
  
                        i += 21+3+1
              
                        
                    elif 5 <= max(phase4_detection) <= 6:
                        

                        i += 21+3+1
                       
                        
                    elif max(phase4_detection) >= 7:
                        
                        i += 21+3+1
                       
                    condition_status = 8

            case 8:
                if step == i:
                    E1_4 = traci.lanearea.getJamLengthVehicle("e2det_E1_4")
                    W1_4 = traci.lanearea.getJamLengthVehicle("e2det_W1_4")
                    phase7_detection = [E1_4, W1_4]
                    

                    if max(phase7_detection) <= 2:
                        
                        i += 8+3+1
                        
                    elif 3<= max(phase7_detection) <= 4:
                        
                        i += 11+3+1
                         
                    elif 5<= max(phase7_detection) <= 6:
                        
                        i += 14+3+1
                    
                    elif max(phase7_detection) >= 7:
                        
                        i += 20+3+1
                       
                    condition_status = 10
            
            case 10:
                if step == i:
                    E1_2 = traci.lanearea.getJamLengthVehicle("e2det_E1_2")
                    E1_3 = traci.lanearea.getJamLengthVehicle("e2det_E1_3")
                    W1_2 = traci.lanearea.getJamLengthVehicle("e2det_W1_2")
                    W1_3 = traci.lanearea.getJamLengthVehicle("e2det_W1_3")
                    E1_0 = traci.lanearea.getJamLengthVehicle("e2det_E1_0")
                    W1_0 = traci.lanearea.getJamLengthVehicle("e2det_S1_0")
                    phase10_detection = [E1_0]

                    if max(phase10_detection) <= 2:
                        filename = "low" + str(i) + ".png"
                        traci.gui.screenshot("View #0", filename)
                        i += 6
                        
                        
                    elif 3 <= max(phase10_detection) <= 4:
                        filename = "medium" + str(i) + ".png"
                        traci.gui.screenshot("View #0", filename)
                        i += 6
                        
                        
                    elif 5 <= max(phase10_detection) <= 6:
                        filename = "high" + str(i) + ".png"
                        traci.gui.screenshot("View #0", filename)
                        i += 6
                        
                       
                    elif max(phase10_detection) >= 7:
                        filename = "veryhigh" + str(i) + ".png"
                        traci.gui.screenshot("View #0", filename)
                        i += 6
                        
                    condition_status = 11
                        
            
            case 11:
                if step == i:
                    phase11_detection =  [E1_2, E1_3]

                    if max(phase11_detection) <= 2:
                        filename = "low" + str(i) + ".png"
                        traci.gui.screenshot("View #0", filename)
                        
                        i += 18+3+1
                       
                    elif  3<= max(phase11_detection) <= 4:
                        filename = "medium" + str(i) + ".png"
                        traci.gui.screenshot("View #0", filename)
                        
                        i += 18+3+1
                        
                    elif 5 <= max(phase11_detection) <= 6:
                        filename = "high" + str(i) + ".png"
                        traci.gui.screenshot("View #0", filename)
                        
                        i += 18+3+1
                       
                    elif max(phase11_detection) >= 7:
                        filename = "veryhigh" + str(i) + ".png"
                        traci.gui.screenshot("View #0", filename)
                        
                        i += 18+3+1
                        
                    condition_status = 0
        
        
        step += 1

    workbook.close()

    traci.close()

sys.stdout.flush()



# main entry point
if __name__ == "__main__":
    options = get_options()

    # check binary
    if options.nogui:
        sumoBinary = checkBinary('sumo')
    else:
        sumoBinary = checkBinary('sumo-gui')

    # traci starts sumo as a subprocess and then this script connects and runs
    traci.start([sumoBinary, "-c", "S:/3_dynamic_simulations/1_simulation_details_(dynamic).sumocfg"])
    run()

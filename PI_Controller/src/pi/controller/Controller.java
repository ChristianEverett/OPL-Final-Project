package pi.controller;

import java.sql.*;
import java.util.logging.*;
import com.pi4j.io.gpio.*;

public class Controller
{
	private final static Logger LOGGER = Logger.getLogger(Controller.class.getName());
	private static MySQLHandler dbHandler = null;
	
	private final static String DATABASE = "pidb";
	private final static String ACTIONS_TABLE = "actions";
	private final static String STATES_TABLE = "states";

	public static void main(String[] args) throws SQLException
	{
		Runtime.getRuntime().addShutdownHook(new Thread()
        {
            @Override
            public void run()
            {
                System.out.println("Shutdown hook ran!");
            }
        });
		
		try
		{
			if(args.length != 0)
				LOGGER.setUseParentHandlers(false);
			LOGGER.addHandler(new FileHandler("../log"));
			LOGGER.info("Starting Service");
			
			dbHandler = new MySQLHandler(LOGGER);
			dbHandler.loadDatabase(DATABASE);
			
			if(dbHandler.tableExists(ACTIONS_TABLE) == false)
			{
				LOGGER.info("Action Table not found");
				dbHandler.createTable(ACTIONS_TABLE, "command", "char(25)", "state", "boolean");
			}
			if(dbHandler.tableExists(STATES_TABLE) == false)
			{
				LOGGER.info("State Table not found");
				dbHandler.createTable(STATES_TABLE, "command", "char(25)", "state", "boolean");
			}
			
			LOGGER.info("Loading GPIO Controller");
			GpioController gpio = GpioFactory.getInstance();
			
		    GpioPinDigitalOutput switch1 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_08, "switch1", PinState.HIGH);
		    GpioPinDigitalOutput switch2 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_09, "switch2", PinState.HIGH);
		    GpioPinDigitalOutput switch3 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_07, "switch3", PinState.HIGH);
		    GpioPinDigitalOutput switch4 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_00, "switch4", PinState.HIGH);
			
			while(true)
			{
				ResultSet result = dbHandler.SELECT("*", ACTIONS_TABLE, null);		
				
				
				while(result.next())
				{
					String command = result.getString("command");
					boolean state = result.getBoolean("state");
					LOGGER.info("Action: " + command);
					ProcessBuilder process;
					
					switch (command)
					{
					case ACTIONS.TEST:
						//result.getBoolean("state");
						System.out.println("Action hit: " + state);

						break;
						
					case ACTIONS.SWITCH_ONE:
						switch1.setState(!state);
						Controller.updateState(command, state);
						break;
					case ACTIONS.SWITCH_TWO:
						switch2.setState(!state);
						Controller.updateState(command, state);
						break;
					case ACTIONS.SWITCH_THREE:
						switch3.setState(!state);
						Controller.updateState(command, state);
						break;
					case ACTIONS.SWITCH_FOUR:
						switch4.setState(!state);
						Controller.updateState(command, state);
						break;
						
					case ACTIONS.RUN_ECHO_SERVER:
						process = new ProcessBuilder("python", "../echo/fauxmo.py");
						//process.redirectOutput(ProcessBuilder.Redirect.INHERIT);
						process.start();
						break;
	
					default:
						break;
					}
				}	
				
				dbHandler.clearTable(ACTIONS_TABLE);
				Thread.sleep(50);
			}
		} 
		catch (Exception e)
		{
			dbHandler.close();
			LOGGER.severe("Exception: " + e.getMessage());
		}
	}
	
	private static void updateState(String command, boolean state) throws SQLException
	{
		if (!dbHandler.SELECT("*", STATES_TABLE, "command = '" + command + "'").next())
		{
			dbHandler.INSERT(STATES_TABLE, "'" + command + "'", String.valueOf(state));
			LOGGER.info("New Device Added: " + command + " " + state);
		}
		else 
		{
			dbHandler.UPDATE(STATES_TABLE, "state", String.valueOf(state), "command = " + "'" + command + "'");
			LOGGER.info("Device state changed: " + command + " " + state);
		}
	}
	
	private interface ACTIONS
	{
		public static final String TEST = "test";
		public static final String RUN_ECHO_SERVER = "run_echo_server";
		public static final String SWITCH_ONE = "switch_one";
		public static final String SWITCH_TWO = "switch_two";
		public static final String SWITCH_THREE = "switch_three";
		public static final String SWITCH_FOUR = "switch_four";
	}
}

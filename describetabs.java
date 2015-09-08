package describetabs;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import com.acn.aies.common.*;
import com.sforce.soap.partner.DescribeTab;
import com.sforce.soap.partner.DescribeTabSetResult;

import com.sforce.soap.partner.PartnerConnection;

import com.sforce.ws.ConnectorConfig;



import com.sforce.soap.partner.Error;

//Dhivya //
public class describetabs {
	public static void main(String args[])
	{
		
			  try {
				  BufferedReader bufferRead = new BufferedReader(new InputStreamReader(System.in));
					System.out.println("Enter User Name");
					String aiesUserName = bufferRead.readLine();

					System.out.println("Enter Password");
					String aiesPassword = bufferRead.readLine();
					
					

					System.out.println("Logging into salesforce instance...");
					ConnectorConfig aiesEnterpriseConfig = new ConnectorConfig();
					
					
					
					aiesEnterpriseConfig.setUsername(aiesUserName);
				
					aiesEnterpriseConfig.setPassword(aiesPassword);
					aiesEnterpriseConfig.setAuthEndpoint("https://test.salesforce.com/services/Soap/u/31.0");
					aiesEnterpriseConfig.setServiceEndpoint("https://test.salesforce.com/services/Soap/u/31.0");
					PartnerConnection ne=new PartnerConnection(aiesEnterpriseConfig);
					System.out.println(aiesEnterpriseConfig.getPassword());
					
				
												//aiesEnterpriseConfig.setServiceEndpoint(Constants.SANDBOX_ENTERPRISE_ENDPOINT);
					/*
						

						AIESSession.clientPartnerConnection = com.sforce.soap.partner.Connector.newConnection(aiesEnterpriseConfig);

					
			    // Describe tabs
					DescribeTabSetResult[] dts=ne
			    //DescribeTabSetResult[] dtsrs = connection.describeTabs();
			    System.out.println("There are " + dtsrs.length + 
			        " tab sets defined.");
			    
			    // For each tab set describe result, get some properties 
			    for (int i = 0; i < dtsrs.length; i++) {
			      System.out.println("Tab Set " + (i + 1) + ":");
			      DescribeTabSetResult dtsr = dtsrs[i];
			      System.out.println("Label: " + dtsr.getLabel());
			      System.out.println("\tLogo URL: " + dtsr.getLogoUrl());
			      System.out.println("\tTab selected: " + 
			          dtsr.isSelected());
			      
			      // Describe the tabs for the tab set
			      DescribeTab[] tabs = dtsr.getTabs();
			      System.out.println("\tTabs defined: " + tabs.length);
			      
			      // Iterate through the returned tabs
			      for (int j = 0; j < tabs.length; j++) {
			        DescribeTab tab = tabs[j];
			        System.out.println("\tTab " + (j + 1) + ":");
			        System.out.println("\t\tName: " + 
			            tab.getSobjectName());
			        System.out.println("\t\tLabel: " + tab.getLabel());
			        System.out.println("\t\tURL: " + tab.getUrl());
			        //DescribeColor[] tabColors = tab.getColors();
			        // Iterate through tab colors as needed
			       // DescribeIcon[] tabIcons = tab.getIcons();
			        // Iterate through tab icons as needed
			      }
			    }
			  } catch (Exception ce) {
			    ce.printStackTrace();
			  }*/
					DescribeTab[] tabs = ne.describeAllTabs();
					    System.out.println("There are " + tabs.length + 
					        " tabs available to you.");

					      // Iterate through the returned tabs
					      for (int j = 0; j < tabs.length; j++) {
					        
					        System.out.println("\tTab " + (j + 1) + ":");
					      //  System.out.println("\t\tName: " + tab.getName());
					       // System.out.println("\t\tAssociated SObject" + tab.getSobjectName());
					        System.out.println("\t\tLabel: " + tabs[j].getLabel());
					        //System.out.println("\t\tURL: " + tab.getUrl());
					       // DescribeColor[] tabColors = tab.getColors();
					        // Iterate through tab colors as needed
					       // DescribeIcon[] tabIcons = tab.getIcons();
					        // Iterate through tab icons as needed
					      }
					  } catch (Exception ce) {
					    ce.printStackTrace();
					  }
			}
}


	
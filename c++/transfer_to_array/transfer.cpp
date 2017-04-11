#include <iostream>
#include <iomanip>
#include <array>
#include <fstream>
#include <sstream>
#include <string>
#include <stdio.h>
#include <cmath>
int rowA=0;
int colA=0;
using namespace std;
int main ()
{
	std::string lineA;
	int x;
	int arrayA[216][2]={{0}};
	ifstream fileIN("locations.dat");
	
	if(fileIN.is_open())
	{
		while(getline(fileIN,lineA))
		{		
			istringstream streamA(lineA);
			colA=0;
			while(streamA>>x)
			{
				arrayA[rowA][colA]=x;
				colA++;
			}
			rowA++;
		}
	}
	//DISPLAY
	cout<<"# of rows----->"<<rowA<<endl;
	cout<<"# of colums--->"<<colA<<endl;
	cout<<"..."<<endl;
	fileIN.close();
	double x_particle_A;
	double y_particle_A;
	double x_particle_B;
	double y_particle_B;
	double distance=12000;
	double D=0;
	ofstream myfile;
	myfile.open("dis.dat");
	for(int i=0;i<rowA;i++)
	{
		x_particle_A=arrayA[i][0];
		y_particle_A=arrayA[i][1];		
		for(int j=0;j<rowA;j++)
		{
			if(i==j)
			{			
				
			}
			else
			{
				x_particle_B=arrayA[j][0];
				y_particle_B=arrayA[j][1];
				D=sqrt((pow((x_particle_A-x_particle_B),2)+pow((y_particle_A-y_particle_B),2)));
				//myfile<<distance<<" "<<D<<" "<<x_particle_A<<" "<<x_particle_B<<" "<<y_particle_A<<" "<<y_particle_B<<'\n';
				if(D<=distance)
				{
					distance=D;
				}
			}		
		}
		myfile<<distance<<'\n';
		distance=12000;
		
	}
	myfile.close();
	return 0;
}

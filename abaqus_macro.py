from abaqus import *  
from abaqusConstants import *  
import __main__  

def Automat_Modele():  
  import section  
  import regionToolset  
  import displayGroupMdbToolset as dgm  
  import part  
  import material  
  import assembly  
  import step  
  import interaction  
  import load  
  import mesh  
  import optimization  
  import job  
  import sketch  
  import visualization  
  import xyPlot  
  import displayGroupOdbToolset as dgo  
  import connectorBehavior  

  x=int('1') # numer symulacji  
  y=float('0') # obciazenie poczatkowe  
  k=float('0.005') #krok zwiekszania obciazenia  
  maks=float('0.06') # maksymalne przemieszczenie  

  while y < maks:  
    x=str(x)  
    p1 = mdb.models['baza'].parts['PART-1']  
    session.viewports['Viewport: 1'].setValues(displayedObject=p1)  
    mdb.Model(name=x, objectToCopy=mdb.models['baza'])  
    p = mdb.models[x].parts['PART-1']  
    session.viewports['Viewport: 1'].setValues(displayedObject=p)  
    a = mdb.models[x].rootAssembly  
    session.viewports['Viewport: 1'].setValues(displayedObject=a)  
    session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON,  
    predefinedFields=ON, connectors=ON, optimizationTasks=OFF,  
    geometricRestrictions=OFF, stopConditions=OFF)  
    session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='Static')  
    mdb.models[x].boundaryConditions['Przemieszczenie'].setValues(u2=y)  
    session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF,  
    predefinedFields=OFF, connectors=OFF)  
    mdb.Job(name=x, model=x, description='', type=ANALYSIS, atTime=None,  
    waitMinutes=0, waitHours=0, queue=None, memory=90,  
    memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True,  
    explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF,  
    modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, userSubroutine='',  
    scratch='', multiprocessingMode=DEFAULT, numCpus=1, numGPUs=0)  
    mdb.jobs[x].submit(consistencyChecking=OFF)  
    mdb.jobs[x].waitForCompletion() 

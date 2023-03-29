# **OSM_bicyle_Road Projet** 


## **Getting started**

 This document describe how to manually install, configure and deploy the environement for running OSM_bicyle_Road Projet. 

### **Requirements**
 You will need, to installed for use this style:

>* QGIS
>* PostgreSQL
>* PostGIS 
>* Htsore
>* Osm2pgsql
>* OSM Data geofabrik
>* OSM style file

First setps: 

> 1.   Donwload and install QGIS: use this [This link](https://www.qgis.org/fr/site/forusers/download.html)  

> 2.  Donwload and install PostgreSQL use this [This link](https://www.postgresql.org/download/)


### **1. PostgreSQL and PostGIS**

in this part, we donwload and install PostgreSQL, PostGIS and Htsore after that we create a database to use to store osm data.

 > 1.   Donwload and install [PostgreSQL](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)

 > 2.   Install PostgreSQL double clik on the setup and after this provide a password for the database superuser postgress we use default password admin. use default port 5432

 > 3.  Install PostGIS for this: click on spatial Extensions and select the last version of PostGIS 

Spatial Extensions         |  Select PostGIS
:-------------------------:|:-------------------------:
<img src=images/postgis1.PNG width="350" height="200">  |  <img src=images/postgis.PNG width="350" height="200">

After do next->next->next->next and all yes and last do finish. 

 > 4. 
      > - Open pgadmin  
      > - Create the the new server 
      > - Go to connection: put host : localhost and set password
      > - Create a new database
      > - Open querytools excute the follow commands : \
            `create extension postgis` \
             `create extension hstore`


Spatial Extensions         |  Select PostGIS           |       Select PostGIS
:-------------------------:|:-------------------------:|:-------------------------:
<img src=images/d0.PNG width="450" height="200"> |  <img src=images/d1.PNG width="450" height="200"> |  <img src=images/d2.PNG width="450" height="200"> 



### **2 Osm2pgsql, OSM Data geofabrik, OSM style file**

 > 1. For Osm2pgsql, We use prebuilt binaries for this you can download prebuilt binaries in this [link](https://osm2pgsql.org/download/windows/)  
 Unpack the ZIP file and you can immediately use osm2pgsql.


> 2. Osm2pgsql requires the use of a custom OSM style file to define which tags   are included in the database during import. 
 You can download the default style file [here](https://github.com/openstreetmap/osm2pgsql/blob/master/default.style).


> 3. GeoFabrik is a company which specializes in working with OpenStreetMap. They provide a variety of free extracts in raw OSM format on their download website.
The advantage of downloading GeoFabrik data is that it is updated every day, and it’s easy and reliable. One disadvantage is that the data is extracted by country, and not all countries are available.
For our projet we use OpenStreetMap data for Belgium ,you can download Osm_data/osm2pgsql (extension file pbf) use this [link](https://download.geofabrik.de/europe/belgium.html)


### **3 import data in Postgis database using Osm2pgsql**

Open PgAdmin III and create a new database named osm, just as you did in the previous chapter. To import the data, we will run the osm2pgsql program via the command line.

Here we will run the application osm2pgsql with several options. We need at least to supply it with:

1. The location of the OSM Data File
2. The name of the database, and the database username
3. The style file which defines which OSM tags will be imported to the database

 Type the following command in the command line, before replacing the location of the OSM file and style file with your own.

> location\osm2pgsql-bin\osm2pgsql.exe -c -d database -U user -W  -H localhost -S -K location\default.style location belgium-latest.osm.pbf \
`for example : 
C:\Users\Hugues.Kamto.Kamden\Downloads\osm2pgsql-bin\osm2pgsql.exe -c -d osm -U postgres -W  -H localhost -S -K C:\Users\Hugues.Kamto.Kamden\Downloads\default.style C:\Users\Hugues.Kamto.Kamden\Downloads\belgium-latest.osm.pbf `

Press Enter. If all goes well, the process should begin running. It may take a few minutes for all of the data to load into the database.


### **TESTINT IT**

We can test that the import was successful and view the data in our database using QGIS that we install in the first part.

Open QGIS and make rigth-click on the “Postgres”  and choice new connection option 

Give the new connection a name. Under database type osm (the name of your database).
Enter the username postgres and your password below.

<img src=images/conex.PNG width="500" height="500"> 


Click OK to save the connection settings. 
Then click on PostgreSQL connect to your PostgreSQL server.
Click to  “public” to see all of the layers (tables) in your database. 
Notice that osm2pgsql creates a separate table for different object types - points, lines, and polygons. 
It also creates a roads table, which contains only major roads.

Click to one or more of the layers to see the plots and If is the first time choose WGS84 as the CRS (on bottom in right).

If everything is successful, you will see the layers you selected displayed in QGIS

<img src=images/conex1.PNG width="700" height="500"> 

Other option we can quilkly test if the import was successful for this we can use Pgadmin. 
open pgadmin clik on your server--clik on your database-clique schema and clik on Tables.
If everything is successful, you will see the layers you selected displayed in QGIS

<img src=images/conex3.PNG width="700" height="700"> 
### **TESTINT IT**

For our projet, we use the `view cyclosm_ways` for the **cyclosm-cartocss-style** projet. cyclosm-cartocss-style  is a new cycle-oriented render , contrary to OpenCycleMap, this render is free and open-source software and aims at being more complete to take into account a wider diversity of cycling habits., this views provides all the ways of the country.  

That you can see or download the file code [there](https://github.com/cyclosm/cyclosm-cartocss-style/blob/master/views.sql)

once this has been done: 
open pgadmin clik and connect in database.
make rigth-click on database and select query tools
copy an pass the code sql of 'view cyclosm_ways` and excute 
you can see the view in views

<img src=images/view.PNG width="3000" height="500">

### **Lanes and Cycleways**


to create a lanes layout ,


In order to create our the lanes and cycleways layouts base on our views,
Open QGIS and make clik on the PostgreSQL and choice  connection after this make right-clik on the connection and choice option 'Execute SQl...'  a new window will be opened

### **Lanes**
for the lane in the new window that opened copy and paste the SQL followowing source code: 
~~~~sql
select *
  from public.cyclosm_ways
 where  cycleway_left_render in ('lane','busway','track','sidewalk')
        or  
		cycleway_right_render in ('lane','busway','track','sidewalk') 
~~~~

- Click to the button Execute in the bottom 
- After execution clik to the 'Load as new layer' 
- And  for the list of check boxes select "columns with unique values" and "geometry column" 
- change the name of the layer optional. 
- At the end click on "Load Layer" in bottom

![connect QGIS and Postgress](images/lane.PNG)

### **Cycleways**

For the creation of cylCycleways,  the steps are the same that Lanes. 
replace only the the preview code by the followind code : 

~~~~sql
select *
  from public.cyclosm_ways
 where type ='cycleway'
             and 
            (bicycle not in ('no','use_sidepath','delivery','permit','permissive','destination','mtb','military','dismount','customers','undefined','discouraged','no|designated','unknown') or bicycle is null)
			 and 
            (cycleway_left_render is null 
             and  
		     cycleway_right_render is null )			 
union

select *
  from public.cyclosm_ways
 where segregated ='yes'
        and 
        (cycleway_left_render is null 
        and  
		cycleway_right_render is null )
		and 
		type not in ('cycleway')
~~~~

If everything is successful, you will see the layers you selected displayed in QGIS 

![connect QGIS and Postgress](images/lane1.PNG)


### **Computes lenght Lanes and Cycleways per commune**

to compute the length of cycleways or lanes per commune follow the following steps: 
 > Add communes-belges-2019.geojson layer in QGIS for this: 

  - In QGIS Click on the "Layer" menu, mouse-over "Add Layer" and click "Add Vector Layer..."  
- If the geojson you have are on your local machine, all you need to do is click on the Browse button and navigate to the folder where your geojson are. 
- Clik on add wait few secondes after clik on add Layers

![connect QGIS and Postgress](images/layer.PNG)

> Use function to compute length in polygons

- In the search bar in botton located in  the left Sum line clik on  the function "Sum line lengths"
- In the case Polygons choice the name of layer that represents communes-belges
- In lines choice **the name of layer that represents lanes to compute lenght lane by commune** or choice **the name of layer that represents cycleways if you want to compute length cycle ways by commune**  and clik on **run** 
- After execution clik on close.

![connect QGIS and Postgress](images/compu.PNG)


### **Parsings and export the two files in .csv**
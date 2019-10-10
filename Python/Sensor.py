import firebase_admin
import google.cloud
import time
import datetime
import smbus
import requests
from firebase_admin import credentials, firestore

sec = 5
# Credentials and Firebase App initialization. Always required
firCredentials = credentials.Certificate("./Key.json")
firApp = firebase_admin.initialize_app (firCredentials)

# Get access to Firestore
firStore = firestore.client()

# Get access to the hero collection
# The ‘u’ prior to strings means a Unicode string. This is required for Firebase
firHeroesCollectionRef = firStore.collection(u'Sensor')


#************************************************************************
#SENSOR DATA
#new lines
RGB_ADDRESS = 0x29
RGB_VERSION = 0x44

# Get I2C bus
bus = smbus.SMBus(1)

# Enable Color Sensor
rgbEnabled = False
bus.write_byte(RGB_ADDRESS, 0x80|0x12)
ver = bus.read_byte(RGB_ADDRESS)
if ver == RGB_VERSION:
    rgbEnabled = True
    bus.write_byte(RGB_ADDRESS, 0x80|0x00)
    bus.write_byte(RGB_ADDRESS, 0x01|0x02)
    bus.write_byte(RGB_ADDRESS, 0x80|0x14)

# MPL3115A2 address, 0x60(96)
# Select control register, 0x26(38)
#        0xB9(185)    Active mode, OSR = 128, Altimeter mode
bus.write_byte_data(0x60, 0x26, 0xB9)
# MPL3115A2 address, 0x60(96)
# Select data configuration register, 0x13(19)
#        0x07(07)    Data ready event enabled for altitude, pressure, temperature
bus.write_byte_data(0x60, 0x13, 0x07)
# MPL3115A2 address, 0x60(96)
# Select control register, 0x26(38)
#        0xB9(185)    Active mode, OSR = 128, Altimeter mode
bus.write_byte_data(0x60, 0x26, 0xB9)

time.sleep(1)
try:
    if requests.get('https://google.com').ok:
        firHeroDocs = firHeroesCollectionRef.stream()
    # Loop through all docs and print
    # Firebase Documents can be mapped to dictionary automatically (Hint: For classes)
        print("before for loop")
        for sensorDoc in firHeroDocs:
            print(u'Sensor Data:{}'.format(sensorDoc.to_dict()))
except google.cloud.exceptions.NotFound:
    print(u'No Documents found')

#************************************************************************
i = 1
try:
    while 1:
        
        data = bus.read_i2c_block_data(0x60, 0x00, 6)
    
        # Convert the data to 20-bits
        tHeight = ((data[1] * 65536) + (data[2] * 256) + (data[3] & 0xF0)) / 16
        temp = ((data[4] * 256) + (data[5] & 0xF0)) / 16
        altitude = (tHeight / 2048) * 0.3
        cTemp = temp / 16.0
        fTemp = cTemp * 1.8 + 32
        
        # MPL3115A2 address, 0x60(96)
        # Select control register, 0x26(38)
        #        0x39(57)    Active mode, OSR = 128, Barometer mode
        bus.write_byte_data(0x60, 0x26, 0x39)
        
        time.sleep(sec)
        
        # MPL3115A2 address, 0x60(96)
        # Read data back from 0x00(00), 4 bytes
        # status, pres MSB1, pres MSB, pres LSB
        data = bus.read_i2c_block_data(0x60, 0x00, 4)
        
        # Convert the data to 20-bits
        pres = ((data[1] * 65536) + (data[2] * 256) + (data[3] & 0xF0)) / 16
        pressure = (pres / 4.0) / 1000.0
        red=0.0
        green=0.0
        blue=0.0
        if rgbEnabled:
            print('Getting data')
            data = bus.read_i2c_block_data(RGB_ADDRESS, 0)
            clear = data[1] << 8 | data[0]
            red = ((data[3] << 8) | data[2]) / 256
            green = ((data[5] << 8) | data[4]) / 256
            blue = ((data[7] << 8) | data[6]) / 256
            time.sleep(1)
        else:
            print('Failed to load')
            break

        #SENDING DATA TO CLOUD

        presentTime = datetime.datetime.now().isoformat()
        presentDate = presentTime[0:10]
        presentTime = presentTime[11:19]
    
        newData = {
            "Number": i,
            "Green": str(green),
            "Blue": str(blue),
            "Red": str(red),
            "Pressure": str(round(pressure, 2)),
            "Altitude": str(round(altitude, 2)),
            "Temperature": str(round(cTemp, 2)),
            "UnixTime": str(int(time.time())),
            "Date": presentDate,
            "Time": presentTime
        }
        
        #checking if there is internet connectivity. If yes then write to firebase
        if requests.get('https://google.com').ok:
            print('Writing to Firebase Server')
            firHeroesCollectionRef.add(newData)
        else:
            print('Network Connection Not Available, Preparing to write to local file')
            with open('sensorDataNoInternet.txt', 'a') as file:
                print(newData, file=file)
        #writing data to a file for offline storage and retrival later
        print('Writing date to file')
        with open('sensorData.txt', 'a') as file:
            print(newData, file=file)


except KeyboardInterrupt:
    file.close()
    print('Program exiting')
